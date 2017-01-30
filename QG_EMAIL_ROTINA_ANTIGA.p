{include/i-buffer.i}
{utp/utapi019.i}    /* Temp-table para envio de e-mail */
{utp/ut-glob.i}

/*------------ Envio e-mail -------------*/

DEFINE VAR c-remetente        AS CHARACTER  no-undo.
DEFINE VAR c-destino          AS CHARACTER  no-undo.
DEFINE VAR c-assunto-e-mail   AS CHARACTER  no-undo.
DEFINE VAR c-mensagem-e-mail  AS CHARACTER  NO-UNDO FORMAT 'x(38)'.
DEFINE VAR c-copia            AS CHARACTER  NO-UNDO.

ASSIGN c-remetente       = "erick.souza@tortuga.com.br"
       c-destino         = "erick.souza@tortuga.com.br"
       c-assunto-e-mail  = "teste"
       c-mensagem-e-mail = "teste"
       c-copia           = "".

/* Codigo de pagina para impressao em iso8859-1 quando for envio e-mail */
DEF VAR codepage-orig AS CHAR FORMAT "X(10)" NO-UNDO.
DEF VAR codepage-dest AS CHAR FORMAT "X(10)" NO-UNDO.

DEF VAR l-envia AS LOGICAL INIT YES NO-UNDO.

/*{cdp/cdapi523.i "h-prg523"}*/

DEFINE VARIABLE h-prg523 AS HANDLE.
FUNCTION empresa    RETURNS INTEGER   IN h-prg523.
FUNCTION serv-mail  RETURNS CHARACTER IN h-prg523.
FUNCTION porta-mail RETURNS INTEGER   IN h-prg523.
FUNCTION ms-serv    RETURNS LOGICAL   IN h-prg523.
FUNCTION modulo-mp  RETURNS LOGICAL   IN h-prg523.
FUNCTION modulo-cl  RETURNS LOGICAL   IN h-prg523.
FUNCTION modulo-ge  RETURNS LOGICAL   IN h-prg523.
FUNCTION sc-format  RETURNS CHARACTER IN h-prg523.
FUNCTION ct-format  RETURNS CHARACTER IN h-prg523.

FIND FIRST param-global NO-LOCK NO-ERROR.

IF AVAIL param-global THEN DO:
    
    FOR EACH tt-envio:
        DELETE tt-envio.
    END.
    
    CREATE tt-envio.
    ASSIGN tt-envio.versao-integracao = 001
           tt-envio.importancia       = 1
           tt-envio.remetente         = c-remetente       
           tt-envio.destino           = c-destino
           tt-envio.assunto           = c-assunto-e-mail 
           tt-envio.mensagem          = c-mensagem-e-mail
           tt-envio.copia             = c-copia.

    RUN cdp/cdapi523.p PERSISTENT SET h-prg523.

    IF VALID-HANDLE(h-prg523) AND RETURN-VALUE = "OK" THEN DO:
        ASSIGN tt-envio.servidor = serv-mail()
               tt-envio.porta    = porta-mail()
               tt-envio.exchange = ms-serv().
        DELETE PROCEDURE h-prg523.
    END.

    IF AVAIL tt-envio THEN DO:

        RUN utp/utapi009.p (INPUT TABLE tt-envio,
                            OUTPUT TABLE tt-erros).

        IF RETURN-VALUE = "NOK" THEN DO:
            FOR EACH tt-erros:
                DISP tt-erros WITH 1 COLUMN WIDTH 300.
            END.
        END.
    END.
END.
