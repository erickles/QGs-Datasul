OUTPUT TO "c:\repres.csv".

PUT "Cod-Rep"   ";"
    "Nome"      ";"
    "Regiao"    ";"
    "Telefone1" ";"
    "Telefone2" ";"
    SKIP.

FOR EACH repres WHERE repres.nome-ab-reg BEGINS "Palmas" NO-LOCK:
    FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = repres.cod-rep NO-LOCK NO-ERROR.
    IF es-repres-comis.situacao = 3 THEN NEXT.
    FIND FIRST cont-repres WHERE cont-repres.cod-rep = repres.cod-rep NO-LOCK NO-ERROR.
    IF AVAIL cont-repres THEN DO:   
        FIND FIRST pm-rep-param WHERE pm-rep-param.cod_rep = repres.cod-rep NO-LOCK NO-ERROR.
        IF AVAIL pm-rep-param THEN
            PUT repres.cod-rep      ";"
                cont-repres.nome    ";"
                repres.nome-ab-reg  ";"
                repres.telefone[1]  ";"
                repres.telefone[2]  ";"
                SKIP.
    END.
END.
OUTPUT CLOSE.
