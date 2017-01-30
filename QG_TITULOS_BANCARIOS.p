{include/i-buffer.i}
OUTPUT TO "c:\temp\titulos_bancarios.csv".

FOR EACH bord_ap WHERE bord_ap.cod_empresa    = "TOR"
                   AND bord_ap.cod_estab_bord = "01"
                   AND bord_ap.cod_portador   = "34110"
                   /*AND bord_ap.dat_transacao  =*/
                   NO-LOCK:

    FOR EACH item_bord_ap OF bord_ap NO-LOCK:
        FIND FIRST tit_ap OF ITEM_bord_ap NO-LOCK NO-ERROR.
        IF AVAIL tit_ap THEN DO:
            FIND FIRST emsuni.fornecedor WHERE emsuni.fornecedor.cdn_fornecedor = tit_ap.cdn_fornecedor NO-LOCK NO-ERROR.
            IF AVAIL emsuni.fornecedor THEN DO:
                PUT UNFORM emsuni.fornecedor.cdn_fornecedor                                                                     ";"
                            emsuni.fornecedor.nom_pessoa                                                                        ";"
                            emsuni.fornecedor.cod_id_feder                                                                      ";"
                            IF TRIM(tit_ap.cb4_tit_ap_bco_cobdor) <> "" THEN STRING("'" + tit_ap.cb4_tit_ap_bco_cobdor) ELSE "" ";"
                            tit_ap.val_origin_tit_ap                                                                            ";"
                            tit_ap.cod_tit_ap                                                                                   ";"
                            tit_ap.dat_vencto_tit_ap                                                                            ";"
                            bord_ap.cod_usuar_pagto                                                                             SKIP.
            END.
        END.
    END.
END.

OUTPUT CLOSE.
