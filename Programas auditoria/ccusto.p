DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
OUTPUT TO VALUE("c:\temp\Ccusto.txt").

EXPORT DELIMITER "|"
    "cod_ccusto"            
    "cod_empresa"           
    "cod_livre_1"           
    "cod_livre_2"           
    "cod_plano_ccusto"      
    "cod_usuar_respons"     
    "dat_fim_valid"         
    "dat_inic_valid"        
    "dat_livre_1"           
    "dat_livre_2"           
    "des_anot_tab"          
    "des_tit_ctbl"          
    "log_livre_1"           
    "log_livre_2"           
    "log_permit_lancto_ctbl"
    "log_sumar_agro"        
    "num_livre_1"           
    "num_livre_2"           
    "val_livre_1"           
    "val_livre_2"           
    SKIP.

FOR EACH emsuni.ccusto NO-LOCK:

    ASSIGN i-cont = i-cont + 1.

    EXPORT DELIMITER "|"
        ccusto.cod_ccusto 
        ccusto.cod_empresa 
        ccusto.cod_livre_1 
        ccusto.cod_livre_2 
        ccusto.cod_plano_ccusto 
        ccusto.cod_usuar_respons 
        ccusto.dat_fim_valid 
        ccusto.dat_inic_valid 
        ccusto.dat_livre_1 
        ccusto.dat_livre_2 
        ccusto.des_anot_tab 
        ccusto.des_tit_ctbl 
        ccusto.log_livre_1 
        ccusto.log_livre_2 
        ccusto.log_permit_lancto_ctbl 
        ccusto.log_sumar_agro 
        ccusto.num_livre_1 
        ccusto.num_livre_2 
        ccusto.val_livre_1 
        ccusto.val_livre_2
        SKIP.

END.
OUTPUT CLOSE.

MESSAGE 
    "Centro de Custo" SKIP
    "TOTAL de Registros: " i-cont SKIP
    TODAY " - " STRING(TIME,"hh:mm:ss")
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
