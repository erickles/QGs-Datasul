OUTPUT TO c:\pedidos_ficha_31052013.csv.

PUT "NR PEDIDO"             ";"
    "DT IMPLANTACAO"        ";"
    "HR IMPLANTACAO"        ";"
    "CODIGO ITEM"           ";"
    "DESC ITEM"             ";"
    "TABELA PRECO"          ";"
    "DT INICIO TAB"         ";"
    "PRECO TABELA"
    SKIP.

FOR EACH es-cad-cli WHERE es-cad-cli.log-renov = FALSE
                      AND es-cad-cli.dt-inclusao = 05/31/2013
                      NO-LOCK:

    FIND FIRST emitente WHERE emitente.cod-emitente = es-cad-cli.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:

        FOR EACH ws-p-venda WHERE ws-p-venda.nome-abrev = emitente.nome-abrev 
                              AND ws-p-venda.dt-implant = es-cad-cli.dt-inclusao
                              AND (ws-p-venda.cod-tipo-oper = 1 OR ws-p-venda.cod-tipo-oper = 2)
                              AND STRING(ws-p-venda.hr-implant,"HH:MM:SS") <= "18:00:00"
                              NO-LOCK BREAK BY STRING(ws-p-venda.hr-implant,"HH:MM:SS"):
            
            FOR EACH ws-p-item OF ws-p-venda NO-LOCK:

                FIND FIRST ITEM WHERE ITEM.it-codigo = ws-p-item.it-codigo NO-LOCK NO-ERROR.

                FIND FIRST preco-item WHERE preco-item.it-codigo    = ITEM.it-codigo
                                        AND preco-item.preco-venda  = ws-p-item.vl-pretab
                                        NO-LOCK NO-ERROR.

                PUT ws-p-venda.nr-pedcli                        ";"
                    ws-p-venda.dt-implant                       ";"
                    STRING(ws-p-venda.hr-implant,"HH:MM:SS")    ";"
                    ws-p-item.it-codigo                         ";"
                    item.desc-item                              ";"
                    ws-p-item.nr-tabpre                         ";"
                    preco-item.dt-inival                        ";"
                    preco-item.preco-venda
                    SKIP.

            END.            

        END.

    END.

END.

OUTPUT CLOSE.
