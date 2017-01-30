OUTPUT TO C:\Temp\ws-p-import.d.
FOR LAST ws-p-import NO-LOCK:
    EXPORT ws-p-import.
END.
OUTPUT CLOSE.

/*
FIND FIRST ws-p-venda WHERE ws-p-venda.dt-implant >= 06/01/2016
                        AND ws-p-venda.nr-pedrep <> ""
                        AND INDEX(ws-p-venda.nr-pedcli,"-") > 0
                        NO-LOCK NO-ERROR.
DISP ws-p-venda.nr-pedcli.
*/
