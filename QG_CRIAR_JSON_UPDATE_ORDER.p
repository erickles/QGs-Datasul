DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

FIND LAST ws-p-venda WHERE ws-p-venda.nr-pedcli BEGINS "3076-" NO-LOCK NO-ERROR.

DEFINE TEMP-TABLE MensagemPedido NO-UNDO
    FIELD tipo              AS CHAR
    FIELD situacao          AS INTE
    FIELD dtMensagem        AS DATE
    FIELD hrMensagem        AS CHAR.

IF AVAIL ws-p-venda THEN DO:

    CREATE MensagemPedido.
    ASSIGN MensagemPedido.tipo          = "orderUpdate"
           MensagemPedido.situacao      = ws-p-venda.ind-sit-ped
           MensagemPedido.dtMensagem    = TODAY
           MensagemPedido.hrMensagem    = STRING(time,"HH:MM:SS").
    
    /* Code to populate the temp-table */  
    ASSIGN cTargetType = "file"   
           cFile       = "C:\Temp\MensagemPedido.json"   
           lFormatted  = TRUE.
    
    lRetOK = TEMP-TABLE MensagemPedido:WRITE-JSON(cTargetType, cFile, lFormatted).

END.


