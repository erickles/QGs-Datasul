FIND FIRST ws-p-venda WHERE nr-pedcli = "3817w0015" NO-LOCK NO-ERROR.
DISP substring(ws-p-venda.char-1,304,3)
     substring(ws-p-venda.char-1,303,1)
     substring(ws-p-venda.char-1,332,10)
     substring(ws-p-venda.char-1,368,8).
