DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
OUTPUT TO VALUE("c:\temp\empresa.txt").

EXPORT DELIMITER "|"
    "cod_empresa"            
    "cod_livre_1"            
    "cod_livre_2"            
    "dat_livre_1"            
    "dat_livre_2"            
    "des_anot_tab"           
    "log_agent_retenc_impto" 
    "log_livre_1"            
    "log_livre_2"            
    "log_recebe_alter_clien" 
    "log_recebe_alter_fornec"
    "log_recebe_alter_repres"
    "log_recebe_cop_clien"   
    "log_recebe_cop_fornec"  
    "log_recebe_cop_repres"  
    "nom_abrev"              
    "nom_razao_social"       
    "num_livre_1"            
    "num_livre_2"            
    "val_livre_1"            
    "val_livre_2"            
    SKIP.

FOR EACH emsuni.empresa NO-LOCK:

    ASSIGN i-cont = i-cont + 1.

    EXPORT DELIMITER "|"
        empresa.cod_empresa 
        empresa.cod_livre_1 
        empresa.cod_livre_2 
        empresa.dat_livre_1 
        empresa.dat_livre_2 
        empresa.des_anot_tab 
        empresa.log_agent_retenc_impto 
        empresa.log_livre_1 
        empresa.log_livre_2 
        empresa.log_recebe_alter_clien 
        empresa.log_recebe_alter_fornec 
        empresa.log_recebe_alter_repres 
        empresa.log_recebe_cop_clien 
        empresa.log_recebe_cop_fornec 
        empresa.log_recebe_cop_repres 
        empresa.nom_abrev 
        empresa.nom_razao_social 
        empresa.num_livre_1 
        empresa.num_livre_2 
        empresa.val_livre_1 
        empresa.val_livre_2
        SKIP.

END.
OUTPUT CLOSE.

MESSAGE 
    "Empresa" SKIP
    "TOTAL de Registros: " i-cont SKIP
        TODAY " - " STRING(TIME,"hh:mm:ss")
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
