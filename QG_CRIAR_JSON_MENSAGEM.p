DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

DEFINE TEMP-TABLE Mensagem NO-UNDO
    FIELD tipo              AS CHAR
    FIELD titulo            AS CHAR
    FIELD mensagem          AS CHAR
    FIELD dtMensagem        AS DATE
    FIELD hrMensagem        AS CHAR.

CREATE Mensagem.
ASSIGN Mensagem.tipo        = "mensagem"
       Mensagem.titulo      = "Titulo da mensagem"
       Mensagem.mensagem    = "Esta eh uma mensagem de teste e vocˆ a recebeu!"
       Mensagem.dtMensagem  = TODAY
       Mensagem.hrMensagem  = STRING(time,"HH:MM:SS").

/* Code to populate the temp-table */  
ASSIGN cTargetType = "file"   
       cFile       = "C:\Temp\Mensagem.json"   
       lFormatted  = TRUE.

lRetOK = TEMP-TABLE Mensagem:WRITE-JSON(cTargetType, cFile, lFormatted).
