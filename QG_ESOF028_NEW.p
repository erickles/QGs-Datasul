
DEFINE BUFFER bf_movto-estoq FOR movto-estoq.

FOR EACH nota-fiscal WHERE nota-fiscal.nr-nota-fis = "0069980"
                       AND nota-fiscal.dt-emis     = 09/11/2012
                       AND nota-fiscal.cod-estabel = "22"
                       AND nota-fiscal.serie       = "2"
                       NO-LOCK:

    FOR EACH it-nota-fisc OF nota-fiscal,
        EACH ITEM WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-LOCK:

        FOR EACH movto-estoq WHERE movto-estoq.it-codigo   = it-nota-fisc.it-codigo
                               AND movto-estoq.serie-docto  = it-nota-fisc.serie
                               AND movto-estoq.nro-docto    = it-nota-fisc.nr-nota-fis
                               AND movto-estoq.cod-estabel  = it-nota-fisc.cod-estabel
                               AND movto-estoq.cod-emitente = it-nota-fisc.cd-emitente
                               AND movto-estoq.nat-operacao = it-nota-fisc.nat-operacao
                               AND movto-estoq.sequen-nf    = it-nota-fisc.nr-seq-fat
                               NO-LOCK:
                
            FIND FIRST bf_movto-estoq WHERE bf_movto-estoq.it-codigo   = movto-estoq.it-codigo
                                        AND bf_movto-estoq.lote        = movto-estoq.lote
                                        AND bf_movto-estoq.tipo-trans  = 1
                                        AND (bf_movto-estoq.esp-docto = 23)
                                        NO-LOCK NO-ERROR.

            IF AVAIL bf_movto-estoq THEN DO:
                DISP "BF" 
                     bf_movto-estoq.serie
                     bf_movto-estoq.nro-docto
                     bf_movto-estoq.cod-estabel
                     bf_movto-estoq.it-codigo
                     bf_movto-estoq.lote.
            END.

        END.
    END.
END.
