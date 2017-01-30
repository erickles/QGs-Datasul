/*

Table: bord_ap

Field Name                  Data Type  Flg Format
--------------------------- ---------- --- --------------------------------
cod_empresa                 char       im  x(3)
cod_estab_bord              char       im  x(3)
cod_portador                char       im  x(5)
num_bord_ap                 inte       im  >>>>>9
cod_msg_inic                char       m   x(2)
cod_msg_fim                 char       m   x(2)
log_bord_ap_escrit          logi       m   Sim/NÆo
log_bord_ap_escrit_envdo    logi       m   Sim/NÆo
ind_tip_bord_ap             char       m   X(17)
dat_transacao               date       m   99/99/9999
cod_indic_econ              char       m   x(8)
cod_finalid_econ            char       im  x(10)
ind_sit_bord_ap             char       m   X(20)
cod_usuar_pagto             char       m   x(12)
cod_cart_bcia               char       im  x(3)
val_tot_lote_pagto_efetd    deci-2     m   ->>,>>>,>>>,>>9.99
val_tot_lote_pagto_infor    deci-2     m   ->>,>>>,>>>,>>9.99
cod_livre_1                 char           x(100)
log_bxa_estab_tit_ap        logi       m   Sim/NÆo
log_bord_gps                logi           Sim/NÆo
log_bord_darf               logi       m   Sim/NÆo
cod_livre_2                 char           x(100)
dat_livre_1                 date           99/99/9999
dat_livre_2                 date           99/99/9999
log_livre_1                 logi           Sim/NÆo
log_livre_2                 logi           Sim/NÆo
num_livre_1                 inte           >>>>>9
num_livre_2                 inte           >>>>>9
val_livre_1                 deci-4         >>>,>>>,>>9.9999
val_livre_2                 deci-4         >>>,>>>,>>9.9999


related Tables
    cheq_ap OF bord_ap (cod_estab_bord,cod_portador,num_bord_ap)
    item_bord_ap OF bord_ap (cod_estab_bord,cod_portador,num_bord_ap)
    ocor_item_bord_ap OF bord_ap (cod_estab_bord,cod_portador,num_bord_ap)
    
    
Table: item_bord_ap

Field Name                  Data Type  Flg Format
--------------------------- ---------- --- --------------------------------
cod_empresa                 char       m   x(3)
cod_estab_bord              char       im  x(3)
cod_portador                char       im  x(5)
num_bord_ap                 inte       im  >>>>>9
num_seq_bord                inte       im  >>>9
cod_refer_antecip_pef       char       i   x(10)
cod_estab                   char       im  x(3)
cod_espec_docto             char       im  x(3)
cod_ser_docto               char       im  x(3)
cdn_fornecedor              inte       im  >>>,>>>,>>9
cod_tit_ap                  char       im  x(10)
cod_parcela                 char       im  x(02)
num_seq_pagto_tit_ap        inte       m   >9
cod_banco                   char       m   x(8)
cod_forma_pagto             char       m   x(3)
cod_forma_pagto_altern      char           x(3)
dat_vencto_tit_ap           date           99/99/9999
dat_prev_pagto              date           99/99/9999
dat_desconto                date           99/99/9999
dat_cotac_indic_econ        date           99/99/9999
val_cotac_indic_econ        deci-10        >>>>,>>9.9999999999
val_pagto                   deci-2     m   ->>>,>>>,>>9.99
val_pagto_inic              deci-2     m   ->>>,>>>,>>9.99
val_multa_tit_ap            deci-2         ->>>,>>>,>>9.99
val_juros                   deci-2         >>>>,>>>,>>9.99
val_cm_tit_ap               deci-2         ->>>,>>>,>>9.99
val_desc_tit_ap             deci-2         ->>>,>>>,>>9.99
val_desc_tit_ap_inic        deci-2         ->>>,>>>,>>9.99
val_abat_tit_ap             deci-2         ->>>,>>>,>>9.99
val_pagto_orig              deci-2     m   ->>>,>>>,>>9.99
val_pagto_orig_inic         deci-2     m   ->>>,>>>,>>9.99
val_multa_tit_ap_orig       deci-2         ->>>,>>>,>>9.99
val_juros_tit_ap_orig       deci-2         ->>>,>>>,>>9.99
val_cm_tit_ap_orig          deci-2     m   ->>>,>>>,>>9.99
val_desc_tit_ap_orig        deci-2         ->>>,>>>,>>9.99
val_desc_tit_ap_orig_inic   deci-2         ->>>,>>>,>>9.99
val_abat_tit_ap_orig        deci-2         ->>>,>>>,>>9.99
des_text_histor             char       m   x(2000)
cod_docto_bco_pagto         char       m   x(20)
ind_sit_item_bord_ap        char       m   X(9)
log_critic_atualiz_ok       logi       m   Sim/NÆo
num_id_item_bord_ap         inte       im  >>>>,>>9
num_id_agrup_item_bord_ap   inte       im  >>>>>>>>>9
cod_estab_cheq              char       m   x(3)
num_id_cheq_ap              inte       m   9999999999
num_seq_item_cheq           inte       m   >>>9
ind_sit_envio_escrit        char       m   X(10)
cdn_proces_edi              inte       im  >>>>>>>9
cod_livre_1                 char           x(100)
cod_bco_pagto               char           x(8)
cod_agenc_bcia_pagto        char           x(10)
cod_digito_agenc_bcia_pagto char           x(2)
cod_cta_corren_bco_pagto    char           x(20)
cod_digito_cta_corren_pagto char           x(2)
cod_usuar_pagto             char       m   x(12)
dat_pagto_tit_ap            date       m   99/99/9999
ind_favorec_cheq            char       m   X(15)
nom_favorec_cheq            char       m   x(40)
cod_contrat_cambio          char           x(15)
dat_contrat_cambio_import   date           99/99/9999
num_contrat_id_cambio       inte           9999999999
cod_estab_contrat_cambio    char           x(3)
cod_refer_contrat_cambio    char           x(10)
dat_refer_contrat_cambio    date           99/99/9999
num_id_proces_pagto         inte       m   999999999
cod_livre_2                 char           x(100)
dat_livre_1                 date           99/99/9999
dat_livre_2                 date           99/99/9999
log_livre_1                 logi           Sim/NÆo
log_livre_2                 logi           Sim/NÆo
num_livre_1                 inte           >>>>>9
num_livre_2                 inte           >>>>>9
val_livre_1                 deci-4         >>>,>>>,>>9.9999
val_livre_2                 deci-4         >>>,>>>,>>9.9999


*/

