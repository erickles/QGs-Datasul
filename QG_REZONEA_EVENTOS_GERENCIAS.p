{include/i-freeac.i}

DEFINE BUFFER bf-ev-permissao           FOR es-ev-permissao.
DEFINE BUFFER bf-ev-unid-tp-ev-hist     FOR es-ev-unid-tp-ev-hist.
DEFINE BUFFER bf-ev-unid-tp-ev          FOR es-ev-unid-tp-ev.
DEFINE BUFFER bf-ev-unid-vendas         FOR es-ev-unid-vendas.
DEFINE BUFFER bf-ev-unid-vendas-hist    FOR es-ev-unid-vendas-hist.
DEFINE BUFFER bf-ev-regiao-unid         FOR es-ev-regiao-unid.
DEFINE BUFFER bf-ft-gerencias           FOR es-ft-gerencias.

DEFINE VARIABLE cGerencia       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cUnidadeVendas  AS CHARACTER   NO-UNDO.

UPDATE cUnidadeVendas   LABEL "Unidade de Venda"    FORMAT "X(60)"
       cGerencia        LABEL "Gerencia"            FORMAT "X(60)".

ASSIGN cUnidadeVendas = fn-free-accent(cUnidadeVendas)
       cGerencia      = fn-free-accent(cGerencia).

