OUTPUT TO "c:\temp\pedidos.csv".

FOR EACH ws-p-import NO-LOCK:
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ws-p-import.nr-pedcli NO-LOCK NO-ERROR.
    IF NOT AVAIL ws-p-venda THEN DO:
        PUT ws-p-import.nr-pedcli   ";"
            DATE(ws-p-import.data-envio)  SKIP.
    END.
END.

OUTPUT CLOSE.
