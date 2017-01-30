DEFINE BUFFER bfes-ev-despesas FOR es-ev-despesas.
DEFINE VARIABLE iSeqDesp AS INTEGER     NO-UNDO.

FOR EACH item-doc-est
    WHERE item-doc-est.cod-emitente = 245055
    AND   item-doc-est.nro-docto    = "0000131"
    AND   ITEM-doc-est.serie-docto  = "1"
    AND   item-doc-est.nat-operacao = "2972Mi" NO-LOCK:    

    FIND ordem-compra NO-LOCK WHERE ordem-compra.numero-ordem = item-doc-est.numero-ordem NO-ERROR.
    IF AVAIL ordem-compra THEN DO:
        
        /*Ordem de Compra*/
        IF CAN-FIND(FIRST es-ev-integr-desp
                    WHERE es-ev-integr-desp.origem       = "OC"
                    AND es-ev-integr-desp.numero-ordem = ordem-compra.numero-ordem) THEN DO:

            FOR EACH es-ev-integr-desp EXCLUSIVE-LOCK WHERE es-ev-integr-desp.origem       = "OC"
                                                        AND es-ev-integr-desp.numero-ordem = ordem-compra.numero-ordem:
                    
                         /*RUN piAtualizaDespesas IN THIS-PROCEDURE.*/
                        MESSAGE "Atualizou"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        
            END.
        END.
        ELSE DO:

            /*Solicita‡Æo de Compras*/ 
            IF CAN-FIND(FIRST es-ev-integr-desp 
                        WHERE es-ev-integr-desp.origem        = "SC"
                          AND es-ev-integr-desp.nr-requisicao = ordem-compra.nr-requisicao
                          AND es-ev-integr-desp.it-codigo     = ordem-compra.it-codigo
                          AND es-ev-integr-desp.sequencia     = ordem-compra.sequencia) THEN DO:
                        
                FOR FIRST it-requisicao NO-LOCK
                    WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao
                      AND it-requisicao.it-codigo     = ordem-compra.it-codigo   
                      AND it-requisicao.sequencia     = ordem-compra.sequencia:
                        
                    FOR EACH es-ev-integr-desp EXCLUSIVE-LOCK WHERE es-ev-integr-desp.origem        = "SC"
                                                                AND es-ev-integr-desp.nr-requisicao = ordem-compra.nr-requisicao
                                                                AND es-ev-integr-desp.it-codigo     = ordem-compra.it-codigo
                                                                AND es-ev-integr-desp.sequencia     = ordem-compra.sequencia:
                               
                        /*RUN piAtualizaDespesas IN THIS-PROCEDURE.*/
                        MESSAGE "Atualizou"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                 
                    END.
                END.
            END.
            ELSE DO:

                /*Contrato de Compras*/
                IF CAN-FIND(FIRST es-ev-integr-desp 
                            WHERE es-ev-integr-desp.origem       = "CN"
                              AND es-ev-integr-desp.nr-contrato  = ordem-compra.nr-contrato   
                              AND es-ev-integr-desp.numero-ordem = ordem-compra.numero-ordem) THEN DO:

                    FOR LAST medicao-contrat NO-LOCK
                        WHERE medicao-contrat.nr-contrato  = ordem-compra.nr-contrato 
                          AND medicao-contrat.numero-ordem = ordem-compra.numero-ordem
                          AND medicao-contrat.log-rec-medicao:

                        FOR EACH es-ev-integr-desp EXCLUSIVE-LOCK WHERE es-ev-integr-desp.origem          = "CN"
                                                                    AND es-ev-integr-desp.nr-contrato     = medicao-contrat.nr-contrato    
                                                                    AND es-ev-integr-desp.num-seq-item    = medicao-contrat.num-seq-item   
                                                                    AND es-ev-integr-desp.numero-ordem    = medicao-contrat.numero-ordem   
                                                                    AND es-ev-integr-desp.num-seq-event   = medicao-contrat.num-seq-event  
                                                                    AND es-ev-integr-desp.num-seq-medicao = medicao-contrat.num-seq-medicao :
                                                                 
                                     /*RUN piAtualizaDespesas IN THIS-PROCEDURE.*/
                                    MESSAGE "Atualizou"
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                    
                        END.
                    END.
                END.
            END.
        END.                     
    END.
             
    /* Busca pelo FIFO (rat-ordem) */
    FOR EACH rat-ordem OF item-doc-est NO-LOCK:
        
        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK NO-ERROR.
        IF AVAIL ordem-compra THEN DO:      
            /*
            MESSAGE "item-doc-est.it-codigo     "  item-doc-est.it-codigo      SKIP
                    "item-doc-est.numero-ordem  "  item-doc-est.numero-ordem   SKIP
                    "rat-ordem.num-pedido       "  rat-ordem.num-pedido        SKIP
                    "rat-ordem.numero-ordem     "  rat-ordem.numero-ordem      SKIP
                    "rat-ordem.quantidade       "  rat-ordem.quantidade        SKIP
                    "rat-ordem.sequencia        "  rat-ordem.sequencia             
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.                             
            */         
            IF CAN-FIND(FIRST es-ev-integr-desp
                        WHERE es-ev-integr-desp.origem       = "OC"
                          AND es-ev-integr-desp.numero-ordem = ordem-compra.numero-ordem) THEN DO:
    
                FOR EACH es-ev-integr-desp EXCLUSIVE-LOCK WHERE es-ev-integr-desp.origem       = "OC"
                                                            AND es-ev-integr-desp.numero-ordem = ordem-compra.numero-ordem:
    
                    /*RUN piAtualizaDespesas IN THIS-PROCEDURE.*/
                    MESSAGE "Atualizou pela rat-ordem"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
                END.
    
            END.
            ELSE DO:
                /*Contrato de Compras*/                                                                         
                IF CAN-FIND(FIRST es-ev-integr-desp                                                             
                                 WHERE es-ev-integr-desp.origem       = "CN"                                    
                                   AND es-ev-integr-desp.nr-contrato  = ordem-compra.nr-contrato                   
                                   AND es-ev-integr-desp.numero-ordem = ordem-compra.numero-ordem) THEN DO:        
                                                                                                                
                    FOR LAST medicao-contrat NO-LOCK                                                            
                                 WHERE medicao-contrat.nr-contrato  = ordem-compra.nr-contrato                     
                                   AND medicao-contrat.numero-ordem = ordem-compra.numero-ordem                    
                                   AND medicao-contrat.log-rec-medicao:                                         
                                                                                                                
                        FOR EACH es-ev-integr-desp EXCLUSIVE-LOCK                                               
                                     WHERE es-ev-integr-desp.origem          = "CN"                             
                                       AND es-ev-integr-desp.nr-contrato     = medicao-contrat.nr-contrato      
                                       AND es-ev-integr-desp.num-seq-item    = medicao-contrat.num-seq-item     
                                       AND es-ev-integr-desp.numero-ordem    = medicao-contrat.numero-ordem     
                                       AND es-ev-integr-desp.num-seq-event   = medicao-contrat.num-seq-event    
                                       AND es-ev-integr-desp.num-seq-medicao = medicao-contrat.num-seq-medicao :
                                                                                                                
                            /*RUN piAtualizaDespesas IN THIS-PROCEDURE.*/                                       
                            MESSAGE "Atualizou"                                                                 
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.                                          
                                                                                                                
                        END.                                                                                    
                    END.
                END.                                                
                ELSE DO:                
                    /*Solicita‡Æo de Compras*/                                                                 
                    IF CAN-FIND(FIRST es-ev-integr-desp                                                    
                                WHERE es-ev-integr-desp.origem        = "SC"                               
                                  AND es-ev-integr-desp.nr-requisicao = ordem-compra.nr-requisicao         
                                  AND es-ev-integr-desp.it-codigo     = ordem-compra.it-codigo             
                                  AND es-ev-integr-desp.sequencia     = ordem-compra.sequencia) THEN DO:   
                                                                                                           
                        FOR FIRST it-requisicao NO-LOCK                                                    
                            WHERE it-requisicao.nr-requisicao = ordem-compra.nr-requisicao                 
                              AND it-requisicao.it-codigo     = ordem-compra.it-codigo                     
                              AND it-requisicao.sequencia     = ordem-compra.sequencia:                    
                                                                                                           
                            FOR EACH es-ev-integr-desp EXCLUSIVE-LOCK                                      
                                         WHERE es-ev-integr-desp.origem        = "SC"                      
                                           AND es-ev-integr-desp.nr-requisicao = ordem-compra.nr-requisicao
                                           AND es-ev-integr-desp.it-codigo     = ordem-compra.it-codigo    
                                           AND es-ev-integr-desp.sequencia     = ordem-compra.sequencia:   
                                                                                                           
                                /*RUN piAtualizaDespesas IN THIS-PROCEDURE.*/                              
                                MESSAGE "Atualizou"                                                        
                                        VIEW-AS ALERT-BOX INFO BUTTONS OK.                                 
                                                                                                           
                            END.                                                                           
                        END.                                                                               
                    END.
                    
                END.
            END.
        END.
    END.                                   
