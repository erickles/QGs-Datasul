OUTPUT TO "c:\regioesEventos.csv".
PUT "Gerencia evento;Descricao;Ano Refer" SKIP.
FOR EACH es-ev-unid-vendas NO-LOCK:
    PUT es-ev-unid-vendas.unidade-vendas    ";"
        es-ev-unid-vendas.descricao         ";"
        es-ev-unid-vendas.ano-referencia    
        SKIP.
END.
OUTPUT CLOSE.
