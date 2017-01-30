DEFINE VARIABLE cod-repres  AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-sequencia AS INTEGER FORMAT "9999"    NO-UNDO.

UPDATE cod-repres.

ASSIGN i-sequencia = 1.

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = STRING(cod-repres) + "w" + STRING(i-sequencia,"9999") NO-LOCK NO-ERROR.
IF NOT AVAIL ws-p-venda THEN
    MESSAGE STRING(cod-repres) + "w" + STRING(i-sequencia,"9999")
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
ELSE DO:
        FIND LAST ws-p-venda WHERE ws-p-venda.nr-pedcli BEGINS STRING(cod-repres) + "w" NO-LOCK NO-ERROR.
        IF AVAIL ws-p-venda THEN DO:
            i-sequencia = INTE(SUBSTRING(ws-p-venda.nr-pedcli,LENGTH(ws-p-venda.nr-pedcli) - 3,4)).
            MESSAGE STRING(cod-repres) + "w" + STRING(i-sequencia,"9999")            
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
     END.
