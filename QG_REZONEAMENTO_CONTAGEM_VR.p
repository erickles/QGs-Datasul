OUTPUT TO "C:\Temp\rezoneamentos.csv".

FOR EACH es-loc-mr WHERE es-loc-mr.dt-atualiza >= 01/01/2015
                     AND es-loc-mr.dt-atualiza <= 12/31/2015
                     AND (es-loc-mr.evento BEGINS "ALTERA" OR es-loc-mr.evento BEGINS "INCLUS")
                     NO-LOCK:
    PUT TRIM(es-loc-mr.evento)      ";"
        es-loc-mr.cod-localiz       ";"
        es-loc-mr.cod-localiz-nova  SKIP.
END.

OUTPUT CLOSE.
