{include/i-freeac.i}
FOR EACH movtrp.fatura-frete WHERE fatura-frete.cod-estabel = "01"                                /*Fatura*/
                               AND fatura-frete.cgc-transp = "07784847000234"
                               AND fatura-frete.nr-fatura = "000615"
                               NO-LOCK:

    FIND emitente WHERE emitente.cgc = fatura-frete.cgc-transp NO-LOCK NO-ERROR.
          
    FOR EACH movtrp.fatura-docto-frete WHERE fatura-docto-frete.cgc-transp = fatura-frete.cgc-transp   /*CTRC's da fatura*/
                                        AND fatura-docto-frete.nr-fatura = fatura-frete.nr-fatura
                                        AND fatura-docto-frete.serie-fat = fatura-frete.serie,
                                        EACH transporte WHERE transporte.cgc = movtrp.fatura-frete.cgc-transp:

        find first movtrp.docto-frete of movtrp.fatura-docto-frete no-lock no-error.
                
        FOR EACH tit-ap WHERE tit-ap.cod-estabel = fatura-frete.cod-estabel
                          AND tit-ap.cod-esp     = "FF"
                          AND tit-ap.ep-codigo   = 1
                          AND tit-ap.cod-fornec  = emitente.cod-emitente
                          AND tit-ap.parcela     = "1"
                          AND tit-ap.nr-docto    = fatura-frete.nr-fatura
                          AND tit-ap.serie       = fatura-frete.serie:

            MESSAGE "Estabel:                   "   movtrp.fatura-frete.cod-estabel         SKIP
                    "Nr Fatura                  "   movtrp.fatura-frete.nr-fatura           SKIP
                    "Dt Emissao                 "   movtrp.fatura-docto-frete.dt-emissao    SKIP
                    "DT Trans                   "   tit-ap.dt-trans                         SKIP
                    "Transp                     "   transporte.cod-transp                   SKIP
                    "Transp N.                  "   fn-free-accent(transporte.nome)         SKIP
                    "CTRC                       "   movtrp.fatura-docto-frete.nr-documento  SKIP
                    "Vl. Fatura                 "   movtrp.fatura-frete.vl-fatura           SKIP
                    "Serie                      "   tit-ap.serie                            SKIP
                    
                    VIEW-AS ALERT-BOX.                            

        END.

    END.

END.
