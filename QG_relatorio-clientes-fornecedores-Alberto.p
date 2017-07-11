{include/i-freeac.i}

OUTPUT TO c:\temp\Clientes.csv.

PUT "Codigo;"
    "Nome;"
    "Pais;"
    "Endereco;"
    "Bairro;"
    "Cep;"
    "Cidade;"
    "Estado;"
    "Grupo de cliente;"
    "Conta contabil;"
    "CNPJ;"
    "Nome abrev"
    SKIP.

FOR EACH emitente NO-LOCK WHERE emitente.identific = 1 /*Cliente*/
                            AND NOT emitente.nome-emit MATCHES "*eliminado*":

    FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
    IF AVAIL gr-cli THEN DO:

        FIND FIRST cta_grp_clien WHERE cta_grp_clien.cod_grp_clien    = STRING(emitente.cod-gr-cli) 
                                   AND cta_grp_clien.cod_espec_docto  = "DP"
                                   AND cta_grp_clien.cod_finalid_econ = "Corrente"
                                   AND cta_grp_clien.ind_finalid_ctbl = "Saldo"
                                   NO-LOCK NO-ERROR.
    END.

    PUT UNFORMATTED
        emitente.cod-emit                                               ";"
        fn-free-accent(emitente.nome-emit)                              ";"
        fn-free-accent(emitente.pais)                                   ";"
        fn-free-accent(emitente.endereco)                               ";"
        fn-free-accent(emitente.bairro)                                 ";"
        fn-free-accent(emitente.cep)                                    ";"
        fn-free-accent(emitente.cidade)                                 ";"
        fn-free-accent(emitente.estado)                                 ";"
        IF AVAIL gr-cli THEN fn-free-accent(gr-cli.descricao) ELSE ""   ";"
        IF AVAIL cta_grp_clien THEN cta_grp_clien.cod_cta_ctbl ELSE ""  ";"
        emitente.cgc                                                    ";"
        emitente.nome-abrev                                             SKIP.
END.

OUTPUT CLOSE.

OUTPUT TO c:\temp\Fornecedores.csv.

PUT "Codigo;"
    "Nome;"
    "Pais;"
    "Endereco;"
    "Bairro;"
    "Cep;"
    "Cidade;"
    "Estado;"
    "Grupo fornec;"
    "Conta contabil;"
    "CNPJ;"
    "Nome Abrev"
    SKIP.

FOR EACH emitente NO-LOCK WHERE emitente.identific = 2 /*Fornecedores*/
                            AND NOT emitente.nome-emit MATCHES "*eliminado*":

    FIND FIRST grupo-fornec WHERE grupo-fornec.cod-gr-forn = emitente.cod-gr-forn NO-LOCK NO-ERROR.
    FIND FIRST cta_grp_forn WHERE cta_grp_forn.cod_grp_forn = STRING(grupo-fornec.cod-gr-forn) NO-LOCK NO-ERROR.

    PUT UNFORMATTED 
        emitente.cod-emit                                                           ";"
        fn-free-accent(emitente.nome-emit)                                          ";"
        fn-free-accent(emitente.pais)                                               ";"
        fn-free-accent(emitente.endereco)                                           ";"
        fn-free-accent(emitente.bairro)                                             ";"
        fn-free-accent(emitente.cep)                                                ";"
        fn-free-accent(emitente.cidade)                                             ";"
        fn-free-accent(emitente.estado)                                             ";"
        IF AVAIL grupo-fornec THEN fn-free-accent(grupo-fornec.descricao) ELSE ""   ";"
        IF AVAIL cta_grp_forn THEN cta_grp_forn.cod_cta_ctbl ELSE ""                ";"
        emitente.cgc                                                                ";"
        emitente.nome-abrev                                                         SKIP.
    
END.

OUTPUT CLOSE.


OUTPUT TO c:\temp\Clientes_e_Fornecedores.csv.

PUT "Codigo;"
    "Nome;"
    "Pais;"
    "Endereco;"
    "Bairro;"
    "Cep;"
    "Cidade;"
    "Estado;"
    "Grupo de cliente;"
    "Conta contabil;"
    "CNPJ;"
    "Nome abrev"
    SKIP.

FOR EACH emitente NO-LOCK WHERE emitente.identific = 3 /*Fornecedores*/
                            AND NOT emitente.nome-emit MATCHES "*eliminado*":

    FIND FIRST gr-cli WHERE gr-cli.cod-gr-cli = emitente.cod-gr-cli NO-LOCK NO-ERROR.
    IF AVAIL gr-cli THEN DO:

        FIND FIRST cta_grp_clien WHERE cta_grp_clien.cod_grp_clien    = STRING(emitente.cod-gr-cli) 
                                   AND cta_grp_clien.cod_espec_docto  = "DP"
                                   AND cta_grp_clien.cod_finalid_econ = "Corrente"
                                   AND cta_grp_clien.ind_finalid_ctbl = "Saldo"
                                   NO-LOCK NO-ERROR.
    END.
    
    PUT UNFORMATTED 
        emitente.cod-emit                                               ";"
        fn-free-accent(emitente.nome-emit)                              ";"
        fn-free-accent(emitente.pais)                                   ";"
        fn-free-accent(emitente.endereco)                               ";"
        fn-free-accent(emitente.bairro)                                 ";"
        fn-free-accent(emitente.cep)                                    ";"
        fn-free-accent(emitente.cidade)                                 ";"
        fn-free-accent(emitente.estado)                                 ";"
        IF AVAIL gr-cli THEN fn-free-accent(gr-cli.descricao) ELSE ""   ";"
        IF AVAIL cta_grp_clien THEN cta_grp_clien.cod_cta_ctbl ELSE ""  ";"
        emitente.cgc                                                    ";"
        emitente.nome-abrev                                             SKIP.
END.

OUTPUT CLOSE.
