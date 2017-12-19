OUTPUT TO "C:\Temp\Titulos_22_12_vencimento.csv".

PUT "Estab"         ";"
    "Fornec"        ";"
    "Especie"       ";"
    "Serie"         ";"
    "Titulo"        ";"
    "Parcela"       ";"
    "Dt vencimento" SKIP.

FOR EACH tit_ap WHERE tit_ap.cod_espec_docto <> "FG" 
                  AND tit_ap.cod_espec_docto <> "FS"
                  AND tit_ap.cod_espec_docto <> "IA"
                  AND tit_ap.cod_espec_docto <> "IE"
                  AND tit_ap.cod_espec_docto <> "IG"
                  AND tit_ap.cod_espec_docto <> "IH"
                  AND tit_ap.cod_espec_docto <> "IN"
                  AND tit_ap.cod_espec_docto <> "IO"
                  AND tit_ap.cod_espec_docto <> "IP"
                  AND tit_ap.cod_espec_docto <> "IR"
                  AND tit_ap.cod_espec_docto <> "IU"
                  AND tit_ap.cod_espec_docto <> "SE"
                  AND tit_ap.cod_espec_docto <> "SR"
                  AND tit_ap.cod_espec_docto <> "SS"
                  AND tit_ap.cod_espec_docto <> "ST"
                  AND tit_ap.cod_espec_docto <> "TO"
                  AND tit_ap.dat_vencto_tit_ap = 12/22/2017 NO-LOCK 
                  BY tit_ap.dat_vencto_tit_ap:

    PUT tit_ap.cod_estab            ";"
        tit_ap.cdn_fornec           ";"
        tit_ap.cod_espec_docto      ";"
        tit_ap.cod_ser_docto        ";"
        tit_ap.cod_tit_ap           ";"
        tit_ap.cod_parcela          ";"
        tit_ap.dat_vencto_tit_ap    SKIP.

    /*tit_ap.dat_vencto_tit_ap = 12/22/2017.*/

END.

OUTPUT CLOSE.