IF cUnidadeVendas <> "" AND cUnidadeVendas <> "" THEN DO:
    
    FOR EACH es-ev-permissao WHERE TRIM(es-ev-permissao.unidade-vendas) = cUnidadeVendas.
        ASSIGN es-ev-permissao.unidade-vendas = cGerencia.
    END.
    
    FOR EACH es-ev-unid-tp-ev-hist WHERE TRIM(es-ev-unid-tp-ev-hist.unidade-vendas) = cUnidadeVendas.
        ASSIGN es-ev-unid-tp-ev-hist.unidade-vendas = cGerencia.
    END.

    FOR EACH es-ev-unid-tp-ev WHERE TRIM(es-ev-unid-tp-ev.unidade-vendas) = cUnidadeVendas.
        ASSIGN es-ev-unid-tp-ev.unidade-vendas = cGerencia.
    END.
    
    FOR EACH es-ev-unid-vendas WHERE TRIM(es-ev-unid-vendas.unidade-vendas) = cUnidadeVendas.
        ASSIGN es-ev-unid-vendas.unidade-vendas = cGerencia.
    END.
    
    FOR EACH es-ev-unid-vendas-hist WHERE TRIM(es-ev-unid-vendas-hist.unidade-vendas) = cUnidadeVendas.
        ASSIGN es-ev-unid-vendas-hist.unidade-vendas = cGerencia.
    END.
    
    /*
    FOR EACH es-ev-permissao WHERE TRIM(es-ev-permissao.unidade-vendas) = TRIM(cUnidadeVendas).
        FIND FIRST bf-ev-permissao WHERE bf-ev-permissao.cod-usuario    = es-ev-permissao.cod-usuario
                                     AND bf-ev-permissao.unidade-vendas = cGerencia
                                     NO-LOCK NO-ERROR.

        IF NOT AVAIL bf-ev-permissao THEN
            ASSIGN es-ev-permissao.unidade-vendas = cGerencia.
    END.
    
    FOR EACH es-ev-unid-tp-ev-hist WHERE TRIM(es-ev-unid-tp-ev-hist.unidade-vendas) = TRIM(cUnidadeVendas).
        FIND FIRST bf-ev-unid-tp-ev-hist WHERE bf-ev-unid-tp-ev-hist.unidade-vendas = cGerencia
                                           AND bf-ev-unid-tp-ev-hist.tipo-verba     = es-ev-unid-tp-ev-hist.tipo-verba
                                           AND bf-ev-unid-tp-ev-hist.ano-referencia = es-ev-unid-tp-ev-hist.ano-referencia
                                           AND bf-ev-unid-tp-ev-hist.tipo-evento    = es-ev-unid-tp-ev-hist.tipo-evento
                                           AND bf-ev-unid-tp-ev-hist.dat-alter      = es-ev-unid-tp-ev-hist.dat-alter
                                           AND bf-ev-unid-tp-ev-hist.hr-alteracao   = es-ev-unid-tp-ev-hist.hr-alteracao
                                           NO-LOCK NO-ERROR.

        IF NOT AVAIL bf-ev-unid-tp-ev-hist THEN
            ASSIGN es-ev-unid-tp-ev-hist.unidade-vendas = cGerencia.
    END.

    FOR EACH es-ev-unid-tp-ev WHERE TRIM(es-ev-unid-tp-ev.unidade-vendas) = TRIM(cUnidadeVendas).
        FIND FIRST bf-ev-unid-tp-ev WHERE bf-ev-unid-tp-ev.unidade-vendas   = cGerencia
                                      AND bf-ev-unid-tp-ev.tipo-verba       = es-ev-unid-tp-ev.tipo-verba    
                                      AND bf-ev-unid-tp-ev.ano-referencia   = es-ev-unid-tp-ev.ano-referencia
                                      AND bf-ev-unid-tp-ev.tipo-evento      = es-ev-unid-tp-ev.tipo-evento
                                      NO-ERROR.
        IF NOT AVAIL bf-ev-unid-tp-ev THEN
            ASSIGN es-ev-unid-tp-ev.unidade-vendas = cGerencia.
        ELSE DO:
            bf-ev-unid-tp-ev.valor-verba = bf-ev-unid-tp-ev.valor-verba + es-ev-unid-tp-ev.valor-verba.
            DELETE es-ev-unid-tp-ev.
        END.
    END.
    
    FOR EACH es-ev-unid-vendas WHERE TRIM(es-ev-unid-vendas.unidade-vendas) = TRIM(cUnidadeVendas).
        FIND FIRST bf-ev-unid-vendas WHERE bf-ev-unid-vendas.unidade-vendas = cGerencia
                                       AND bf-ev-unid-vendas.tipo-verba     = es-ev-unid-vendas.tipo-verba    
                                       AND bf-ev-unid-vendas.ano-referencia = es-ev-unid-vendas.ano-referencia
                                       NO-ERROR.
        IF NOT AVAIL bf-ev-unid-vendas THEN
            ASSIGN es-ev-unid-vendas.unidade-vendas = cGerencia.
        ELSE DO:
            ASSIGN bf-ev-unid-vendas.valor-verba = bf-ev-unid-vendas.valor-verba + es-ev-unid-vendas.valor-verba.
            DELETE es-ev-unid-vendas.
        END.
    END.
    
    FOR EACH es-ev-unid-vendas-hist WHERE TRIM(es-ev-unid-vendas-hist.unidade-vendas) = TRIM(cUnidadeVendas).
        FIND FIRST bf-ev-unid-vendas-hist WHERE bf-ev-unid-vendas-hist.unidade-vendas = cGerencia
                                            AND bf-ev-unid-vendas-hist.tipo-verba     = es-ev-unid-vendas-hist.tipo-verba
                                            AND bf-ev-unid-vendas-hist.ano-referencia = es-ev-unid-vendas-hist.ano-referencia
                                            AND bf-ev-unid-vendas-hist.dat-alter      = es-ev-unid-vendas-hist.dat-alter
                                            AND bf-ev-unid-vendas-hist.hr-alteracao   = es-ev-unid-vendas-hist.hr-alteracao
                                            NO-LOCK NO-ERROR.
        IF NOT AVAIL bf-ev-unid-vendas-hist THEN
            ASSIGN es-ev-unid-vendas-hist.unidade-vendas = cGerencia.
    END.
    */
    /*
    FOR EACH es-eventos WHERE es-eventos.unidade-venda = cUnidadeVendas:
        ASSIGN es-eventos.unidade-venda = cGerencia.
    END.

    FOR EACH es-ev-regiao-unid WHERE es-ev-regiao-unid.unidade-venda = cUnidadeVendas:
        ASSIGN es-ev-regiao-unid.unidade-venda = cGerencia.
    END.
    
    FOR EACH es-ft-gerencias WHERE es-ft-gerencias.unidade-venda = cUnidadeVendas:
        ASSIGN es-ft-gerencias.unidade-venda = cGerencia.
    END.
    */
END.
