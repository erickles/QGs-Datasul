{include/i-freeac.i}
OUTPUT TO "c:\Representantes_Sintegra.csv".

FOR EACH movto-sintegra NO-LOCK,
    EACH emitente WHERE emitente.cod-emitente = movto-sintegra.cod-emitente:
    PUT movto-sintegra.cod-emitente                 ";"
        emitente.nome-emit                          ";"
        movto-sintegra.data-consulta                ";"
        fn-free-accent(movto-sintegra.situacao) FORMAT "X(20)"    ";"
        emitente.estado                             SKIP.
END.

OUTPUT CLOSE.
