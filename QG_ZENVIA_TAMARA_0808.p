/* Variaveis para criacao do JSON */
DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE cContent AS LONGCHAR   NO-UNDO.

DEFINE VARIABLE cDestinos AS CHARACTER   NO-UNDO.

/*cDestinos = "5511996566594,5511961921595,5511984567809,5511968604752,5511986960615,5511996536425,5511944927385,5511959821634,5511984565780,5511954750431,5511996373631,5511986359525,5511986970502,5511998915526,5511963824828,5511960695049,5511987420277,5511943952942,5511942774810,5511950783163,5511995605988,5519991704580,5511995600412,5511995419617,5567999120558,5511998209332,5511963795790,5581981317946,5511986359422,5562999313908,5566997250313,5511957960020,5511941165090,5511984566846,5521979560060,5511999051513,5569999846700,5519991704790,5511975672247,5544991222822,5511954750266,5511987765381,5534998174041,5511997402216".*/

cDestinos = "5511981338172,5511984677500,5516997610179,5519991704580,5511984441186,5511995419617,5511998209332,5511963795790,5581981317946,5511986359422,5511996536425,5511941165090,5521979560060,5511999051513,5519991704790,5511971811639,5511987765381,5534998174041,5511950610199,5511941543789,5511985650032,5511997581267,5511995961307,5511941997720,5518996079425,5519994031231,5534998161141,5519993046537,5511999143026,5519991960976,5511950719352,5519991960799,5511941967273,5519995757542,5511960695554,5511961921595,5511959821621,5551981918821".

/*cDestinos = "5511997402216,5511997402216".*/
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

DO iCont = 1 TO NUM-ENTRIES(cDestinos):

    EMPTY TEMP-TABLE sendSmsRequest.
    
    CREATE sendSmsRequest.
    ASSIGN sendSmsRequest.from_          = "DSM"
           sendSmsRequest.to_            = ENTRY(iCont, cDestinos)
           sendSmsRequest.schedule       = ""
           sendSmsRequest.msg            = "Mauricio Adade e Marcelo Casta¤ares tem um convite especial para voce acesse: https://www.youtube.com/watch?v=78ZTyJHSlDw. Nao perca!"
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

    MESSAGE STRING(strRET)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

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

    MESSAGE "statusCode " statusCode                SKIP
            "statusDescription " statusDescription  SKIP
            "detailCode " detailCode                SKIP
            "detailDescription " detailDescription
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.
