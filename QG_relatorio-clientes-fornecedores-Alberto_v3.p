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
    "CEP;"
    "Telefone 1;"
    "Telefone 2;"
    "Email;"
    "Inativo;"
    "Grupo Fornec;"
    "Banco;"
    "Agencia;"
    "Conta;"
    "Tipo pagamento"
    SKIP.

FOR EACH emitente NO-LOCK WHERE emitente.identific = 2 /*Fornecedores*/
                            AND NOT emitente.nome-emit MATCHES "*eliminado*",                            
                            EACH es-emit-fornec WHERE es-emit-fornec.cod-emitente = emitente.cod-emitente NO-LOCK:
    
    FIND FIRST grupo-fornec WHERE grupo-fornec.cod-gr-forn  = emitente.cod-gr-forn NO-LOCK NO-ERROR.
    FIND FIRST mgcad.banco WHERE mgcad.banco.cod-banco = emitente.cod-banco NO-LOCK NO-ERROR.

    PUT UNFORMATTED 
        emitente.cod-emit                                                                                   ";"
        fn-free-accent(emitente.nome-emit)                                                                  ";"
        fn-free-accent(emitente.pais)                                                                       ";"
        emitente.cgc                                                                                        ";"
        emitente.nome-abrev                                                                                 ";"
        emitente.ins-estadual                                                                               ";"
        emitente.endereco                                                                                   ";"
        emitente.cidade                                                                                     ";"
        emitente.estado                                                                                     ";"
        emitente.cep                                                                                        ";"
        emitente.telefone[1]                                                                                ";"
        emitente.telefone[2]                                                                                ";"
        emitente.e-mail                                                                                     ";"
        es-emit-fornec.log-2                                                                                ";"
        IF AVAIL grupo-fornec THEN grupo-fornec.descricao ELSE ""                                           ";"
        STRING(emitente.cod-banco) + " - " + IF AVAIL banco THEN banco.nome-banco ELSE ""                   ";"
        emitente.agencia                                                                                    ";"
        emitente.conta-corren                                                                               ";"
        IF emitente.tp-pagto = 8 THEN "Agendamento eletronico" ELSE {adinc/i22ad098.i 04 emitente.tp-pagto}                                             SKIP.
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
