OUTPUT TO "c:\temp\tabelas_financeiras.csv".

PUT "TABELA FINANCEIRA;INDICE;(%)" SKIP.

FOR EACH tab-finan NO-LOCK,
    EACH tab-finan-indice WHERE tab-finan-indice.nr-tab-finan = tab-finan.nr-tab-finan NO-LOCK:

    PUT tab-finan.nr-tab-finan          ";"
        tab-finan-indice.num-seq        ";"
        tab-finan-indice.tab-ind-fin    SKIP.

END.

OUTPUT CLOSE.
