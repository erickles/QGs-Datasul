DEFINE VARIABLE c-email AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-linha AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-path  AS CHARACTER   NO-UNDO.

{include/i-freeac.i}

c-path = "C:\PEDIDO_VENDA_7700a.html".

c-email = "".
INPUT FROM VALUE(c-path) NO-CONVERT.
REPEAT:
    IMPORT UNFORMATTED c-linha.
    ASSIGN c-email = fn-free-accent(c-email) + CHR(10) + fn-free-accent(c-linha).
END.
INPUT CLOSE.

ASSIGN c-email = REPLACE(c-email,'<td class="alt_pedido"></td>',"").

OUTPUT TO VALUE ("C:\PEDIDO_VENDA_7700a@.html") NO-CONVERT.
    PUT UNFORMATTED c-email.
OUTPUT CLOSE.
