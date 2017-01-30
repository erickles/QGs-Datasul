OUTPUT TO "c:\es-loc-entr-rep_353.csv".

PUT "cod entrega;cod rep;cod rep 2;nome abrev" SKIP.

FOR EACH es-loc-entr-rep WHERE es-loc-entr-rep.cod-rep = 353 NO-LOCK:

    FIND FIRST es-loc-entr WHERE es-loc-entr.nome-abrev  = es-loc-entr-rep.nome-abrev
                             AND es-loc-entr.cod-entrega = es-loc-entr-rep.cod-entrega
                             NO-LOCK NO-ERROR.

    IF AVAIL es-loc-entr THEN DO:

        FIND FIRST emitente WHERE emitente.nome-abrev = es-loc-entr-rep.nome-abrev NO-LOCK NO-ERROR.
        IF es-loc-entr.cod-rep     = es-loc-entr-rep.cod-rep THEN
            PUT es-loc-entr-rep.cod-entrega ";"
                es-loc-entr-rep.cod-rep     ";"
                es-loc-entr.cod-rep         ";"
                es-loc-entr-rep.nome-abrev  SKIP.
    END.        

END.

OUTPUT CLOSE.
