DEF STREAM str-cab.
DEF STREAM str-det.

DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont2 AS INTEGER     NO-UNDO.
    
OUTPUT STREAM str-cab TO VALUE("c:\temp\lancto_ctbl.txt").
OUTPUT STREAM str-det TO VALUE("c:\temp\item_lancto_ctbl.txt").

EXPORT STREAM str-cab DELIMITER "|"
    "cod_cenar_ctbl"
    "cod_empresa"
    "cod_histor_padr_estorn"
    "cod_lancto_ctbl_padr"
    "cod_livre_1"
    "cod_livre_2"
    "cod_modul_dtsul"
    "cod_rat_ctbl"
    "dat_estorn_lancto_ctbl"
    "dat_lancto_ctbl"
    "dat_livre_1"
    "dat_livre_2"
    "ind_sit_lancto_ctbl"
    "ind_tip_lancto"
    "log_lancto_apurac_restdo"
    "log_lancto_apurac_variac"
    "log_lancto_conver"
    "log_livre_1"
    "log_livre_2"
    "log_sdo_batch_atlzdo"    
    "num_lancto_ctbl"         
    "num_lancto_ctbl_orig_cop"
    "num_lancto_estordo"      
    "num_livre_1"             
    "num_livre_2"             
    "num_lote_ctbl"           
    "num_lote_ctbl_orig_cop"  
    "num_lote_estordo"        
    "val_livre_1"             
    "val_livre_2"
    SKIP.

EXPORT STREAM str-det DELIMITER "|"
    "cod_ccusto"
    "cod_cenar_ctbl"
    "cod_cta_ctbl" 
    "cod_empresa" 
    "cod_espec_docto" 
    "cod_estab" 
    "cod_histor_padr" 
    "cod_imagem" 
    "cod_indic_econ" 
    "cod_livre_1" 
    "cod_livre_2" 
    "cod_plano_ccusto" 
    "cod_plano_cta_ctbl" 
    "cod_proj_financ" 
    "cod_tip_lancto_ctbl" 
    "cod_unid_negoc" 
    "dat_docto" 
    "dat_lancto_ctbl" 
    "dat_livre_1" 
    "dat_livre_2" 
    "des_docto" 
    "des_histor_lancto_ctbl" 
    "ind_natur_lancto_ctbl" 
    "ind_sit_lancto_ctbl" 
    "log_lancto_apurac_restdo" 
    "log_livre_1" 
    "log_livre_2" 
    "num_lancto_ctbl" 
    "num_livre_1" 
    "num_livre_2" 
    "num_lote_ctbl" 
    "num_seq_lancto_ctbl" 
    "num_seq_lancto_ctbl_cpart" 
    "qtd_unid_lancto_ctbl" 
    "val_lancto_ctbl" 
    "val_livre_1" 
    "val_livre_2" 
    "val_seq_entry_number"
    SKIP.

