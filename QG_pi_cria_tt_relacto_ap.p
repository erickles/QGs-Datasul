PROCEDURE pi_cria_tt_relacto:

    /************************** Buffer Definition Begin *************************/

    &if "{&emsfin_version}" >= "5.01" &then
    def buffer b_tit_acr_buf
        for tit_acr.
    &endif


    /*************************** Buffer Definition End **************************/

    /************************* Variable Definition Begin ************************/

    DEFINE VAR v_log_bxa_estab_tit_ap AS LOGICAL FORMAT "Sim/NÆo" INITIAL NO NO-UNDO.

    DEF VAR v_cod_estab_renegoc AS CHARACTER       NO-UNDO. /*local*/

    /************************** Variable Definition End *************************/

    cria_temp_table:
    FOR EACH relacto_tit_acr NO-LOCK WHERE relacto_tit_acr.cod_estab      = tit_acr.cod_estab
                                       AND relacto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr:
        /* Procura pelas notas de credito/debito */
        find movto_tit_acr no-lock
             where movto_tit_acr.cod_estab = relacto_tit_acr.cod_estab_tit_acr_pai
               and movto_tit_acr.num_id_movto_tit_acr = relacto_tit_acr.num_id_movto_tit_acr_pai
              no-error.
        if avail movto_tit_acr then do:
            find tt_relacto_tit_acr
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
            find first movto_tit_acr use-index mvtttcr_id no-lock
                 where movto_tit_acr.cod_estab      = tit_acr.cod_estab
                   and movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr no-error.
        end.
        if  not avail tt_relacto_tit_acr
        then do:
            if  avail b_tit_acr
            then do:
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
                      tt_relacto_tit_acr.ttv_rec_tit_acr         = recid(b_tit_acr).
            end /* if */.
        end /* if */.
    end /* for cria_temp_table */.

    cria_temp_table:
    for
    each movto_tit_acr no-lock
    where movto_tit_acr.cod_estab = tit_acr.cod_estab
      and movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr
    :

        /* Procura pelas notas de credito/debito */
        block1:
        for
        each relacto_tit_acr no-lock
        where relacto_tit_acr.cod_estab_tit_acr_pai = movto_tit_acr.cod_estab
          and relacto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr
        :
            find tt_relacto_tit_acr
                where tt_relacto_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                  and tt_relacto_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr no-error.
            if  not avail tt_relacto_tit_acr
            then do:
                find b_tit_acr no-lock
                     where b_tit_acr.cod_estab      = relacto_tit_acr.cod_estab
                       and b_tit_acr.num_id_tit_acr = relacto_tit_acr.num_id_tit_acr no-error.
                if  avail b_tit_acr
                then do:
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
                          tt_relacto_tit_acr.ttv_rec_tit_acr         = recid(b_tit_acr).
                end /* if */.
            end /* if */.
        end /* for block1 */.

        /* Procura pelos movimentos pais */
        for each b_movto_tit_acr no-lock
            where b_movto_tit_acr.cod_estab            = movto_tit_acr.cod_estab_tit_acr_pai
            and   b_movto_tit_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr_pai:

            find tt_relacto_tit_acr
                 where tt_relacto_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                   and tt_relacto_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr no-error.
            if  not avail tt_relacto_tit_acr
            then do:
                find b_tit_acr no-lock
                     where b_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                       and b_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr
                       and b_tit_acr.num_id_tit_acr <> tit_acr.num_id_tit_acr no-error.
                if  avail b_tit_acr
                then do:
                    create tt_relacto_tit_acr.
                    assign tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela.
                    assign tt_relacto_tit_acr.cod_estab           = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto     = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto       = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_portador        = b_tit_acr.cod_portador
                           tt_relacto_tit_acr.cod_cart_bcia       = b_tit_acr.cod_cart_bcia
                           tt_relacto_tit_acr.cod_tit_acr         = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_parcela         = b_tit_acr.cod_parcela
                           tt_relacto_tit_acr.cdn_cliente         = b_tit_acr.cdn_cliente
                           tt_relacto_tit_acr.dat_emis_docto      = b_tit_acr.dat_emis_docto
                           tt_relacto_tit_acr.dat_vencto_tit_acr  = b_tit_acr.dat_vencto_tit_acr
                           tt_relacto_tit_acr.cod_indic_econ      = b_tit_acr.cod_indic_econ
                           tt_relacto_tit_acr.val_origin_tit_acr  = b_tit_acr.val_origin_tit_acr
                           tt_relacto_tit_acr.val_sdo_tit_acr     = b_tit_acr.val_sdo_tit_acr
                           tt_relacto_tit_acr.num_id_tit_acr      = b_tit_acr.num_id_tit_acr
                           tt_relacto_tit_acr.log_tit_acr_estordo = b_tit_acr.log_tit_acr_estordo
                           tt_relacto_tit_acr.tta_dat_gerac_movto = movto_tit_acr.dat_gerac_movto
                           tt_relacto_tit_acr.tta_hra_gerac_movto = movto_tit_acr.hra_gerac_movto
                           tt_relacto_tit_acr.tta_val_relacto_tit_acr = movto_tit_acr.val_movto_tit_acr                        
                           tt_relacto_tit_acr.ttv_rec_tit_acr     = recid(b_tit_acr).
                end /* if */.
            end /* if */.
        end.

        /* Procura pelos movimentos filhos */
        for each b_movto_tit_acr use-index mvtttcr_movto_pai no-lock
            where b_movto_tit_acr.cod_estab_tit_acr_pai    = movto_tit_acr.cod_estab
            and   b_movto_tit_acr.num_id_movto_tit_acr_pai = movto_tit_acr.num_id_movto_tit_acr:

            find b_tit_acr no-lock
                where b_tit_acr.cod_estab      = b_movto_tit_acr.cod_estab
                  and b_tit_acr.num_id_tit_acr = b_movto_tit_acr.num_id_tit_acr
                  and b_tit_acr.num_id_tit_acr <> tit_acr.num_id_tit_acr no-error.
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
                    assign tt_relacto_tit_acr.cod_estab           = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto     = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto       = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_tit_acr         = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_portador        = b_tit_acr.cod_portador
                           tt_relacto_tit_acr.cod_cart_bcia       = b_tit_acr.cod_cart_bcia
                           tt_relacto_tit_acr.cod_parcela         = b_tit_acr.cod_parcela
                           tt_relacto_tit_acr.cdn_cliente         = b_tit_acr.cdn_cliente
                           tt_relacto_tit_acr.dat_emis_docto      = b_tit_acr.dat_emis_docto
                           tt_relacto_tit_acr.dat_vencto_tit_acr  = b_tit_acr.dat_vencto_tit_acr
                           tt_relacto_tit_acr.cod_indic_econ      = b_tit_acr.cod_indic_econ
                           tt_relacto_tit_acr.val_origin_tit_acr  = b_movto_tit_acr.val_movto_tit_acr
                           tt_relacto_tit_acr.val_sdo_tit_acr     = b_tit_acr.val_sdo_tit_acr
                           tt_relacto_tit_acr.num_id_tit_acr      = b_tit_acr.num_id_tit_acr
                           tt_relacto_tit_acr.log_tit_acr_estordo = b_tit_acr.log_tit_acr_estordo
                           tt_relacto_tit_acr.tta_dat_gerac_movto = movto_tit_acr.dat_gerac_movto
                           tt_relacto_tit_acr.tta_hra_gerac_movto = movto_tit_acr.hra_gerac_movto
                           tt_relacto_tit_acr.tta_val_relacto_tit_acr = b_movto_tit_acr.val_movto_tit_acr 
                           tt_relacto_tit_acr.ttv_rec_tit_acr     = recid(b_tit_acr).
                end /* if */.
            end.
        end.
    end /* for cria_temp_table */.

    find movto_tit_acr no-lock
        where movto_tit_acr.cod_estab           = tit_acr.cod_estab
         and  movto_tit_acr.num_id_tit_acr      = tit_acr.num_id_tit_acr
         and  movto_tit_acr.ind_trans_acr_abrev = "REN" /*l_ren*/  no-error.
    if avail movto_tit_acr then do:

        assign v_log_bxa_estab_tit_ap = no.
        find first renegoc_acr no-lock
            where renegoc_acr.cod_estab = movto_tit_acr.cod_estab
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
                        assign tt_relacto_tit_acr.cod_estab           = b_tit_acr.cod_estab
                               tt_relacto_tit_acr.cod_espec_docto     = b_tit_acr.cod_espec_docto
                               tt_relacto_tit_acr.cod_ser_docto       = b_tit_acr.cod_ser_docto
                               tt_relacto_tit_acr.cod_tit_acr         = b_tit_acr.cod_tit_acr
                               tt_relacto_tit_acr.cod_portador        = b_tit_acr.cod_portador
                               tt_relacto_tit_acr.cod_cart_bcia       = b_tit_acr.cod_cart_bcia
                               tt_relacto_tit_acr.cod_parcela         = b_tit_acr.cod_parcela
                               tt_relacto_tit_acr.cdn_cliente         = b_tit_acr.cdn_cliente
                               tt_relacto_tit_acr.dat_emis_docto      = b_tit_acr.dat_emis_docto
                               tt_relacto_tit_acr.dat_vencto_tit_acr  = b_tit_acr.dat_vencto_tit_acr
                               tt_relacto_tit_acr.cod_indic_econ      = b_tit_acr.cod_indic_econ
                               tt_relacto_tit_acr.val_origin_tit_acr  = b_tit_acr.val_origin_tit_acr
                               tt_relacto_tit_acr.val_sdo_tit_acr     = b_tit_acr.val_sdo_tit_acr
                               tt_relacto_tit_acr.num_id_tit_acr      = b_tit_acr.num_id_tit_acr
                               tt_relacto_tit_acr.log_tit_acr_estordo = b_tit_acr.log_tit_acr_estordo
                               tt_relacto_tit_acr.tta_dat_gerac_movto = b_movto_tit_acr.dat_gerac_movto
                               tt_relacto_tit_acr.tta_hra_gerac_movto = b_movto_tit_acr.hra_gerac_movto
                               tt_relacto_tit_acr.tta_val_relacto_tit_acr = movto_tit_acr.val_movto_tit_acr
                               tt_relacto_tit_acr.ttv_rec_tit_acr     = recid(b_tit_acr).
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
                    assign tt_relacto_tit_acr.cod_estab           = b_tit_acr.cod_estab
                           tt_relacto_tit_acr.cod_espec_docto     = b_tit_acr.cod_espec_docto
                           tt_relacto_tit_acr.cod_ser_docto       = b_tit_acr.cod_ser_docto
                           tt_relacto_tit_acr.cod_tit_acr         = b_tit_acr.cod_tit_acr
                           tt_relacto_tit_acr.cod_portador        = b_tit_acr.cod_portador
                           tt_relacto_tit_acr.cod_cart_bcia       = b_tit_acr.cod_cart_bcia
                           tt_relacto_tit_acr.cod_parcela         = b_tit_acr.cod_parcela
                           tt_relacto_tit_acr.cdn_cliente         = b_tit_acr.cdn_cliente
                           tt_relacto_tit_acr.dat_emis_docto      = b_tit_acr.dat_emis_docto
                           tt_relacto_tit_acr.dat_vencto_tit_acr  = b_tit_acr.dat_vencto_tit_acr
                           tt_relacto_tit_acr.cod_indic_econ      = b_tit_acr.cod_indic_econ
                           tt_relacto_tit_acr.val_origin_tit_acr  = b_tit_acr.val_origin_tit_acr
                           tt_relacto_tit_acr.val_sdo_tit_acr     = b_tit_acr.val_sdo_tit_acr
                           tt_relacto_tit_acr.num_id_tit_acr      = b_tit_acr.num_id_tit_acr
                           tt_relacto_tit_acr.log_tit_acr_estordo = b_tit_acr.log_tit_acr_estordo
                           tt_relacto_tit_acr.tta_dat_gerac_movto = b_movto_tit_acr.dat_gerac_movto
                           tt_relacto_tit_acr.tta_hra_gerac_movto = b_movto_tit_acr.hra_gerac_movto
                           tt_relacto_tit_acr.tta_val_relacto_tit_acr = movto_tit_acr.val_movto_tit_acr
                           tt_relacto_tit_acr.ttv_rec_tit_acr     = recid(b_tit_acr).
                    if tt_relacto_tit_acr.val_origin_tit_acr = 0 then 
                       assign tt_relacto_tit_acr.val_origin_tit_acr  = b_movto_tit_acr.val_movto_tit_acr.
                end /* if */.
            end /* for each */.
        end.
    end.

    find movto_tit_acr no-lock
        where movto_tit_acr.cod_estab          = tit_acr.cod_estab 
        and movto_tit_acr.num_id_movto_tit_acr = tit_acr.num_id_movto_tit_acr_ult
        and movto_tit_acr.ind_trans_acr_abrev  = "LQRN" /*l_lqrn*/  no-error.
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
                        if  not avail tt_relacto_tit_acr
                        then do:
                            create tt_relacto_tit_acr.
                            assign tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                                   tt_relacto_tit_acr.cod_estab       = b_tit_acr.cod_estab
                                   tt_relacto_tit_acr.cod_espec_docto = b_tit_acr.cod_espec_docto
                                   tt_relacto_tit_acr.cod_ser_docto   = b_tit_acr.cod_ser_docto
                                   tt_relacto_tit_acr.cod_tit_acr     = b_tit_acr.cod_tit_acr
                                   tt_relacto_tit_acr.cod_parcela     = b_tit_acr.cod_parcela.
                            assign tt_relacto_tit_acr.cod_estab           = b_tit_acr.cod_estab
                                   tt_relacto_tit_acr.cod_espec_docto     = b_tit_acr.cod_espec_docto
                                   tt_relacto_tit_acr.cod_ser_docto       = b_tit_acr.cod_ser_docto
                                   tt_relacto_tit_acr.cod_tit_acr         = b_tit_acr.cod_tit_acr
                                   tt_relacto_tit_acr.cod_portador        = b_tit_acr.cod_portador
                                   tt_relacto_tit_acr.cod_cart_bcia       = b_tit_acr.cod_cart_bcia
                                   tt_relacto_tit_acr.cod_parcela         = b_tit_acr.cod_parcela
                                   tt_relacto_tit_acr.cdn_cliente         = b_tit_acr.cdn_cliente
                                   tt_relacto_tit_acr.dat_emis_docto      = b_tit_acr.dat_emis_docto
                                   tt_relacto_tit_acr.dat_vencto_tit_acr  = b_tit_acr.dat_vencto_tit_acr
                                   tt_relacto_tit_acr.cod_indic_econ      = b_tit_acr.cod_indic_econ
                                   tt_relacto_tit_acr.val_origin_tit_acr  = b_tit_acr.val_origin_tit_acr
                                   tt_relacto_tit_acr.val_sdo_tit_acr     = b_tit_acr.val_sdo_tit_acr
                                   tt_relacto_tit_acr.num_id_tit_acr      = b_tit_acr.num_id_tit_acr
                                   tt_relacto_tit_acr.log_tit_acr_estordo = b_tit_acr.log_tit_acr_estordo
                                   tt_relacto_tit_acr.tta_dat_gerac_movto = b_movto_tit_acr.dat_gerac_movto
                                   tt_relacto_tit_acr.tta_hra_gerac_movto = b_movto_tit_acr.hra_gerac_movto
                                   tt_relacto_tit_acr.tta_val_relacto_tit_acr = b_tit_acr.val_origin_tit_acr
                                   tt_relacto_tit_acr.ttv_rec_tit_acr     = recid(b_tit_acr).
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
                        assign tt_relacto_tit_acr.cod_estab           = b_tit_acr.cod_estab
                               tt_relacto_tit_acr.cod_espec_docto     = b_tit_acr.cod_espec_docto
                               tt_relacto_tit_acr.cod_ser_docto       = b_tit_acr.cod_ser_docto
                               tt_relacto_tit_acr.cod_tit_acr         = b_tit_acr.cod_tit_acr
                               tt_relacto_tit_acr.cod_portador        = b_tit_acr.cod_portador
                               tt_relacto_tit_acr.cod_cart_bcia       = b_tit_acr.cod_cart_bcia
                               tt_relacto_tit_acr.cod_parcela         = b_tit_acr.cod_parcela
                               tt_relacto_tit_acr.cdn_cliente         = b_tit_acr.cdn_cliente
                               tt_relacto_tit_acr.dat_emis_docto      = b_tit_acr.dat_emis_docto
                               tt_relacto_tit_acr.dat_vencto_tit_acr  = b_tit_acr.dat_vencto_tit_acr
                               tt_relacto_tit_acr.cod_indic_econ      = b_tit_acr.cod_indic_econ
                               tt_relacto_tit_acr.val_origin_tit_acr  = b_tit_acr.val_origin_tit_acr
                               tt_relacto_tit_acr.val_sdo_tit_acr     = b_tit_acr.val_sdo_tit_acr
                               tt_relacto_tit_acr.num_id_tit_acr      = b_tit_acr.num_id_tit_acr
                               tt_relacto_tit_acr.log_tit_acr_estordo = b_tit_acr.log_tit_acr_estordo
                               tt_relacto_tit_acr.tta_dat_gerac_movto = b_movto_tit_acr.dat_gerac_movto
                               tt_relacto_tit_acr.tta_hra_gerac_movto = b_movto_tit_acr.hra_gerac_movto
                               tt_relacto_tit_acr.tta_val_relacto_tit_acr = b_tit_acr.val_origin_tit_acr
                               tt_relacto_tit_acr.ttv_rec_tit_acr     = recid(b_tit_acr).
                    end /* if */.
            end.    
        end.    
    end.

END PROCEDURE. /* pi_cria_tt_relacto */
