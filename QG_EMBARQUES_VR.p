
DEFINE VARIABLE iEmbarques AS DECI NO-UNDO.
DEFINE VARIABLE iPedidos AS DECI   NO-UNDO.

DEFINE TEMP-TABLE tt-embarque
    FIELD nr-embarque AS INTE
    FIELD nr-pedidos  AS INTE.

OUTPUT TO "c:\temp\embarques.csv".

PUT SKIP(4).
DEFINE VARIABLE lFatur AS LOGICAL     NO-UNDO.

FOR EACH es-embarque NO-LOCK WHERE es-embarque.dt-frete >= 07/01/2016 
                               AND es-embarque.dt-frete <= 07/31/2016 
                               /*AND es-embarque.situacao = 2*/
                               BREAK BY es-embarque.cdd-embarq:
    /*  
        es-embarque.dt-frete
        es-embarque.data 
        es-embarque.data-1 
        es-embarque.data-2 
        es-embarque.data-aprovacao-comp 
        es-embarque.data-lib 
        es-embarque.date-3 
        es-embarque.date-4 
        es-embarque.date-5 
        es-embarque.dt-contrato-hist
    */

    lFatur = TRUE.
    
    iEmbarques = iEmbarques + 1.

    FIND FIRST es-embarque-pedido WHERE es-embarque-pedido.nr-fila = es-embarque.nr-fila NO-LOCK NO-ERROR.    
    IF AVAIL es-embarque-pedido THEN
        FOR EACH es-embarque-pedido WHERE es-embarque-pedido.nr-fila = es-embarque.nr-fila NO-LOCK:
            
            FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = es-embarque-pedido.nr-pedcli NO-LOCK NO-ERROR.
            IF AVAIL ws-p-venda THEN DO:
                IF ws-p-venda.ind-sit-ped < 17 THEN DO:
                    lFatur = FALSE.
                    LEAVE.
                END.
            END.
    
            iPedidos = iPedidos + 1.
    
        END.
    ELSE
        lFatur = NO.
    
    IF lFatur THEN
        IF es-embarque.cdd-embarq <> 0 THEN
            PUT es-embarque.cdd-embarq SKIP.
END.

MESSAGE iEmbarques
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

/*
FOR EACH embarque WHERE embarque.dt-embarque >= 01/01/2016
                    AND embarque.dt-embarque <= 01/31/2016                    
                    NO-LOCK:
    PUT embarque.cdd-embarq SKIP.
    /*iEmbarques = iEmbarques + 1.*/
END.
*/
/*
MESSAGE "Numeros de embarques "         iEmbarques              SKIP
        "Numero de pedidos "            iPedidos                SKIP
        "Media de pedidos por embarque " iPedidos / iEmbarques   SKIP
        "Media de embarques por mes "    iEmbarques / 12
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
OUTPUT CLOSE.
