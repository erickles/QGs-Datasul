DEFINE BUFFER bf_movto-estoq FOR movto-estoq.
DEFINE BUFFER bf_nota-fiscal FOR nota-fiscal.

OUTPUT TO "c:\notas.csv".

FOR EACH nota-fiscal WHERE nota-fiscal.nr-nota-fis = "0069980"
                       AND nota-fiscal.dt-emis     >= 09/11/2012
                       AND nota-fiscal.cod-estabel <= "22"
                       AND nota-fiscal.serie       <= "2"
                       NO-LOCK:

    FOR EACH it-nota-fisc OF nota-fiscal WHERE it-nota-fisc.it-codigo = "40000801",
        EACH ITEM WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-LOCK:

        /*deQuantidade = 0.*/

        FOR EACH movto-estoq WHERE movto-estoq.it-codigo    = it-nota-fisc.it-codigo
                               AND movto-estoq.serie-docto  = it-nota-fisc.serie
                               AND movto-estoq.nro-docto    = it-nota-fisc.nr-nota-fis
                               AND movto-estoq.cod-estabel  = it-nota-fisc.cod-estabel
                               AND movto-estoq.cod-emitente = it-nota-fisc.cd-emitente
                               AND movto-estoq.nat-operacao = it-nota-fisc.nat-operacao
                               AND movto-estoq.sequen-nf    = it-nota-fisc.nr-seq-fat
                               NO-LOCK:

            FOR EACH bf_movto-estoq WHERE bf_movto-estoq.it-codigo    = movto-estoq.it-codigo
                                      AND bf_movto-estoq.lote         = movto-estoq.lote
                                      AND bf_movto-estoq.tipo-trans   = 2 /* Saida */
                                      AND bf_movto-estoq.cod-depos    = "EXP"
                                      AND bf_movto-estoq.esp-docto    = 23 /* NFT */
                                      /*AND bf_movto-estoq.quantidade   >= it-nota-fisc.qt-faturada[1]*/
                                      /*AND bf_movto-estoq.dt-trans     <= movto-estoq.dt-trans*/
                                      /*AND bf_movto-estoq.nro-docto    <> movto-estoq.nro-docto*/
                                      /*AND bf_movto-estoq.serie-docto  <> movto-estoq.serie-docto*/
                                      NO-LOCK BY bf_movto-estoq.dt-trans DESC:

                FIND FIRST item-doc-est WHERE item-doc-est.it-codigo   = bf_movto-estoq.it-codigo
                                          AND item-doc-est.nro-docto   = bf_movto-estoq.nro-docto
                                          AND item-doc-est.serie-docto = bf_movto-estoq.serie-docto
                                          NO-LOCK NO-ERROR.

                    PUT nota-fiscal.dt-emis      ";"
                        movto-estoq.tipo-trans   ";"
                        movto-estoq.esp-docto    ";"
                        movto-estoq.cod-depos    ";"
                        movto-estoq.nro-docto    ";"
                        item-doc-est.nro-docto   ";"
                        bf_movto-estoq.dt-trans  ";"
                        bf_movto-estoq.nro-docto SKIP.

            END.
        END.
    END.
END.

OUTPUT CLOSE.
