{include/i-freeac.i}

OUTPUT TO c:\temp\Clientes.csv.

PUT "Codigo;"
    "Nome;"
    "Pais;"
    "CNPJ;"
    "Nome abrev;"
    "Insc.Estadual;"
    "Endereco;"
    "Cidade;"
    "Estado;"
    "CEP;"
    SKIP.

FOR EACH emitente NO-LOCK WHERE emitente.identific = 1 /*Cliente*/
                            AND NOT emitente.nome-emit MATCHES "*eliminado*":

    PUT UNFORMATTED
        emitente.cod-emit                   ";"
        fn-free-accent(emitente.nome-emit)  ";"
        fn-free-accent(emitente.pais)       ";"
        emitente.cgc                        ";"
        emitente.nome-abrev                 ";"
        emitente.ins-estadual               ";"
        emitente.endereco                   ";"
        emitente.cidade                     ";"
        emitente.estado                     ";"
        emitente.cep                        SKIP.
END.

OUTPUT CLOSE.

OUTPUT TO c:\temp\Fornecedores.csv.

PUT "Codigo;"
    "Nome;"
    "Pais;"
    "CNPJ;"
    "Nome Abrev;"
    "Insc.Estadual;"
    "Endereco;"
    "Cidade;"
    "Estado;"
    "CEP"
    SKIP.

FOR EACH emitente NO-LOCK WHERE emitente.identific = 2 /*Fornecedores*/
                            AND NOT emitente.nome-emit MATCHES "*eliminado*":
    
    PUT UNFORMATTED 
        emitente.cod-emit                   ";"
        fn-free-accent(emitente.nome-emit)  ";"
        fn-free-accent(emitente.pais)       ";"
        emitente.cgc                        ";"
        emitente.nome-abrev                 ";"
        emitente.ins-estadual               ";"
        emitente.endereco                   ";"
        emitente.cidade                     ";"
        emitente.estado                     ";"
        emitente.cep                        SKIP.
END.

OUTPUT CLOSE.


OUTPUT TO c:\temp\Clientes_e_Fornecedores.csv.

PUT "Codigo;"
    "Nome;"
    "Pais;"
    "CNPJ;"
    "Nome Abrev;"
    "Insc.Estadual;"
    "Endereco;"
    "Cidade;"
    "Estado;"
    "CEP"
    SKIP.

FOR EACH emitente NO-LOCK WHERE emitente.identific = 3 /*Fornecedores*/
                            AND NOT emitente.nome-emit MATCHES "*eliminado*":
    
    PUT UNFORMATTED 
        emitente.cod-emit                   ";"
        fn-free-accent(emitente.nome-emit)  ";"
        fn-free-accent(emitente.pais)       ";"
        emitente.cgc                        ";"
        emitente.nome-abrev                 ";"
        emitente.ins-estadual               ";"
        emitente.endereco                   ";"
        emitente.cidade                     ";"
        emitente.estado                     ";"
        emitente.cep                        SKIP.
END.

OUTPUT CLOSE.
