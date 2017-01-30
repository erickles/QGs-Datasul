OUTPUT TO "C:\Temp\pedidos.csv".

FOR EACH ws-p-venda WHERE ws-p-venda.ind-sit-ped < 17
                      AND ws-p-venda.nr-pedcli BEGINS "AGD"
                      AND YEAR(ws-p-venda.dt-implant) = 2016
                      AND ws-p-venda.tp-frete = 2
                      :

    PUT ws-p-venda.nr-pedcli ";" ws-p-venda.tp-frete SKIP.

    ws-p-venda.tp-frete = 1.

END.

OUTPUT CLOSE.
