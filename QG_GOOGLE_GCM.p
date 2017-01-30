/*

Tipos de mensagem:
1 - Mensagem simples
2 - Mensagem simples com conteudo a ser inserido

*/

DEFINE VARIABLE cTipo AS CHARACTER   NO-UNDO.

ASSIGN cTipo = "1".

CASE cTipo:

    WHEN "1" THEN DO:
        RUN piEnviaGcmTypeOne(INPUT "Pedido 1234-XXXX",
                              INPUT "Pendente comercial",
                              INPUT "APA91bFL4ZcIkBAhgcSNgMihhjydSJGi7Ui88T-7IiVg0z9nTJTd8NiQtHewRFD7FFZoe6-7HE2O80GJ5yRH5gKXZnQVKg06ap0ySAncQfRzSd1yc6fptXLX1NA39cBWqEOQ93MqTgzJwWuVRbucskMHb0W8rKS_8w").
    END.

    WHEN "2" THEN DO:
        RUN piEnviaGcmTypeTwo(INPUT "Nova condi‡Æo VV d¡sponivel!",
                              INPUT "VV 94 adicionada ao PedMombile",
                              INPUT "APA91bFL4ZcIkBAhgcSNgMihhjydSJGi7Ui88T-7IiVg0z9nTJTd8NiQtHewRFD7FFZoe6-7HE2O80GJ5yRH5gKXZnQVKg06ap0ySAncQfRzSd1yc6fptXLX1NA39cBWqEOQ93MqTgzJwWuVRbucskMHb0W8rKS_8w",
                              INPUT "vv",
                              INPUT "add",
                              INPUT "").
    END.

END CASE.

PROCEDURE piEnviaGcmTypeOne:
/*------------------------------------------------------------------------------
  Purpose:     Dispara uma mensagem para o Google cloud message
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER cTitle   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER cMessage AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER gcmId    AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE strURL AS CHARACTER   NO-UNDO.
    strURL = "https://android.googleapis.com/gcm/send".

    /* Variaveis da consulta ao webservice */
    DEFINE VARIABLE http        AS COM-HANDLE.
    DEFINE VARIABLE strRET      AS CHARACTER.
    DEFINE VARIABLE cBody       AS CHARACTER   NO-UNDO.

    /* Le a informa‡Æo do Retorno */
    CREATE "MSXML2.XMLHTTP.3.0" http NO-ERROR.
    http:OPEN("POST", strURL, FALSE).
    http:setRequestHeader("Authorization", "key=AIzaSyC8HLAV-e6I1HFZz6fdMLGA8c9mhtO7LUM").
    http:setRequestHeader("Content-Type", "application/json").
    
    cBody = CHR(123) +
                '"data": ' + 
                    CHR(123) +
                        '"type":"'      + "1"              + '",' +
                        '"title":"'     + cTitle              + '",' +
                        '"message":"'   + cMessage             + '"' +
                    CHR(125)         + ',' +

                    '"to"' + ' : ' + '"' + gcmId + '"' +
            CHR(125).
    
    http:SEND(cBody) NO-ERROR.
    
    /* Armazena o retorno */
    strRET = http:responseText.   
    
    /* Se tiver erro, retorna o erro */
    
    IF strRET BEGINS "Houve erro" THEN DO:
       /* Trata */
    END.
    ELSE DO:
        /*
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
                
                DO idx2 = 1 TO NUM-ENTRIES(cLinha,':'):
                    IF idx2 = 1 THEN
                        tt-zenvia.cTag     = TRIM(REPLACE(TRIM(ENTRY(idx2,cLinha,':')),'"','')).
                    ELSE
                        tt-zenvia.cContent = TRIM(REPLACE(TRIM(ENTRY(idx2,cLinha,':')),'"','')).
                END.
            END.
        END.
        */
    END.
    
END PROCEDURE.

PROCEDURE piEnviaGcmTypeTwo:
/*------------------------------------------------------------------------------
  Purpose:     Dispara uma mensagem para o Google cloud message
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* T¡tulo da mensagem */
    DEFINE INPUT PARAMETER cTitle   AS CHARACTER NO-UNDO.

    /* Corpo da mensagem */
    DEFINE INPUT PARAMETER cMessage AS CHARACTER NO-UNDO.

    /* Id do receptor */
    DEFINE INPUT PARAMETER gcmId    AS CHARACTER NO-UNDO.

    /* Tipo de entidade a ser inserida\deletada do aparelho */
    DEFINE INPUT PARAMETER cEntity  AS CHARACTER NO-UNDO.

    /* Acao a ser tomada no aparelho: "add" ou "delete" */
    DEFINE INPUT PARAMETER cAction  AS CHARACTER NO-UNDO.

    /* Conteudo a ser importado no banco do aparelho */
    DEFINE INPUT PARAMETER cContent AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE strURL AS CHARACTER   NO-UNDO.
    strURL = "https://android.googleapis.com/gcm/send".

    /* Variaveis da consulta ao webservice */
    DEFINE VARIABLE http        AS COM-HANDLE.
    DEFINE VARIABLE strRET      AS CHARACTER.
    DEFINE VARIABLE cBody       AS CHARACTER   NO-UNDO.

    /* Le a informa‡Æo do Retorno */
    CREATE "MSXML2.XMLHTTP.3.0" http NO-ERROR.
    http:OPEN("POST", strURL, FALSE).
    http:setRequestHeader("Authorization", "key=AIzaSyC8HLAV-e6I1HFZz6fdMLGA8c9mhtO7LUM").
    http:setRequestHeader("Content-Type", "application/json").    
    
    cBody = CHR(123) +
                '"data": ' + 
                    CHR(123) +
                        '"type":"'      + "1"       + '",' +
                        '"title":"'     + cTitle    + '",' +
                        '"message":"'   + cMessage  + '",' +
                        '"entity":"'    + cEntity   + '",' +
                        '"action":"'    + cAction   + '",' +
                        '"content":"'   + cContent  + '"' +
                    CHR(125)         + ',' +

                    '"to"' + ' : ' + '"' + gcmId + '"' +
            CHR(125).
    
    http:SEND(cBody) NO-ERROR.
    
    /* Armazena o retorno */
    strRET = http:responseText.   
    
    /* Se tiver erro, retorna o erro */
    
    IF strRET BEGINS "Houve erro" THEN DO:
       /* Trata */
    END.
    ELSE DO:
        /*
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
                
                DO idx2 = 1 TO NUM-ENTRIES(cLinha,':'):
                    IF idx2 = 1 THEN
                        tt-zenvia.cTag     = TRIM(REPLACE(TRIM(ENTRY(idx2,cLinha,':')),'"','')).
                    ELSE
                        tt-zenvia.cContent = TRIM(REPLACE(TRIM(ENTRY(idx2,cLinha,':')),'"','')).
                END.
            END.
        END.
        */
    END.
    
END PROCEDURE.
