OUTPUT TO "c:\temp\condicoes.csv".

PUT "COD COND;DESCRICAO COND;TAB FINAN;INDICE;(%)" SKIP.

FOR EACH cond-pagto NO-LOCK WHERE cond-pagto.cod-cond-pag > 499
                              AND cond-pagto.cod-cond-pag < 1000,
                            FIRST es-cond-pagto OF cond-pagto NO-LOCK
                            WHERE es-cond-pagto.log-1 = TRUE /* Liberada para Web*/ :

    FIND FIRST tab-finan OF cond-pagto NO-LOCK NO-ERROR.
    IF AVAIL tab-finan THEN
        FIND FIRST tab-finan-indice WHERE tab-finan-indice.nr-tab-finan = tab-finan.nr-tab-finan
                                      AND tab-finan-indice.num-seq      = cond-pagto.nr-ind-finan
                                      NO-LOCK NO-ERROR.

    PUT cond-pagto.cod-cond-pag                                             ";"
        cond-pagto.descricao                                                ";"
        IF AVAIL tab-finan THEN tab-finan.nr-tab-finan ELSE 0               ";"
        cond-pagto.nr-ind-finan                                             ";"
        IF AVAIL tab-finan-indice THEN tab-finan-indice.tab-ind-fin  ELSE 0 SKIP.
             

END.

OUTPUT CLOSE.
