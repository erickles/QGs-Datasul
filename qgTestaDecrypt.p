/*AppServer x Decrypt process*/
DEFINE NEW GLOBAL SHARED VARIABLE conteudo-cookie AS CHARACTER NO-UNDO.

DEFINE VARIABLE cComando2 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hAppSrv   AS HANDLE       NO-UNDO.
DEFINE VARIABLE hProg     AS HANDLE       NO-UNDO.
DEFINE VARIABLE iTime     AS INTEGER      NO-UNDO.
DEFINE VARIABLE online    AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lApp      AS LOGICAL      NO-UNDO.

/* AppServer Functions */
FUNCTION fConectaAppServer RETURNS LOGICAL (INPUT iSeqAppService AS INTEGER):

    DEFINE VARIABLE nrAppSrv  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE counter   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lAppSrv   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE cParamApp AS CHARACTER   NO-UNDO.
    
    /* Localiza PF de Connecxao do AppServer */
    FIND FIRST mgcad.servid_rpc WHERE mgcad.servid_rpc.cod_servid_rpc = "DSM" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE mgcad.servid_rpc THEN
        RETURN NO.

    ASSIGN cParamApp = mgcad.servid_rpc.des_carg_rpc + ' -DirectConnect'
           cParamApp = mgcad.servid_rpc.des_carg_rpc.

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
                           RowErrors.ErrorDescription = 'Falha ConexÊo AppServer "' + es-param-aprov-eletro.descricao + '" - ' + ERROR-STATUS:GET-MESSAGE(counter)
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
            
            RUN esp/esapi910za.p (INPUT hAppSrv,          /* Hnd AppServer */
                                  INPUT conteudo-cookie,  /* Cookie */
                                  INPUT c-seg-usuario,    /* Usuario */
                                  INPUT "tortuga",        /* Dominio */
                                  OUTPUT TABLE tt-erros). /* Erros */
            
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

    MESSAGE "entrou no repeat"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    IF NOT online THEN DO:

        MESSAGE "not online"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        IF conteudo-cookie = "" THEN 
            RUN createContextoSessao IN THIS-PROCEDURE.
        
        FIND FIRST Ws-sessao 
             WHERE Ws-sessao.Identificacao = conteudo-cookie NO-LOCK NO-ERROR.

        
        ASSIGN lApp = fConectaAppServer(1) NO-ERROR.
        IF NOT lApp THEN DO:
            MESSAGE 
                "Nao conectou" SKIP 
                "lApp -> " lApp
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            LEAVE.
        END.

    END.

END.


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



        
        
