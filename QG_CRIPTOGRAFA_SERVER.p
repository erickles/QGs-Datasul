/*******************************************************************************
** Programa...: PRGESP\TGES\TWEDI030.p
** Descricao..: Gatilho de WRITE da Tabela proces_edi
** Empresa....: DSM
** Autor......: ESS
** Versoes....: 09/06/2015 - 5.06.00.000 - Versao Inicial
*******************************************************************************/
{include/i-buffer.i}
{cdp/cdcfgdis.i}
{include/i-ambiente.i}
{utp/ut-glob.i}
{utp/utapi009.i}
/* Verifica se EMS2 e EMS5 estao no mesmo Ambiente (Producao ou Homologacao) */

/* Trata bancos para compilacao EMS 2 X EMS 5 */
/*{prgesp\include\i-buffer-ems5.i}*/

/* Include com Variaveis Globais de Ambiente  */
/*{prgesp\include\ut-glob-ems5.i}*/

/*{prgesp\apb\esapbapi001.i tt-relacto-tit-ap} /* Temp-Table tt-relacto-tit-ap */*/
/*
DEFINE PARAMETER BUFFER p-table     FOR proces_edi.
DEFINE PARAMETER BUFFER p-old-table FOR proces_edi.
*/
DEFINE VARIABLE cComando    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hAppSrv     AS HANDLE       NO-UNDO.
DEFINE VARIABLE hProg       AS HANDLE       NO-UNDO.
DEFINE VARIABLE iTime       AS INTEGER      NO-UNDO.
DEFINE VARIABLE online      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lApp        AS LOGICAL      NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE conteudo-cookie AS CHARACTER NO-UNDO.

DEFINE VARIABLE cChave AS CHARACTER   NO-UNDO.
ASSIGN cChave = "".

/* AppServer Functions */
FUNCTION fConectaAppServer RETURNS LOGICAL (INPUT iSeqAppService AS INTEGER):

    DEFINE VARIABLE nrAppSrv  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE counter   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lAppSrv   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE cParamApp AS CHARACTER   NO-UNDO.
    
    /* Localiza PF de Connecxao do AppServer */
    FIND es-param-aprov-eletro WHERE es-param-aprov-eletro.sequencia = iSeqAppService NO-LOCK NO-ERROR.

    IF NOT AVAILABLE es-param-aprov THEN
        RETURN NO.

    ASSIGN cParamApp = '-AppService ' + es-param-aprov-eletro.appService + ' '
                        + '-H ' + es-param-aprov-eletro.host + ' '
                        + '-S ' + es-param-aprov-eletro.service + ' '
                        + '-DirectConnect'
           cParamAPP = "-AppService TORTUGA -H SRVVM26 -S 3116 -DirectConnect"
           cParamAPP = "-AppService TORTUGA -H SRVVM17t -S 3116 -DirectConnect".
    
    CREATE SERVER hAppSrv.
    DO WHILE NOT lAppSrv:
        ASSIGN lAppSrv = hAppSrv:CONNECT(cParamApp ,"","") NO-ERROR.
        IF NOT lAppSrv THEN DO:
            nrAppSrv = nrAppSrv + 1.
            IF nrAppSrv = 2 THEN 
                LEAVE.            
        END.
    END.

    IF VALID-HANDLE(hAppSrv) THEN DO:
        
        IF NOT hAppSrv:CONNECTED() THEN DO:
            IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
                DO counter = 1 TO ERROR-STATUS:NUM-MESSAGES:
                    
                    /*
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = counter
                           RowErrors.ErrorNumber      = 17006
                           RowErrors.ErrorDescription = 'Falha Conex’o AppServer "' + es-param-aprov-eletro.descricao + '" - ' + ERROR-STATUS:GET-MESSAGE(counter)
                           RowErrors.ErrorParameters  = ''
                           RowErrors.ErrorType        = 'Custom'
                           RowErrors.ErrorHelp        = ERROR-STATUS:GET-MESSAGE(counter)
                           RowErrors.ErrorSubType     = 'Error'.
                    */
                END.
            END.
        END.
    
        /* MVR - Efetua Autenticacao no APPServer */
        /*
        IF VALID-HANDLE(hAppSrv) AND hAppSrv:CONNECTED() THEN DO:
            /*
            RUN esp/esapi910za.p (INPUT hAppSrv,          /* Hnd AppServer */
                                  INPUT conteudo-cookie,  /* Cookie */
                                  INPUT c-seg-usuario,    /* Usuario */
                                  INPUT "tortuga",        /* Dominio */
                                  OUTPUT TABLE tt-erros). /* Erros */
            */
            /* Trata Retorno de Erro de Autenticacao */
            IF RETURN-VALUE = "NOK" OR CAN-FIND(FIRST tt-erros) THEN DO:
                
                /*
                FOR EACH tt-erros:
                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorSequence    = counter
                           RowErrors.ErrorNumber      = tt-erros.cod-erro
                           RowErrors.ErrorDescription = tt-erros.desc-erro
                           RowErrors.ErrorParameters  = ''
                           RowErrors.ErrorType        = 'Custom'
                           RowErrors.ErrorHelp        = tt-erros.desc-erro
                           RowErrors.ErrorSubType     = 'Error'.
                END.
                */
            END.
        END.
        */
        RETURN hAppSrv:CONNECTED().

    END.

    RETURN FALSE.

