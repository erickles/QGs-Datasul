DEFINE VARIABLE cont AS INTEGER     NO-UNDO.
FOR EACH es-solic-mkt WHERE es-solic-mkt.dt-criacao <= 03/11/2012
                        AND (es-solic-mkt.it-codigo-rem[1] <> ""
                         OR es-solic-mkt.it-codigo-rem[2] <> "" 
                         OR es-solic-mkt.it-codigo-rem[3] <> "" 
                         OR es-solic-mkt.it-codigo-rem[4] <> "").
    cont = cont + 1.
    DISP nr-seq.
END.

DISP cont.
