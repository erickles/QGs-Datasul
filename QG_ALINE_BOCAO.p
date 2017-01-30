OUTPUT TO "c:\pedidos.csv".

PUT "MATRIZ;CODIGO;PEDIDO;DATA FATUR" SKIP.

FOR EACH emitente WHERE emitente.nome-matriz = "215228" NO-LOCK:

    FOR EACH ws-p-venda WHERE ws-p-venda.nome-abrev = emitente.nome-abrev 
                          AND ws-p-venda.ind-sit-ped = 17
                          NO-LOCK:
        
        FIND FIRST nota-fiscal WHERE nota-fiscal.nr-pedcli = ws-p-venda.nr-pedcli
                                 AND nota-fiscal.nome-ab-cli = ws-p-venda.nome-abrev
                                 NO-LOCK NO-ERROR.

        PUT emitente.nome-matriz ";"
            emitente.nome-abrev  ";"
            ws-p-venda.nr-pedcli ";"
            nota-fiscal.dt-emis SKIP.

    END.
END.

OUTPUT CLOSE.
