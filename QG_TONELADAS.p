DEFINE VARIABLE deQuantidade AS DECIMAL     NO-UNDO.

OUTPUT TO "c:\Temp\pedidos_ton.csv".
FOR EACH ws-p-venda WHERE ws-p-venda.dt-implant >= 12/21/2016
                      AND ws-p-venda.dt-implant <= 12/21/2016
                      AND (ws-p-venda.cod-tipo-oper = 1 OR ws-p-venda.cod-tipo-oper = 2)
                      AND ws-p-venda.dt-canc    = ?
                      AND ws-p-venda.log-5      = NO
                      NO-LOCK:

    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
        deQuantidade = deQuantidade + ws-p-item.qt-pedida.
    END.

    PUT ws-p-venda.nr-pedcli    ";"
        deQuantidade            SKIP.

    deQuantidade = 0.
END.
OUTPUT CLOSE.

OUTPUT TO "c:\Temp\pedidos_ton_mob.csv".
FOR EACH ws-p-venda WHERE ws-p-venda.dt-implant >= 12/21/2016
                      AND ws-p-venda.dt-implant <= 12/21/2016
                      AND (ws-p-venda.cod-tipo-oper = 1 OR ws-p-venda.cod-tipo-oper = 2)
                      AND ws-p-venda.dt-canc    = ?
                      AND ws-p-venda.log-5      = YES
                      NO-LOCK:

    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
        deQuantidade = deQuantidade + ws-p-item.qt-pedida.
    END.

    PUT ws-p-venda.nr-pedcli    ";"
        deQuantidade            SKIP.

    deQuantidade = 0.
END.
OUTPUT CLOSE.
