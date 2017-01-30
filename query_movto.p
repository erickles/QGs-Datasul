def var j as int.

find first funcionario where funcionario.cdn_funcionario = 5580.

find first movto_calcul_func of funcionario no-lock where
           movto_calcul_func.num_ano_refer_fp          = 2009    and
           movto_calcul_func.num_mes_refer_fp          = 08      and
           movto_calcul_func.idi_tip_fp                = 1       and
           movto_calcul_func.qti_parc_habilit_calc_fp  = 9.


do j = 1 to 30:
    find event_fp no-lock where event_fp.cdn_event_fp = movto_calcul_func.cdn_event_fp[j].
    if inte(event_fp.idi_ident_efp) = 3 then 
    disp event_fp.des_event_fp          
         event_fp.des_folha_compl_neg
         inte(event_fp.idi_ident_efp)
         event_fp.idi_ident_efp
         movto_calcul_func.val_calcul_efp[j] 
         movto_calcul_func.val_salario_atual 
         movto_calcul_func.val_salario_hora
         movto_calcul_func.idi_sit_fasb_cmcac 
         movto_calcul_func.idi_tip_fp 
         movto_calcul_func.log_consid_calc_folha_compl 
         movto_calcul_func.log_cta_mes_13o 
         movto_calcul_func.qtd_hrs_demonst_efp[j] 
         movto_calcul_func.qtd_unid_event_fp[j].
    pause 1.
end.
