define var l-tem-movto      as log                          no-undo.
define var d-base-fgts      as dec format ">>>>>>,>>9.99"   no-undo.
define var d-valor-fgts     as dec format ">>>>>,>>9.99"    no-undo.
define var d-base-irrf      as dec format ">>>>>>,>>9.99"   no-undo.
define var d-base-iapas     as dec format ">>>>>>,>>9.99"   no-undo.
define var d-base-i         as dec format ">>>>>>,>>9.99"   no-undo.
define var w_contador       as int.
define var d-total-vencto   as dec format ">>>>>>,>>9.99+"  no-undo.
define var d-total-descto   as dec format ">>>>>>,>>9.99"   no-undo.
define var d-liquido-pagar  as dec format ">>>,>>>,>>9.99"  no-undo.
define var i-cont-linha     as int                          no-undo.
define var d-salar-atual    as dec                          no-undo.

find param_empres_rh no-lock where param_empres_rh.cdn_empresa = 1 no-error.


assign l-tem-movto     = no
       d-base-iapas    = 0
       d-base-fgts     = 0
       d-valor-fgts    = 0
       d-base-irrf     = 0
       d-liquido-pagar = 0
       d-total-vencto  = 0
       d-total-descto  = 0
       i-cont-linha    = 0
       d-salar-atual   = funcionario.val_salario_atual.
                   
       for each movto_calcul_func of funcionario no-lock where
                movto_calcul_func.num_ano_refer_fp          = /*tt-param.i-ano-ref*/    2009    and
                movto_calcul_func.num_mes_refer_fp          = /*tt-param.i-mes-ref*/    08      and
                movto_calcul_func.idi_tip_fp                = /*tt-param.i-tipo-folha*/ 1       and
                movto_calcul_func.qti_parc_habilit_calc_fp  = /*tt-param.i-parcela*/    9:
           find last histor_sal_func of funcionario where
                     histor_sal_func.dat_liber_sal <= movto_calcul_func.dat_term_parc_calcula no-lock no-error.
           if available histor_sal_func then
              assign d-salar-atual = histor_sal_func.val_salario_categ.

           if movto_calcul_func.num_ano_refer_fp <> param_empres_rh.num_ano_refer_calc_efetd or
              movto_calcul_func.num_mes_refer_fp <> param_empres_rh.num_mes_refer_calc_efetd then do:
              find turno_trab no-lock where
                   turno_trab.cdn_turno_trab = func_turno_trab.cdn_turno_trab no-error.
                      
              if available turno_trab then
                 assign d-hrs-categ    = if can-do("2,5",string(func_categ_sal.cdn_categ_sal))
                                         then 1
                                         else if func_categ_sal.cdn_categ_sal = 1
                                              then turno_trab.qtd_hrs_padr_mes_rh
                                              else if func_categ_sal.cdn_categ_sal = 6
                                                   then turno_trab.qtd_hrs_padr_dia_rh
                                                   else if func_categ_sal.cdn_categ_sal = 3
                                                        then turno_trab.qtd_hrs_padr_sema_rh
                                                        else turno_trab.qtd_hrs_padr_quinz_rh
                        d-sal-cat      = if func_categ_sal.cdn_categ_sal = 1
                                         then v_val_sal_mensal
                                         else v_val_sal_hora
                        d-salar-atual  = if func_categ_sal.cdn_categ_sal = 1
                                         then v_val_sal_mensal
                                         else if func_categ_sal.cdn_categ_sal = 2
                                              then truncate(round(turno_trab.qtd_hrs_padr_mes_rh * v_val_sal_hora,3),3)
                                              else truncate(round(v_val_sal_hora / d-hrs-categ * turno_trab.qtd_hrs_padr_mes_rh,3),3).                                                     
           end.

           assign i-inx       = 0
                  l-tem-movto = yes.
           repeat:
              assign i-inx = i-inx + 1.
              if  i-inx > movto_calcul_func.qti_efp then
                  leave.
              if  movto_calcul_func.cdn_event_fp[i-inx] > 900  then
                  next.
              find event_fp no-lock where
                   event_fp.cdn_event_fp = movto_calcul_func.cdn_event_fp[i-inx].
              if  movto_calcul_func.cdn_idx_efp_funcao_espcif[i-inx] = 52 then do:
                  assign d-liquido-pagar = movto_calcul_func.val_calcul_efp[i-inx].
                  next.
              end.
              if movto_calcul_func.cdn_idx_efp_funcao_espcif[i-inx] = 17 then
                 assign d-base-iapas = movto_calcul_func.val_base_calc_fp[i-inx].
              if movto_calcul_func.cdn_idx_efp_funcao_espcif[i-inx] = 18 and
                 d-base-iapas              = 0  then
                 assign d-base-iapas = movto_calcul_func.val_base_calc_fp[i-inx].
              if movto_calcul_func.idi_tip_fp = 3 and
                 movto_calcul_func.cdn_idx_efp_funcao_espcif[i-inx] = 9 then
                 assign d-base-iapas = movto_calcul_func.val_base_calc_fp[i-inx].
              if movto_calcul_func.cdn_idx_efp_funcao_espcif[i-inx] = 20 or
                 movto_calcul_func.cdn_idx_efp_funcao_espcif[i-inx] = 56 OR
                 movto_calcul_func.cdn_idx_efp_funcao_espcif[i-inx] = 138   then do:
                 assign d-base-fgts  = d-base-fgts + movto_calcul_func.val_base_calc_fp[i-inx]
                        d-valor-fgts = d-valor-fgts + movto_calcul_func.val_calcul_efp[i-inx].
              if not event_fp.log_impr_envel_fp then
                 next.
           end.
           if movto_calcul_func.idi_tip_fp = 3 and
              movto_calcul_func.cdn_idx_efp_funcao_espcif[i-inx] = 14 then
              assign d-base-irrf = movto_calcul_func.val_base_calc_fp[i-inx].
              if movto_calcul_func.cdn_idx_efp_funcao_espcif[i-inx] = 12 then
                 assign d-base-irrf = movto_calcul_func.val_base_calc_fp[i-inx].
              if  movto_calcul_func.val_calcul_efp[i-inx] = 0 and
                  event_fp.idi_ident_efp <> 3 then
                  next.
              if  not event_fp.log_impr_envel_fp then
                  next.
              create w-mvtocalc.
              assign w-mvtocalc.fc-codigo   = movto_calcul_func.cdn_funcionario
                     w-mvtocalc.ev-codigo   = event_fp.cdn_event_fp
                     w-mvtocalc.descricao   = event_fp.des_event_fp
                     w-mvtocalc.identif     = event_fp.idi_ident_efp 
                     w-mvtocalc.unidades    = movto_calcul_func.qtd_unid_event_fp[i-inx] 
                     w-mvtocalc.horas       = movto_calcul_func.qtd_hrs_demonst_efp[i-inx]
                     w-mvtocalc.base        = movto_calcul_func.val_base_calc_fp[i-inx]
                     w-mvtocalc.salar-hora  = if  movto_calcul_func.qtd_hrs_demonst_efp[i-inx] > 0
                                              then truncate(movto_calcul_func.val_calcul_efp[i-inx] /
                                                   movto_calcul_func.qtd_hrs_demonst_efp[i-inx],3)
                                              else 0
                     w-mvtocalc.salar-hora  = if w-mvtocalc.salar-hora > 9999.999
                                              then 9999.999
                                              else w-mvtocalc.salar-hora
                     w-mvtocalc.valor       = movto_calcul_func.val_calcul_efp[i-inx]
                     w-mvtocalc.inc-liquido = event_fp.idi_tip_inciden_liq.
           end.
       end.
       if  not l-tem-movto then                                    
           next.
