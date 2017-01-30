DEFINE VARIABLE i AS INTEGER     NO-UNDO.

{include/i-freeac.i}

DEFINE BUFFER bf-p-venda FOR ws-p-venda.
    
OUTPUT TO "C:\Temp\Relatorio_Pedidos_duplicados.csv" NO-CONVERT.

PUT "Pedido Original"   ";"
    "Pedido Duplicado"  ";"
    "Valor dos pedidos" ";"
    SKIP.

FOR EACH ws-p-venda WHERE ws-p-venda.dt-impl >= 11/21/2016 NO-LOCK
        BREAK BY ws-p-venda.nome-abrev:
    FOR EACH bf-p-venda WHERE bf-p-venda.nome-abrev <>  ws-p-venda.nome-abrev
                          AND bf-p-venda.dt-impl    =  ws-p-venda.dt-impl
                          AND bf-p-venda.nr-pedcli  <> ws-p-venda.nr-pedcli
                          AND bf-p-venda.cod-tipo-oper = ws-p-venda.cod-tipo-oper
                          NO-LOCK:
        IF ws-p-venda.vl-tot-ped = bf-p-venda.vl-tot-ped THEN
            PUT ws-p-venda.nr-pedcli    ";"
                bf-p-venda.nr-pedcli    ";"
                ws-p-venda.vl-tot-ped   ";"
                SKIP.
    END.    
END.

OUTPUT CLOSE.
