DEF VAR c-diferencas AS CHAR.
DEF STREAM s-diferencas.

DEFINE BUFFER bf-p-venda FOR ws-p-venda.

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = "MKTFG3310/11".
FIND FIRST bf-p-venda WHERE bf-p-venda.nr-pedcli = "MKTDG3310/11".

OUTPUT STREAM s-diferencas TO c:\temp\dif.txt APPEND.
BUFFER-COMPARE ws-p-venda TO bf-p-venda SAVE c-diferencas.
EXPORT STREAM s-diferencas c-diferencas.
OUTPUT STREAM s-diferencas CLOSE.
