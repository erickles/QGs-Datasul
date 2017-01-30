{include/varsituac.i}
OUTPUT TO "c:\pedidos.csv".

PUT "NUMERO PEDIDO;DATA IMPLANTACAO;SITUACAO" SKIP.

FOR EACH ws-p-venda WHERE cod-tipo-oper =   139 
                      AND ind-sit-ped   =   17
                      AND NOT CAN-FIND(FIRST nota-fiscal WHERE nota-fiscal.nr-pedcli = ws-p-venda.nr-pedcli
                                                           AND nota-fiscal.nome-ab-cli = ws-p-venda.nome-abrev)
                      NO-LOCK:

    PUT ws-p-venda.nr-pedcli    ";"
        ws-p-venda.dt-implant   ";"
        cSituacao[ws-p-venda.ind-sit-ped]
        SKIP.

END.
OUTPUT CLOSE.
