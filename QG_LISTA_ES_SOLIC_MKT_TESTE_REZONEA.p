OUTPUT TO "c:\rezonea_teste_solic_mkt.csv".
PUT "Nr. Solic;Regiao" SKIP.
FOR EACH es-solic-mkt WHERE es-solic-mkt.nr-seq      = "BA 01"
                         OR es-solic-mkt.nome-ab-reg = "BA 02" NO-LOCK:

    PUT es-solic-mkt.nr-seq         ";"
        es-solic-mkt.nome-ab-reg    SKIP.

END.
OUTPUT CLOSE.