END FUNCTION.

FUNCTION fDesconectaAppServer RETURNS LOGICAL:

    DEFINE VARIABLE lDisconnect AS LOGICAL     NO-UNDO.

    IF VALID-HANDLE(hAppSrv) THEN DO:
        IF hAppSrv:CONNECTED() THEN DO:
            ASSIGN lDisconnect = hAppSrv:DISCONNECT() NO-ERROR.
        END.
        DELETE OBJECT hAppSrv NO-ERROR.
    END.

    RETURN lDisconnect.

END FUNCTION.

REPEAT:

    iTime = TIME.

    IF NOT online THEN DO:
        
        IF conteudo-cookie = "" THEN 
            RUN createContextoSessao IN THIS-PROCEDURE.
            
        FIND FIRST Ws-sessao WHERE Ws-sessao.Identificacao = conteudo-cookie NO-LOCK NO-ERROR.
        IF NOT AVAIL ws-sessao THEN RETURN.
            
        /*EMPTY TEMP-TABLE rowErrors.*/
            
        ASSIGN lApp = fConectaAppServer(1) NO-ERROR.
        IF NOT lApp THEN DO:

            MESSAGE "Nao conectou"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        
        END.
        
        /* Criptografa arquivo */
        RUN esp\esapiCript.p ON SERVER hAppSrv (INPUT "\\SRVVM01\ScanTI\teste.rem",
                                                INPUT "E:\ESCRITURAL\TOR\PAG\ITAU\REM\teste.rem",
                                                INPUT "itau_admin").

        ASSIGN lApp = fDesconectaAppServer().

    END.
    ELSE DO:
        IF conteudo-cookie = "" THEN 
            RUN createContextoSessao IN THIS-PROCEDURE.
            
        FIND FIRST Ws-sessao WHERE Ws-sessao.Identificacao = conteudo-cookie NO-LOCK NO-ERROR.
        IF NOT AVAIL ws-sessao THEN RETURN.
            
        /*EMPTY TEMP-TABLE rowErrors.*/
            
        ASSIGN lApp = fConectaAppServer(1) NO-ERROR.
        IF NOT lApp THEN DO:

            MESSAGE "Nao conectou"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        
        END.
        
        /* Criptografa arquivo */
        RUN esp\esapiCript.p ON SERVER hAppSrv (INPUT "\\SRVVM01\ScanTI\teste.rem",
                                                INPUT "E:\ESCRITURAL\TOR\PAG\ITAU\REM\teste.rem",
                                                INPUT "itau_admin").

        ASSIGN lApp = fDesconectaAppServer().
    END.

    IF lApp THEN
        LEAVE.

END.

RETURN "OK".

PROCEDURE createContextoSessao:

    CREATE Ws-sessao.
    ASSIGN Ws-sessao.Usuario = c-seg-usuario
           Ws-sessao.Data    = TODAY
           Ws-sessao.Hora    = STRING(TIME,"HH:MM:SS")
           Ws-sessao.Tipo    = "USU"
           ws-sessao.codigo  = 0
           Ws-sessao.Identificacao = STRING(NEXT-VALUE(GapSeqIdentificacao),"999999999")    +
                                     STRING(RANDOM(1,1000000000),"9999999999")              +
                                     STRING(TIME,"99999")                                   +
                                     STRING((TIME * RANDOM(1,YEAR(TODAY) + 1)),"999999999") +
                                     STRING((TIME * RANDOM(1,MONTH(TODAY) + 1)),"9999999")  +
                                     STRING((TIME * RANDOM(1,DAY(TODAY) + 1)),"9999999").

    ASSIGN conteudo-cookie = ws-sessao.Identificacao.

END PROCEDURE.
