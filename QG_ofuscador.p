DEFINE VARIABLE cComando    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRetorno    AS LONGCHAR.
DEFINE VARIABLE cPassFile   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPrograma   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPass       AS CHARACTER   NO-UNDO.

ASSIGN cPrograma = "C:\Temp\Ofuscador.exe -e"
       cPassFile = "C:\Temp\pass.txt"
       cPass     = "ERICK"
       cComando  = cPrograma + " " + cPass + " " + " > " + cPassFile.

OS-COMMAND SILENT VALUE(cComando).

COPY-LOB FROM FILE cPassFile to cRetorno NO-CONVERT.

ASSIGN cComando = "DEL " + cPassFile.

OS-COMMAND SILENT VALUE(cComando).

MESSAGE STRING(cRetorno)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
