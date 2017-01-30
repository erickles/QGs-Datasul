DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO.
OUTPUT TO "c:\Temp\titulos_aberto.csv".

PUT "COD EMPRESA"       ";"
    "ESTABELECIMENTO"   ";"
    "ESPECIE"           ";"
    "DATA PAGAMENTO"    ";"
    "VALOR PAGAMENTO"   ";"
    "DATA VENCIMENTO"   ";"
    "COD FORNEC"        ";"
    "GRUPO FORNEC"      SKIP.

FOR EACH tit_ap WHERE MONTH(tit_ap.dat_liquidac_tit_ap) = 04
               AND YEAR(tit_ap.dat_liquidac_tit_ap)     = 2014
               AND tit_ap.cod_espec_docto               = "DP"
               AND tit_ap.cod_empresa                   = "TOR"
               AND tit_ap.val_sdo_tit_ap                >= 0,
               EACH emsuni.fornecedor OF tit_ap WHERE fornecedor.cod_grp_fornec = "1"
                                                   OR fornecedor.cod_grp_fornec = "3"
               NO-LOCK:

    PUT tit_ap.cod_empresa              ";"
        tit_ap.cod_estab                ";"
        CAPS(tit_ap.cod_espec_docto)    ";"
        tit_ap.dat_liquidac_tit_ap      ";"
        tit_ap.val_pagto_tit_ap         ";"
        tit_ap.dat_vencto_tit_ap        ";"
        fornecedor.cdn_fornecedor       ";"
        fornecedor.cod_grp_fornec       SKIP.

    deValor = deValor + tit_ap.val_pagto_tit_ap.

END.

/*
MESSAGE deValor
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/

OUTPUT CLOSE.
