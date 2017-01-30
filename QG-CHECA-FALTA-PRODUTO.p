DEFINE VARIABLE c-mensagem      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem-2    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem-3    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE de-soma-saldo   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE c-email         AS CHARACTER   NO-UNDO.

{utp/ut-glob.i}

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli  = "2909-0111A1"
                        AND ws-p-venda.nome-abrev = "204308" NO-ERROR.
    
ASSIGN c-mensagem = "".

ASSIGN OVERLAY(ws-p-venda.char-1,39,1) = "".

IF AVAIL ws-p-venda                         AND
   SUBSTRING(ws-p-venda.char-1,39,1) = ""   THEN DO:
    
    /**/
    FIND FIRST ped-venda WHERE ped-venda.nr-pedcli  = ws-p-venda.nr-pedcli
                           AND ped-venda.nome-abrev = ws-p-venda.nome-abrev 
                           NO-ERROR.
    /**/

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

                IF SUBSTRING(ws-p-venda.char-1,39,1) = "" THEN DO:
            
                    FIND FIRST ITEM WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK NO-ERROR.
                    ASSIGN c-mensagem   = c-mensagem   + ITEM.it-codigo     + " - "
                                                       + ITEM.descricao-1   + " - "
                                                       + "Qt. Pedida: "     + STRING(ped-item.qt-pedida,">>>>,>>9.9999") 
                                                       + " Qt. D°sponivel: " + STRING(de-soma-saldo,">>>>,>>9.9999")
                                                       + " Qt. Faltante: "  + STRING(ped-item.qt-pedida - de-soma-saldo,">>>>,>>9.9999") + CHR(10)
                           c-mensagem-3 = c-mensagem-3 + ITEM.it-codigo     + " - "
                                                       + ITEM.descricao-1   + " - "
                                                       + " Qt. Faltante: "  + STRING(ped-item.qt-pedida - de-soma-saldo,">>>>,>>9.9999") + CHR(10).                    
                    
                END.
                RELEASE ws-p-item.
            END.            
        END.
    END.

    ASSIGN SUBSTRING(ws-p-venda.char-1,39,1) = "S".

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
                                 CHR(10)                                            +                                                                   
                                 c-mensagem                                         +
                                 CHR(10)                                            +
                                 "Os demais itens est∆o com a quantidade atendida:" +                                    
                                 CHR(10)                                            +
                                 c-mensagem-2                                       +
                                 CHR(10)                                            +
                                 "Atenciosamente,"                                  +
                                 CHR(10)                                            +
                                 "Log°stica Sa£de.".                                                                                                                                                        
            END.
        END.
    END.
END.
