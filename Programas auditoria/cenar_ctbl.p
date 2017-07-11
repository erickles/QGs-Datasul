DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
    
OUTPUT TO VALUE("c:\temp\cenar_ctbl.txt").

EXPORT DELIMITER "|"
    "cod_cenar_ctbl"  
    "cod_livre_1"     
    "cod_livre_2"     
    "dat_livre_1"     
    "dat_livre_2"     
    "des_anot_tab"    
    "des_cenar_ctbl"  
    "log_cenar_inativ"
    "log_livre_1"     
    "log_livre_2"     
    "num_livre_1"     
    "num_livre_2"     
    "qtd_period_ctbl"
    "val_livre_1"     
    "val_livre_2"     
    SKIP.

FOR EACH cenar_ctbl NO-LOCK:

    ASSIGN i-cont = i-cont + 1.

    EXPORT DELIMITER "|"
        cenar_ctbl.cod_cenar_ctbl 
        cenar_ctbl.cod_livre_1 
        cenar_ctbl.cod_livre_2 
        cenar_ctbl.dat_livre_1 
        cenar_ctbl.dat_livre_2 
        cenar_ctbl.des_anot_tab 
        cenar_ctbl.des_cenar_ctbl 
        cenar_ctbl.log_cenar_inativ 
        cenar_ctbl.log_livre_1 
        cenar_ctbl.log_livre_2 
        cenar_ctbl.num_livre_1 
        cenar_ctbl.num_livre_2 
        cenar_ctbl.qtd_period_ctbl 
        cenar_ctbl.val_livre_1 
        cenar_ctbl.val_livre_2
        SKIP.

END.
OUTPUT CLOSE.

MESSAGE 
    "Cenario Contabil" SKIP
    "TOTAL de Registros: " i-cont SKIP
    TODAY " - " STRING(TIME,"hh:mm:ss")
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
