{include/i-freeac.i}

DEFINE VARIABLE cName       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSituacao   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLinha      AS CHARACTER   NO-UNDO.

OUTPUT TO "c:\repres.csv".

PUT "CODIGO;COMUNICACAO;SITUACAO REPRES;SITUACAO PEDMOBILE;LINHA" SKIP.

INPUT FROM OS-DIR ("\\bovigold\PedMobile_producao\Area Transferencia").
    
    REPEAT:

        IMPORT cName.

        IF cName EQ "." OR
           cName EQ ".." THEN NEXT.

        FIND FIRST pm-rep-param WHERE pm-rep-param.cod_rep = INTE(cName) NO-LOCK NO-ERROR.
        IF NOT AVAIL pm-rep-param OR 
           (AVAIL pm-rep-param /*AND pm-rep-param.ind_situacao <> 1*/)  THEN DO:

            FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.

            IF NOT AVAIL es-repres-comis THEN
                PUT cName ";"
                    "Verificar" SKIP.

            IF NOT AVAIL es-repres-comis THEN NEXT.
            
            /*IF es-repres-comis.u-int-1 <> 2 AND es-repres-comis.u-int-1 <> 4 THEN NEXT.*/
            cSituacao = "".
            CASE es-repres-comis.situacao:

                WHEN 1 THEN
                    cSituacao = "ATIVO".

                WHEN 2 THEN
                    cSituacao = "SUSPENSO FINANCEIRO".

                WHEN 3 THEN
                    cSituacao = "DISTRATADO".

                WHEN 4 THEN
                    cSituacao = "ATIVO UNIFICADO".

                WHEN 5 THEN
                    cSituacao = "SUSPENSO COMERCIAL".
               
            END CASE.

            cLinha = "".
            CASE es-repres-comis.u-int-1:
                
                WHEN 1 THEN
                    cLinha = "NUTRICAO".

                WHEN 2 THEN
                    cLinha = "SAUDE".

                WHEN 3 THEN
                    cLinha = "NUTRICAO\SAUDE".

                WHEN 4 THEN
                    cLinha = "MITUISAL".

            END CASE.

            PUT UNFORMATTED 
                cName                                                                                                   ";"
                IF AVAIL pm-rep-param THEN REPLACE(fn-free-accent(pm-rep-param.des_comunicacao),CHR(10)," ") ELSE ""    ";"
                IF cSituacao <> "" THEN cSituacao ELSE STRING(es-repres-comis.situacao)                                 ";"
                pm-rep-param.ind_situacao                                                                               ";"
                cLinha
                SKIP.

        END.                

    END.

   OUTPUT CLOSE.
