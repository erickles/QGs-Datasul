DEFINE VARIABLE i-sequencia AS INTEGER     NO-UNDO.
DEFINE VARIABLE cod-repres AS INTEGER     NO-UNDO.

FIND repres WHERE repres.cod-rep = 2749 NO-LOCK NO-ERROR.
    IF AVAIL repres THEN DO:

        ASSIGN cod-repres  = repres.cod-rep
               i-sequencia = 1.

        FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = STRING(cod-repres) + "w" + STRING(i-sequencia,"9999") NO-LOCK NO-ERROR.

        
        END.
/*             MESSAGE STRING(cod-repres) + "w" + STRING(i-sequencia,"9999") */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                        */
        ELSE DO:
            DO  i-sequencia = 2 TO 9999:                
                FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = STRING(cod-repres) + "w" + STRING(i-sequencia,"9999") NO-LOCK NO-ERROR.
                    IF NOT AVAIL ws-p-venda THEN DO:
                        /*
                        i-sequencia = INTE(SUBSTRING(b2-p-venda.nr-pedcli,INDEX(b2-p-venda.nr-pedcli,"c") + 1,4)) + 1.
                        ASSIGN tt-ped-venda.nr-pedcli = STRING(repres.cod-repre) + "c" + STRING(i-sequencia,"9999").
                        */
                        MESSAGE STRING(repres.cod-rep) + "w" + STRING(i-sequencia,"9999")
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.                        
                        LEAVE.
                    END.
                END.
        END.
    END.