OUTPUT TO c:\temp\relatorio_titulos_codigo_barra_producao.csv.

PUT
    "cod_portador;"
    "num_bord_ap;"
    "dat_transacao;"
    "ind_sit_bord_ap;"
    "cod_usuar_pagto;"
    "nome_usuar_pagto;"
    "cod_estab;"
    "cod_espec_docto;"
    "cod_ser_docto;"
    "cdn_fornecedor;"
    "nome_fornecedor;"
    "cod_tit_ap;"
    "cod_parcela;"
    "dat_vencto_tit_ap;"
    "val_pagto;"
    "dat_pagto_tit_ap;"
    "cb4_tit_ap_bco_cobdor;"
    "cod_forma_pagto"
    SKIP.


FOR EACH bord_ap NO-LOCK
    WHERE bord_ap.dat_transacao >= 08/01/2014
      AND bord_ap.dat_transacao <= 03/31/2015
    ,
    EACH item_bord_ap OF bord_ap NO-LOCK
   WHERE item_bord_ap.cod_forma_pagto = "001"
      OR item_bord_ap.cod_forma_pagto = "008"
    ,
    FIRST tit_ap OF item_bord_ap NO-LOCK
    /*WHERE tit_ap.cb4_tit_ap_bco_cobdor <> ""*/
    , 
    FIRST emsuni.fornecedor OF tit_ap NO-LOCK
    ,
    FIRST mgcad.usuar_mestre NO-LOCK
    WHERE mgcad.usuar_mestre.cod_usuario = bord_ap.cod_usuar_pagto
    :
    PUT UNFORMATTED
        bord_ap.cod_portador           ";"
        bord_ap.num_bord_ap            ";"
        bord_ap.dat_transacao          ";"
        bord_ap.ind_sit_bord_ap        ";"
        bord_ap.cod_usuar_pagto        ";"
        mgcad.usuar_mestre.nom_usuario ";"
        item_bord_ap.cod_estab         ";"
        item_bord_ap.cod_espec_docto   ";"
        item_bord_ap.cod_ser_docto     ";"
        item_bord_ap.cdn_fornecedor    ";"
        emsuni.fornecedor.nom_pessoa   ";"
        item_bord_ap.cod_tit_ap        ";"
        item_bord_ap.cod_parcela       ";"
        item_bord_ap.dat_vencto_tit_ap ";"
        item_bord_ap.val_pagto         ";"
        item_bord_ap.dat_pagto_tit_ap  ";"
        "'" + tit_ap.cb4_tit_ap_bco_cobdor ";"
        item_bord_ap.cod_forma_pagto  
        SKIP.
        
END.

OUTPUT CLOSE.


