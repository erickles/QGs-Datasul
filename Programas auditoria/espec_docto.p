DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
OUTPUT TO VALUE("c:\temp\espec_docto.txt").

EXPORT DELIMITER "|"
    "cod_espec_docto"    
    "cod_livre_1"        
    "cod_livre_2"        
    "dat_livre_1"        
    "dat_livre_2"        
    "des_espec_docto"    
    "ind_tip_espec_docto"
    "log_livre_1"        
    "log_livre_2"        
    "num_livre_1"        
    "num_livre_2"        
    "val_livre_1"        
    "val_livre_2"        
    SKIP.

FOR EACH espec_docto NO-LOCK:

    ASSIGN i-cont = i-cont + 1.

    EXPORT DELIMITER "|"
        espec_docto.cod_espec_docto 
        espec_docto.cod_livre_1 
        espec_docto.cod_livre_2 
        espec_docto.dat_livre_1 
        espec_docto.dat_livre_2 
        espec_docto.des_espec_docto 
        espec_docto.ind_tip_espec_docto 
        espec_docto.log_livre_1 
        espec_docto.log_livre_2 
        espec_docto.num_livre_1 
        espec_docto.num_livre_2 
        espec_docto.val_livre_1 
        espec_docto.val_livre_2
        SKIP.

END.
OUTPUT CLOSE.

MESSAGE 
    "Especie de documento" SKIP
    "TOTAL de Registros: " i-cont SKIP
        TODAY " - " STRING(TIME,"hh:mm:ss")
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
