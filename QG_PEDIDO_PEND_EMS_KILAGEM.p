{include/varsituac.i}

DEFINE VARIABLE dKilagem AS DECIMAL     NO-UNDO.

OUTPUT TO "c:\pedidos_pendentes.csv".

PUT "PEDIDO;SITUACAO;PESO;DATA;HORA" SKIP.
/*
FOR EACH ws-p-venda WHERE (ws-p-venda.ind-sit-ped = 1
                       OR ws-p-venda.ind-sit-ped = 2
                       OR ws-p-venda.ind-sit-ped = 3
                       OR ws-p-venda.ind-sit-ped = 4)
                      AND ws-p-venda.dt-implant  = 05/31/2013 NO-LOCK:
*/

FOR EACH ws-p-venda WHERE (ws-p-venda.dt-implant  = 12/18/2013 AND STRING(ws-p-venda.hr-implant,"HH:MM:SS") >= "18:00:00")
                      AND ws-p-venda.cod-tipo-oper = 1 
                      AND ind-sit-ped <> 22 NO-LOCK:
/*
FOR EACH ws-p-venda WHERE ws-p-venda.dt-implant  = 12/19/2013
                      AND ws-p-venda.cod-tipo-oper = 1 
                      AND ind-sit-ped <> 22 NO-LOCK:
*/
    ASSIGN dKilagem = 0.

    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
        dKilagem = dKilagem + ws-p-item.qt-pedida.
    END.

    PUT ws-p-venda.nr-pedcli                ";"
        cSituacao[ws-p-venda.ind-sit-ped]  FORMAT "X(25)" ";"
        dKilagem                            ";"
        ws-p-venda.dt-implant               ";"
        STRING(ws-p-venda.hr-implant,"HH:MM:SS")
        SKIP.

END.

OUTPUT CLOSE.
