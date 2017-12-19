/* Variaveis para criacao do JSON */
DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE cContent AS LONGCHAR   NO-UNDO.

DEFINE VARIABLE cDestinos AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD numero      AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Temp\listavivo.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.numero.

END.
INPUT CLOSE.

DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

/* Variaveis da consulta ao webservice */
DEFINE VARIABLE http        AS COM-HANDLE.
DEFINE VARIABLE strRET      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cBody       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cAuth       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cURL        AS CHARACTER    NO-UNDO.

DEFINE VARIABLE idx     AS INTEGER     NO-UNDO.
DEFINE VARIABLE idx2    AS INTEGER     NO-UNDO.
DEFINE VARIABLE cLinha  AS CHARACTER   NO-UNDO.

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

ASSIGN cURL  = "https://private-anon-49e0e4850-zenviasms.apiary-proxy.com/services/send-sms"
       cURL  = "https://api-rest.zenvia360.com.br/services/send-sms"
       cAuth = "dG9ydHVnYS5hcGk6dktaeTBkd3o1RA==".

FOR EACH tt-planilha:

    IF tt-planilha.numero = "" THEN NEXT.

    ASSIGN tt-planilha.numero = REPLACE(tt-planilha.numero, " ","")
           tt-planilha.numero = REPLACE(tt-planilha.numero, "(","")
           tt-planilha.numero = REPLACE(tt-planilha.numero, ")","")
           tt-planilha.numero = REPLACE(tt-planilha.numero, "-","")
           tt-planilha.numero = "55" + tt-planilha.numero.
    
    EMPTY TEMP-TABLE sendSmsRequest.

    CREATE sendSmsRequest.
    ASSIGN sendSmsRequest.from_          = "DSM"
           sendSmsRequest.to_            = tt-planilha.numero
           sendSmsRequest.schedule       = ""
           sendSmsRequest.msg            = "Vocˆ tem at‚ o dia 25/10 para finalizar sua autoavaliacao de desempenho e avaliar sua equipe! Engaje sua equipe e se dedique nas suas avaliacoes.Participe!"
           sendSmsRequest.callbackOption = "NONE"
           sendSmsRequest.id             = ""
           sendSmsRequest.aggregateId    = "".

    lRetOK = TEMP-TABLE sendSmsRequest:WRITE-JSON(cTargetType, cContent, lFormatted).

    ASSIGN cContent = REPLACE(cContent,"from_","from")
           cContent = REPLACE(cContent,"to_","to")
           cContent = REPLACE(cContent,"[","")
           cContent = REPLACE(cContent,"]","").
    
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

    /* Trata o retorno */
    ASSIGN strRET = REPLACE(strRET,CHR(123),"")
           strRET = REPLACE(strRET,CHR(125),"")
           strRET = REPLACE(strRET,CHR(10),"")
           strRET = REPLACE(strRET," ","")
           strRET = REPLACE(strRET,'"sendSmsResponse":','')
           strRET = TRIM(strRET).

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
    
    IF detailDescription = "MessageSent" THEN
        iCont = iCont + 1.
    
    
    MESSAGE "statusCode " statusCode                SKIP
            "statusDescription " statusDescription  SKIP
            "detailCode " detailCode                SKIP
            "detailDescription " detailDescription
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    
END.

MESSAGE "Foram enviados " + STRING(iCont) + " SMSs"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
