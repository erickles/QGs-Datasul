FOR EACH es-tab-preco-repres:
    FIND FIRST tb-preco WHERE tb-preco.nr-tabpre = es-tab-preco-repres.nr-tabpre NO-LOCK NO-ERROR.
    IF AVAIL tb-preco AND tb-preco.situacao = 2 THEN DO:
        DISP es-tab-preco-repres.cod-rep
             es-tab-preco-repres.nr-tabpre.
    END.    
END.
