def var c-email as char.
def var email-log-dest as char.
def var c-mensagem as char.
def var c-mensagem-3 as char.
def var c-mensagem-2 as char.
def var de-soma-saldo as deci.

{utp/ut-glob.i}

FIND FIRST ped-venda WHERE ped-venda.nr-pedcli   = "3082-0716a"
                       NO-LOCK NO-ERROR.
    
IF AVAIL ped-venda THEN DO:
    
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ped-venda.nr-pedcli
                            AND ws-p-venda.nome-abrev = ped-venda.nome-abrev NO-ERROR.
        
    ASSIGN c-mensagem = "".

    IF AVAIL ws-p-venda                         THEN DO:
                                                
        /* Monta a variavel de texto para o envio do e-mail         */                
        FOR EACH ped-item OF ped-venda NO-LOCK:

            ASSIGN de-soma-saldo = 0.
                                                
            FOR EACH saldo-estoq WHERE saldo-estoq.it-codigo    = ped-item.it-codigo
                                   AND saldo-estoq.qtidade-atu  > 0
                                   AND saldo-estoq.cod-estabel  = ped-venda.cod-estabel
                                   AND saldo-estoq.dt-vali-lote >= TODAY
                                   AND saldo-estoq.cod-dep      = "EXP":
                                                
                ASSIGN de-soma-saldo = de-soma-saldo + saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada.

            END.

            IF ped-item.qt-pedida > de-soma-saldo THEN DO:
                  
                FIND FIRST ws-p-item WHERE ws-p-item.nr-pedcli  = ped-item.nr-pedcli
                                       AND ws-p-item.nome-abrev = ped-item.nome-abrev EXCLUSIVE-LOCK.

                IF AVAIL ws-p-item THEN DO:
                     
                    IF SUBSTRING(ws-p-venda.char-1,39,1) <> "" THEN DO:
                                message "ok" view-as alert-box.
                        FIND FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
                        ASSIGN c-mensagem   = c-mensagem   + ITEM.it-codigo     + " - "
                                                           + ITEM.descricao-1   + " - "
                                                           + "Qt. Pedida: "     + STRING(ped-item.qt-pedida,">>>>,>>9.9999") 
                                                           + " Qt. D°sponivel: " + STRING(de-soma-saldo,">>>>,>>9.9999")
                                                           + " Qt. Faltante: "  + STRING(ped-item.qt-pedida - de-soma-saldo,">>>>,>>9.9999") + CHR(10)
                               c-mensagem-3 = c-mensagem-3 + ITEM.it-codigo     + " - "
                                                           + ITEM.descricao-1   + " - "
                                                           + " Qt. Faltante: "  + STRING(ped-item.qt-pedida - de-soma-saldo,">>>>,>>9.9999") + CHR(10).

                        ASSIGN SUBSTRING(ws-p-venda.char-1,39,1) = "S".
                        
                    END.
                    RELEASE ws-p-item.
                END.
            END.
        END.

        IF c-mensagem <> "" THEN DO:
            FOR EACH ped-item WHERE ped-item.nr-pedcli  = ped-venda.nr-pedcli
                                AND ped-item.nome-abrev = ped-venda.nome-abrev NO-LOCK:

                ASSIGN de-soma-saldo = 0.

                FOR EACH saldo-estoq WHERE saldo-estoq.it-codigo    = ped-item.it-codigo
                                       AND saldo-estoq.qtidade-atu  > 0
                                       AND saldo-estoq.cod-estabel  = ped-venda.cod-estabel
                                       AND saldo-estoq.dt-vali-lote >= TODAY
                                       AND saldo-estoq.cod-dep      = "EXP":

                    ASSIGN de-soma-saldo = de-soma-saldo + saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada.

                END.

                IF ped-item.qt-pedida <= de-soma-saldo THEN DO:
                    FIND FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
                    ASSIGN c-mensagem-2 = c-mensagem-2 + ITEM.it-codigo     + " - "
                                                       + ITEM.descricao-1   + " - "
                                                       + "Qt. Pedida: "   + STRING(ped-item.qt-pedida,">>>>,>>9.9999") + CHR(10).
                END.
            END.

        END.

        /* Caso haja falta de produto, pergunta se deseja enviar e-mail */                                                  
        IF c-mensagem <> "" THEN DO:                                                                                        
                                                                                                                            
            MESSAGE "Os seguintes produtos possuem falta no pedido " + STRING(ws-p-venda.nr-pedcli) + ":" SKIP(1)           
                    c-mensagem-3  SKIP(1)                                                                                     
                    "Deseja enviar e-mail para Log°stica e Administraá∆o de Vendas?"                                        
                    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE l-envia AS LOG.                                         
                                                                                                                            
            IF l-envia THEN DO:                                                                                             
                                                                                                                            
                FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.                    
                IF AVAIL usuar_mestre THEN DO:                                                                              
                                                                                                                            
                    ASSIGN c-email = "Os seguintes produtos possuem falta no pedido " + STRING(ws-p-venda.nr-pedcli) + ":" +
                                     CHR(10)             +                                                                   
                                     c-mensagem          +                                                                   
                                     CHR(10)             +                                                                   
                                     "Os demais itens est∆o com a quantidade atendida:" +                                    
                                     CHR(10)             +                                                                   
                                     c-mensagem-2        +                                                                   
                                     CHR(10)             +                                                                   
                                     "Atenciosamente,"   +                                                                   
                                     CHR(10)             +                                                                   
                                     "Log°stica Sa£de.".

                    ASSIGN email-log-dest = "".
                    CASE ws-p-venda.cod-estabel:
                        WHEN "01" THEN
                            email-log-dest = "logisticasa@tortuga.com.br".
                
                        WHEN "19" THEN
                            email-log-dest = "logistica-mq@tortuga.com.br".

                        WHEN "05" THEN
                            email-log-dest = "logisticace@tortuga.com.br".

                        WHEN "43" THEN
                            email-log-dest = "logisticasv@tortuga.com.br".

                        WHEN "44" THEN
                            email-log-dest = "logisticamg@tortuga.com.br".

                        WHEN "10" THEN
                            email-log-dest = "logisticasuprimentos-sv-mq-fl@tortuga.com.br".

                        WHEN "09" THEN
                            email-log-dest = "logisticars@tortuga.com.br".

                        WHEN "24" THEN
                            email-log-dest = "logisticasc@tortuga.com.br".

                        WHEN "06" THEN
                            email-log-dest = "logisticago@tortuga.com.br".

                        WHEN "22" THEN
                            email-log-dest = "logisticams@tortuga.com.br".

                        WHEN "18" THEN
                            email-log-dest = "logisticamt@tortuga.com.br".

                        WHEN "26" THEN
                            email-log-dest = "logisticapr@tortuga.com.br".

                        WHEN "38" THEN
                            email-log-dest = "logisticaro@tortuga.com.br".

                        WHEN "12" THEN
                            email-log-dest = "logisticapa@tortuga.com.br".

                    END CASE.
                                                                                                                            
                    RUN esp\wsmail-sac2.p(usuar_mestre.cod_e_mail_local ,                                       /* de       */ 
                                         STRING("administracaodevendassaude@tortuga.com.br;" + email-log-dest), /* para     */ 
                                         STRING("Falta de itens no pedido " + STRING(ws-p-venda.nr-pedcli)),    /* assunto  */
                                         c-email,                                                               /* mensagem */ 
                                         "").                                                                               
                END.
            END.
        END.
    END.
END. 
