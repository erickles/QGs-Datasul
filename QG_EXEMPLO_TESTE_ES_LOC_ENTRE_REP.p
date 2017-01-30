DEFINE BUFFER bf-rep-micro          FOR rep-micro.
DEFINE BUFFER bf-es-repres-comis    FOR es-repres-comis.

OUTPUT TO "c:\exemplo_repres.csv".

FOR EACH bf-es-repres-comis WHERE bf-es-repres-comis.situacao = 3,
    EACH bf-rep-micro WHERE bf-rep-micro.nome-ab-rep = STRING(bf-es-repres-comis.cod-rep):

    FIND FIRST es-loc-entr-rep WHERE es-loc-entr-rep.cod-rep = bf-es-repres-comis.cod-rep NO-LOCK NO-ERROR.
    IF AVAIL es-loc-entr-rep THEN DO:

        FOR EACH es-repres-comis WHERE es-repres-comis.situacao = 1
                                   AND es-repres-comis.log-1,
            EACH rep-micro WHERE rep-micro.nome-ab-reg = bf-rep-micro.nome-ab-reg
                             AND rep-micro.nome-ab-rep = STRING(es-repres-comis.cod-rep)
                             AND rep-micro.nome-mic-reg = bf-rep-micro.nome-mic-reg:
    
            PUT bf-es-repres-comis.cod-rep "  " es-repres-comis.cod-rep SKIP.
    
        END.

    END.

END.

OUTPUT CLOSE.