FOR EACH lancto_ctbl NO-LOCK
   WHERE lancto_ctbl.cod_empresa = "TOR"
     AND lancto_ctbl.dat_lancto_ctbl >= 23/11/2014
     AND lancto_ctbl.dat_lancto_ctbl <= 29/11/2014:

    ASSIGN i-cont = i-cont + 1.

    EXPORT STREAM str-cab DELIMITER "|"
        lancto_ctbl.cod_cenar_ctbl 
        lancto_ctbl.cod_empresa 
        lancto_ctbl.cod_histor_padr_estorn 
        lancto_ctbl.cod_lancto_ctbl_padr 
        lancto_ctbl.cod_livre_1 
        lancto_ctbl.cod_livre_2 
        lancto_ctbl.cod_modul_dtsul 
        lancto_ctbl.cod_rat_ctbl 
        lancto_ctbl.dat_estorn_lancto_ctbl 
        lancto_ctbl.dat_lancto_ctbl 
        lancto_ctbl.dat_livre_1 
        lancto_ctbl.dat_livre_2 
        lancto_ctbl.ind_sit_lancto_ctbl 
        lancto_ctbl.ind_tip_lancto 
        lancto_ctbl.log_lancto_apurac_restdo 
        lancto_ctbl.log_lancto_apurac_variac 
        lancto_ctbl.log_lancto_conver 
        lancto_ctbl.log_livre_1 
        lancto_ctbl.log_livre_2 
        lancto_ctbl.log_sdo_batch_atlzdo 
        lancto_ctbl.num_lancto_ctbl 
        lancto_ctbl.num_lancto_ctbl_orig_cop 
        lancto_ctbl.num_lancto_estordo 
        lancto_ctbl.num_livre_1 
        lancto_ctbl.num_livre_2 
        lancto_ctbl.num_lote_ctbl 
        lancto_ctbl.num_lote_ctbl_orig_cop 
        lancto_ctbl.num_lote_estordo 
        lancto_ctbl.val_livre_1 
        lancto_ctbl.val_livre_2
        SKIP.

    FOR EACH ITEM_lancto_ctbl OF lancto_ctbl NO-LOCK:

        ASSIGN i-cont2 = i-cont2 + 1.

        EXPORT STREAM str-det DELIMITER "|"
            item_lancto_ctbl.cod_ccusto 
            item_lancto_ctbl.cod_cenar_ctbl 
            item_lancto_ctbl.cod_cta_ctbl 
            item_lancto_ctbl.cod_empresa 
            item_lancto_ctbl.cod_espec_docto 
            item_lancto_ctbl.cod_estab 
            item_lancto_ctbl.cod_histor_padr 
            item_lancto_ctbl.cod_imagem 
            item_lancto_ctbl.cod_indic_econ 
            item_lancto_ctbl.cod_livre_1 
            item_lancto_ctbl.cod_livre_2 
            item_lancto_ctbl.cod_plano_ccusto 
            item_lancto_ctbl.cod_plano_cta_ctbl 
            item_lancto_ctbl.cod_proj_financ 
            item_lancto_ctbl.cod_tip_lancto_ctbl 
            item_lancto_ctbl.cod_unid_negoc 
            item_lancto_ctbl.dat_docto 
            item_lancto_ctbl.dat_lancto_ctbl 
            item_lancto_ctbl.dat_livre_1 
            item_lancto_ctbl.dat_livre_2 
            item_lancto_ctbl.des_docto 
            item_lancto_ctbl.des_histor_lancto_ctbl 
            item_lancto_ctbl.ind_natur_lancto_ctbl 
            item_lancto_ctbl.ind_sit_lancto_ctbl 
            item_lancto_ctbl.log_lancto_apurac_restdo 
            item_lancto_ctbl.log_livre_1 
            item_lancto_ctbl.log_livre_2 
            item_lancto_ctbl.num_lancto_ctbl 
            item_lancto_ctbl.num_livre_1 
            item_lancto_ctbl.num_livre_2 
            item_lancto_ctbl.num_lote_ctbl 
            item_lancto_ctbl.num_seq_lancto_ctbl 
            item_lancto_ctbl.num_seq_lancto_ctbl_cpart 
            item_lancto_ctbl.qtd_unid_lancto_ctbl 
            item_lancto_ctbl.val_lancto_ctbl 
            item_lancto_ctbl.val_livre_1 
            item_lancto_ctbl.val_livre_2 
            item_lancto_ctbl.val_seq_entry_number
            SKIP.

    END.

END.
OUTPUT STREAM str-cab CLOSE.
OUTPUT STREAM str-det CLOSE.

MESSAGE "Lancamentos e Itens de lancamento" SKIP
        "TOTAL Lan‡amentos: " i-cont SKIP
        "TOTAL Itens Lan‡amentos : " i-cont2 SKIP
        TODAY " - " STRING(TIME,"hh:mm:ss")
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
