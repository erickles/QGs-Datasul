{include/i-freeac.i}

OUTPUT TO "C:\Temp\Clientes_enderecos_portador.csv".

PUT UNFORM  "CODIGO;"
            "NOME;"
            "ENDERECO ENTREGA;"
            "BAIRRO ENTREGA;"
            "CEP ENTREGA;"
            "CIDADE ENTREGA;"
            "ESTADO ENTREGA;"
            "ENDERECO COBR;"
            "BAIRRO COBR;"
            "CEP COBR;"
            "CIDADE COBR;"
            "ESTADO COBR;"
            "PORTADOR PREF"  SKIP.

FOR EACH emitente NO-LOCK WHERE emitente.identific = 1 OR emitente.identific = 3:

    PUT UNFORM  emitente.cod-emitente   ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.nome-emit,";",""),CHR(10),""),CHR(13),"")))      ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.endereco,";",""),CHR(10),""),CHR(13),"")))       ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.bairro,";",""),CHR(10),""),CHR(13),"")))         ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.cep,";",""),CHR(10),""),CHR(13),"")))            ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.cidade,";",""),CHR(10),""),CHR(13),"")))         ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.estado,";",""),CHR(10),""),CHR(13),"")))         ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.endereco-cob,";",""),CHR(10),""),CHR(13),"")))   ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.bairro-cob,";",""),CHR(10),""),CHR(13),"")))     ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.cep-cob,";",""),CHR(10),""),CHR(13),"")))        ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.cidade-cob,";",""),CHR(10),""),CHR(13),"")))     ";"
                TRIM(fn-free-accent(REPLACE(REPLACE(REPLACE(emitente.estado-cob,";",""),CHR(10),""),CHR(13),"")))     ";"
                emitente.port-prefer    SKIP.

END.

OUTPUT CLOSE.
