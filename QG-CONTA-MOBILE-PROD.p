DEFINE VARIABLE i AS INTEGER     NO-UNDO LABEL "Total".

FOR EACH pm-rep-param WHERE pm-rep-param.ind_situacao <> 4 
                        AND pm-rep-param.atualiza_sw
                        NO-LOCK:

    FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.

    FIND FIRST cont-repres WHERE cont-repres.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.
    IF AVAIL cont-repres THEN DO:
        FIND FIRST repres WHERE repres.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.
        IF es-repres-comis.situacao = 3 THEN NEXT.
        
        i = i + 1.
    END.
END.
DISP i.
