DEF VAR iContAuto       AS INTEGER NO-UNDO.
DEF VAR iContManual     AS INTEGER NO-UNDO  FORMAT ">>9.99".
DEF VAR iContNotasAuto  AS INTEGER NO-UNDO  FORMAT ">>9.99".
DEF VAR iContNotasMan   AS INTEGER NO-UNDO  FORMAT ">>9.99".
DEF VAR iContPedidos    AS INTEGER NO-UNDO  FORMAT ">>9.99".
DEF VAR aux             AS INTEGER NO-UNDO.
DEF VAR pauto           AS DECIMAL NO-UNDO  FORMAT ">>9,99".
DEF VAR pman            AS DECIMAL NO-UNDO  FORMAT ">>9,99".

OUTPUT TO "C:\pedidos.txt".    

FOR EACH nota-fiscal WHERE nota-fiscal.dt-emis-nota >= 06/17/2011
                        AND nota-fiscal.dt-emis-nota <= 06/17/2011
                        AND nota-fiscal.emite-duplic = YES
                        AND nota-fiscal.dt-cancela = ?
                        AND nota-fiscal.cod-estabel = "19"
                        AND (INTE(SUBSTR(nota-fiscal.hr-atualiza,1,2)) >= 6
                        AND INTE(SUBSTR(nota-fiscal.hr-atualiza,4,2)) >= 31)
                        NO-LOCK
                       /*AND nota-fiscal.serie = "4"*/ :
    
    ASSIGN aux = 0.
    
    FIND FIRST ws-p-venda WHERE ws-p-venda.nome-abrev = nota-fiscal.nome-ab-cli
                            AND ws-p-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-ERROR.
    IF AVAIL ws-p-venda THEN DO:
        
        /* Receita */
        IF SUBSTRING(ws-p-venda.char-1,307,2) = "OK" THEN DO:
            
            IF SUBSTRING(ws-p-venda.char-1,348,10) = STRING(nota-fiscal.dt-emis,"99/99/9999") THEN DO:
                
                ASSIGN iContManual = iContManual + 1
                       aux         = 1.
                
                PUT ws-p-venda.nr-pedcli "Manual Receita  " nota-fiscal.hr-atualiza FORMAT "X(6)" SKIP.
            END.
            ELSE DO:
                ASSIGN iContAuto    = iContAuto + 1.
                PUT ws-p-venda.nr-pedcli "Auto Receita  " nota-fiscal.hr-atualiza FORMAT "X(6)" SKIP.
            END.
        END.
        ELSE DO:
            ASSIGN iContAuto    = iContAuto + 1.

            PUT ws-p-venda.nr-pedcli "Auto Receita  " nota-fiscal.hr-atualiza FORMAT "X(6)" SKIP.
        END.

        /* Sintegra */
        IF SUBSTRING(ws-p-venda.char-1,304,2)  = "OK" THEN DO:

            IF SUBSTRING(ws-p-venda.char-1,322,10) = STRING(nota-fiscal.dt-emis,"99/99/9999") THEN DO:
                ASSIGN iContManual  = iContManual + 1
                       aux          = 1.
                PUT ws-p-venda.nr-pedcli "Manual Sintegra  " nota-fiscal.hr-atualiza FORMAT "X(6)" SKIP.
            END.
            ELSE DO:
                ASSIGN iContAuto    = iContAuto + 1.
                PUT ws-p-venda.nr-pedcli "Auto Sintegra  " nota-fiscal.hr-atualiza FORMAT "X(6)" SKIP.
            END.                
        END.
        ELSE DO:
            ASSIGN iContAuto    = iContAuto + 1.

            PUT ws-p-venda.nr-pedcli "Auto Sintegra  " nota-fiscal.hr-atualiza FORMAT "X(6)" SKIP.
        END.

        ASSIGN iContPedidos     = iContPedidos + 1.

    END.

   IF aux = 0 THEN
    ASSIGN iContNotasAuto = iContNotasAuto + 1.
   IF aux = 1 THEN
    ASSIGN iContNotasMan = iContNotasMan + 1.

   ASSIGN pman = (iContNotasMan / iContPedidos) * 100 .
   ASSIGN pauto = (iContNotasAuto / iContPedidos) * 100 .

END.

MESSAGE "Total Notas:          "   iContPedidos    SKIP
        "Notas Automaticas:    "   iContNotasAuto  SKIP
        "Notas Manuais:        "   iContNotasMan   SKIP
        pauto                  "%  Automatico"     SKIP
        pman                   "%  Manual" 
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

ASSIGN iContNotasAuto = 0
       iContNotasMan = 0
       iContPedidos = 0
       iContAuto = 0
       iContManual = 0.
