DEFINE BUFFER bf_movto_tit_acr FOR movto_tit_acr.
FIND FIRST mgcad.empresa NO-LOCK NO-ERROR.

FIND FIRST tit_acr WHERE tit_acr.cdn_cliente     = 265887
                     AND tit_acr.cod_empresa     = "TOR"
                     AND tit_acr.cod_espec_docto = "DP"
                     AND tit_acr.cod_estab       = "19"
                     AND tit_acr.cod_parcela     = "01"
                     AND tit_acr.cod_ser_docto   = "4"
                     AND tit_acr.cod_tit_acr     = "0364116"
                     NO-LOCK NO-ERROR.
IF AVAIL tit_acr THEN DO:
    
    FOR EACH movto_tit_acr OF tit_acr NO-LOCK:

        IF movto_tit_acr.ind_trans_acr_abrev = "EVMN" THEN

            FIND FIRST bf_movto_tit_acr WHERE bf_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai NO-LOCK NO-ERROR.
            IF AVAIL bf_movto_tit_acr THEN
                MESSAGE movto_tit_acr.ind_trans_acr_abrev       SKIP
                        movto_tit_acr.cod_refer                 SKIP
                        bf_movto_tit_acr.ind_trans_acr_abrev    SKIP
                        bf_movto_tit_acr.cod_refer              SKIP
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

            /*
            MESSAGE movto_tit_acr.num_id_enctro_cta         SKIP
                    movto_tit_acr.num_id_movto_bxa          SKIP
                    movto_tit_acr.num_id_movto_cta_corren   SKIP
                    movto_tit_acr.num_id_movto_tit_acr      SKIP
                    movto_tit_acr.num_id_movto_tit_acr_pai  SKIP
                    movto_tit_acr.num_id_tit_acr
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            */
        /*
        FOR EACH aprop_ctbl_acr OF movto_tit_acr NO-LOCK:
            
            IF aprop_ctbl_acr.cod_cta_ctbl = "1170301" THEN DO:
                /*
                MESSAGE movto_tit_acr.dat_vincul_contrat_cambio SKIP
                        movto_tit_acr.dat_vencto_tit_acr        SKIP
                        movto_tit_acr.dat_vencto_ant_tit_acr    SKIP
                        "Transacao " movto_tit_acr.dat_transacao             SKIP
                        movto_tit_acr.dat_refer_contrat_cambio  SKIP
                        movto_tit_acr.dat_livre_2               SKIP
                        movto_tit_acr.dat_livre_1               SKIP
                        movto_tit_acr.dat_liquidac_tit_acr      SKIP
                        movto_tit_acr.dat_gerac_movto           SKIP
                        movto_tit_acr.dat_gerac_ctbz            SKIP
                        movto_tit_acr.dat_fluxo_cx_movto        SKIP
                        movto_tit_acr.dat_cr_movto_tit_acr      SKIP
                        movto_tit_acr.dat_contrat_cambio_export SKIP
                        movto_tit_acr.dat_apurac_variac_val_ant SKIP
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                */
                FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis  = tit_acr.cod_tit_acr
                                         AND nota-fiscal.cod-estabel  = tit_acr.cod_estab
                                         AND nota-fiscal.cod-emitente = tit_acr.cdn_cliente
                                         NO-LOCK NO-ERROR.
                IF AVAIL nota-fiscal THEN DO:
                    FIND FIRST repres WHERE repres.nome-abrev = nota-fiscal.no-ab-reppri NO-LOCK NO-ERROR.

                    FIND FIRST es-movto-comis WHERE es-movto-comis.ep-codigo   = empresa.ep-codigo
                                                AND es-movto-comis.cod-estabel = nota-fiscal.cod-estabel
                                                AND es-movto-comis.cod-rep     = repres.cod-rep
                                                AND es-movto-comis.tp-movto    = 200
                                                AND es-movto-comis.dt-trans    <= TODAY
                                                AND es-movto-comis.nro-docto   = nota-fiscal.nr-nota-fis
                                                AND es-movto-comis.parcela     = tit_acr.cod_parcela
                                                AND es-movto-comis.serie       = nota-fiscal.serie
                                                NO-LOCK NO-ERROR.
                END.
            END.
        END.
        */
    END.
END.
