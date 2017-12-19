DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

OUTPUT TO "c:\Temp\pedidos_nao_implantados.csv".

PUT "PEDIDO;IMPLANTADO" SKIP.

FOR EACH ws-p-import NO-LOCK WHERE DATE(ws-p-import.data-envio) >= 12/01/2016:

    PUT ws-p-import.nr-pedcli ";".

    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ws-p-import.nr-pedcli NO-LOCK NO-ERROR.
    IF NOT AVAIL ws-p-venda THEN
        PUT "NAO" SKIP.
    ELSE
        PUT "SIM" SKIP.

END.

OUTPUT CLOSE.                            
