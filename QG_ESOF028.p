OUTPUT TO "c:\teste_ESOF028.txt".

FOR EACH nota-fiscal WHERE nota-fiscal.nr-nota-fis = "0069980"
                       AND nota-fiscal.dt-emis     = 09/11/2012
                       AND nota-fiscal.cod-estabel = "22"
                       AND nota-fiscal.serie       = "2"
                       NO-LOCK:

    FOR EACH it-nota-fisc OF nota-fiscal,
        EACH ITEM WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-LOCK:
        /*
        FIND FIRST fat-ser-lote OF it-nota-fisc NO-LOCK NO-ERROR.
    
        IF AVAIL fat-ser-lote THEN DO:
        */    
            FIND FIRST movto-estoq WHERE movto-estoq.it-codigo   = it-nota-fisc.it-codigo
                                    /*AND movto-estoq.lote        = fat-ser-lote.nr-serlote*/
                                    /*
                                    AND movto-estoq.tipo-trans  = 1
                                    AND (movto-estoq.esp-docto  = 21 OR movto-estoq.esp-docto = 23)
                                    */
                                    AND movto-estoq.serie = it-nota-fisc.serie
                                    AND movto-estoq.nro-docto = it-nota-fisc.nr-nota-fis
                                    AND movto-estoq.cod-estabel = it-nota-fisc.cod-estabel
                                    NO-LOCK NO-ERROR.
            
            /*
            FOR EACH movto-estoq WHERE movto-estoq.it-codigo    =   it-nota-fisc.it-codigo
                                    AND movto-estoq.lote        =   fat-ser-lote.nr-serlote
                                    AND movto-estoq.tipo-trans  =   1
                                    AND movto-estoq.dt-trans    <= nota-fiscal.dt-emis
                                    AND movto-estoq.esp-docto  = 23
                                    NO-LOCK:
            */
            IF AVAIL movto-estoq THEN DO:

                FIND FIRST item-doc-est WHERE item-doc-est.it-codigo = movto-estoq.it-codigo
                                        AND item-doc-est.nro-docto = movto-estoq.nro-docto
                                        AND item-doc-est.serie-docto = movto-estoq.serie-docto
                                        NO-LOCK NO-ERROR.

                IF AVAIL item-doc-est THEN DO:

                    FIND FIRST docum-est OF item-doc-est NO-LOCK NO-ERROR.
                    IF AVAIL docum-est THEN DO:
                        PUT     docum-est.cod-estabel
                                docum-est.serie-docto
                                docum-est.nro-docto
                                docum-est.dt-emissao
                                docum-est.nat-operacao
                                item-doc-est.quantidade
                                item-doc-est.preco-total[1]
                                item-doc-est.valor-icm[1]
                                item-doc-est.valor-icm[1] / item-doc-est.quantidade
                                (item-doc-est.valor-icm[1] / item-doc-est.quantidade) * it-nota-fisc.qt-faturada[1]
                                SKIP.
                    END.
                END.
            END.
        /*END.*/
    END.
END.

OUTPUT CLOSE.
