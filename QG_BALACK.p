OUTPUT TO "c:\pedidos_erro.csv".

FOR EACH es-schedule WHERE es-schedule.tabela = "ws-p-venda" NO-LOCK,
    EACH ws-p-venda WHERE ROWID(ws-p-venda) = TO-ROWID(es-schedule.id) NO-LOCK:

    PUT ws-p-venda.nr-pedcli ";" STRING(LENGTH(ws-p-venda.observacoes)) SKIP.

END.

OUTPUT CLOSE.
