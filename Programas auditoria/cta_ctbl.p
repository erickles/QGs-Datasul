DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
OUTPUT TO VALUE("c:\temp\cta_ctbl.txt").

EXPORT DELIMITER "|"
    "cod_altern_cta_ctbl"       
    "cod_cenar_ctbl_exclus"     
    "cod_cta_ctbl"              
    "cod_cta_ctbl_padr_internac"
    "cod_finalid_econ"          
    "cod_grp_cta_ctbl"          
    "cod_livre_1"               
    "cod_livre_2"               
    "cod_plano_cta_ctbl"        
    "cod_tip_grp_cta_ctbl"      
    "cod_unid_medid"            
    "dat_fim_valid"             
    "dat_inic_valid"            
    "dat_livre_1"               
    "dat_livre_2"               
    "des_anot_tab"              
    "des_tit_ctbl"              
    "ind_espec_cta_ctbl"        
    "ind_natur_cta_ctbl"        
    "ind_tip_taxac_ctbl"        
    "ind_utiliz_ctbl_finalid"   
    "log_consid_apurac_restdo"  
    "log_consid_balan_pat"      
    "log_cta_ctbl_exclus_analit"
    "log_livre_1"               
    "log_livre_2"               
    "num_livre_1"               
    "num_livre_2"               
    "val_livre_1"               
    "val_livre_2"               
    SKIP.

FOR EACH cta_ctbl NO-LOCK WHERE cod_plano_cta_ctbl = "TORT2006":

    ASSIGN i-cont = i-cont + 1.

    EXPORT DELIMITER "|"
        cta_ctbl.cod_altern_cta_ctbl 
        cta_ctbl.cod_cenar_ctbl_exclus 
        cta_ctbl.cod_cta_ctbl 
        cta_ctbl.cod_cta_ctbl_padr_internac 
        cta_ctbl.cod_finalid_econ 
        cta_ctbl.cod_grp_cta_ctbl 
        cta_ctbl.cod_livre_1 
        cta_ctbl.cod_livre_2 
        cta_ctbl.cod_plano_cta_ctbl 
        cta_ctbl.cod_tip_grp_cta_ctbl 
        cta_ctbl.cod_unid_medid 
        
        IF cta_ctbl.dat_fim_valid = ? THEN
            "NULL"
        ELSE
            STRING(cta_ctbl.dat_fim_valid,"99/99/9999")

        IF cta_ctbl.dat_inic_valid = ? THEN
            "NULL"
        ELSE
            STRING(cta_ctbl.dat_inic_valid,"99/99/9999")

        IF cta_ctbl.dat_livre_1 = ? THEN
            "NULL"
        ELSE
            STRING(cta_ctbl.dat_livre_1,"99/99/9999")

        IF cta_ctbl.dat_livre_2 = ? THEN
            "NULL"
        ELSE
            STRING(cta_ctbl.dat_livre_2,"99/99/9999")

        cta_ctbl.des_anot_tab 
        cta_ctbl.des_tit_ctbl 
        cta_ctbl.ind_espec_cta_ctbl 
        cta_ctbl.ind_natur_cta_ctbl 
        cta_ctbl.ind_tip_taxac_ctbl 
        cta_ctbl.ind_utiliz_ctbl_finalid
        STRING(cta_ctbl.log_consid_apurac_restdo)
        STRING(cta_ctbl.log_consid_balan_pat)
        STRING(cta_ctbl.log_cta_ctbl_exclus_analit)
        STRING(cta_ctbl.log_livre_1)
        STRING(cta_ctbl.log_livre_2)
        STRING(cta_ctbl.num_livre_1)
        STRING(cta_ctbl.num_livre_2)
        STRING(cta_ctbl.val_livre_1)
        STRING(cta_ctbl.val_livre_2)
        SKIP.

END.
OUTPUT CLOSE.

MESSAGE "Conta contabil" SKIP
        "TOTAL de Registros: " i-cont SKIP
        TODAY " - " STRING(TIME,"hh:mm:ss")
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
