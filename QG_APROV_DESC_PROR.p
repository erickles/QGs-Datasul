    {include/i-buffer.i}
    DEFINE VARIABLE c-seg-usuario AS CHARACTER   NO-UNDO INITIAL "as41742".
    DEFINE VARIABLE quem-envia     AS CHAR FORMAT "x(50)" NO-UNDO.
    DEFINE VARIABLE mail-envia-1   AS CHAR INITIAL "" NO-UNDO.
    DEFINE VARIABLE c-mail-destino AS CHAR INITIAL "" NO-UNDO.
    DEFINE VARIABLE aprovador-primario  AS LOGICAL INITIAL NO NO-UNDO.
    DEFINE VARIABLE aprovador-master    AS LOGICAL INITIAL NO NO-UNDO.

    DEFINE VARIABLE c-estabel-corrente AS CHAR NO-UNDO.
    DEFINE VARIABLE c-estabel-solicita AS CHAR NO-UNDO.
    
    FIND FIRST es-desconto-duplic WHERE es-desconto-duplic.nr-solicita = 2347 NO-LOCK NO-ERROR.
    IF AVAIL es-desconto-duplic THEN DO:

        /* SD 1403 - Verifica se o estabel do implantador da solicitaá∆o confere com o do aprovador */

        /* acha o cod-estabel do usuario executando o programa */
        FIND es-usuario NO-LOCK WHERE es-usuario.cod-usuario = c-seg-usuario NO-ERROR.
        IF AVAIL es-usuario THEN DO:
            ASSIGN c-estabel-corrente = es-usuario.cod-estabel.
        END.
        ELSE DO:
            MESSAGE "Usu†rio sem permiss∆o para Aprovaá∆o!" 
                    VIEW-AS ALERT-BOX ERROR.
            RETURN "NOK".
        END.
        
        /* acha o cod-estabel do usuario que criou a solicitaá∆o */
        FIND es-usuario NO-LOCK WHERE es-usuario.cod-usuario = es-desconto-duplic.usuar-implant NO-ERROR.
        IF AVAIL es-usuario THEN DO:
            ASSIGN c-estabel-solicita = "19" /*es-usuario.cod-estabel*/. 
        END.

        /*Identifica se o aprovador Ç primario*/
        ASSIGN aprovador-primario = IF es-desconto-duplic.usuar-aprov1 = "" THEN YES ELSE NO.
        
        /*Identifica se o aprovador Ç master*/        
        FIND es-usuario NO-LOCK WHERE es-usuario.cod-usuario = c-seg-usuario NO-ERROR.
        IF SUBSTRING(es-usuario.char-2,11,1) = "S" OR es-usuario.i-desc-prorroga-dupl THEN DO:
            ASSIGN aprovador-master = YES.
        END.        
        /**/

        /*Identifica se o aprovador Ç master*/        
        FIND es-usuario NO-LOCK WHERE es-usuario.cod-usuario = c-seg-usuario NO-ERROR.
        IF  es-desconto-duplic.usuar-aprov1 = "" AND es-usuario.i-desc-prorroga-dupl THEN DO:
            MESSAGE "Usu†rio sem permiss∆o para aprovaá∆o Final, obrigat¢ria prÇ-aprovaá∆o!"
                    VIEW-AS ALERT-BOX ERROR.
            RETURN "NOK".
        END.        
        /**/
        
        /*Permissao*/
        FIND es-usuario NO-LOCK WHERE es-usuario.cod-usuario = c-seg-usuario NO-ERROR.
        IF  NOT AVAIL es-usuario THEN DO:
            MESSAGE "Usu†rio sem permiss∆o para Aprovar Solicitaá∆o!"
                    VIEW-AS ALERT-BOX ERROR.
            RETURN "NOK".
        END.

        FIND es-usuario NO-LOCK WHERE es-usuario.cod-usuario = c-seg-usuario NO-ERROR.
        IF  date(substring(es-usuario.char-2,1,10)) < TODAY AND substring(es-usuario.char-2,11,1) = "S" THEN DO:
            MESSAGE "Usu†rio alternativo com data expirada para Aprovar Solicitaá∆o!"
                    VIEW-AS ALERT-BOX ERROR.
            RETURN "NOK".
        END.

        FIND es-usuario NO-LOCK WHERE es-usuario.cod-usuario = c-seg-usuario NO-ERROR.
        IF es-usuario.dec-1 < es-desconto-duplic.vl-tot-desc AND substring(es-usuario.char-2,11,1) = "S" THEN DO:
            MESSAGE "Valor Limite do Aprovador Alternativo inferior a Solicitaá∆o!"
                    VIEW-AS ALERT-BOX ERROR.
            RETURN "NOK".
        END.

        /*Verifica se o usuario Ç primario e se o valor limite permite pre-aprovacao*/
        FIND es-usuario NO-LOCK WHERE es-usuario.cod-usuario = c-seg-usuario NO-ERROR.
        IF  es-usuario.dec-1 < es-desconto-duplic.vl-tot-desc THEN DO:
            MESSAGE "Valor Limite de PrÇ-Aprovaá∆o do Usu†rio Ç inferior ao valor da Solicitaá∆o!"
                    VIEW-AS ALERT-BOX ERROR.
            RETURN "NOK".
        END.
        /**/

        /*Identifica se Ç permitida a aprovacao final*/
        FIND es-usuario NO-LOCK WHERE es-usuario.cod-usuario = c-seg-usuario NO-ERROR.
        IF  aprovador-primario = NO AND aprovador-master = NO THEN DO:
            MESSAGE "Usu†rio sem permiss∆o para Aprovaá∆o FINAL da Solicitaá∆o!"
                    VIEW-AS ALERT-BOX ERROR.
            RETURN "NOK".
        END.
        /**/

        IF aprovador-primario = YES AND aprovador-master = NO THEN DO:        

            FIND CURRENT es-desconto-duplic EXCLUSIVE-LOCK NO-ERROR NO-WAIT.

            /*ASSIGN es-desconto-duplic.usuar-aprov1 = c-seg-usuario.*/
    
            MESSAGE "Solicitaá∆o aprovada parcialmente, pendente a aprovaá∆o final!"
                    VIEW-AS ALERT-BOX ERROR.
        
            RELEASE es-desconto-duplic NO-ERROR.
    
        END.

        IF aprovador-master = YES THEN DO:

            DEF VAR tot-desconto AS DECIMAL FORMAT ">>>>,>>>,>>9.99" NO-UNDO.
            DEF VAR l-responde AS LOG NO-UNDO INIT NO.
    
            FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = c-seg-usuario /*es-desconto-duplic.usuar-implant*/ NO-LOCK NO-ERROR.
            IF AVAIL usuar_mestre THEN ASSIGN quem-envia   = usuar_mestre.nom_usuario
                                              mail-envia-1 = usuar_mestre.cod_e_mail_local.
            
            MESSAGE "Deseja Aprovar a solicitaá∆o de N£mero: " + string(es-desconto-duplic.nr-solicita) + " ?" 
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE l-responde.
    
            IF  l-responde = NO THEN
                UNDO, RETURN.
            /*
            IF l-responde = YES THEN DO:

                ASSIGN gl-esft045a-parecer = "".
                RUN ftp/esft045a.w.
                IF  gl-esft045a-parecer = "" THEN
                    UNDO, RETURN.
    
                FIND CURRENT es-desconto-duplic EXCLUSIVE-LOCK NO-ERROR NO-WAIT.                
    
                ASSIGN es-desconto-duplic.situacao = "Aprovada"
                       es-desconto-duplic.motivo-aprov = gl-esft045a-parecer
                       es-desconto-duplic.usuar-aprov2 = c-seg-usuario.

                IF aprovador-primario = YES THEN DO:
                    es-desconto-duplic.usuar-aprov1 = c-seg-usuario.
                END.
        
                /**/
                FOR EACH es-desconto-mail:
                    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = es-desconto-mail.cod-usuario NO-LOCK NO-ERROR.
                    IF AVAIL usuar_mestre THEN DO:
                        IF c-mail-destino = "" THEN
                            ASSIGN c-mail-destino = usuar_mestre.cod_e_mail_local.
                        ELSE 
                            ASSIGN c-mail-destino = c-mail-destino + "," + usuar_mestre.cod_e_mail_local.
                    END.
                END.
    
                IF c-mail-destino = "" THEN DO:
                    MESSAGE "Cadastro de E-mail Informaá∆o N∆o Parametrizado!  " 
                            VIEW-AS ALERT-BOX ERROR.
                            RETURN "NOK".
                END.
    
                IF mail-envia-1 = "" THEN DO:
                      ASSIGN mail-envia-1 = "mail.tortuga.com.br".
                END.
                
                RUN esp/mail-alerta1.p (INPUT mail-envia-1, INPUT es-desconto-duplic.nr-solicita, INPUT quem-envia).  
                
                RELEASE es-desconto-duplic NO-ERROR.
    
                MESSAGE "Solicitaá∆o Aprovada!"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
                RUN pi-ultimo   IN h-p-navega.
                RUN pi-primeiro IN h-p-navega.
            END.
            
            ELSE DO:                                                                       
               MESSAGE "Cancelado!" VIEW-AS ALERT-BOX.
            END.               
            */
        END.
    END.
