OUTPUT TO "C:\Temp\Titulos_vencimento.csv".

PUT "Fornec"        ";"
    "Estab"         ";"
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
                  AND tit_ap.cod_espec_docto <> "IM"
                  AND tit_ap.dat_vencto_tit_ap >= 12/23/2017 AND tit_ap.dat_vencto_tit_ap <= 01/15/2018 
                  AND tit_ap.cdn_fornec <> 213235
                  AND tit_ap.cdn_fornec <> 285018
                  AND tit_ap.cdn_fornec <> 804
                  AND tit_ap.cdn_fornec <> 219783
                  AND tit_ap.cdn_fornec <> 284623
                  AND tit_ap.cdn_fornec <> 134259
                  AND tit_ap.cdn_fornec <> 269800
                  AND tit_ap.cdn_fornec <> 270360
                  AND tit_ap.cdn_fornec <> 270380
                  AND tit_ap.cdn_fornec <> 269623
                  AND tit_ap.cdn_fornec <> 169271
                  AND tit_ap.cdn_fornec <> 293030
                  AND tit_ap.cdn_fornec <> 386
                  AND tit_ap.cdn_fornec <> 213924
                  AND tit_ap.cdn_fornec <> 219478
                  AND tit_ap.cdn_fornec <> 168991
                  AND tit_ap.cdn_fornec <> 168560
                  AND tit_ap.cdn_fornec <> 108699
                  AND tit_ap.cdn_fornec <> 189076
                  AND tit_ap.cdn_fornec <> 211277
                  AND tit_ap.cdn_fornec <> 48569
                  AND tit_ap.cdn_fornec <> 4490
                  AND tit_ap.cdn_fornec <> 162404
                  AND tit_ap.cdn_fornec <> 974
                  AND tit_ap.cdn_fornec <> 272
                  AND tit_ap.cdn_fornec <> 184552
                  AND tit_ap.cdn_fornec <> 1027
                  AND tit_ap.cdn_fornec <> 92832
                  AND tit_ap.cdn_fornec <> 122461
                  AND tit_ap.cdn_fornec <> 139063
                  AND tit_ap.cdn_fornec <> 70
                  AND tit_ap.cdn_fornec <> 282330
                  AND tit_ap.cdn_fornec <> 234250
                  AND tit_ap.cdn_fornec <> 133751
                  AND tit_ap.cdn_fornec <> 258103
                  AND tit_ap.cdn_fornec <> 267157
                  AND tit_ap.cdn_fornec <> 220
                  AND tit_ap.cdn_fornec <> 133418
                  AND tit_ap.cdn_fornec <> 108144
                  AND tit_ap.cdn_fornec <> 820
                  AND tit_ap.cdn_fornec <> 205227
                  AND tit_ap.cdn_fornec <> 231140
                  AND tit_ap.cdn_fornec <> 893
                  AND tit_ap.cdn_fornec <> 276256
                  AND tit_ap.cdn_fornec <> 180
                  AND tit_ap.cdn_fornec <> 65
                  NO-LOCK
                  BY tit_ap.dat_vencto_tit_ap:

/*          

*/
    PUT tit_ap.cdn_fornec           ";"
        tit_ap.cod_estab            ";"
        tit_ap.cod_espec_docto      ";"
        tit_ap.cod_ser_docto        ";"
        tit_ap.cod_tit_ap           ";"
        tit_ap.cod_parcela          ";"
        tit_ap.dat_vencto_tit_ap    SKIP.
    /*
    ASSIGN tit_ap.dat_vencto_tit_ap = 12/22/2017
           tit_ap.dat_prev_pagto    = 12/22/2017.
    */
END.

OUTPUT CLOSE.
