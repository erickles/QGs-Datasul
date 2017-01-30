DEFINE VARIABLE cPedido     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomeAbrev  AS CHARACTER   NO-UNDO.

UPDATE  cPedido     LABEL "Pedido"
        cNomeAbrev  LABEL "Cliente".

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli    = cPedido 
                        AND ws-p-venda.nome-abrev   = cNomeAbrev
                        NO-ERROR.
IF AVAIL ws-p-venda THEN DO:
    FOR EACH ws-p-item OF ws-p-venda:

        FOR EACH ws-p-desc OF ws-p-item:
            DELETE ws-p-desc.
        END.
        DELETE ws-p-item.
    END.
    DELETE ws-p-venda.
END.
