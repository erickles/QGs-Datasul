DEFINE VARIABLE cTelefone AS CHARACTER   NO-UNDO.
OUTPUT TO "c:\temp\telefones.csv".

/* Representantes */

FOR EACH es-repres-comis WHERE es-repres-comis.situacao = 1 
                           AND es-repres-comis.log-1
                           NO-LOCK,
    EACH repres WHERE repres.cod-rep = es-repres-comis.cod-rep:
    
    IF TRIM(repres.telefone[1]) <> "" THEN DO:

        ASSIGN cTelefone = REPLACE(repres.telefone[1]," ","")
               cTelefone = REPLACE(cTelefone,".","")
               cTelefone = REPLACE(cTelefone,"-","")
               cTelefone = REPLACE(cTelefone,"(","")
               cTelefone = REPLACE(cTelefone,")","").

        PUT UNFORM cTelefone        SKIP.

    END.

END.

/* Gerentes, supervisores e promotores */
/*
FOR EACH es-repres-comis WHERE es-repres-comis.situacao = 1 
                           AND NOT es-repres-comis.log-1
                           AND (es-repres-comis.u-char-2 = "SUPERVISOR" OR
                                es-repres-comis.u-char-2 = "PROMOTOR"   OR
                                es-repres-comis.u-char-2 BEGINS "GERENTE")
                           NO-LOCK,
    EACH repres WHERE repres.cod-rep = es-repres-comis.cod-rep
                  AND NOT repres.nome BEGINS "DSM"
                  AND NOT repres.nome BEGINS "ALLIMENTA":
    
    IF TRIM(repres.telefone[1]) <> "" THEN DO:

        ASSIGN cTelefone = REPLACE(repres.telefone[1]," ","")
               cTelefone = REPLACE(cTelefone,".","")
               cTelefone = REPLACE(cTelefone,"-","")
               cTelefone = REPLACE(cTelefone,"(","")
               cTelefone = REPLACE(cTelefone,")","").

        PUT UNFORM cTelefone SKIP.

    END.

END.
*/
/* Clientes */
/*
FOR EACH ws-p-venda WHERE ws-p-venda.dt-implant >= 01/01/2014 
                      AND ws-p-venda.ind-sit-ped = 17
                      AND (ws-p-venda.cod-tipo-oper = 1 OR ws-p-venda.cod-tipo-oper = 2)
                      NO-LOCK BREAK BY ws-p-venda.nome-abrev DESC:

    IF FIRST-OF(ws-p-venda.nome-abrev) THEN DO:
        FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
        IF AVAIL emitente AND TRIM(emitente.telefone[1]) <> "" THEN DO:
            ASSIGN cTelefone = REPLACE(emitente.telefone[1]," ","")
                   cTelefone = REPLACE(cTelefone,".","")
                   cTelefone = REPLACE(cTelefone,"-","")
                   cTelefone = REPLACE(cTelefone,"(","")
                   cTelefone = REPLACE(cTelefone,")","").

            PUT UNFORM cTelefone        SKIP.

        END.
    END.
END.
*/
OUTPUT CLOSE.

