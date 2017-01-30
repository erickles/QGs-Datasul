/*LEAVE. */

/*
Kleber Sotte - Workaround to load missing financial documents into DIRF table
*/

/*
Table: dirf_apb

Field Name                  Data Type  Flg Format
--------------------------- ---------- --- --------------------------------
cod_estab                   char       im  x(5)
num_pessoa                  inte       im  >>>,>>>,>>9
dat_refer                   date       im  99/99/9999
cod_pais                    char       im  x(3)
cod_unid_federac            char       im  x(3)
cod_imposto                 char       im  x(5)
cod_classif_impto           char       im  x(05)
cod_espec_docto             char       im  x(3)
cod_ser_docto               char       im  x(3)
cod_tit_ap                  char       im  x(10)
cod_parcela                 char       im  x(02)
val_rendto_tribut           deci-2     m   >,>>>,>>>,>>9.99
val_deduc_inss              deci-2     m   >,>>>,>>>,>>9.99
val_deduc_pensao            deci-2     m   >,>>>,>>>,>>9.99
val_deduc_depend            deci-2     m   >,>>>,>>>,>>9.99
val_outras_deduc_impto      deci-2     m   >,>>>,>>>,>>9.99
val_aliq_impto              deci-2     m   >9.99
val_deduc_faixa_impto       deci-2     m   >,>>>,>>>,>>9.99
val_acum_impto_retid_period deci-2     m   >>>,>>>,>>>,>>9.99
cod_livre_1                 char           x(100)
log_gerac_autom             logi       m   Sim/N∆o
val_deduc_legal             deci-2     m   ->>,>>>,>>>,>>9.99
cod_livre_2                 char           x(100)
dat_livre_1                 date           99/99/9999
dat_livre_2                 date           99/99/9999
log_livre_1                 logi           Sim/N∆o
log_livre_2                 logi           Sim/N∆o
num_livre_1                 inte           >>>>>9
num_livre_2                 inte           >>>>>9
val_livre_1                 deci-4         >>>,>>>,>>9.9999
val_livre_2                 deci-4         >>>,>>>,>>9.9999
*/

DEFINE VARIABLE v_cod_estab                     AS char .                 
DEFINE VARIABLE v_num_pessoa                    AS inte .  
DEFINE VARIABLE v_dat_refer                     AS date .  
DEFINE VARIABLE v_cod_pais                      AS char .  
DEFINE VARIABLE v_cod_unid_federac              AS char .  
DEFINE VARIABLE v_cod_imposto                   AS char .  
DEFINE VARIABLE v_cod_classif_impto             AS char .  
DEFINE VARIABLE v_cod_espec_docto               AS char .  
DEFINE VARIABLE v_cod_ser_docto                 AS char .  
DEFINE VARIABLE v_cod_tit_ap                    AS char .  
DEFINE VARIABLE v_cod_parcela                   AS char .  
DEFINE VARIABLE v_val_rendto_tribut             AS DEC  .
DEFINE VARIABLE v_val_deduc_inss                AS DEC  .
DEFINE VARIABLE v_val_deduc_pensao              AS DEC  .
DEFINE VARIABLE v_val_deduc_depend              AS DEC  .
DEFINE VARIABLE v_val_outras_deduc_impto        AS DEC  .
DEFINE VARIABLE v_val_aliq_impto                AS DEC  .
DEFINE VARIABLE v_val_deduc_faixa_impto         AS DEC  .
DEFINE VARIABLE v_val_acum_impto_retid_period   AS DEC  .
DEFINE VARIABLE v_cod_livre_1                   AS char .  
DEFINE VARIABLE v_log_gerac_autom               AS LOG  .
DEFINE VARIABLE v_val_deduc_legal               AS DECI .
DEFINE VARIABLE v_cod_livre_2                   AS char .  
DEFINE VARIABLE v_dat_livre_1                   AS date .  
DEFINE VARIABLE v_dat_livre_2                   AS date .  
DEFINE VARIABLE v_log_livre_1                   AS LOG  . 
DEFINE VARIABLE v_log_livre_2                   AS LOG  . 
DEFINE VARIABLE v_num_livre_1                   AS inte .  
DEFINE VARIABLE v_num_livre_2                   AS inte .  
DEFINE VARIABLE v_val_livre_1                   AS DEC  .
DEFINE VARIABLE v_val_livre_2                   AS DEC  .
DEFINE VARIABLE iCont                           AS INT  .

DEFINE TEMP-TABLE tt_dirf_apb LIKE dirf_apb.


