OUTPUT TO "c:\Representantes_Receita.csv".

FOR EACH movto-receita NO-LOCK,
    EACH emitente WHERE emitente.cod-emitente = movto-receita.cod-emitente:
    PUT movto-receita.cod-emitente      ";"
        emitente.nome-emit              ";"
        movto-receita.data-pesquisa     ";"
        movto-receita.situacao-s        ";"
        emitente.estado                 SKIP.
END.

OUTPUT CLOSE.
