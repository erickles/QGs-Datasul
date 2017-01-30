{include/i-buffer.i}
{include/i-freeac.i}

DEFINE VARIABLE cGerencia AS CHARACTER   NO-UNDO FORMAT "X(40)".

OUTPUT TO "C:\unidades-vendas.csv".

PUT "REGIAO"                ";"
    "SUPERVISOR"            ";"
    "UNIDADE VENDA"         ";"
    "GERENCIA ENCONTRADA"   SKIP.

FOR EACH es-ev-regiao-unid NO-LOCK:

    FIND FIRST regiao WHERE regiao.nome-ab-reg = es-ev-regiao-unid.nome-ab-reg NO-LOCK NO-ERROR.

    IF AVAIL regiao THEN
        ASSIGN cGerencia = regiao.nome-regiao.
    ELSE
        ASSIGN cGerencia = "".

    PUT fn-free-accent(es-ev-regiao-unid.nome-ab-reg)       FORMAT "X(30)"  ";"
        fn-free-accent(es-ev-regiao-unid.supervisor)        FORMAT "X(30)"  ";"
        fn-free-accent(es-ev-regiao-unid.unidade-vendas)    FORMAT "X(30)"  ";"  
        cGerencia                                                           SKIP.
END.

OUTPUT CLOSE.
