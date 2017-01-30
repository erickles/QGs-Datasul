DEFINE VARIABLE numeroPedido AS CHARACTER   NO-UNDO FORMAT "X(12)".
DEFINE BUFFER bfes-ev-despesas FOR es-ev-despesas.
DEFINE VARIABLE iSeqDesp AS INTEGER     NO-UNDO.

UPDATE numeroPedido.

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = numeroPedido NO-LOCK NO-ERROR.
IF AVAIL ws-p-venda THEN DO:
    
    FIND FIRST nota-fiscal WHERE nota-fiscal.nr-pedcli = numeroPedido NO-LOCK NO-ERROR.
    FOR EACH it-nota-fisc OF nota-fiscal
               BREAK BY it-nota-fisc.nr-pedcli:

        FOR FIRST ws-p-item NO-LOCK
                    WHERE ws-p-item.nome-abrev = nota-fiscal.nome-ab-cli
                      AND ws-p-item.nr-pedcli  = it-nota-fisc.nr-pedcli 
                      AND ws-p-item.it-codigo  = it-nota-fisc.it-codigo:
               
            FOR EACH es-ev-integr-desp EXCLUSIVE-LOCK WHERE es-ev-integr-desp.origem     = "PV"
                                                    AND es-ev-integr-desp.nome-abrev = ws-p-item.nome-abrev
                                                    AND es-ev-integr-desp.nr-pedcli  = ws-p-item.nr-pedcli 
                                                    AND es-ev-integr-desp.it-codigo  = ws-p-item.it-codigo:
    
                FIND es-ev-despesa NO-LOCK WHERE es-ev-despesas.cod-evento     = es-ev-integr-desp.cod-evento    
                                             AND es-ev-despesas.ano-referencia = es-ev-integr-desp.ano-referencia
                                             AND es-ev-despesas.seq-despesa    = es-ev-integr-desp.seq-despesa 
                                             NO-ERROR.
        
                IF AVAIL es-ev-despesa THEN NEXT.
        
                FIND LAST bfes-ev-despesas NO-LOCK WHERE bfes-ev-despesas.cod-evento     = es-ev-integr-desp.cod-evento
                                                     AND bfes-ev-despesas.ano-referencia = es-ev-integr-desp.ano-referencia NO-ERROR.
        
                ASSIGN iSeqDesp = IF AVAIL bfes-ev-despesas THEN (bfes-ev-despesas.seq-despesa + 1) ELSE 1.
                                                                                                     
                FIND ITEM NO-LOCK WHERE ITEM.it-codigo = ws-p-item.it-codigo NO-ERROR.
        
                CREATE es-ev-despesa.
                ASSIGN es-ev-despesas.cod-evento         = es-ev-integr-desp.cod-evento    
                       es-ev-despesas.ano-referencia     = es-ev-integr-desp.ano-referencia
                       es-ev-despesas.seq-despesa        = iSeqDesp 
                       es-ev-despesas.situacao          = "A"
                       es-ev-despesas.data-emissao      =  nota-fiscal.dt-emis-nota
                       es-ev-despesas.descricao         = "NF:" + TRIM(nota-fiscal.nr-nota-fis) + " " + (IF AVAIL ITEM THEN ITEM.desc-item ELSE "")
                       es-ev-despesas.dt-dolar-dia      = ?
                       es-ev-despesas.it-codigo         = ws-p-item.it-codigo
                       es-ev-despesas.nome-abrev        = ws-p-item.nome-abrev
                       es-ev-despesas.nome-abrev-fornec = ""
                       es-ev-despesas.nr-pedcli         = ws-p-item.nr-pedcli
                       es-ev-despesas.num-pedido        = 0
                       es-ev-despesas.valor-despesado   = it-nota-fisc.vl-merc-liq /*es-ev-integr-desp.vl-total*/
                       es-ev-despesas.qtde-item         = it-nota-fisc.qt-faturada[1] /*es-ev-integr-desp.quantidade*/
                       es-ev-despesas.valor-item        = (es-ev-despesas.valor-despesado / es-ev-despesas.qtde-item) /*es-ev-integr-desp.vl-unitario*/ 
                       es-ev-despesas.tipo-item         = es-ev-integr-desp.tipo-item.
        
                ASSIGN es-ev-integr-desp.atualizado  = YES
                       es-ev-integr-desp.seq-despesa = es-ev-despesas.seq-despesa.
            
            END.

        END.

    END.

END.
