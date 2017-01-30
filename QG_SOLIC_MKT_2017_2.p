DEFINE VARIABLE iUltima AS INTEGER     NO-UNDO.

DEFINE BUFFER bf-solic-mkt FOR es-solic-mkt.
DEFINE BUFFER bf2-solic-mkt FOR es-solic-mkt.

OUTPUT TO "C:\Temp\solic.csv".

/* LISTA */

PUT "nr solic;repetida" SKIP.

FOR EACH es-solic-mkt NO-LOCK:
    
    PUT es-solic-mkt.nr-seq                                     ";"
        IF iUltima = es-solic-mkt.nr-seq THEN "SIM" ELSE "NAO"  SKIP.
    /*
    IF iUltima = es-solic-mkt.nr-seq THEN DO:

        FIND LAST bf-solic-mkt NO-LOCK NO-ERROR.
        IF AVAIL bf-solic-mkt THEN DO:
            
            FIND FIRST bf2-solic-mkt WHERE bf2-solic-mkt.nr-seq = bf-solic-mkt.nr-seq + 1 NO-LOCK NO-ERROR.
            IF NOT AVAIL bf2-solic-mkt THEN
                ASSIGN es-solic-mkt.nr-seq = bf-solic-mkt.nr-seq + 1.
        END.

    END.
    */
    ASSIGN iUltima = es-solic-mkt.nr-seq.

END.
OUTPUT CLOSE.
