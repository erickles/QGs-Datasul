    DEFINE BUFFER bfes-ev-despesas FOR es-ev-despesas.
    DEFINE VARIABLE iSeqDesp        AS INTEGER     NO-UNDO.    
    DEFINE VARIABLE iCodEvento      AS INTEGER     NO-UNDO LABEL "Codigo do Evento".
    DEFINE VARIABLE iAnoReferencia  AS INTEGER     NO-UNDO LABEL "Ano de Referencia".

    UPDATE iCodEvento iAnoReferencia.

    IF iCodEvento <> 0 AND iAnoReferencia <> 0 THEN DO:    

        /* Busca pelo FIFO (rat-ordem) */
        FOR EACH es-ev-integr-desp WHERE (es-ev-integr-desp.origem         = "OC"   OR
                                         es-ev-integr-desp.origem          = "CN"   OR
                                         es-ev-integr-desp.origem          = "SC")                                 
                                     AND es-ev-integr-desp.atualizado      = NO
                                     AND es-ev-integr-desp.cod-evento      = iCodEvento
                                     AND es-ev-integr-desp.ano-referencia  = iAnoReferencia:
    
            CASE es-ev-integr-desp.origem:
                /*
                WHEN "OC" THEN DO:                    
    
                    FIND FIRST rat-ordem WHERE rat-ordem.numero-ordem = es-ev-integr-desp.numero-ordem NO-LOCK NO-ERROR.
                    IF AVAIL rat-ordem THEN DO:
                        
                        FIND FIRST docum-est WHERE docum-est.nro-docto      = rat-ordem.nro-docto 
                                               AND docum-est.cod-emitente   = rat-ordem.cod-emitente
                                               AND docum-est.serie-docto    = rat-ordem.serie-docto 
                                               AND docum-est.nat-operacao   = rat-ordem.nat-operacao
                                               NO-LOCK NO-ERROR.

                        IF AVAIL docum-est THEN DO:

                            FOR EACH item-doc-est NO-LOCK OF docum-est:

                                RUN piAtualizaDespesas IN THIS-PROCEDURE.

                            END.
                        END.                        
    
                    END.
    
                END.
                
                WHEN "CN" THEN DO:

                    MESSAGE "CN"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
                    FIND FIRST rat-ordem WHERE rat-ordem.numero-ordem = es-ev-integr-desp.numero-ordem NO-LOCK NO-ERROR.
                    IF AVAIL rat-ordem THEN DO:
    
                        FIND FIRST ordem-compra WHERE ordem-compra.numero-ordem = rat-ordem.numero-ordem NO-LOCK.
                        IF AVAIL ordem-compra THEN DO:

                            FIND FIRST docum-est WHERE docum-est.nro-docto  = rat-ordem.nro-docto 
                                                   AND docum-est.cod-emitente   = rat-ordem.cod-emitente
                                                   AND docum-est.serie-docto    = rat-ordem.serie-docto 
                                                   AND docum-est.nat-operacao   = rat-ordem.nat-operacao
                                                   NO-LOCK NO-ERROR.

                            IF AVAIL docum-est THEN DO:

                                FOR EACH item-doc-est NO-LOCK OF docum-est:
                                    
                                    FOR LAST medicao-contrat NO-LOCK WHERE medicao-contrat.nr-contrato  = ordem-compra.nr-contrato
                                                                       AND medicao-contrat.numero-ordem = ordem-compra.numero-ordem
                                                                       AND medicao-contrat.log-rec-medicao:
    
                                        RUN piAtualizaDespesas IN THIS-PROCEDURE.
                                    
                                    END.

                                END.
                            
                            END.                               
    
                        END.                                        
    
                    END.
    
                END.
                */
                WHEN "SC" THEN DO:

                    MESSAGE "SC"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.                    

                    FIND FIRST ordem-compra WHERE ordem-compra.nr-requisicao  = es-ev-integr-desp.nr-requisicao
                                              AND ordem-compra.it-codigo      = es-ev-integr-desp.it-codigo
                                              AND ordem-compra.sequencia      = es-ev-integr-desp.sequencia
                                              NO-LOCK NO-ERROR.

                    IF AVAIL ordem-compra THEN DO:

                        FIND FIRST rat-ordem WHERE rat-ordem.numero-ordem = es-ev-integr-desp.numero-ordem NO-LOCK NO-ERROR.
                        IF AVAIL rat-ordem THEN DO:
                            
                            FIND FIRST docum-est WHERE docum-est.nro-docto      = rat-ordem.nro-docto 
                                                   AND docum-est.cod-emitente   = rat-ordem.cod-emitente
                                                   AND docum-est.serie-docto    = rat-ordem.serie-docto 
                                                   AND docum-est.nat-operacao   = rat-ordem.nat-operacao
                                                   NO-LOCK NO-ERROR.
    
                            IF AVAIL docum-est THEN DO:
    
                                FOR EACH item-doc-est NO-LOCK OF docum-est:
                                    
                                    RUN piAtualizaDespesas IN THIS-PROCEDURE.
    
                                END.
    
                            END.
                        END.
                    END.
    
                END.
    
            END CASE.
    
        END.
    END.

    PROCEDURE piAtualizaDespesas:

        FIND es-ev-despesa NO-LOCK WHERE es-ev-despesa.cod-evento    = es-ev-integr-desp.cod-evento
                                    AND es-ev-despesa.ano-referencia = es-ev-integr-desp.ano-referencia
                                    AND es-ev-despesa.seq-despesa    = es-ev-integr-desp.seq-despesa
                                    NO-ERROR.
     
        IF AVAIL es-ev-despesa THEN NEXT.
     
        FIND LAST bfes-ev-despesas NO-LOCK WHERE bfes-ev-despesas.cod-evento     = es-ev-integr-desp.cod-evento
                                             AND bfes-ev-despesas.ano-referencia = es-ev-integr-desp.ano-referencia NO-ERROR.

        ASSIGN iSeqDesp = IF AVAIL bfes-ev-despesas THEN (bfes-ev-despesas.seq-despesa + 1) ELSE 1.
                                                                                             
        FIND ITEM NO-LOCK WHERE ITEM.it-codigo = item-doc-est.it-codigo NO-ERROR.
        FIND emitente NO-LOCK WHERE emitente.cod-emitente = docum-est.cod-emitente NO-ERROR.
     
        FIND FIRST es-ev-despesa WHERE es-ev-despesas.cod-evento        = es-ev-integr-desp.cod-evento
                                   AND es-ev-despesas.ano-referencia    = es-ev-integr-desp.ano-referencia
                                   AND es-ev-despesas.seq-despesa       = iSeqDesp
                                   NO-LOCK NO-ERROR.

        IF NOT AVAIL es-ev-despesa THEN DO:        

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

        END.

    END PROCEDURE.