INPUT FROM "C:\Temp\dirf_23022016_2.csv".
REPEAT :
    /*desconsidera cabeáalho*/
    iCont = iCont + 1.
    IF iCont = 1 THEN NEXT.
    /*desconsidera cabeáalho*/

    IMPORT DELIMITER ";"
        v_cod_estab                   
        v_num_pessoa                  
        v_dat_refer                   
        v_cod_pais                    
        v_cod_unid_federac            
        v_cod_imposto                 
        v_cod_classif_impto           
        v_cod_espec_docto             
        v_cod_ser_docto               
        v_cod_tit_ap                  
        v_cod_parcela                 
        v_val_rendto_tribut           
        v_val_deduc_inss              
        v_val_deduc_pensao            
        v_val_deduc_depend            
        v_val_outras_deduc_impto      
        v_val_aliq_impto              
        v_val_deduc_faixa_impto       
        v_val_acum_impto_retid_period 
        v_cod_livre_1                 
        v_log_gerac_autom
        v_val_deduc_legal             
        v_cod_livre_2                 
        v_dat_livre_1                 
        v_dat_livre_2                 
        v_log_livre_1                 
        v_log_livre_2                 
        v_num_livre_1                 
        v_num_livre_2                 
        v_val_livre_1                 
        v_val_livre_2.

           /*
    MESSAGE 
        "v_cod_estab                   => "  v_cod_estab                        SKIP
        "v_num_pessoa                  => "  v_num_pessoa                       SKIP
        "v_dat_refer                   => "  v_dat_refer                        SKIP
        "v_cod_pais                    => "  v_cod_pais                         SKIP
        "v_cod_unid_federac            => "  v_cod_unid_federac                 SKIP
        "v_cod_imposto                 => "  v_cod_imposto                      SKIP
        "v_cod_classif_impto           => "  v_cod_classif_impto                SKIP
        "v_cod_espec_docto             => "  v_cod_espec_docto                  SKIP
        "v_cod_ser_docto               => "  v_cod_ser_docto                    SKIP
        "v_cod_tit_ap                  => "  v_cod_tit_ap                       SKIP
        "v_cod_parcela                 => "  v_cod_parcela                      SKIP
        "v_val_rendto_tribut           => "  v_val_rendto_tribut                SKIP
        "v_val_deduc_inss              => "  v_val_deduc_inss                   SKIP
        "v_val_deduc_pensao            => "  v_val_deduc_pensao                 SKIP
        "v_val_deduc_depend            => "  v_val_deduc_depend                 SKIP
        "v_val_outras_deduc_impto      => "  v_val_outras_deduc_impto           SKIP
        "v_val_aliq_impto              => "  v_val_aliq_impto                   SKIP
        "v_val_deduc_faixa_impto       => "  v_val_deduc_faixa_impto            SKIP
        "v_val_acum_impto_retid_period => "  v_val_acum_impto_retid_period      SKIP
        "v_cod_livre_1                 => "  v_cod_livre_1                      SKIP
        "v_log_gerac_autom             => "  v_log_gerac_autom                  SKIP
        "v_val_deduc_legal             => "  v_val_deduc_legal                  SKIP
        "v_cod_livre_2                 => "  v_cod_livre_2                      SKIP
        "v_dat_livre_1                 => "  v_dat_livre_1                      SKIP
        "v_dat_livre_2                 => "  v_dat_livre_2                      SKIP
        "v_log_livre_1                 => "  v_log_livre_1                      SKIP
        "v_log_livre_2                 => "  v_log_livre_2                      SKIP
        "v_num_livre_1                 => "  v_num_livre_1                      SKIP
        "v_num_livre_2                 => "  v_num_livre_2                      SKIP
        "v_val_livre_1                 => "  v_val_livre_1                      SKIP
        "v_val_livre_2                 => "  v_val_livre_2                      SKIP
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
        */


    CREATE tt_dirf_apb.
    ASSIGN tt_dirf_apb.cod_estab                    = v_cod_estab                  
           tt_dirf_apb.num_pessoa                   = v_num_pessoa                 
           tt_dirf_apb.dat_refer                    = v_dat_refer                  
           tt_dirf_apb.cod_pais                     = v_cod_pais                   
           tt_dirf_apb.cod_unid_federac             = v_cod_unid_federac           
           tt_dirf_apb.cod_imposto                  = v_cod_imposto                
           tt_dirf_apb.cod_classif_impto            = v_cod_classif_impto          
           tt_dirf_apb.cod_espec_docto              = v_cod_espec_docto            
           tt_dirf_apb.cod_ser_docto                = v_cod_ser_docto              
           tt_dirf_apb.cod_tit_ap                   = v_cod_tit_ap                 
           tt_dirf_apb.cod_parcela                  = v_cod_parcela                
           tt_dirf_apb.val_rendto_tribut            = v_val_rendto_tribut          
           tt_dirf_apb.val_deduc_inss               = v_val_deduc_inss             
           tt_dirf_apb.val_deduc_pensao             = v_val_deduc_pensao           
           tt_dirf_apb.val_deduc_depend             = v_val_deduc_depend           
           tt_dirf_apb.val_outras_deduc_impto       = v_val_outras_deduc_impto     
           tt_dirf_apb.val_aliq_impto               = v_val_aliq_impto             
           tt_dirf_apb.val_deduc_faixa_impto        = v_val_deduc_faixa_impto      
           tt_dirf_apb.val_acum_impto_retid_period  = v_val_acum_impto_retid_period
           tt_dirf_apb.cod_livre_1                  = v_cod_livre_1                
           tt_dirf_apb.log_gerac_autom              = NO /*v_log_gerac_autom            */
           tt_dirf_apb.val_deduc_legal              = v_val_deduc_legal            
           tt_dirf_apb.cod_livre_2                  = v_cod_livre_2                
           tt_dirf_apb.dat_livre_1                  = v_dat_livre_1                
           tt_dirf_apb.dat_livre_2                  = v_dat_livre_2                
           tt_dirf_apb.log_livre_1                  = v_log_livre_1                
           tt_dirf_apb.log_livre_2                  = v_log_livre_2                
           tt_dirf_apb.num_livre_1                  = v_num_livre_1                
           tt_dirf_apb.num_livre_2                  = v_num_livre_2                
           tt_dirf_apb.val_livre_1                  = v_val_livre_1                
           tt_dirf_apb.val_livre_2                  = v_val_livre_2    
           .
