OUTPUT TO "c:\temp\titulos_acr_98010.csv".

PUT "estab;titulo;especie;parcela;serie" SKIP.

FOR EACH tit_acr WHERE tit_acr.cod_portador    = "98010"
                    AND tit_acr.cod_espec_docto = "DP"
                    AND tit_acr.val_sdo_tit_acr > 0
                    NO-LOCK:

    PUT tit_acr.cod_estab       ";"
        tit_acr.cod_tit_acr     ";"
        tit_acr.cod_espec_docto ";"
        tit_acr.cod_parcela     ";"
        tit_acr.cod_ser_docto   SKIP.
END.

OUTPUT CLOSE.
