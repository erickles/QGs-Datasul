OUTPUT TO "C:\Temp\avisos.csv".

PUT "NUMERO SOLIC;DATA IMPLANT" SKIP.

FOR EACH es-aviso-lancto WHERE es-aviso-lancto.data-implant >= 01/01/2016 NO-LOCK
                            BREAK BY es-aviso-lancto.data-implant:

    PUT es-aviso-lancto.nr-solicita  ";"
        es-aviso-lancto.data-implant SKIP.

END.

OUTPUT CLOSE.
