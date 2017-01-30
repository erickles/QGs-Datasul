DEFINE VARIABLE idx AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-total-vlr AS DECIMAL     NO-UNDO.
OUTPUT TO "c:\brindes.txt".

ASSIGN c-total-vlr = 0.

FOR EACH es-solic-mkt WHERE es-solic-mkt.nr-seq = 1231:

    DO idx = 1 TO 11:
        
        IF es-solic-mkt.it-codigo-bri[idx] <> "" THEN DO:

            FIND FIRST es-solic-brindes WHERE es-solic-brindes.descricao-brindes BEGINS es-solic-mkt.it-codigo-bri[idx] NO-LOCK NO-ERROR.
            IF AVAIL es-solic-brindes THEN DO:
                PUT es-solic-mkt.nr-seq             " "
                    es-solic-mkt.it-codigo-bri[idx] " "
                    es-solic-mkt.vlr-brinde[idx]    " "
                    es-solic-brindes.vlr-brinde
                    SKIP.

                ASSIGN es-solic-mkt.vlr-brinde[idx] = es-solic-brindes.vlr-brinde
                       c-total-vlr = c-total-vlr + es-solic-mkt.vlr-brinde[idx] * es-solic-mkt.qtd-bri[idx].
                        
            END.
                
        END.            

    END.

    ASSIGN es-solic-mkt.vlr-total-brindes = c-total-vlr.
    UPDATE es-solic-mkt.vlr-evento =  es-solic-mkt.vlr-total-brindes + es-solic-mkt.vlr-desp-reme.

END.

OUTPUT CLOSE.
