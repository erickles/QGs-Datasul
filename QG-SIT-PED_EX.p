OUTPUT TO "c:\teste_pedidos.csv".

PUT "Nr Pedido;"
    "ws-p-venda.ind-sit-ped;"
    "ped-venda.cod-sit-ped"
    SKIP.

FOR EACH ws-p-venda FIELDS(ws-p-venda.nome-abrev ws-p-venda.ind-sit-ped ws-p-venda.dt-entrega ws-p-venda.cod-tipo-oper)
                    WHERE ws-p-venda.ind-sit-ped <> 17
                      AND ws-p-venda.ind-sit-ped <> 22
                      AND ws-p-venda.ind-sit-ped <> 21
                      AND ws-p-venda.ind-sit-ped <> 20
                      AND ws-p-venda.ind-sit-ped <> 19 
                      AND ws-p-venda.dt-implant >= 02/01/2012
                      AND ws-p-venda.dt-implant <= 02/29/2012
                      NO-LOCK:
    
    FIND FIRST ped-venda WHERE ped-venda.nr-pedcli = ws-p-venda.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ped-venda THEN DO:

        PUT ws-p-venda.nr-pedcli            ";"
            STRING(ws-p-venda.ind-sit-ped)  ";"
            STRING(ped-venda.cod-sit-ped)   SKIP.

    END.

END.

OUTPUT CLOSE.
