OUTPUT TO "C:\Temp\fat_ser_lote.csv".

FOR EACH fat-ser-lote WHERE length(fat-ser-lote.nr-serlote) > 20 NO-LOCK:

    PUT UNFORM
        fat-ser-lote.data-1 ";"
        fat-ser-lote.data-2 ";"
        fat-ser-lote.nr-serlote SKIP.

END.

OUTPUT CLOSE.
