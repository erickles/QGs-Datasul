OUTPUT TO "c:\Tabelas.csv".

PUT "Estado Destino"    ";"
    "Cidade"            ";"
    "Tipo Frete"        ";"
    "Tabela de Preco"   SKIP.

FOR EACH es-busca-preco WHERE es-busca-preco.uf-destino = "RR" 
                          AND es-busca-preco.cidade    <> ?
                          AND es-busca-preco.ge-codigo = 44:
    
    IF es-busca-preco.nr-tabpre BEGINS "FOS" THEN NEXT.

    ASSIGN es-busca-preco.ind-tp-frete = 1.

    PUT es-busca-preco.uf-destino   ";"
        es-busca-preco.cidade       ";"
        es-busca-preco.ind-tp-frete ";"
        es-busca-preco.nr-tabpre SKIP.

END.
OUTPUT CLOSE.
