DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE lPedidoOk AS LOGICAL     NO-UNDO.

OUTPUT TO "c:\temp\pedidos-compra.csv".

PUT "DT PEDIDO" ";"
    "PEDIDO"    SKIP.

FOR EACH pedido-compr WHERE pedido-compr.data-pedido >= 08/01/2016
                        AND pedido-compr.data-pedido <= 08/31/2016
                        /*AND pedido-compr.num-pedido = 258226*/
                        NO-LOCK BREAK BY pedido-compr.data-pedido:
    
    lPedidoOk = TRUE.

    FOR EACH ordem-compra WHERE ordem-compra.num-pedido = pedido-compr.num-pedido 
                        NO-LOCK BREAK BY ordem-compra.num-pedido:

        IF ordem-compra.situacao <> 6 THEN
            lPedidoOk = FALSE.
    END.
    
    IF lPedidoOk THEN
        PUT pedido-compr.data-pedido    ";"
            pedido-compr.num-pedido     SKIP.
    
    /*iCont = iCont + 1.*/
END.
/*
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
OUTPUT CLOSE.
