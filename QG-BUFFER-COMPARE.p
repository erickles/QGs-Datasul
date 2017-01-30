DEFINE BUFFER bf-p-venda FOR ws-p-venda.
DEFINE VARIABLE resultado AS CHARACTER   NO-UNDO.

FIND FIRST bf-p-venda WHERE bf-p-venda.nr-pedcli = "ER1003690410" NO-LOCK NO-ERROR.
FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = "BR1003690410" NO-LOCK NO-ERROR.

BUFFER-COMPARE bf-p-venda TO ws-p-venda SAVE resultado.

MESSAGE resultado
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

OUTPUT TO "c:\textio.txt".
MESSAGE trim(ws-p-venda.char-1) ws-p-venda.dt-emissao
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

EXPORT trim(ws-p-venda.char-1).
OUTPUT CLOSE.

MESSAGE trim(bf-p-venda.char-1) ws-p-venda.dt-emissao
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
