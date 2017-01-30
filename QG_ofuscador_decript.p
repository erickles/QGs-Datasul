DEFINE VARIABLE cComando    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRetorno    AS LONGCHAR.
DEFINE VARIABLE cPassFile   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPrograma   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPass       AS CHARACTER   NO-UNDO.

FIND FIRST es-senha-cripto NO-LOCK NO-ERROR.

ASSIGN cPrograma = SEARCH("esp\doc\Ofuscador.exe") + " -d"
       cPassFile = "C:\Datasul\pass.txt"
       cPass     = IF AVAIL es-senha-cripto THEN es-senha-cripto.senha ELSE ""
       cComando  = cPrograma + " " + cPass + " " + " > " + cPassFile.

OS-COMMAND SILENT VALUE(cComando).

COPY-LOB FROM FILE cPassFile to cRetorno NO-CONVERT.

ASSIGN cComando = "DEL " + cPassFile.

OS-COMMAND SILENT VALUE(cComando).

MESSAGE STRING(cRetorno)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
