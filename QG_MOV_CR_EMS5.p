{include/i-freeac.i}

DEFINE BUFFER bf_tit_acr        FOR tit_acr.
DEFINE BUFFER b_tit_acr         FOR tit_acr.
DEFINE BUFFER b_movto_tit_acr   FOR movto_tit_acr.

DEFINE VARIABLE v_log_bxo_estab     AS LOGICAL     NO-UNDO INITIAL YES.
DEFINE VARIABLE v_cod_empres_usuar  AS CHARACTER   NO-UNDO INITIAL "TOR".

DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt_relacto_tit_acr
    FIELD cod_estab                 AS CHAR
    FIELD cod_espec_docto           AS CHAR
    FIELD cod_ser_docto             AS CHAR
    FIELD cod_tit_acr               AS CHAR
    FIELD cod_parcela               AS CHAR    
    FIELD cdn_cliente               AS INTE
    FIELD dat_emis_docto            AS DATE
    FIELD cod_portador              AS CHAR
    FIELD cod_cart_bcia             AS CHAR
    FIELD dat_vencto_tit_acr        AS DATE
    FIELD cod_indic_econ            AS CHAR
    FIELD val_origin_tit_acr        AS DECI
    FIELD val_sdo_tit_acr           AS DECI
    FIELD num_id_tit_acr            AS INTE
    FIELD log_tit_acr_estordo       AS LOG
    FIELD tta_val_relacto_tit_acr   AS DECI
    FIELD tta_dat_gerac_movto       AS DATE
    FIELD tta_hra_gerac_movto       AS CHAR
    FIELD ttv_rec_tit_acr           AS RECID
    FIELD val_juros                 AS DECI
    FIELD val_despes_bcia           AS DECI
    FIELD val_abat_tit_acr          AS DECI
    FIELD val_liq_tit_acr           AS DECI
    FIELD val_multa_tit_acr         AS DECI
    FIELD val_desc_tit_acr          AS DECI
    FIELD cod_refer                 AS CHAR.

DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO FORMAT ">,>>>,>>>,>>9.99".
OUTPUT TO "c:\tmp\DEPOSITOS_N_IDENT_2013.CSV".

PUT UNFORMATTED "DT MOVTO;"
                "NR DOCTO EMP;"
                "NR DOCTO BANCO;"
                "ORIGEM;"
                "VALOR MOVTO;"
                "CLIENTE;"
                "ESPECIE;"
                "SERIE;"
                "PARCELA;"
                "VALOR ORIGINAL;"
                "VALOR LIQUIDO;"
                "VALOR JUROS;"
                "VALOR DESP. BANCARIA;"
                "VALOR ABATIMENTO;"
                "VALOR BAIXA;"
                "VALOR DESCONTO;"
                "VALOR ABATIMENTO;"
                "VALOR TOTAL;"
                "COD ESTABEL;"
                "NRO TITULO;"
                "PARCELA RELAC;"
                "CLIENTE RELAC;"
                "ESPECIE RELAC;"
                "REFERENCIA RELAC;"
                "SERIE RELAC;"
                "VALOR RELACTO"
                SKIP.

FOR EACH tit_acr WHERE tit_acr.cdn_cliente     = 247417
                   AND tit_acr.cod_espec_docto = "DN"
                   AND tit_acr.dat_emis_docto  >= 01/01/2013
                   AND tit_acr.dat_emis_docto  <= 12/31/2013
                   NO-LOCK BREAK BY tit_acr.dat_emis_docto
                                 BY tit_acr.cod_tit_acr
                                 BY tit_acr.nom_abrev:

    deValor = 0.

    IF tit_acr.val_liq_tit_acr = 0 THEN
        deValor = tit_acr.val_origin_tit_acr.
    /*ELSE
        deValor = mov-tit.vl-baixa - movto_tit_acr.val_abat_tit_acr.*/
    
    RUN pi_cria_tt_relacto(INPUT tit_acr.cod_estab,
                           INPUT tit_acr.num_id_tit_acr,
                           INPUT tit_acr.num_id_movto_tit_acr_ult).

    FOR EACH tt_relacto_tit_acr NO-LOCK:
        iCont = iCont + 1.
    END.

    IF iCont > 0 THEN DO:

        FOR EACH tt_relacto_tit_acr NO-LOCK:

            PUT UNFORMATTED tit_acr.dat_emis_docto              ";"
                            tit_acr.cod_tit_acr                 ";"
                            tit_acr.cod_tit_acr_bco             ";"
                            tit_acr.ind_orig_tit_acr            ";"
                            tit_acr.val_liq_tit_acr             ";"
                            tit_acr.cdn_cliente                 ";"
                            tit_acr.cod_espec_docto             ";"
                            tit_acr.cod_ser_docto               ";"
                            tit_acr.cod_parcela                 ";"
                            tit_acr.val_origin_tit_acr          ";"
                            tit_acr.val_liq_tit_acr             ";"

                            tt_relacto_tit_acr.val_juros        ";"
                            tt_relacto_tit_acr.val_despes_bcia  ";"
                            tt_relacto_tit_acr.val_abat_tit_acr ";"
                            0                                   ";"
                            tt_relacto_tit_acr.val_desc_tit_acr ";"
                            tt_relacto_tit_acr.val_abat_tit_acr ";"
                            deValor + tt_relacto_tit_acr.val_juros - tt_relacto_tit_acr.val_despes_bcia  ";"
                            tt_relacto_tit_acr.cod_estab        ";"
                            tt_relacto_tit_acr.cod_tit_acr      ";"
                            tt_relacto_tit_acr.cod_parcela      ";"
                            tt_relacto_tit_acr.cdn_cliente      ";"
                            tt_relacto_tit_acr.cod_espec_docto  ";"
                            tt_relacto_tit_acr.cod_refer        ";"
                            tt_relacto_tit_acr.cod_ser_docto    ";"
                            tta_val_relacto_tit_acr             SKIP.
    
        END.

        FOR EACH tt_relacto_tit_acr:
            DELETE tt_relacto_tit_acr.
        END.

    END.
    ELSE DO:
        PUT UNFORMATTED tit_acr.dat_emis_docto      ";"
                        tit_acr.cod_tit_acr         ";"
                        tit_acr.cod_tit_acr_bco     ";"
                        tit_acr.ind_orig_tit_acr    ";"
                        tit_acr.val_liq_tit_acr     ";"
                        tit_acr.cdn_cliente         ";"
                        tit_acr.cod_espec_docto     ";"
                        tit_acr.cod_ser_docto       ";"
                        tit_acr.cod_parcela         ";"
                        tit_acr.val_origin_tit_acr  ";"
                        tit_acr.val_liq_tit_acr     SKIP.
    END.

