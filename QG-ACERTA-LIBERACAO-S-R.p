find first ws-p-venda where ws-p-venda.nr-pedcli = "1472-1597".
ASSIGN OVERLAY(ws-p-venda.char-1,304,2)  = "OK"
       OVERLAY(ws-p-venda.char-1,322,10) = STRING(TODAY,"99/99/9999")
       OVERLAY(ws-p-venda.char-1,332,16) = "as41742".

ASSIGN OVERLAY(ws-p-venda.char-1,307,2) = "OK"
       OVERLAY(ws-p-venda.char-1,348,10) = STRING(TODAY,"99/99/9999")
       OVERLAY(ws-p-venda.char-1,358,16) = "as41742".
