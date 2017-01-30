DEFINE VARIABLE cComando    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLog        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cResultado  AS CHARACTER   NO-UNDO.

cComando = "winscp.exe ftpes://ftpsmb.tortuga.com.br%7Cpedmobile:P%24m0b%21l3@ftpsmb.tortuga.com.br:115/ cd /Backup put c:\temp\wspvenda.csv close exit".

INPUT THROUGH VALUE(cComando).

ASSIGN cResultado = ""
       cLog       = "".

REPEAT:
    
    IMPORT UNFORMATTED cResultado.
    
    cLog = cLog + cResultado.
        
END.

MESSAGE cLog
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
