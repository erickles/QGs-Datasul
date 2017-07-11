DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE deQuantidade AS DECIMAL     NO-UNDO.

OUTPUT TO "c:\temp\pedidos_implantados.csv".


PUT "Pedido"        ";"
    "Dt Implant"    ";"
    /*"Quantidade"    ";"*/
    "Via Mobile?"   SKIP.

FOR EACH ws-p-venda WHERE ws-p-venda.dt-implant     >= 01/01/2016
                      AND ws-p-venda.dt-implant     <= 12/31/2016
                      AND (ws-p-venda.cod-tipo-oper  = 1 OR ws-p-venda.cod-tipo-oper  = 2)
                      AND INDEX(ws-p-venda.nr-pedcli,"/") = 0
                      NO-LOCK BY ws-p-venda.dt-implant:
    /*
    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
        deQuantidade = deQuantidade + ws-p-item.qt-pedida.
    END.
    */
    PUT ws-p-venda.nr-pedcli                ";"
        ws-p-venda.dt-implant               ";"
        /*deQuantidade                        ";"*/
        ws-p-venda.log-5 FORMAT "Sim/Nao"   SKIP.

    deQuantidade = 0.

END.

OUTPUT CLOSE.
