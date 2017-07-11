DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
OUTPUT TO VALUE("c:\temp\estabelecimento.txt").

EXPORT DELIMITER "|"
    "cdn_estab"           
    "cod_calend_distrib"  
    "cod_calend_financ"  
    "cod_calend_manuf"    
    "cod_calend_mater"    
    "cod_calend_rh"       
    "cod_empresa"         
    "cod_estab"           
    "cod_id_feder"        
    "cod_id_previd_social"
    "cod_livre_1"         
    "cod_livre_2"         
    "cod_pais"            
    "dat_livre_1"         
    "dat_livre_2"         
    "des_anot_tab"        
    "log_estab_princ"     
    "log_livre_1"         
    "log_livre_2"         
    "nom_abrev"           
    "nom_pessoa"          
    "num_livre_1"         
    "num_livre_2"         
    "num_pessoa_jurid"    
    "val_livre_1"         
    "val_livre_2"         
    SKIP.

FOR EACH estabelecimento NO-LOCK:

    ASSIGN i-cont = i-cont + 1.

    EXPORT DELIMITER "|"
        estabelecimento.cdn_estab 
        estabelecimento.cod_calend_distrib 
        estabelecimento.cod_calend_financ 
        estabelecimento.cod_calend_manuf 
        estabelecimento.cod_calend_mater 
        estabelecimento.cod_calend_rh 
        estabelecimento.cod_empresa 
        estabelecimento.cod_estab 
        estabelecimento.cod_id_feder 
        estabelecimento.cod_id_previd_social 
        estabelecimento.cod_livre_1 
        estabelecimento.cod_livre_2 
        estabelecimento.cod_pais 
        estabelecimento.dat_livre_1 
        estabelecimento.dat_livre_2 
        estabelecimento.des_anot_tab 
        estabelecimento.log_estab_princ 
        estabelecimento.log_livre_1 
        estabelecimento.log_livre_2 
        estabelecimento.nom_abrev 
        estabelecimento.nom_pessoa 
        estabelecimento.num_livre_1 
        estabelecimento.num_livre_2 
        estabelecimento.num_pessoa_jurid 
        estabelecimento.val_livre_1 
        estabelecimento.val_livre_2
        SKIP.

END.
OUTPUT CLOSE.

MESSAGE 
    "Estabelecimento" SKIP
    "TOTAL de Registros: " i-cont SKIP
        TODAY " - " STRING(TIME,"hh:mm:ss")
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
