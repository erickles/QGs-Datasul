 DEFINE VARIABLE idx AS INTEGER     NO-UNDO.

FOR EACH sit_afast_func NO-LOCK 
       WHERE (cdn_sit_afast_func >= 80  
         AND  cdn_sit_afast_func <= 89)     
         AND dat_inic_sit_afast >= 06/01/2010
         AND dat_inic_sit_afast <= 06/30/2010
         AND sit_afast_func.cdn_empresa  >= 01
         AND sit_afast_func.cdn_empresa  <= 01
         AND sit_afast_func.cdn_estab    >= 01
         AND sit_afast_func.cdn_estab    <= 99,  
         EACH sit_afast NO-LOCK WHERE sit_afast.cdn_sit_afast_func = sit_afast_func.cdn_sit_afast_func,
            EACH funcionario OF sit_afast_func NO-LOCK,
                EACH movto_calcul_func WHERE movto_calcul_func.cdn_funcionario   =  funcionario.cdn_funcionario
                                         AND movto_calcul_func.cdn_empresa       =  funcionario.cdn_empresa
                                         AND movto_calcul_func.cdn_estab         =  funcionario.cdn_estab
                                         AND movto_calcul_func.num_mes_refer_fp  = 06
                                         AND movto_calcul_func.num_ano_refer_fp  = 2010:

    DO idx = 1 TO 30:    
        IF movto_calcul_func.cdn_event_fp[idx] = 900 THEN DO:
            MESSAGE movto_calcul_func.cdn_estab                                                                   
                    movto_calcul_func.cdn_empresa                                                                 
                    funcionario.nom_pessoa_fisic                                                                  
                    STRING(funcionario.cdn_agenc_bcia_liq)                                                        
                    STRING(STRING(funcionario.cdn_cta_corren) + " - " + STRING(funcionario.cod_digito_cta_corren))
                    movto_calcul_func.val_calcul_efp[idx]
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.
END.