END.

FOR EACH tt_dirf_apb:

    FIND FIRST emsuni.fornecedor NO-LOCK
         WHERE emsuni.fornecedor.cdn_fornecedor = tt_dirf_apb.num_pessoa /*KSR - eles ir∆o informar o c¢digo do fornecedor e eu procuro o n£mero da pessoa*/
           AND emsuni.fornecedor.cod_empresa    = "TOR".
    IF NOT AVAIL emsuni.fornecedor THEN
        MESSAGE "Fornecedor " + string(emsuni.fornecedor.cdn_fornecedor) + " n∆o encontrado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

    CREATE dirf_apb.
    ASSIGN dirf_apb.cod_estab                        = tt_dirf_apb.cod_estab                  
           dirf_apb.num_pessoa                       = emsuni.fornecedor.num_pessoa /*KSR - eles ir∆o informar o c¢digo do fornecedor e eu procuro o n£mero da pessoa*/
           dirf_apb.dat_refer                        = tt_dirf_apb.dat_refer                  
           dirf_apb.cod_pais                         = tt_dirf_apb.cod_pais                   
           dirf_apb.cod_unid_federac                 = tt_dirf_apb.cod_unid_federac           
           dirf_apb.cod_imposto                      = tt_dirf_apb.cod_imposto                
           dirf_apb.cod_classif_impto                = tt_dirf_apb.cod_classif_impto          
           dirf_apb.cod_espec_docto                  = tt_dirf_apb.cod_espec_docto               
           dirf_apb.cod_ser_docto                    = tt_dirf_apb.cod_ser_docto              
           dirf_apb.cod_tit_ap                       = tt_dirf_apb.cod_tit_ap                 
           dirf_apb.cod_parcela                      = tt_dirf_apb.cod_parcela                
           dirf_apb.val_rendto_tribut                = tt_dirf_apb.val_rendto_tribut          
           dirf_apb.val_deduc_inss                   = tt_dirf_apb.val_deduc_inss             
           dirf_apb.val_deduc_pensao                 = tt_dirf_apb.val_deduc_pensao           
           dirf_apb.val_deduc_depend                 = tt_dirf_apb.val_deduc_depend           
           dirf_apb.val_outras_deduc_impto           = tt_dirf_apb.val_outras_deduc_impto     
           dirf_apb.val_aliq_impto                   = tt_dirf_apb.val_aliq_impto             
           dirf_apb.val_deduc_faixa_impto            = tt_dirf_apb.val_deduc_faixa_impto      
           dirf_apb.val_acum_impto_retid_period      = tt_dirf_apb.val_acum_impto_retid_period
           dirf_apb.cod_livre_1                      = tt_dirf_apb.cod_livre_1                
           dirf_apb.log_gerac_autom                  = tt_dirf_apb.log_gerac_autom            
           dirf_apb.val_deduc_legal                  = tt_dirf_apb.val_deduc_legal            
           dirf_apb.cod_livre_2                      = tt_dirf_apb.cod_livre_2                
           dirf_apb.dat_livre_1                      = tt_dirf_apb.dat_livre_1                
           dirf_apb.dat_livre_2                      = tt_dirf_apb.dat_livre_2                
           dirf_apb.log_livre_1                      = tt_dirf_apb.log_livre_1                
           dirf_apb.log_livre_2                      = tt_dirf_apb.log_livre_2                
           dirf_apb.num_livre_1                      = tt_dirf_apb.num_livre_1                
           dirf_apb.num_livre_2                      = tt_dirf_apb.num_livre_2                
           dirf_apb.val_livre_1                      = tt_dirf_apb.val_livre_1                
           dirf_apb.val_livre_2                      = tt_dirf_apb.val_livre_2                
           .

    DELETE tt_dirf_apb.

END.
                                                     
