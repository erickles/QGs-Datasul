DEFINE VARIABLE i AS INTEGER     NO-UNDO.

OUTPUT TO "C:\restantes.csv".

PUT "Cod.Rep"       ";"
    "Nome Rep"      ";"
    "Regiao"        ";"
    "Atuacao"       ";"
    "Telefone 1"    ";"
    "Telefone 2"    SKIP.

FOR EACH pm-rep-param WHERE pm-rep-param.ind_situacao <> 4 
                        AND NOT pm-rep-param.atualiza_sw
                        NO-LOCK:

    FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.

    FIND FIRST cont-repres WHERE cont-repres.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.
    IF AVAIL cont-repres THEN DO:
        FIND FIRST repres WHERE repres.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.
        IF es-repres-comis.situacao = 3 THEN NEXT.
        PUT cont-repres.cod-rep         ";"
            repres.nome                 ";"
            repres.nome-ab-reg          ";"
            es-repres-comis.u-char-2    ";"
            repres.telefone[1]          ";"
            repres.telefone[2]          SKIP.
        i = i + 1.
    END.
END.
DISP i.
OUTPUT CLOSE.
