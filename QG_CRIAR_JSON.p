DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO. 
DEFINE TEMP-TABLE tt-es-repres-comis NO-UNDO LIKE es-repres-comis. 

/* Code to populate the temp-table */  
ASSIGN cTargetType = "file"   
       cFile       = "C:\Temp\es-repres-comis.json"   
       lFormatted  = TRUE.

FOR EACH es-repres-comis NO-LOCK:
    CREATE tt-es-repres-comis.
    BUFFER-COPY es-repres-comis TO tt-es-repres-comis.
END.

lRetOK = TEMP-TABLE tt-es-repres-comis:WRITE-JSON(cTargetType, cFile, lFormatted).

MESSAGE cFile
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
