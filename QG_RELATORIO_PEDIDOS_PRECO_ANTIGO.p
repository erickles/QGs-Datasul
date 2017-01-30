OUTPUT TO "c:\relatorio.csv".

DEFINE BUFFER bf-preco-item FOR preco-item.

PUT "NUMERO PEDIDO"     ";"
    "HORA IMPLANT"      ";"
    "INICIO VAL PRE"    ";"
    "ITEM"              ";"
    "PRECO ATUAL"       ";"
    "PRECO CORRETO"     ";"
    "DIFERENTE"         SKIP.

FOR EACH ws-p-venda WHERE ws-p-venda.dt-implant = TODAY 
                      AND ws-p-venda.cod-tipo-oper = 1
                        NO-LOCK:

    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
        FIND FIRST preco-item WHERE preco-item.it-codigo   = ws-p-item.it-codigo
                                AND preco-item.preco-venda = ws-p-item.vl-preori
                                NO-LOCK NO-ERROR.

        IF AVAIL preco-item THEN DO:

            FIND FIRST bf-preco-item WHERE bf-preco-item.nr-tabpre  = ws-p-item.nr-tabpre
                                       AND bf-preco-item.it-codigo  = ws-p-item.it-codigo
                                       AND bf-preco-item.cod-refer  = ws-p-item.cod-refer
                                       AND bf-preco-item.quant-min <= ws-p-item.qt-pedida
                                       AND bf-preco-item.dt-inival <= ws-p-venda.dt-implant
                                       AND bf-preco-item.situacao   = 1              
                                       NO-LOCK NO-ERROR.

            PUT ws-p-venda.nr-pedcli                        ";"
                STRING(ws-p-venda.hr-implant,"HH:MM:SS")    ";"
                preco-item.dt-inival                        ";"
                preco-item.it-codigo                        ";"
                round(preco-item.preco-venda,2)                      ";"
                IF AVAIL bf-preco-item THEN bf-preco-item.preco-venda ELSE 0                  SKIP.
        END.
    END.
    
END.

OUTPUT CLOSE.