END.

PROCEDURE piAtualizaDespesas:

     FIND es-ev-despesa NO-LOCK WHERE es-ev-despesa.cod-evento     = es-ev-integr-desp.cod-evento    
                                  AND es-ev-despesa.ano-referencia = es-ev-integr-desp.ano-referencia
                                  AND es-ev-despesa.seq-despesa    = es-ev-integr-desp.seq-despesa 
                                  NO-ERROR.
     
     IF AVAIL es-ev-despesa THEN NEXT.
     
     FIND LAST bfes-ev-despesas NO-LOCK
         WHERE bfes-ev-despesas.cod-evento     = es-ev-integr-desp.cod-evento
           AND bfes-ev-despesas.ano-referencia = es-ev-integr-desp.ano-referencia NO-ERROR.

     ASSIGN iSeqDesp = IF AVAIL bfes-ev-despesas THEN (bfes-ev-despesas.seq-despesa + 1) ELSE 1.
                                                                                             
     FIND ITEM NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.
     FIND emitente NO-LOCK WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.
     
     CREATE es-ev-despesa.
     ASSIGN es-ev-despesas.cod-evento        = es-ev-integr-desp.cod-evento    
            es-ev-despesas.ano-referencia    = es-ev-integr-desp.ano-referencia
            es-ev-despesas.seq-despesa       = iSeqDesp 
            es-ev-despesas.situacao          = "A"
            es-ev-despesas.data-emissao      = docum-est.dt-trans
            es-ev-despesas.descricao         = "NFE:" + TRIM(docum-est.nro-docto) + " " + (IF AVAIL ITEM THEN ITEM.desc-item ELSE "")
            es-ev-despesas.dt-dolar-dia      = ?
            es-ev-despesas.it-codigo         = item-doc-est.it-codigo
            es-ev-despesas.nome-abrev        = ""
            es-ev-despesas.nome-abrev-fornec = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
            es-ev-despesas.nr-pedcli         = ""
            es-ev-despesas.num-pedido        = item-doc-est.num-pedido
            es-ev-despesas.qtde-item         = item-doc-est.quantidade
            es-ev-despesas.tipo-item         = es-ev-integr-desp.tipo-item
            es-ev-despesas.valor-despesado   = item-doc-est.preco-total[1]
            es-ev-despesas.valor-item        = (es-ev-despesas.valor-despesado / es-ev-despesas.qtde-item) .
     
     ASSIGN es-ev-integr-desp.atualizado  = YES                        
            es-ev-integr-desp.seq-despesa = es-ev-despesas.seq-despesa.

END PROCEDURE.
