OUTPUT TO "c:\nao_encontrados.csv".

PUT "UNIDADE;REGIAO;MICRO;COD. EVENTO" SKIP.
/*
FOR EACH es-eventos WHERE NOT es-eventos.unidade-venda BEGINS "Gerencia" 
                      AND es-eventos.unidade-venda <> ""
                      AND es-eventos.unidade-venda <> "MARKETING"
                      AND es-eventos.unidade-venda <> "ME02 - AM LATINA"
                      AND es-eventos.unidade-venda <> "Coordenacao Regional - CENTRO OESTE"
                      NO-LOCK:

    PUT es-eventos.unidade-venda    ";"
        es-eventos.nome-ab-reg      ";"
        es-eventos.nome-mic-reg     ";"
        es-eventos.cod-evento       SKIP.
END.
*/

FOR EACH es-eventos WHERE es-eventos.unidade-venda <> "" NO-LOCK:

    FIND FIRST es-ev-unid-vendas WHERE TRIM(es-ev-unid-vendas.unidade-venda) = TRIM(es-eventos.unidade-venda) NO-LOCK NO-ERROR.
    IF NOT AVAIL es-ev-unid-vendas THEN
        PUT es-eventos.unidade-venda    ";"
            es-eventos.nome-ab-reg      ";"
            es-eventos.nome-mic-reg     ";"
            es-eventos.cod-evento       SKIP.
END.

OUTPUT CLOSE.
