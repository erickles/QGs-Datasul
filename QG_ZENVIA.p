DEFINE TEMP-TABLE tt-send NO-UNDO
    FIELD cFrom              AS CHAR
    FIELD cTo                AS CHAR
    FIELD cMsg               AS CHAR
    FIELD cCallbackOption    AS CHAR
    FIELD cId                AS CHAR.

DEFINE TEMP-TABLE tt-zenvia NO-UNDO
    FIELD cCode     AS CHAR
    FIELD cMessage  AS CHAR.

CREATE tt-send.
ASSIGN tt-send.cFrom           = ""
       tt-send.cTo             = "5511997402216"
       tt-send.cMsg            = "TESTE JSON DSM"
       tt-send.cCallbackOption = "ALL"
       tt-send.cId             = "009".

RUN piEnviaSmsZenvia(INPUT tt-send.cFrom,
                     INPUT tt-send.cTo,
                     INPUT tt-send.cMsg,
                     INPUT tt-send.cCallbackOption,
                     INPUT tt-send.cId,
                     INPUT "https://private-anon-49e0e4850-zenviasms.apiary-proxy.com/services/send-sms",
                     INPUT "dG9ydHVnYS5hcGk6dktaeTBkd3o1RA==").

PROCEDURE piEnviaSmsZenvia:

    DEFINE INPUT PARAMETER cFrom            AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER cTo              AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER cMsg             AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER cCallbackOption  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER cId              AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER strURL           AS LONGCHAR  NO-UNDO.
    DEFINE INPUT PARAMETER cAuth            AS LONGCHAR  NO-UNDO.

    /* Variaveis da consulta ao webservice */
    DEFINE VARIABLE http        AS COM-HANDLE.
    DEFINE VARIABLE strRET      AS CHARACTER.
    DEFINE VARIABLE cBody       AS CHARACTER   NO-UNDO.

    /* Leitura do JSON */    
    DEFINE VARIABLE sendSmsResponse AS HANDLE       NO-UNDO.
    DEFINE VARIABLE idx             AS INTEGER     NO-UNDO.
    DEFINE VARIABLE idx2            AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cChave          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDetalhe        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cLinha          AS CHARACTER   NO-UNDO.
    
    /* Le a informa‡Æo do Retorno */
    CREATE "MSXML2.XMLHTTP.3.0" http NO-ERROR.
    http:OPEN("POST", strURL, FALSE).
    http:setRequestHeader("Authorization", "Basic " + cAuth).
    http:setRequestHeader("Content-Type", "application/json").
    http:setRequestHeader("Accept", "application/json").
    
    cBody = CHR(123) +
                '"sendSmsRequest": ' + 
                    CHR(123) +
                        /*'"from":"'           + cFrom            + '",' +*/
                        '"to":"'             + cTo              + '",' +
                        '"msg":"'            + cMsg             + '",' +
                        
                        (IF cId <> "" THEN
                            STRING('"id":"' + cId + '",') 
                        ELSE
                            '')                                         +
                        '"callbackOption":"' + cCallbackOption  + '"'    +
                    CHR(125)         +
            CHR(125).
    
    http:SEND(cBody) NO-ERROR.
    
    /* Armazena o retorno */
    strRET = http:responseText.
    
    /* Se tiver erro, retorna o erro */
    IF strRET BEGINS "Houve erro" THEN DO:
       /* Trata */
    END.
    ELSE DO:
        /* Trata o retorno */
        ASSIGN strRET = REPLACE(strRET,CHR(123),"")
               strRET = REPLACE(strRET,CHR(125),"")
               strRET = REPLACE(strRET,CHR(10),"")
               strRET = REPLACE(strRET," ","")
               strRET = REPLACE(strRET,'"sendSmsResponse":','')
               strRET = TRIM(strRET).

        DO idx = 1 TO NUM-ENTRIES(strRET,","):
                                
            IF ENTRY(idx,strRET) <> ? THEN DO:
                ASSIGN cLinha   = TRIM(ENTRY(idx,strRET)).
                
                CREATE tt-zenvia.

                DO idx2 = 1 TO NUM-ENTRIES(cLinha,':'):

                    IF idx2 = 1 THEN
                        tt-zenvia.cCode    = REPLACE(TRIM(ENTRY(idx2,cLinha,':')),'"','').
                    ELSE
                        tt-zenvia.cMessage = REPLACE(TRIM(ENTRY(idx2,cLinha,':')),'"','').
                    
                END.

                MESSAGE tt-zenvia.cCode SKIP
                        tt-zenvia.cMessage
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

            END.
            
        END.
                
    END.

END PROCEDURE.
