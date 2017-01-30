DEFINE VARIABLE c-blat              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-path-corpo-email  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-comando           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-server            AS CHARACTER  FORMAT "x(30)" NO-UNDO.
DEFINE VARIABLE c-out-de            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-out-para          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-assunto           AS CHARACTER   NO-UNDO.

FIND FIRST param-global NO-LOCK NO-ERROR.
IF AVAIL param-global THEN 
    ASSIGN c-server = param-global.serv-mail.
ELSE DO:
    RETURN 'NOK'.
END.

ASSIGN c-path-corpo-email = SEARCH("esp/doc/emailContent.html")
       c-path-corpo-email = REPLACE(c-path-corpo-email,"conteudo","teste")
       c-out-de           = "sac@tortuga.com.br"
       /*c-out-para         = "erick.souza@tortuga.com.br"*/
       c-out-para         = "erick842006@gmail.com"
       c-assunto          = "Teste_favor_responder_caso_receba(teste_de_envio)".

ASSIGN c-blat    =  SEARCH("interfac/mail/blat.exe")
       c-comando =  c-blat +
                    " -server " + c-server          +
                    " -f " + c-out-de               +
                    " -to " + c-out-para            +
                    /*" -u "                          +
                    "erick.souza@tortuga.com.br"    +
                    " -pw "                         +
                    "erickles11"                    +*/
                    " -subject " + c-assunto        +
                    " -body " + "teste".

MESSAGE c-comando
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

OS-COMMAND SILENT VALUE (c-comando).
