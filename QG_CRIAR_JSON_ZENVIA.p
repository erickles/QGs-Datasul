/* Variaveis para criacao do JSON */
DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE cContent AS LONGCHAR   NO-UNDO.

/* Variaveis da consulta ao webservice */
DEFINE VARIABLE http        AS COM-HANDLE.
DEFINE VARIABLE strRET      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cBody       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cAuth       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cURL        AS CHARACTER    NO-UNDO.

DEFINE TEMP-TABLE sendSmsRequest NO-UNDO
    FIELD from_             AS CHAR
    FIELD to_               AS CHAR
    FIELD schedule          AS CHAR
    FIELD msg               AS CHAR
    FIELD callbackOption    AS CHAR
    FIELD id                AS CHAR
    FIELD aggregateId       AS CHAR.

DEFINE TEMP-TABLE sendSmsResponse NO-UNDO
    FIELD statusCode        AS CHAR
    FIELD statusDescription AS CHAR
    FIELD detailCode        AS CHAR
    FIELD detailDescription AS CHAR.

/* Code to populate the temp-table */  
ASSIGN cTargetType = "LONGCHAR"
       lFormatted  = YES.

    FIND LAST es-comunica-cliente-envio WHERE es-comunica-cliente-envio.nr-pedcli BEGINS "3076-" 
                                          AND es-comunica-cliente-envio.tipo = "SMS"
                                          NO-ERROR.
    
    /*es-comunica-cliente-envio.texto-mensagem = REPLACE(es-comunica-cliente-envio.texto-mensagem,"IVALDO","MARIO").*/

    CREATE sendSmsRequest.
    ASSIGN sendSmsRequest.from_          = "DSM"
           sendSmsRequest.to_            = "5511997402216"
           sendSmsRequest.schedule       = ""
           sendSmsRequest.msg            = TRIM(es-comunica-cliente-envio.texto-mensagem)
           sendSmsRequest.callbackOption = "NONE"
           sendSmsRequest.id             = ""
           sendSmsRequest.aggregateId    = "".

    
lRetOK = TEMP-TABLE sendSmsRequest:WRITE-JSON(cTargetType, cContent, lFormatted).

ASSIGN cContent = REPLACE(cContent,"from_","from")
       cContent = REPLACE(cContent,"to_","to")
       cContent = REPLACE(cContent,"[","")
       cContent = REPLACE(cContent,"]","").

MESSAGE STRING(cContent)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

ASSIGN cURL  = "https://private-anon-49e0e4850-zenviasms.apiary-proxy.com/services/send-sms"
       cURL  = "https://api-rest.zenvia360.com.br/services/send-sms"
       cAuth = "dG9ydHVnYS5hcGk6dktaeTBkd3o1RA==".

/* Le a informa‡Æo do Retorno */
CREATE "MSXML2.XMLHTTP.3.0" http NO-ERROR.
http:OPEN("POST", cURL, FALSE).
http:setRequestHeader("Authorization", "Basic " + cAuth).
http:setRequestHeader("Content-Type", "application/json").
http:setRequestHeader("Accept", "application/json").

cBody = STRING(cContent).

http:SEND(cBody) NO-ERROR.

/* Armazena o retorno */
strRET = http:responseText.

MESSAGE STRING(strRET)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* Trata o retorno */
ASSIGN strRET = REPLACE(strRET,CHR(123),"")
       strRET = REPLACE(strRET,CHR(125),"")
       strRET = REPLACE(strRET,CHR(10),"")
       strRET = REPLACE(strRET," ","")
       strRET = REPLACE(strRET,'"sendSmsResponse":','')
       strRET = TRIM(strRET).

DEFINE VARIABLE idx     AS INTEGER     NO-UNDO.
DEFINE VARIABLE idx2    AS INTEGER     NO-UNDO.
DEFINE VARIABLE cLinha  AS CHARACTER   NO-UNDO.

CREATE sendSmsResponse.

DO idx = 1 TO NUM-ENTRIES(strRET,","):
                        
    IF ENTRY(idx,strRET) <> ? THEN DO:

        ASSIGN cLinha = TRIM(ENTRY(idx,strRET)).

        DO idx2 = 1 TO NUM-ENTRIES(cLinha,':'):

            CASE REPLACE(TRIM(ENTRY(idx2,cLinha,':')),'"',''):

                WHEN "statusCode" THEN
                    ASSIGN sendSmsResponse.statusCode = REPLACE(TRIM(ENTRY(idx2 + 1,cLinha,':')),'"','').

                WHEN "statusDescription" THEN
                    ASSIGN sendSmsResponse.statusDescription = REPLACE(TRIM(ENTRY(idx2 + 1,cLinha,':')),'"','').

                WHEN "detailCode" THEN
                    ASSIGN sendSmsResponse.detailCode = REPLACE(TRIM(ENTRY(idx2 + 1,cLinha,':')),'"','').

                WHEN "detailDescription" THEN
                    ASSIGN sendSmsResponse.detailDescription = REPLACE(TRIM(ENTRY(idx2 + 1,cLinha,':')),'"','').

            END CASE.

        END.

    END.
    
END.

MESSAGE "statusCode " statusCode                SKIP
        "statusDescription " statusDescription  SKIP
        "detailCode " detailCode                SKIP
        "detailDescription " detailDescription
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
