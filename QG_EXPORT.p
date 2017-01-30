OUTPUT TO C:\tit_ap.TXT.
FOR EACH tit_ap WHERE tit_ap.cod_tit_ap = "3031786"
                   OR tit_ap.cod_tit_ap = "3031784"
                   OR tit_ap.cod_tit_ap = "3031783"
                   OR tit_ap.cod_tit_ap = "7"
                   OR tit_ap.cod_tit_ap = "32"
                   OR tit_ap.cod_tit_ap = "2"
                   OR tit_ap.cod_tit_ap = "916"
                   OR tit_ap.cod_tit_ap = "1674"
                   OR tit_ap.cod_tit_ap = "164"
                   OR tit_ap.cod_tit_ap = "2811/2813"
                   OR tit_ap.cod_tit_ap = "259/263"
                   OR tit_ap.cod_tit_ap = "8400"
                   AND tit_ap.cod_estab = "19"
                   NO-LOCK:
    EXPORT tit_ap.
END.
OUTPUT CLOSE.
