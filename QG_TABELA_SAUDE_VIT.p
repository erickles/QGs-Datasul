
DEFINE BUFFER bf-tab-preco-repres FOR es-tab-preco-repres.

FOR EACH pm-rep-param WHERE pm-rep-param.ind_situacao <> 4 NO-LOCK:
    FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.
    IF (es-repres-comis.u-int-1 = 2 OR es-repres-comis.u-int-1 = 3) THEN DO:
        FIND FIRST es-tab-preco-repres WHERE es-tab-preco-repres.cod-rep = pm-rep-param.cod_rep
                                         AND es-tab-preco-repres.nr-tabpre = "ASPTREV"
                                         NO-ERROR.

        FIND FIRST repres WHERE repres.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.

        IF NOT AVAIL es-tab-preco-repres THEN
            CREATE es-tab-preco-repres.
        ASSIGN es-tab-preco-repres.cod-rep    = pm-rep-param.cod_rep
               es-tab-preco-repres.nr-tabpre  = "ASPTREV"
               es-tab-preco-repres.nome-abrev = repres.nome-abrev.

        FIND FIRST es-tab-preco-repres WHERE es-tab-preco-repres.cod-rep = pm-rep-param.cod_rep
                                         AND es-tab-preco-repres.nr-tabpre = "ASPTCON"
                                         NO-ERROR.

        FIND FIRST repres WHERE repres.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.

        IF NOT AVAIL es-tab-preco-repres THEN
            CREATE es-tab-preco-repres.
        ASSIGN es-tab-preco-repres.cod-rep    = pm-rep-param.cod_rep
               es-tab-preco-repres.nr-tabpre  = "ASPTCON"
               es-tab-preco-repres.nome-abrev = repres.nome-abrev.
    END.
END.
