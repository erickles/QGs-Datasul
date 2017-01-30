DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE cArquivo    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lAtualiza   AS LOGICAL     NO-UNDO.

{include/i-ambiente.i}

DEFINE VARIABLE cMeses      AS CHARACTER EXTENT 12  NO-UNDO
    INIT["JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"].

lAtualiza = NO.

FOR EACH es-cad-cli-doc NO-LOCK WHERE es-cad-cli-doc.caminho-arquivo <> "":    

    IF adm-ambiente = "PRODUCAO" THEN
        cArquivo = "\\srvvm01\doc-ficha$\" + "PRODUCAO" + "\" + STRING(YEAR(es-cad-cli-doc.date-1)) + "\" + cMeses[MONTH(es-cad-cli-doc.date-1)] + "\" + es-cad-cli-doc.caminho-arquivo.
    ELSE
        cArquivo = "\\srvvm01\doc-ficha$\" + "TESTE" + "\" + STRING(YEAR(es-cad-cli-doc.date-1)) + "\" + cMeses[MONTH(es-cad-cli-doc.date-1)] + "\" + es-cad-cli-doc.caminho-arquivo.

    FILE-INFO:FILE-NAME = cArquivo.

    IF NOT FILE-INFO:FULL-PATHNAME EQ ? THEN DO:

        FIND FIRST es-cad-cli WHERE es-cad-cli.nr-ficha = es-cad-cli-doc.nr-ficha 
                                AND es-cad-cli.dt-inclusao < TODAY
                                NO-ERROR.
        IF AVAIL es-cad-cli THEN DO:
            IF es-cad-cli.dt-Atualiz <> ? THEN DO:
                iCont = iCont + 1.

                es-cad-cli.situacao      = 3.

            END.
                
            /*
            IF es-cad-cli.situacao      = 1     AND
               es-cad-cli.data-atualiz  = ?     AND
               es-cad-cli.hora-atualiz  = ?     AND
               es-cad-cli.usuar-atualiz = ""    THEN
                iCont = iCont + 1.
                */
            /*
            IF lAtualiza THEN DO:
                                          
                ASSIGN es-cad-cli.situacao      = 2  
                       es-cad-cli.data-atualiz  = TODAY  
                       es-cad-cli.hora-atualiz  = TIME
                       es-cad-cli.usuar-atualiz = "repres".

            END.
            */
        END.
    END.

END.

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
