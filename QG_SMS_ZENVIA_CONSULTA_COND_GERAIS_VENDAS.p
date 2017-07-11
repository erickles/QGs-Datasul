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

ASSIGN cURL  = "https://api-rest.zenvia360.com.br/services/get-sms-status/000DDD"
       cAuth = "dG9ydHVnYS5hcGk6dktaeTBkd3o1RA==".

/* Le a informa‡Æo do Retorno */
CREATE "MSXML2.XMLHTTP.3.0" http NO-ERROR.
http:OPEN("GET", cURL, FALSE).
http:setRequestHeader("Authorization", "Basic " + cAuth).
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
       strRET = REPLACE(strRET,'"getSmsStatusResp":','')
       strRET = TRIM(strRET).

MESSAGE STRING(strRET)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

DEFINE VARIABLE idx     AS INTEGER     NO-UNDO.
DEFINE VARIABLE idx2    AS INTEGER     NO-UNDO.
DEFINE VARIABLE cLinha  AS CHARACTER   NO-UNDO.
/*
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
*/
