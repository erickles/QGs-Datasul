DEFINE VARIABLE cUltimoPedido   AS CHARACTER   NO-UNDO INITIAL "1547-A001".
DEFINE VARIABLE cPrefixo        AS CHARACTER   NO-UNDO INITIAL "1547-".
DEFINE VARIABLE iSequencia      AS INTEGER     NO-UNDO FORMAT "999".
DEFINE VARIABLE iSeqIni         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSeqFim         AS INTEGER     NO-UNDO INITIAL 90.
DEFINE VARIABLE cNumeroPedido   AS CHARACTER   NO-UNDO.

pedido:
DO:

    DO  iSeqIni = 65 TO iSeqFim:

        DO iSequencia = 0 TO 999:
    
            cNumeroPedido = cPrefixo + CHR(iSeqIni) + STRING(iSequencia,"999").
                    
            FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = cNumeroPedido NO-LOCK NO-ERROR.
            IF NOT AVAIL ws-p-venda THEN DO:                

                RETURN NO-APPLY.
    
            END.
    
        END.

    END.

END.

MESSAGE cNumeroPedido
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
