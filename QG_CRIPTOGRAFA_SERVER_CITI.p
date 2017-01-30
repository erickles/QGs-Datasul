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

DEFINE VARIABLE cChave      AS CHARACTER   NO-UNDO.
/*
IF NOT adm-ambiente = "PRODUCAO" THEN
    ASSIGN cChave = "DSMFARIALIMA".
ELSE
    ASSIGN cChave = "bcotst".

*/
/* Buscando nos registros de localiza‡Æo de arquivo EDI */
FIND FIRST es_localiz_arq_edi WHERE es_localiz_arq_edi.cdn_parcei_edi               = 745
                                AND es_localiz_arq_edi.cdn_trans_edi                = 1000
                                AND es_localiz_arq_edi.ind_finalid_localiz_arq_edi  = "EXPORTACAO"
                                NO-LOCK NO-ERROR.

IF AVAIL es_localiz_arq_edi THEN
    ASSIGN cChave = es_localiz_arq_edi.nome_chave.

/* AppServer Functions */
FUNCTION fConectaAppServer RETURNS LOGICAL:

    DEFINE VARIABLE nrAppSrv  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE counter   AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lAppSrv   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE cParamApp AS CHARACTER   NO-UNDO.
    
    /* Localiza PF de Connecxao do AppServer */
    FIND FIRST servid_rpc WHERE servid_rpc.cod_servid_rpc = "dsm" NO-LOCK NO-ERROR.
    IF NOT AVAILABLE servid_rpc THEN
        RETURN NO.

    ASSIGN cParamApp = servid_rpc.des_carg_rpc
           cParamApp = REPLACE(cParamApp,"srvvm17t","srvvm17").    

    /*
    MESSAGE cParamApp
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
    CREATE SERVER hAppSrv.
    DO WHILE NOT lAppSrv:

        ASSIGN lAppSrv = hAppSrv:CONNECT(cParamApp ,?,?,?) NO-ERROR.

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
                           RowErrors.ErrorDescription = 'Falha Conexao AppServer "' + es-param-aprov-eletro.descricao + '" - ' + ERROR-STATUS:GET-MESSAGE(counter)
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
            
            RUN esp/esapi910za.p (INPUT hAppSrv,            /* Hnd AppServer */
                                  INPUT conteudo-cookie,    /* Cookie */
                                  INPUT "ems",              /* Usuario */
                                  INPUT "tortuga",          /* Dominio */
                                  OUTPUT TABLE tt-erros).   /* Erros */
            
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
        /*IF NOT AVAIL ws-sessao THEN RETURN.*/
            
        /*EMPTY TEMP-TABLE rowErrors.*/
            
        ASSIGN lApp = fConectaAppServer() NO-ERROR.
        IF NOT lApp THEN DO:
            MESSAGE "Nao conectou"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.                        
        END.
        
        /* Criptografa arquivo */        
        RUN \\srvvm17t\totvs\Biblioteca\TOTVS\ATUALIZACAO\esp\esapiCriptCiti.p ON SERVER hAppSrv (INPUT "\\srvvm01\ScanTI\TESTE.REM",
                                                                                                  INPUT "E:\ESCRITURAL\TOR\PAG\CITI\REM\TESTE.REM",
                                                                                                  INPUT "\\srvvm01\ScanTI\").
        /*
        RUN esp\esapiCriptCiti.r ON SERVER hAppSrv (INPUT "O:\ESCRITURAL\TOR\PAG\CITI\REM\23092016150659.REM",
                                                    INPUT "E:\ESCRITURAL\TOR\PAG\CITI\REM\23092016150659.REM",
                                                    INPUT "E:\ESCRITURAL\TOR\PAG\CITI\LOG\").
        */
        ASSIGN lApp = fDesconectaAppServer().

    END.
    ELSE DO:
        IF conteudo-cookie = "" THEN 
            RUN createContextoSessao IN THIS-PROCEDURE.
            
        FIND FIRST Ws-sessao WHERE Ws-sessao.Identificacao = conteudo-cookie NO-LOCK NO-ERROR.
        IF NOT AVAIL ws-sessao THEN RETURN.
            
        /*EMPTY TEMP-TABLE rowErrors.*/
            
        ASSIGN lApp = fConectaAppServer() NO-ERROR.
        IF NOT lApp THEN DO:

            MESSAGE "Nao conectou"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        
        END.

        /* Criptografa arquivo */
       RUN esp\esapiCriptCiti.r ON SERVER hAppSrv (INPUT "\\srvvm01\ScanTI\TESTE.REM",
                                                   INPUT "E:\ESCRITURAL\TOR\PAG\CITI\REM\TESTE.REM",
                                                   INPUT "\\srvvm01\ScanTI\").

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
