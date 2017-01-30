DEFINE VARIABLE cComando AS CHARACTER   NO-UNDO.

ASSIGN cComando = 'h:\htmltools\htmltools.exe h:\danfe\danfe.doc h:\danfe\danfe.pdf'.

OS-COMMAND VALUE(cComando).
