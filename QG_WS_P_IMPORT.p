DEFINE VARIABLE cPedido AS CHARACTER   NO-UNDO FORMAT "X(12)".

UPDATE cPedido LABEL "Pedido".

FIND FIRST ws-p-import WHERE nr-pedcli = cPedido.
ASSIGN ws-p-import.atualizado = YES
       ws-p-import.data-atualizado = TODAY.
