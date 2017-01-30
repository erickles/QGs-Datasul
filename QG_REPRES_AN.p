OUTPUT TO "c:\Temp\titulos_an.csv".

PUT "Estab"     ";"
    "Cliente"   ";"
    "Empresa"   ";"
    "Parcela"   ";"
    "Serie"     ";"
    "Titulo"    ";"
    "Repres"    SKIP.

FOR EACH tit_acr WHERE tit_acr.cod_espec_docto = "AN"
                   AND tit_acr.val_sdo_tit_acr > 0:

    FIND FIRST emitente WHERE emitente.cod-emitente = tit_acr.cdn_cliente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
        IF tit_acr.cdn_repres = 0 THEN DO:

            ASSIGN tit_acr.cdn_repres = emitente.cod-rep.
            PUT tit_acr.cod_estab       ";"
                tit_acr.cdn_cliente     ";"
                tit_acr.cod_empresa     ";"
                tit_acr.cod_parcela     ";"
                tit_acr.cod_ser_docto   ";"
                tit_acr.cod_tit_acr     ";"
                tit_acr.cdn_repres      SKIP.
        END.
    END.

END.
OUTPUT CLOSE.
