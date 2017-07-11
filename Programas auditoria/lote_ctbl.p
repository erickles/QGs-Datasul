DEF STREAM str-cab.

DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.

OUTPUT STREAM str-cab TO VALUE("c:\temp\lote_ctbl_12_2014.txt").

EXPORT STREAM str-cab DELIMITER "|"
    "cod_empresa"
    "cod_livre_1"
    "cod_livre_2"
    "cod_modul_dtsul"
    "cod_usuar_ult_atualiz"
    "dat_livre_1"
    "dat_livre_2"
    "dat_lote_ctbl"
    "dat_ult_atualiz"
    "des_lote_ctbl"
    "hra_ult_atualiz"
    "ind_sit_lote_ctbl"
    "log_estorn_lote_ctbl"
    "log_integr_ctbl_online"
    "log_livre_1"
    "log_livre_2"
    "num_livre_1"
    "num_livre_2"
    "num_lote_ctbl"
    "val_livre_1"
    "val_livre_2"
    "contador"
    SKIP.

FOR EACH lancto_ctbl NO-LOCK
   WHERE lancto_ctbl.cod_empresa = "TOR"
     AND lancto_ctbl.dat_lancto_ctbl >= 12/01/2014
     AND lancto_ctbl.dat_lancto_ctbl <= 12/31/2014,
    EACH lote_ctbl OF lancto_ctbl BREAK BY lote_ctbl.num_lote_ctbl:

    IF FIRST-OF(lote_ctbl.num_lote_ctbl) THEN DO:
    
        ASSIGN i-cont = i-cont + 1.
    
        EXPORT STREAM str-cab DELIMITER "|"
            lote_ctbl.cod_empresa 
            lote_ctbl.cod_livre_1 
            lote_ctbl.cod_livre_2 
            lote_ctbl.cod_modul_dtsul 
            lote_ctbl.cod_usuar_ult_atualiz 
                            
            IF lote_ctbl.dat_livre_1 = ? THEN
                "NULL"
            ELSE
                STRING(lote_ctbl.dat_livre_1,"99/99/9999")

            IF lote_ctbl.dat_livre_2 = ? THEN
                "NULL"
            ELSE
                STRING(lote_ctbl.dat_livre_2,"99/99/9999")

            IF lote_ctbl.dat_lote_ctbl = ? THEN
                "NULL"
            ELSE
                STRING(lote_ctbl.dat_lote_ctbl,"99/99/9999")

            IF lote_ctbl.dat_ult_atualiz = ? THEN
                "NULL"
            ELSE
                STRING(lote_ctbl.dat_ult_atualiz,"99/99/9999")
             
            lote_ctbl.des_lote_ctbl 
            lote_ctbl.hra_ult_atualiz 
            lote_ctbl.ind_sit_lote_ctbl 
            STRING(lote_ctbl.log_estorn_lote_ctbl)
            STRING(lote_ctbl.log_integr_ctbl_online)
            STRING(lote_ctbl.log_livre_1)
            STRING(lote_ctbl.log_livre_2)
            STRING(lote_ctbl.num_livre_1)
            STRING(lote_ctbl.num_livre_2)
            STRING(lote_ctbl.num_lote_ctbl)
            STRING(lote_ctbl.val_livre_1)
            STRING(lote_ctbl.val_livre_2)
            STRING(i-cont)
            SKIP.
    END.
END.

OUTPUT STREAM str-cab CLOSE.

MESSAGE "Lotes contabeis"     SKIP
        "TOTAL Lotes: " i-cont            SKIP
        TODAY " - " STRING(TIME,"hh:mm:ss")
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
