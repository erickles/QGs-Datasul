FOR EACH tb-preco WHERE tb-preco.situacao = 2 NO-LOCK:
    FOR EACH es-tab-preco-repres WHERE es-tab-preco-repres.nr-tabpre = tb-preco.nr-tabpre:
        DELETE es-tab-preco-repres.
    END.
END.
