DEFINE VARIABLE iUltima AS INTEGER     NO-UNDO.

DEFINE BUFFER bf-solic-mkt FOR es-solic-mkt.
DEFINE BUFFER bf2-solic-mkt FOR es-solic-mkt.

/* CORRIGE */

iUltima = 8340.

FIND LAST es-solic-mkt WHERE es-solic-mkt.nr-seq = 8284 NO-ERROR.
IF AVAIL es-solic-mkt THEN DO:    
            
    
    FIND FIRST bf-solic-mkt WHERE bf-solic-mkt.nr-seq = iUltima NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-solic-mkt THEN DO:
        ASSIGN es-solic-mkt.nr-seq = iUltima.



        MESSAGE es-solic-mkt.nr-seq
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.    
    
    /*
    FOR EACH bf-solic-mkt NO-LOCK WHERE bf-solic-mkt.nr-seq > 0 BREAK BY bf-solic-mkt.nr-seq:
        iUltima = bf-solic-mkt.nr-seq.
    END.

    MESSAGE iUltima
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
END.

