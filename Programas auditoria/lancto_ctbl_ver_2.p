DEF STREAM str-cab.
DEF STREAM str-det.

DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont2 AS INTEGER     NO-UNDO.
    
OUTPUT STREAM str-cab TO VALUE("c:\temp\lancto_ctbl_01122014_31122014.txt").
OUTPUT STREAM str-det TO VALUE("c:\temp\item_lancto_ctbl_01122014_31122014.txt").

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
    "contagem"
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
    "contagem"
    SKIP.

FOR EACH lancto_ctbl NO-LOCK
   WHERE lancto_ctbl.cod_empresa = "TOR"
     AND lancto_ctbl.dat_lancto_ctbl >= 12/01/2014
     AND lancto_ctbl.dat_lancto_ctbl <= 12/31/2014:

    ASSIGN i-cont = i-cont + 1.

    EXPORT STREAM str-cab DELIMITER "|"
        REPLACE(lancto_ctbl.cod_cenar_ctbl,CHR(10),"")
        REPLACE(lancto_ctbl.cod_empresa,CHR(10),"")
        REPLACE(lancto_ctbl.cod_histor_padr_estorn,CHR(10),"")
        REPLACE(lancto_ctbl.cod_lancto_ctbl_padr,CHR(10),"")
        REPLACE(lancto_ctbl.cod_livre_1,CHR(10),"")
        REPLACE(lancto_ctbl.cod_livre_2,CHR(10),"")
        REPLACE(lancto_ctbl.cod_modul_dtsul,CHR(10),"")
        REPLACE(lancto_ctbl.cod_rat_ctbl,CHR(10),"")

        IF lancto_ctbl.dat_estorn_lancto_ctbl = ? THEN
            "NULL"
        ELSE
            STRING(lancto_ctbl.dat_estorn_lancto_ctbl,"99/99/9999")

        IF lancto_ctbl.dat_lancto_ctbl = ? THEN
            "NULL"
        ELSE
            STRING(lancto_ctbl.dat_lancto_ctbl,"99/99/9999")

        IF lancto_ctbl.dat_livre_1 = ? THEN
            "NULL"
        ELSE
            STRING(lancto_ctbl.dat_livre_1,"99/99/9999")

        IF lancto_ctbl.dat_livre_2 = ? THEN
            "NULL"
        ELSE
            STRING(lancto_ctbl.dat_livre_2,"99/99/9999")

        STRING(lancto_ctbl.ind_sit_lancto_ctbl)
        STRING(lancto_ctbl.ind_tip_lancto)
        STRING(lancto_ctbl.log_lancto_apurac_restdo)
        STRING(lancto_ctbl.log_lancto_apurac_variac)
        STRING(lancto_ctbl.log_lancto_conver)
        STRING(lancto_ctbl.log_livre_1)
        STRING(lancto_ctbl.log_livre_2)
        STRING(lancto_ctbl.log_sdo_batch_atlzdo)
        STRING(lancto_ctbl.num_lancto_ctbl)
        STRING(lancto_ctbl.num_lancto_ctbl_orig_cop)
        STRING(lancto_ctbl.num_lancto_estordo)
        STRING(lancto_ctbl.num_livre_1)
        STRING(lancto_ctbl.num_livre_2)
        STRING(lancto_ctbl.num_lote_ctbl)
        STRING(lancto_ctbl.num_lote_ctbl_orig_cop)
        STRING(lancto_ctbl.num_lote_estordo)
        STRING(lancto_ctbl.val_livre_1)
        STRING(lancto_ctbl.val_livre_2)
        STRING(i-cont)
        SKIP.

    FOR EACH ITEM_lancto_ctbl OF lancto_ctbl NO-LOCK:

        ASSIGN i-cont2 = i-cont2 + 1.

        EXPORT STREAM str-det DELIMITER "|"
            REPLACE(item_lancto_ctbl.cod_ccusto,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_cenar_ctbl,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_cta_ctbl,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_empresa,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_espec_docto,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_estab,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_histor_padr,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_imagem,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_indic_econ,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_livre_1,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_livre_2,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_plano_ccusto,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_plano_cta_ctbl,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_proj_financ,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_tip_lancto_ctbl,CHR(10),"")
            REPLACE(item_lancto_ctbl.cod_unid_negoc,CHR(10),"")

            IF item_lancto_ctbl.dat_docto = ? THEN
                "NULL"
            ELSE                
                STRING(item_lancto_ctbl.dat_docto,"99/99/9999")

            IF item_lancto_ctbl.dat_lancto_ctbl = ? THEN
                "NULL"
            ELSE
                STRING(item_lancto_ctbl.dat_lancto_ctbl,"99/99/9999")

            IF item_lancto_ctbl.dat_livre_1 = ? THEN
                "NULL"
            ELSE
                STRING(item_lancto_ctbl.dat_livre_1,"99/99/9999")

            IF item_lancto_ctbl.dat_livre_2 = ? THEN
                "NULL"
            ELSE
                STRING(item_lancto_ctbl.dat_livre_2,"99/99/9999")

            REPLACE(item_lancto_ctbl.des_docto,CHR(10),"")
            REPLACE(item_lancto_ctbl.des_histor_lancto_ctbl,CHR(10),"")
            REPLACE(item_lancto_ctbl.ind_natur_lancto_ctbl,CHR(10),"")
            REPLACE(item_lancto_ctbl.ind_sit_lancto_ctbl,CHR(10),"")
            STRING(item_lancto_ctbl.log_lancto_apurac_restdo)
            STRING(item_lancto_ctbl.log_livre_1)
            STRING(item_lancto_ctbl.log_livre_2)
            STRING(item_lancto_ctbl.num_lancto_ctbl)
            STRING(item_lancto_ctbl.num_livre_1)
            STRING(item_lancto_ctbl.num_livre_2)
            STRING(item_lancto_ctbl.num_lote_ctbl)
            STRING(item_lancto_ctbl.num_seq_lancto_ctbl)
            STRING(item_lancto_ctbl.num_seq_lancto_ctbl_cpart)
            STRING(item_lancto_ctbl.qtd_unid_lancto_ctbl)
            STRING(item_lancto_ctbl.val_lancto_ctbl)
            STRING(item_lancto_ctbl.val_livre_1)
            STRING(item_lancto_ctbl.val_livre_2)
            STRING(item_lancto_ctbl.val_seq_entry_number)
            STRING(i-cont2)
            SKIP.

    END.

END.

OUTPUT STREAM str-cab CLOSE.
OUTPUT STREAM str-det CLOSE.

MESSAGE "Lancamentos e Itens de lancamento"     SKIP
        "TOTAL Lan‡amentos: " i-cont            SKIP
        "TOTAL Itens Lan‡amentos : " i-cont2    SKIP
        TODAY " - " STRING(TIME,"hh:mm:ss")
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
