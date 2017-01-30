DEFINE BUFFER bfes-ev-despesas FOR es-ev-despesas.

DEFINE VARIABLE iSeqDesp AS INTEGER     NO-UNDO.

FOR EACH es-ev-integr-desp WHERE es-ev-integr-desp.cod-evento = 8806
                               AND es-ev-integr-desp.ano-refer  = 2013                                
                               AND es-ev-integr-desp.origem = "SC"
                               AND es-ev-integr-desp.atualizado = NO
                                BY es-ev-integr-desp.seq-despesa:
    
    FOR EACH ordem-compra WHERE ordem-compra.nr-requisicao  = es-ev-integr-desp.nr-requisicao
                              AND ordem-compra.it-codigo      = es-ev-integr-desp.it-codigo
                              AND ordem-compra.sequencia      = es-ev-integr-desp.sequencia
                              NO-LOCK.

        IF AVAIL ordem-compra THEN DO:
                    
            /* FIND FIRST docum-est WHERE docum-est.nro-docto      = rat-ordem.nro-docto     */
            /*                        AND docum-est.cod-emitente   = rat-ordem.cod-emitente  */
            /*                        AND docum-est.serie-docto    = rat-ordem.serie-docto   */
            /*                        AND docum-est.nat-operacao   = rat-ordem.nat-operacao  */
            /*                        NO-LOCK NO-ERROR.                                      */
    
                FOR EACH item-doc-est NO-LOCK WHERE item-doc-est.num-pedido     = ordem-compra.num-pedido 
                                                AND item-doc-est.numero-ordem   = ordem-compra.numero-ordem
                                                :
                    FIND FIRST docum-est OF item-doc-est NO-LOCK NO-ERROR.
                    IF AVAIL docum-est THEN
                    /*RUN piAtualizaDespesas IN THIS-PROCEDURE.*/
                    DISP "OK".
    
                END.        
    
        END.
    END.
END.
PROCEDURE piAtualizaDespesas:
    
    

     FIND es-ev-despesa NO-LOCK
         WHERE es-ev-despesa.cod-evento     = es-ev-integr-desp.cod-evento    
           AND es-ev-despesa.ano-referencia = es-ev-integr-desp.ano-referencia
           AND es-ev-despesa.seq-despesa    = es-ev-integr-desp.seq-despesa 
         NO-ERROR.
     
     IF AVAIL es-ev-despesa THEN
         
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