END.

OUTPUT CLOSE.


PROCEDURE pi_cria_tt_relacto:

    DEFINE INPUT PARAMETER p_cod_estab                  AS CHAR.
    DEFINE INPUT PARAMETER p_num_id_tit_acr             AS INTE.
    DEFINE INPUT PARAMETER p_num_id_movto_tit_acr_ult   AS INTE.
    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.01" &then
    DEF BUFFER b_tit_acr_buf FOR tit_acr.
    &endif

    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    DEFINE VAR v_log_bxa_estab_tit_ap AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO NO-UNDO.

    DEF VAR v_cod_estab_renegoc AS CHARACTER       NO-UNDO. /*local*/

    /************************** Variable Definition End *************************/

    cria_temp_table:
    /*
    FOR EACH relacto_tit_acr NO-LOCK WHERE relacto_tit_acr.cod_estab      = tit_acr.cod_estab
                                       AND relacto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:
    */
    FOR EACH relacto_tit_acr NO-LOCK WHERE relacto_tit_acr.cod_estab      = p_cod_estab
                                       AND relacto_tit_acr.num_id_tit_acr = p_num_id_tit_acr:
        /* Procura pelas notas de credito/debito */
        FIND movto_tit_acr NO-LOCK
             WHERE movto_tit_acr.cod_estab            = relacto_tit_acr.cod_estab_tit_acr_pai
               AND movto_tit_acr.num_id_movto_tit_acr = relacto_tit_acr.num_id_movto_tit_acr_pai
              NO-ERROR.
        if avail movto_tit_acr then do:
            FIND tt_relacto_tit_acr
                 where tt_relacto_tit_acr.cod_estab      = movto_tit_acr.cod_estab
                   and tt_relacto_tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr NO-ERROR.
            FIND b_tit_acr NO-LOCK
                 WHERE b_tit_acr.cod_estab      = movto_tit_acr.cod_estab
                   AND b_tit_acr.num_id_tit_acr = movto_tit_acr.num_id_tit_acr NO-ERROR.
        end.
        else do:
            find b_tit_acr no-lock
                 where b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab_tit_acr_pai
                   and b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr_pai no-error.
            find tt_relacto_tit_acr
                 where tt_relacto_tit_acr.cod_estab      = b_tit_acr.cod_estab
                   and tt_relacto_tit_acr.num_id_tit_acr = b_tit_acr.num_id_tit_acr no-error.
            /*
            find first movto_tit_acr use-index mvtttcr_id no-lock
                 where movto_tit_acr.cod_estab      = tit_acr.cod_estab
                   and movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr no-error.
            */
            FIND FIRST movto_tit_acr USE-INDEX mvtttcr_id NO-LOCK
                 WHERE movto_tit_acr.cod_estab      = p_cod_estab
                   AND movto_tit_acr.num_id_tit_acr = p_num_id_tit_acr NO-ERROR.
        end.
        if  not avail tt_relacto_tit_acr
        then do:
            IF AVAIL b_tit_acr THEN DO:

               CREATE tt_relacto_tit_acr.
               ASSIGN tt_relacto_tit_acr.cod_estab               = b_tit_acr.cod_estab
                      tt_relacto_tit_acr.cod_estab               = b_tit_acr.cod_estab
                      tt_relacto_tit_acr.cod_espec_docto         = b_tit_acr.cod_espec_docto
                      tt_relacto_tit_acr.cod_ser_docto           = b_tit_acr.cod_ser_docto
                      tt_relacto_tit_acr.cod_tit_acr             = b_tit_acr.cod_tit_acr
                      tt_relacto_tit_acr.cod_parcela             = b_tit_acr.cod_parcela.
               
               ASSIGN tt_relacto_tit_acr.cod_estab               = b_tit_acr.cod_estab
                      tt_relacto_tit_acr.cod_espec_docto         = b_tit_acr.cod_espec_docto
                      tt_relacto_tit_acr.cod_ser_docto           = b_tit_acr.cod_ser_docto
                      tt_relacto_tit_acr.cod_tit_acr             = b_tit_acr.cod_tit_acr
                      tt_relacto_tit_acr.cod_parcela             = b_tit_acr.cod_parcela
                      tt_relacto_tit_acr.cdn_cliente             = b_tit_acr.cdn_cliente
                      tt_relacto_tit_acr.dat_emis_docto          = b_tit_acr.dat_emis_docto
                      tt_relacto_tit_acr.cod_portador            = b_tit_acr.cod_portador
                      tt_relacto_tit_acr.cod_cart_bcia           = b_tit_acr.cod_cart_bcia
                      tt_relacto_tit_acr.dat_vencto_tit_acr      = b_tit_acr.dat_vencto_tit_acr
                      tt_relacto_tit_acr.cod_indic_econ          = b_tit_acr.cod_indic_econ
                      tt_relacto_tit_acr.val_origin_tit_acr      = b_tit_acr.val_origin_tit_acr
                      tt_relacto_tit_acr.val_sdo_tit_acr         = b_tit_acr.val_sdo_tit_acr
                      tt_relacto_tit_acr.num_id_tit_acr          = b_tit_acr.num_id_tit_acr
                      tt_relacto_tit_acr.log_tit_acr_estordo     = b_tit_acr.log_tit_acr_estordo
                      tt_relacto_tit_acr.tta_val_relacto_tit_acr = relacto_tit_acr.val_relacto_tit_acr
                      tt_relacto_tit_acr.tta_dat_gerac_movto     = movto_tit_acr.dat_gerac_movto
                      tt_relacto_tit_acr.tta_hra_gerac_movto     = movto_tit_acr.hra_gerac_movto
                      tt_relacto_tit_acr.ttv_rec_tit_acr         = RECID(b_tit_acr)
                      tt_relacto_tit_acr.val_juros               = b_tit_acr.val_juros
                      tt_relacto_tit_acr.val_despes_bcia         = b_tit_acr.val_despes_bcia
                      tt_relacto_tit_acr.val_abat_tit_acr        = b_tit_acr.val_abat_tit_acr
                      tt_relacto_tit_acr.val_liq_tit_acr         = b_tit_acr.val_liq_tit_acr
                      tt_relacto_tit_acr.val_multa_tit_acr       = b_tit_acr.val_multa_tit_acr
                      tt_relacto_tit_acr.val_desc_tit_acr        = b_tit_acr.val_desc_tit_acr
                      tt_relacto_tit_acr.cod_refer               = b_tit_acr.cod_refer.
            end /* if */.
        end /* if */.
    end /* for cria_temp_table */.

    cria_temp_table:
    /*
    FOR EACH movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_estab = tit_acr.cod_estab
                                     AND movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:
    */
    FOR EACH movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_estab      = p_cod_estab
                                     AND movto_tit_acr.num_id_tit_acr = p_num_id_tit_acr:
        /* Procura pelas notas de credito/debito */
        block1:
        for each relacto_tit_acr NO-LOCK where relacto_tit_acr.cod_estab_tit_acr_pai    = movto_tit_acr.cod_estab
                                           and relacto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr:
            find tt_relacto_tit_acr where tt_relacto_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                                      and tt_relacto_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr no-error.
            if  not avail tt_relacto_tit_acr then do:
                find b_tit_acr no-lock where b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                                         and b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr no-error.
                if  avail b_tit_acr then do:
                   create tt_relacto_tit_acr.
                   assign tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                          tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                          tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                          tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                          tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                          tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela.
                   assign tt_relacto_tit_acr.cod_estab               = b_tit_acr.cod_estab
                          tt_relacto_tit_acr.cod_espec_docto         = b_tit_acr.cod_espec_docto
                          tt_relacto_tit_acr.cod_portador            = b_tit_acr.cod_portador
                          tt_relacto_tit_acr.cod_cart_bcia           = b_tit_acr.cod_cart_bcia
                          tt_relacto_tit_acr.cod_ser_docto           = b_tit_acr.cod_ser_docto
                          tt_relacto_tit_acr.cod_tit_acr             = b_tit_acr.cod_tit_acr
                          tt_relacto_tit_acr.cod_parcela             = b_tit_acr.cod_parcela
                          tt_relacto_tit_acr.cdn_cliente             = b_tit_acr.cdn_cliente
                          tt_relacto_tit_acr.dat_emis_docto          = b_tit_acr.dat_emis_docto
                          tt_relacto_tit_acr.dat_vencto_tit_acr      = b_tit_acr.dat_vencto_tit_acr
                          tt_relacto_tit_acr.cod_indic_econ          = b_tit_acr.cod_indic_econ
                          tt_relacto_tit_acr.val_origin_tit_acr      = b_tit_acr.val_origin_tit_acr
                          tt_relacto_tit_acr.val_sdo_tit_acr         = b_tit_acr.val_sdo_tit_acr
                          tt_relacto_tit_acr.num_id_tit_acr          = b_tit_acr.num_id_tit_acr
                          tt_relacto_tit_acr.log_tit_acr_estordo     = b_tit_acr.log_tit_acr_estordo
                          tt_relacto_tit_acr.tta_val_relacto_tit_acr = relacto_tit_acr.val_relacto_tit_acr
                          tt_relacto_tit_acr.tta_dat_gerac_movto     = movto_tit_acr.dat_gerac_movto
                          tt_relacto_tit_acr.tta_hra_gerac_movto     = movto_tit_acr.hra_gerac_movto
                          tt_relacto_tit_acr.ttv_rec_tit_acr         = RECID(b_tit_acr)
                          tt_relacto_tit_acr.val_juros               = b_tit_acr.val_juros
                          tt_relacto_tit_acr.val_despes_bcia         = b_tit_acr.val_despes_bcia
                          tt_relacto_tit_acr.val_abat_tit_acr        = b_tit_acr.val_abat_tit_acr
                          tt_relacto_tit_acr.val_liq_tit_acr         = b_tit_acr.val_liq_tit_acr
                          tt_relacto_tit_acr.val_multa_tit_acr       = b_tit_acr.val_multa_tit_acr
                          tt_relacto_tit_acr.val_desc_tit_acr        = b_tit_acr.val_desc_tit_acr
                          tt_relacto_tit_acr.cod_refer               = b_tit_acr.cod_refer.
                end /* if */.
            end /* if */.
        end /* for block1 */.

        /* Procura pelos movimentos pais */
        for each b_movto_tit_acr no-lock where b_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
                                           and b_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai:

            find tt_relacto_tit_acr where tt_relacto_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                                      and tt_relacto_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr no-error.
            if not avail tt_relacto_tit_acr then do:
                /*
                FIND b_tit_acr NO-LOCK WHERE b_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                                         AND b_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr
                                         AND b_tit_acr.num_id_tit_acr <> tit_acr.num_id_tit_acr 
                                         NO-ERROR.
                */
                FIND b_tit_acr NO-LOCK WHERE b_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                                         AND b_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr
                                         AND b_tit_acr.num_id_tit_acr <> p_num_id_tit_acr
                                         NO-ERROR.

                IF AVAIL b_tit_acr THEN DO:
                    CREATE tt_relacto_tit_acr.
                    ASSIGN tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela.
                    ASSIGN tt_relacto_tit_acr.cod_estab                 = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto           = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto             = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_portador              = b_tit_acr.cod_portador
                           tt_relacto_tit_acr.cod_cart_bcia             = b_tit_acr.cod_cart_bcia
                           tt_relacto_tit_acr.cod_tit_acr               = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_parcela               = b_tit_acr.cod_parcela
                           tt_relacto_tit_acr.cdn_cliente               = b_tit_acr.cdn_cliente
                           tt_relacto_tit_acr.dat_emis_docto            = b_tit_acr.dat_emis_docto
                           tt_relacto_tit_acr.dat_vencto_tit_acr        = b_tit_acr.dat_vencto_tit_acr
                           tt_relacto_tit_acr.cod_indic_econ            = b_tit_acr.cod_indic_econ
                           tt_relacto_tit_acr.val_origin_tit_acr        = b_tit_acr.val_origin_tit_acr
                           tt_relacto_tit_acr.val_sdo_tit_acr           = b_tit_acr.val_sdo_tit_acr
                           tt_relacto_tit_acr.num_id_tit_acr            = b_tit_acr.num_id_tit_acr
                           tt_relacto_tit_acr.log_tit_acr_estordo       = b_tit_acr.log_tit_acr_estordo
                           tt_relacto_tit_acr.tta_dat_gerac_movto       = movto_tit_acr.dat_gerac_movto
                           tt_relacto_tit_acr.tta_hra_gerac_movto       = movto_tit_acr.hra_gerac_movto
                           tt_relacto_tit_acr.tta_val_relacto_tit_acr   = movto_tit_acr.val_movto_tit_acr                        
                           tt_relacto_tit_acr.ttv_rec_tit_acr           = RECID(b_tit_acr)
                           tt_relacto_tit_acr.val_juros                 = b_tit_acr.val_juros
                           tt_relacto_tit_acr.val_despes_bcia           = b_tit_acr.val_despes_bcia
                           tt_relacto_tit_acr.val_abat_tit_acr          = b_tit_acr.val_abat_tit_acr
                           tt_relacto_tit_acr.val_liq_tit_acr           = b_tit_acr.val_liq_tit_acr
                           tt_relacto_tit_acr.val_multa_tit_acr         = b_tit_acr.val_multa_tit_acr
                           tt_relacto_tit_acr.val_desc_tit_acr          = b_tit_acr.val_desc_tit_acr
                           tt_relacto_tit_acr.cod_refer                 = b_tit_acr.cod_refer.
                end /* if */.
            end /* if */.
        end.

        /* Procura pelos movimentos filhos */
        for each b_movto_tit_acr use-index mvtttcr_movto_pai no-lock
            where b_movto_tit_acr.cod_estab_tit_acr_pai    = movto_tit_acr.cod_estab
            and   b_movto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr:

            FIND b_tit_acr NO-LOCK WHERE b_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                                     AND b_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr
                                     AND b_tit_acr.num_id_tit_acr <> p_num_id_tit_acr 
                                     NO-ERROR.

            /*
            FIND b_tit_acr NO-LOCK WHERE b_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                                     AND b_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr
                                     AND b_tit_acr.num_id_tit_acr <> tit_acr.num_id_tit_acr 
                                     NO-ERROR.
            */
            if  avail b_tit_acr then do:
                find tt_relacto_tit_acr no-lock
                    where tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                      and tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                      and tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                      and tt_relacto_tit_acr.cdn_cliente     = b_tit_acr.cdn_cliente
                      and tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                      and tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela no-error.
                if  not avail tt_relacto_tit_acr
                then do:
                    create tt_relacto_tit_acr.
                    assign tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela.
                    ASSIGN tt_relacto_tit_acr.cod_estab                 = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto           = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto             = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_tit_acr               = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_portador              = b_tit_acr.cod_portador
                           tt_relacto_tit_acr.cod_cart_bcia             = b_tit_acr.cod_cart_bcia
                           tt_relacto_tit_acr.cod_parcela               = b_tit_acr.cod_parcela
                           tt_relacto_tit_acr.cdn_cliente               = b_tit_acr.cdn_cliente
                           tt_relacto_tit_acr.dat_emis_docto            = b_tit_acr.dat_emis_docto
                           tt_relacto_tit_acr.dat_vencto_tit_acr        = b_tit_acr.dat_vencto_tit_acr
                           tt_relacto_tit_acr.cod_indic_econ            = b_tit_acr.cod_indic_econ
                           tt_relacto_tit_acr.val_origin_tit_acr        = b_movto_tit_acr.val_movto_tit_acr
                           tt_relacto_tit_acr.val_sdo_tit_acr           = b_tit_acr.val_sdo_tit_acr
                           tt_relacto_tit_acr.num_id_tit_acr            = b_tit_acr.num_id_tit_acr
                           tt_relacto_tit_acr.log_tit_acr_estordo       = b_tit_acr.log_tit_acr_estordo
                           tt_relacto_tit_acr.tta_dat_gerac_movto       = movto_tit_acr.dat_gerac_movto
                           tt_relacto_tit_acr.tta_hra_gerac_movto       = movto_tit_acr.hra_gerac_movto
                           tt_relacto_tit_acr.tta_val_relacto_tit_acr   = b_movto_tit_acr.val_movto_tit_acr 
                           tt_relacto_tit_acr.ttv_rec_tit_acr           = RECID(b_tit_acr)
                           tt_relacto_tit_acr.val_juros                 = b_tit_acr.val_juros
                           tt_relacto_tit_acr.val_despes_bcia           = b_tit_acr.val_despes_bcia
                           tt_relacto_tit_acr.val_abat_tit_acr          = b_tit_acr.val_abat_tit_acr
                           tt_relacto_tit_acr.val_liq_tit_acr           = b_tit_acr.val_liq_tit_acr
                           tt_relacto_tit_acr.val_multa_tit_acr         = b_tit_acr.val_multa_tit_acr
                           tt_relacto_tit_acr.val_desc_tit_acr          = b_tit_acr.val_desc_tit_acr
                           tt_relacto_tit_acr.cod_refer                 = b_tit_acr.cod_refer.
                end /* if */.
            end.
        end.
    end /* for cria_temp_table */.

    FIND movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_estab           = p_cod_estab
                                 AND movto_tit_acr.num_id_tit_acr      = p_num_id_tit_acr
                                 AND movto_tit_acr.ind_trans_acr_abrev = "REN" /*l_ren*/  
                                 NO-ERROR.
    /*
    FIND movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_estab           = tit_acr.cod_estab
                                 AND movto_tit_acr.num_id_tit_acr      = tit_acr.num_id_tit_acr
                                 AND movto_tit_acr.ind_trans_acr_abrev = "REN" /*l_ren*/  
                                 NO-ERROR.
    */
    if avail movto_tit_acr then do:

        assign v_log_bxa_estab_tit_ap = no.
        find first renegoc_acr NO-LOCK where renegoc_acr.cod_estab = movto_tit_acr.cod_estab
                                         and renegoc_acr.cod_refer = movto_tit_acr.cod_refer
                                         no-error.
        if  avail renegoc_acr then
            &if '{&emsfin_version}' >= '5.06' &then
            assign v_log_bxa_estab_tit_ap = renegoc_acr.log_bxa_estab_tit_acr.
            &else 
                &if '{&emsfin_version}' >= '5.04' &then
            assign v_log_bxa_estab_tit_ap = renegoc_acr.log_livre_2.
                &endif 
            &endif 

        if   v_log_bxa_estab_tit_ap
        and  v_log_bxo_estab
        then do:
            for each estabelecimento NO-LOCK where estabelecimento.cod_empresa = v_cod_empres_usuar:
                movto_block:
                for each b_movto_tit_acr no-lock
                    where b_movto_tit_acr.cod_estab           = estabelecimento.cod_estab
                    and  b_movto_tit_acr.cod_refer            = movto_tit_acr.cod_refer
                    and  b_movto_tit_acr.ind_trans_acr_abrev  = "LQRN" /*l_lqrn*/ :

                    &if '{&emsfin_version}' >= '5.06' &then
                    if b_movto_tit_acr.cod_estab_proces_bxa <> renegoc_acr.cod_estab then 
                        next movto_block. 
                    &else
                    if entry(8,b_movto_tit_acr.cod_livre_1,chr(24)) <> renegoc_acr.cod_estab then 
                        next movto_block. 
                    &endif 

                    find b_tit_acr of b_movto_tit_acr no-lock no-error.
                    find tt_relacto_tit_acr no-lock
                        where tt_relacto_tit_acr.cod_estab        = b_tit_acr.cod_estab
                          and tt_relacto_tit_acr.cod_espec_docto  = b_tit_acr.cod_espec_docto
                          and tt_relacto_tit_acr.cod_ser_docto    = b_tit_acr.cod_ser_docto
                          and tt_relacto_tit_acr.cdn_cliente      = b_tit_acr.cdn_cliente
                          and tt_relacto_tit_acr.cod_tit_acr      = b_tit_acr.cod_tit_acr
                          and tt_relacto_tit_acr.cod_parcela      = b_tit_acr.cod_parcela no-error.
                    if  not avail tt_relacto_tit_acr
                    then do:
                        create tt_relacto_tit_acr.
                        assign tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                               tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                               tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                               tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                               tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                               tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela.
                        assign tt_relacto_tit_acr.cod_estab                 = b_tit_acr.cod_estab
                               tt_relacto_tit_acr.cod_espec_docto           = b_tit_acr.cod_espec_docto
                               tt_relacto_tit_acr.cod_ser_docto             = b_tit_acr.cod_ser_docto
                               tt_relacto_tit_acr.cod_tit_acr               = b_tit_acr.cod_tit_acr
                               tt_relacto_tit_acr.cod_portador              = b_tit_acr.cod_portador
                               tt_relacto_tit_acr.cod_cart_bcia             = b_tit_acr.cod_cart_bcia
                               tt_relacto_tit_acr.cod_parcela               = b_tit_acr.cod_parcela
                               tt_relacto_tit_acr.cdn_cliente               = b_tit_acr.cdn_cliente
                               tt_relacto_tit_acr.dat_emis_docto            = b_tit_acr.dat_emis_docto
                               tt_relacto_tit_acr.dat_vencto_tit_acr        = b_tit_acr.dat_vencto_tit_acr
                               tt_relacto_tit_acr.cod_indic_econ            = b_tit_acr.cod_indic_econ
                               tt_relacto_tit_acr.val_origin_tit_acr        = b_tit_acr.val_origin_tit_acr
                               tt_relacto_tit_acr.val_sdo_tit_acr           = b_tit_acr.val_sdo_tit_acr
                               tt_relacto_tit_acr.num_id_tit_acr            = b_tit_acr.num_id_tit_acr
                               tt_relacto_tit_acr.log_tit_acr_estordo       = b_tit_acr.log_tit_acr_estordo
                               tt_relacto_tit_acr.tta_dat_gerac_movto       = b_movto_tit_acr.dat_gerac_movto
                               tt_relacto_tit_acr.tta_hra_gerac_movto       = b_movto_tit_acr.hra_gerac_movto
                               tt_relacto_tit_acr.tta_val_relacto_tit_acr   = movto_tit_acr.val_movto_tit_acr
                               tt_relacto_tit_acr.ttv_rec_tit_acr           = RECID(b_tit_acr)
                               tt_relacto_tit_acr.val_juros                 = b_tit_acr.val_juros
                               tt_relacto_tit_acr.val_despes_bcia           = b_tit_acr.val_despes_bcia
                               tt_relacto_tit_acr.val_abat_tit_acr          = b_tit_acr.val_abat_tit_acr
                               tt_relacto_tit_acr.val_liq_tit_acr           = b_tit_acr.val_liq_tit_acr
                               tt_relacto_tit_acr.val_multa_tit_acr         = b_tit_acr.val_multa_tit_acr
                               tt_relacto_tit_acr.val_desc_tit_acr          = b_tit_acr.val_desc_tit_acr
                               tt_relacto_tit_acr.cod_refer                 = b_tit_acr.cod_refer.

                        if tt_relacto_tit_acr.val_origin_tit_acr = 0 then 
                           assign tt_relacto_tit_acr.val_origin_tit_acr  = b_movto_tit_acr.val_movto_tit_acr.
                    end /* if */.
                end /* for each */.
            end.    
        end.    
        else do:
            for each b_movto_tit_acr no-lock
                where b_movto_tit_acr.cod_estab           = movto_tit_acr.cod_estab
                and  b_movto_tit_acr.cod_refer            = movto_tit_acr.cod_refer
                and  b_movto_tit_acr.ind_trans_acr_abrev  = "LQRN" /*l_lqrn*/ :

                find b_tit_acr of b_movto_tit_acr no-lock no-error.
                find tt_relacto_tit_acr no-lock
                    where tt_relacto_tit_acr.cod_estab        = b_tit_acr.cod_estab
                      and tt_relacto_tit_acr.cod_espec_docto  = b_tit_acr.cod_espec_docto
                      and tt_relacto_tit_acr.cod_ser_docto    = b_tit_acr.cod_ser_docto
                      and tt_relacto_tit_acr.cdn_cliente      = b_tit_acr.cdn_cliente
                      and tt_relacto_tit_acr.cod_tit_acr      = b_tit_acr.cod_tit_acr
                      and tt_relacto_tit_acr.cod_parcela      = b_tit_acr.cod_parcela no-error.
                if  not avail tt_relacto_tit_acr
                then do:
                    create tt_relacto_tit_acr.
                    assign tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela.
                    assign tt_relacto_tit_acr.cod_estab                 = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto           = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto             = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_tit_acr               = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_portador              = b_tit_acr.cod_portador
                           tt_relacto_tit_acr.cod_cart_bcia             = b_tit_acr.cod_cart_bcia
                           tt_relacto_tit_acr.cod_parcela               = b_tit_acr.cod_parcela
                           tt_relacto_tit_acr.cdn_cliente               = b_tit_acr.cdn_cliente
                           tt_relacto_tit_acr.dat_emis_docto            = b_tit_acr.dat_emis_docto
                           tt_relacto_tit_acr.dat_vencto_tit_acr        = b_tit_acr.dat_vencto_tit_acr
                           tt_relacto_tit_acr.cod_indic_econ            = b_tit_acr.cod_indic_econ
                           tt_relacto_tit_acr.val_origin_tit_acr        = b_tit_acr.val_origin_tit_acr
                           tt_relacto_tit_acr.val_sdo_tit_acr           = b_tit_acr.val_sdo_tit_acr
                           tt_relacto_tit_acr.num_id_tit_acr            = b_tit_acr.num_id_tit_acr
                           tt_relacto_tit_acr.log_tit_acr_estordo       = b_tit_acr.log_tit_acr_estordo
                           tt_relacto_tit_acr.tta_dat_gerac_movto       = b_movto_tit_acr.dat_gerac_movto
                           tt_relacto_tit_acr.tta_hra_gerac_movto       = b_movto_tit_acr.hra_gerac_movto
                           tt_relacto_tit_acr.tta_val_relacto_tit_acr   = movto_tit_acr.val_movto_tit_acr
                           tt_relacto_tit_acr.ttv_rec_tit_acr           = RECID(b_tit_acr)
                           tt_relacto_tit_acr.val_juros                 = b_tit_acr.val_juros
                           tt_relacto_tit_acr.val_despes_bcia           = b_tit_acr.val_despes_bcia
                           tt_relacto_tit_acr.val_abat_tit_acr          = b_tit_acr.val_abat_tit_acr
                           tt_relacto_tit_acr.val_liq_tit_acr           = b_tit_acr.val_liq_tit_acr
                           tt_relacto_tit_acr.val_multa_tit_acr         = b_tit_acr.val_multa_tit_acr
                           tt_relacto_tit_acr.val_desc_tit_acr          = b_tit_acr.val_desc_tit_acr
                           tt_relacto_tit_acr.cod_refer                 = b_tit_acr.cod_refer.

                    IF tt_relacto_tit_acr.val_origin_tit_acr = 0 THEN
                       ASSIGN tt_relacto_tit_acr.val_origin_tit_acr  = b_movto_tit_acr.val_movto_tit_acr.
                END /* if */.
            end /* for each */.
        end.
    end.

    find movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_estab            = p_cod_estab
                                 AND movto_tit_acr.num_id_movto_tit_acr = p_num_id_movto_tit_acr_ult
                                 AND movto_tit_acr.ind_trans_acr_abrev  = "LQRN" /*l_lqrn*/
                                 NO-ERROR.
    /*
    find movto_tit_acr NO-LOCK WHERE movto_tit_acr.cod_estab            = tit_acr.cod_estab
                                 AND movto_tit_acr.num_id_movto_tit_acr = tit_acr.num_id_movto_tit_acr_ult
                                 AND movto_tit_acr.ind_trans_acr_abrev  = "LQRN" /*l_lqrn*/  
                                 NO-ERROR.
    */

    if avail movto_tit_acr then do:
        assign v_log_bxa_estab_tit_ap = no
               v_cod_estab_renegoc    = ''.
        &if '{&emsfin_version}' >= '5.06' &then
            assign v_cod_estab_renegoc = movto_tit_acr.cod_estab_proces_bxa.
        &else
            if num-entries(movto_tit_acr.cod_livre_1,chr(24)) >= 8 then
               assign v_cod_estab_renegoc = entry(8,movto_tit_acr.cod_livre_1,chr(24)).
            else
               assign v_cod_estab_renegoc = movto_tit_acr.cod_estab.
        &endif
        if v_cod_estab_renegoc = '' then
           assign v_cod_estab_renegoc = movto_tit_acr.cod_estab.
        find first renegoc_acr no-lock
            where renegoc_acr.cod_estab = v_cod_estab_renegoc
            and   renegoc_acr.cod_refer = movto_tit_acr.cod_refer
            no-error.
        if  avail renegoc_acr then
            &if '{&emsfin_version}' >= '5.06' &then
            assign v_log_bxa_estab_tit_ap = renegoc_acr.log_bxa_estab_tit_acr.
            &else 
                &if '{&emsfin_version}' >= '5.04' &then
            assign v_log_bxa_estab_tit_ap = renegoc_acr.log_livre_2.
                &endif 
            &endif 
        if   v_log_bxa_estab_tit_ap
        and  v_log_bxo_estab
        then do:    
            for each estabelecimento no-lock
                where estabelecimento.cod_empresa = v_cod_empres_usuar:
                movto_block:
                for each  b_movto_tit_acr no-lock
                    where b_movto_tit_acr.cod_estab           = estabelecimento.cod_estab
                    and   b_movto_tit_acr.cod_refer           = movto_tit_acr.cod_refer 
                    and   b_movto_tit_acr.ind_trans_acr_abrev = "REN" /*l_ren*/ :

                    &if '{&emsfin_version}' >= '5.06' &then
                    if b_movto_tit_acr.cod_estab_proces_bxa <> renegoc_acr.cod_estab then 
                        next movto_block. 
                    &else
                    if entry(8,b_movto_tit_acr.cod_livre_1,chr(24)) <> renegoc_acr.cod_estab then 
                        next movto_block. 
                    &endif 

                    find b_tit_acr no-lock
                        where b_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                        and   b_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr no-error.

                        find tt_relacto_tit_acr no-lock
                             where tt_relacto_tit_acr.cod_estab     = b_tit_acr.cod_estab
                             and tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                             and tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                             and tt_relacto_tit_acr.cdn_cliente     = b_tit_acr.cdn_cliente
                             and tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                             and tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela no-error.
                        if  not avail tt_relacto_tit_acr then do:
                            create tt_relacto_tit_acr.
                            assign tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                                   tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                                   tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                                   tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                                   tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                                   tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela.
                            assign tt_relacto_tit_acr.cod_estab               = b_tit_acr.cod_estab
                                   tt_relacto_tit_acr.cod_espec_docto         = b_tit_acr.cod_espec_docto
                                   tt_relacto_tit_acr.cod_ser_docto           = b_tit_acr.cod_ser_docto
                                   tt_relacto_tit_acr.cod_tit_acr             = b_tit_acr.cod_tit_acr
                                   tt_relacto_tit_acr.cod_portador            = b_tit_acr.cod_portador
                                   tt_relacto_tit_acr.cod_cart_bcia           = b_tit_acr.cod_cart_bcia
                                   tt_relacto_tit_acr.cod_parcela             = b_tit_acr.cod_parcela
                                   tt_relacto_tit_acr.cdn_cliente             = b_tit_acr.cdn_cliente
                                   tt_relacto_tit_acr.dat_emis_docto          = b_tit_acr.dat_emis_docto
                                   tt_relacto_tit_acr.dat_vencto_tit_acr      = b_tit_acr.dat_vencto_tit_acr
                                   tt_relacto_tit_acr.cod_indic_econ          = b_tit_acr.cod_indic_econ
                                   tt_relacto_tit_acr.val_origin_tit_acr      = b_tit_acr.val_origin_tit_acr
                                   tt_relacto_tit_acr.val_sdo_tit_acr         = b_tit_acr.val_sdo_tit_acr
                                   tt_relacto_tit_acr.num_id_tit_acr          = b_tit_acr.num_id_tit_acr
                                   tt_relacto_tit_acr.log_tit_acr_estordo     = b_tit_acr.log_tit_acr_estordo
                                   tt_relacto_tit_acr.tta_dat_gerac_movto     = b_movto_tit_acr.dat_gerac_movto
                                   tt_relacto_tit_acr.tta_hra_gerac_movto     = b_movto_tit_acr.hra_gerac_movto
                                   tt_relacto_tit_acr.tta_val_relacto_tit_acr = b_tit_acr.val_origin_tit_acr
                                   tt_relacto_tit_acr.ttv_rec_tit_acr         = RECID(b_tit_acr)
                                   tt_relacto_tit_acr.val_juros               = b_tit_acr.val_juros
                                   tt_relacto_tit_acr.val_despes_bcia         = b_tit_acr.val_despes_bcia
                                   tt_relacto_tit_acr.val_abat_tit_acr        = b_tit_acr.val_abat_tit_acr
                                   tt_relacto_tit_acr.val_liq_tit_acr         = b_tit_acr.val_liq_tit_acr
                                   tt_relacto_tit_acr.val_multa_tit_acr       = b_tit_acr.val_multa_tit_acr
                                   tt_relacto_tit_acr.val_desc_tit_acr        = b_tit_acr.val_desc_tit_acr
                                   tt_relacto_tit_acr.cod_refer               = b_tit_acr.cod_refer.
                        end /* if */.
                end.
            end.     
        end.
        else do:
            for each  b_movto_tit_acr no-lock
                where b_movto_tit_acr.cod_estab           = movto_tit_acr.cod_estab
                and   b_movto_tit_acr.cod_refer           = movto_tit_acr.cod_refer 
                and   b_movto_tit_acr.ind_trans_acr_abrev = "REN" /*l_ren*/ :

                find b_tit_acr no-lock
                    where b_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                    and   b_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr no-error.

                    find tt_relacto_tit_acr no-lock
                         where tt_relacto_tit_acr.cod_estab     = b_tit_acr.cod_estab
                         and tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                         and tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                         and tt_relacto_tit_acr.cdn_cliente     = b_tit_acr.cdn_cliente
                         and tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                         and tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela no-error.
                    if  not avail tt_relacto_tit_acr
                    then do:
                        create tt_relacto_tit_acr.
                        assign tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                               tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                               tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                               tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                               tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                               tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela.
                        assign tt_relacto_tit_acr.cod_estab                 = b_tit_acr.cod_estab
                               tt_relacto_tit_acr.cod_espec_docto           = b_tit_acr.cod_espec_docto
                               tt_relacto_tit_acr.cod_ser_docto             = b_tit_acr.cod_ser_docto
                               tt_relacto_tit_acr.cod_tit_acr               = b_tit_acr.cod_tit_acr
                               tt_relacto_tit_acr.cod_portador              = b_tit_acr.cod_portador
                               tt_relacto_tit_acr.cod_cart_bcia             = b_tit_acr.cod_cart_bcia
                               tt_relacto_tit_acr.cod_parcela               = b_tit_acr.cod_parcela
                               tt_relacto_tit_acr.cdn_cliente               = b_tit_acr.cdn_cliente
                               tt_relacto_tit_acr.dat_emis_docto            = b_tit_acr.dat_emis_docto
                               tt_relacto_tit_acr.dat_vencto_tit_acr        = b_tit_acr.dat_vencto_tit_acr
                               tt_relacto_tit_acr.cod_indic_econ            = b_tit_acr.cod_indic_econ
                               tt_relacto_tit_acr.val_origin_tit_acr        = b_tit_acr.val_origin_tit_acr
                               tt_relacto_tit_acr.val_sdo_tit_acr           = b_tit_acr.val_sdo_tit_acr
                               tt_relacto_tit_acr.num_id_tit_acr            = b_tit_acr.num_id_tit_acr
                               tt_relacto_tit_acr.log_tit_acr_estordo       = b_tit_acr.log_tit_acr_estordo
                               tt_relacto_tit_acr.tta_dat_gerac_movto       = b_movto_tit_acr.dat_gerac_movto
                               tt_relacto_tit_acr.tta_hra_gerac_movto       = b_movto_tit_acr.hra_gerac_movto
                               tt_relacto_tit_acr.tta_val_relacto_tit_acr   = b_tit_acr.val_origin_tit_acr
                               tt_relacto_tit_acr.ttv_rec_tit_acr           = RECID(b_tit_acr)
                               tt_relacto_tit_acr.val_juros                 = b_tit_acr.val_juros
                               tt_relacto_tit_acr.val_despes_bcia           = b_tit_acr.val_despes_bcia
                               tt_relacto_tit_acr.val_abat_tit_acr          = b_tit_acr.val_abat_tit_acr
                               tt_relacto_tit_acr.val_liq_tit_acr           = b_tit_acr.val_liq_tit_acr
                               tt_relacto_tit_acr.val_multa_tit_acr         = b_tit_acr.val_multa_tit_acr
                               tt_relacto_tit_acr.val_desc_tit_acr          = b_tit_acr.val_desc_tit_acr
                               tt_relacto_tit_acr.cod_refer                 = b_tit_acr.cod_refer.
                    end /* if */.
            end.    
        end.    
    end.

END PROCEDURE. /* pi_cria_tt_relacto */
