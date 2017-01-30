OUTPUT TO "c:\rezonea.csv".

PUT "Cod. Evento"   ";"
    "Regiao"        ";"
    "Nome Regiao"   SKIP.

FOR EACH es-eventos NO-LOCK,
    EACH regiao WHERE regiao.nome-ab-reg = es-eventos.nome-ab-reg:
    PUT es-eventos.cod-evento   ";"
        regiao.nome-ab-reg      ";"
        regiao.nome-regiao      SKIP.
END.
OUTPUT CLOSE.
