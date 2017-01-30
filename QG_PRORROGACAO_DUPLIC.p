{include/i-buffer.i}
DEFINE VARIABLE cod-solicita AS INTEGER   NO-UNDO.

DEFINE VARIABLE c-mail-destino  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-out-de        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-out-assunto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-out-mensagem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-out-error     AS LOGICAL     NO-UNDO.

UPDATE cod-solicita LABEL "Codigo da solicitacao".

/* Gera listagem de usuarios copia */
FIND FIRST es-desconto-duplic WHERE es-desconto-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
IF AVAIL es-desconto-duplic THEN DO:
    
    FOR EACH es-desconto-info WHERE es-desconto-info.nr-solicita = es-desconto-duplic.nr-solicita NO-LOCK:
        
        IF AVAIL es-desconto-info THEN DO:
            
            FIND FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuar = es-desconto-info.usuar-copia NO-ERROR.
            IF AVAIL usuar_mestre THEN DO:
        
                ASSIGN c-mail-destino = usuar_mestre.cod_e_mail_local.
                MESSAGE c-mail-destino
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                /* Caso seja um email tortuga, dispara internamente */
                IF INDEX(c-mail-destino,"@tortuga.com.br") > 0 THEN DO:
                    RUN mail/wsmail.p (INPUT c-out-de,          /* remetente */
                                       INPUT c-mail-destino,    /* destinatario */
                                       INPUT c-out-assunto,
                                       INPUT c-out-mensagem,
                                       OUTPUT l-out-error).
                END.
                ELSE DO:
                    
                    /* Caso seja um email externo (@dsm) dispara externamente via pescador no servidor */
                    CREATE es-comunica-cliente-envio.
                    ASSIGN es-comunica-cliente-envio.char-1         = c-out-de
                           es-comunica-cliente-envio.destino        = c-mail-destino
                           es-comunica-cliente-envio.texto-mensagem = c-out-mensagem
                           es-comunica-cliente-envio.nome-abrev     = "DESCONTO-DUPLIC"
                           es-comunica-cliente-envio.nr-pedcli      = STRING(es-desconto-duplic.nr-solicita).
                END.

                ASSIGN c-mail-destino = "".

            END.
        END.
    END.
END. 
/**/
