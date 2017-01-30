{include/i-freeac.i}

DEFINE BUFFER bf-ev-permissao           FOR es-ev-permissao.
DEFINE BUFFER bf-ev-unid-tp-ev-hist     FOR es-ev-unid-tp-ev-hist.
DEFINE BUFFER bf-ev-unid-tp-ev          FOR es-ev-unid-tp-ev.
DEFINE BUFFER bf-ev-unid-vendas         FOR es-ev-unid-vendas.
DEFINE BUFFER bf-ev-unid-vendas-hist    FOR es-ev-unid-vendas-hist.
DEFINE BUFFER bf-ev-regiao-unid         FOR es-ev-regiao-unid.
DEFINE BUFFER bf-ft-gerencias           FOR es-ft-gerencias.

DEFINE VARIABLE cRegiaoAntiga   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRegiaoNova     AS CHARACTER   NO-UNDO.

UPDATE cRegiaoAntiga   LABEL "Regiao antiga"    FORMAT "X(60)"
       cRegiaoNova     LABEL "Regiao nova"      FORMAT "X(60)".

ASSIGN cRegiaoAntiga = fn-free-accent(cRegiaoAntiga)
       cRegiaoNova   = fn-free-accent(cRegiaoNova).

IF cRegiaoAntiga <> "" AND cRegiaoNova <> "" THEN DO:

    FOR EACH es-eventos WHERE es-evento.nome-ab-reg = cRegiaoAntiga:
        ASSIGN es-evento.nome-ab-reg = cRegiaoNova.
    END.

    /*
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
    */
    
END.
