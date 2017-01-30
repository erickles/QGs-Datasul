DEFINE BUFFER bfes-ev-despesas FOR es-ev-despesas.
DEFINE VARIABLE iSeqDesp AS INTEGER     NO-UNDO.
DEFINE VARIABLE codEvento AS INTEGER     NO-UNDO.

UPDATE codEvento.

FOR EACH es-ev-integr-desp WHERE es-ev-integr-desp.cod-evento       = codEvento
                             AND es-ev-integr-desp.ano-referencia   = 2012
                             AND es-ev-integr-desp.atualizado       = NO:
        
    FIND FIRST ordem-compra WHERE ordem-compra.nr-requisicao    = es-ev-integr-desp.nr-requisicao
                             AND ordem-compra.it-codigo         = es-ev-integr-desp.it-codigo
                             AND ordem-compra.sequencia         = es-ev-integr-desp.sequencia
                             NO-LOCK NO-ERROR.

    IF AVAIL ordem-compra THEN DO:
           
        FOR EACH recebimento OF ordem-compra NO-LOCK:
           MESSAGE "Tem recebimento"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            FOR EACH docum-est
                WHERE docum-est.cod-emitente = recebimento.cod-emitente
                AND   docum-est.nat-operacao = recebimento.nat-operacao
                AND   docum-est.nro-docto    = recebimento.numero-nota
                AND   docum-est.serie-docto  = recebimento.serie-docto  NO-LOCK :

                DISP docum-est.cod-emitente
                     docum-est.nat-operacao
                     docum-est.nro-docto
                     docum-est.serie-docto.

                FOR EACH item-doc-est OF docum-est NO-LOCK:

                    IF item-doc-est.numero-ordem = 0 THEN DO:

                        FOR EACH rat-ordem OF item-doc-est NO-LOCK:
                                
                            IF rat-ordem.numero-ordem = ordem-compra.numero-ordem THEN DO:
                                /*
                                MESSAGE "RAT-ORDEM"                                                     SKIP
                                        "SEQ "                          es-ev-integr-desp.seq-despesa   SKIP
                                        "Valor total integracao "       es-ev-integr-desp.vl-total      SKIP
                                        "Valor unitario integracao "    es-ev-integr-desp.vl-unitario   SKIP
                                        "Valor no documento"            item-doc-est.preco-total[1]     SKIP
                                        "Valor Recebimento"             item-doc-est.preco-unit[1] * item-doc-est.quantidade
                                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                               */
                                
                               RUN piAtualizaDespesas IN THIS-PROCEDURE.
                            END.
                        END.
                    END.

                    ELSE DO:
                        
                        IF item-doc-est.numero-ordem = ordem-compra.numero-ordem THEN DO:
                            /*
                            MESSAGE "ITEM-DOC-EST"                                                  SKIP
                                    "SEQ "                          es-ev-integr-desp.seq-despesa   SKIP
                                    "Valor total integracao "       es-ev-integr-desp.vl-total      SKIP
                                    "Valor unitario integracao "    es-ev-integr-desp.vl-unitario   SKIP
                                    "Valor no documento"            item-doc-est.preco-total[1]     SKIP
                                    "Valor Recebimento"             item-doc-est.preco-unit[1] * item-doc-est.quantidade
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                           */
                            
                           RUN piAtualizaDespesas IN THIS-PROCEDURE.

                        END.
                    END.
                END.
            END.
        END.
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

        MESSAGE "Na nota " + String(item-doc-est.preco-total[1])
                "NFE:" + TRIM(docum-est.nro-docto) + " " + (IF AVAIL ITEM THEN ITEM.desc-item ELSE "")
                "NO provisionado " + String(es-ev-integr-desp.vl-total)
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        /*
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

               /*es-ev-despesas.valor-despesado   = item-doc-est.preco-total[1]*/
               es-ev-despesas.valor-despesado   = es-ev-integr-desp.vl-total

               es-ev-despesas.valor-item        = (es-ev-despesas.valor-despesado / es-ev-despesas.qtde-item).
        
        ASSIGN es-ev-integr-desp.atualizado  = YES                        
               es-ev-integr-desp.seq-despesa = es-ev-despesas.seq-despesa.
        */                
   END.   

END PROCEDURE.
