{include/i-buffer.i}

DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO.

DEFINE BUFFER bf-movto-comis FOR es-movto-comis.

FIND FIRST tit_acr WHERE tit_acr.cod_estab       = "19"
                     AND tit_acr.cod_espec_docto = "DP"
                     AND tit_acr.cod_ser_docto = "4"
                     AND tit_acr.cod_tit_acr     = "0358109"
                     AND tit_acr.cod_parcela     = "01"
                     NO-LOCK NO-ERROR.
IF AVAIL tit_acr THEN DO:
    
    FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis  = tit_acr.cod_tit_acr
                             /*AND nota-fiscal.serie       = tit_acr.cod_ser_docto*/
                             AND nota-fiscal.cod-estabel  = tit_acr.cod_estab
                             AND nota-fiscal.cod-emitente = tit_acr.cdn_cliente
                             NO-LOCK NO-ERROR.

    IF AVAIL nota-fiscal THEN DO:

        FIND FIRST repres WHERE repres.nome-abrev = nota-fiscal.no-ab-reppri NO-LOCK NO-ERROR.
        IF AVAIL repres THEN                        
            FIND FIRST repres_tit_acr WHERE repres_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.        

        FOR EACH movto_tit_acr OF tit_acr NO-LOCK:

            FOR EACH aprop_ctbl_acr OF movto_tit_acr NO-LOCK:

                CASE aprop_ctbl_acr.cod_cta_ctbl:

                    WHEN "3610206" THEN DO:
                        
                        IF movto_tit_acr.ind_trans_acr_abrev = "AVMN" THEN.

                        IF AVAIL repres_tit_acr THEN DO:

                            ASSIGN deValor = 0
                                   deValor = ((movto_tit_acr.val_movto_tit_acr * repres_tit_acr.val_perc_comis_repres) / 100). /*(subtrair venda)*/
                        END.
                        
                        /* tit_acr.val_origin_tit_acr */

                        FIND FIRST bf-movto-comis WHERE bf-movto-comis.ep-codigo   = 1
                                                    AND bf-movto-comis.cod-estabel = nota-fiscal.cod-estabel
                                                    AND bf-movto-comis.cod-rep     = repres.cod-rep
                                                    AND bf-movto-comis.tp-movto    = 200
                                                    AND bf-movto-comis.dt-trans    <= TODAY
                                                    AND bf-movto-comis.nro-docto   = nota-fiscal.nr-nota-fis
                                                    AND bf-movto-comis.parcela     = tit_acr.cod_parcela
                                                    AND bf-movto-comis.serie       = nota-fiscal.serie
                                                    NO-LOCK NO-ERROR.

                        IF AVAIL bf-movto-comis THEN
                            MESSAGE bf-movto-comis.valor - deValor SKIP
                                    bf-movto-comis.valor           SKIP
                                    deValor
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            

                    END.

                END CASE.

            END.

        END.

    END.

END.
