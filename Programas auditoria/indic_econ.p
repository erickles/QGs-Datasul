DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
OUTPUT TO VALUE("c:\temp\indic_econ.txt").

EXPORT DELIMITER "|"
    "cod_indic_econ"          
    "cod_livre_1"             
    "cod_livre_2"             
    "cod_modul_dtsul"         
    "cod_usuar_ult_atualiz"   
    "dat_fim_valid"           
    "dat_inic_valid"          
    "dat_livre_1"             
    "dat_livre_2"             
    "dat_ult_atualiz"         
    "des_indic_econ"          
    "des_sig_indic_econ"      
    "hra_ult_atualiz"         
    "ind_capitaliz_indic_econ"
    "ind_tip_cotac"           
    "ind_tip_indic_econ"      
    "ind_ump_indic_econ_infor"
    "log_calc_projec_fasb"    
    "log_envio_bco_histor"    
    "log_livre_1"             
    "log_livre_2"             
    "num_casas_dec"           
    "num_dias_descap"         
    "num_livre_1"             
    "num_livre_2"             
    "val_livre_1"             
    "val_livre_2"             
    SKIP.

FOR EACH indic_econ NO-LOCK:

    ASSIGN i-cont = i-cont + 1.

    EXPORT DELIMITER "|"
        indic_econ.cod_indic_econ 
        indic_econ.cod_livre_1 
        indic_econ.cod_livre_2 
        indic_econ.cod_modul_dtsul 
        indic_econ.cod_usuar_ult_atualiz 
        indic_econ.dat_fim_valid 
        indic_econ.dat_inic_valid 
        indic_econ.dat_livre_1 
        indic_econ.dat_livre_2 
        indic_econ.dat_ult_atualiz 
        indic_econ.des_indic_econ 
        indic_econ.des_sig_indic_econ 
        indic_econ.hra_ult_atualiz 
        indic_econ.ind_capitaliz_indic_econ 
        indic_econ.ind_tip_cotac 
        indic_econ.ind_tip_indic_econ 
        indic_econ.ind_ump_indic_econ_infor 
        indic_econ.log_calc_projec_fasb 
        indic_econ.log_envio_bco_histor 
        indic_econ.log_livre_1 
        indic_econ.log_livre_2 
        indic_econ.num_casas_dec 
        indic_econ.num_dias_descap 
        indic_econ.num_livre_1 
        indic_econ.num_livre_2 
        indic_econ.val_livre_1 
        indic_econ.val_livre_2
        SKIP.

END.
OUTPUT CLOSE.

MESSAGE 
    "Indicador Economico" SKIP
    "TOTAL de Registros: " i-cont SKIP
        TODAY " - " STRING(TIME,"hh:mm:ss")
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
