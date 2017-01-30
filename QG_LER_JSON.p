DEFINE VARIABLE cSourceType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cReadMode   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE httCust     AS HANDLE    NO-UNDO.

CREATE TEMP-TABLE httCust.
    
ASSIGN  cSourceType = "file"  
        cFile       = "ttcust.json"   
        cReadMode   = "empty".
 
lRetOK = httCust:READ-JSON(cSourceType, cFile, cReadMode).

/* Sample Code to Read Data Loaded into the Temp-Table */

DEFINE VARIABLE hQuery      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
DEFINE VARIABLE iNumFields  AS INTEGER   NO-UNDO.
DEFINE VARIABLE iLoop       AS INTEGER   NO-UNDO.

ASSIGN hBuffer    =  httCust:DEFAULT-BUFFER-HANDLE
       iNumFields = hBuffer:NUM-FIELDS.

CREATE QUERY hQuery.

hQuery:SET-BUFFERS(httCust:DEFAULT-BUFFER-HANDLE).
hQuery:QUERY-PREPARE("FOR EACH " + httCust:NAME).
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().

DO WHILE hQuery:QUERY-OFF-END = FALSE:
    DO iLoop = 1 TO iNumFields:
        MESSAGE hBuffer:BUFFER-FIELD(iLoop):STRING-VALUE 
                VIEW-AS ALERT-BOX.
    END.
    hQuery:GET-NEXT().
END.

hQuery:QUERY-CLOSE().

DELETE OBJECT hQuery.
DELETE OBJECT hBuffer.
