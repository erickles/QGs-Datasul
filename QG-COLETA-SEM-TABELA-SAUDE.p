DEFINE VARIABLE l-tabela AS LOGICAL     NO-UNDO.

OUTPUT TO "C:\repres_sem_saude.txt".
FOR EACH es-repres-comis NO-LOCK WHERE es-repres-comis.u-int-1 = 3:
    IF es-repres-comis.situacao = 3 THEN NEXT.
    FIND FIRST repres WHERE repres.cod-rep = es-repres-comis.cod-rep NO-LOCK NO-ERROR.
    IF AVAIL repres THEN DO:
        FIND FIRST pm-rep-param WHERE pm-rep-param.cod_rep = repres.cod-rep     
                                  AND pm-rep-param.ind_situacao <> 4
                                  NO-LOCK NO-ERROR.
        IF AVAIL pm-rep-param AND pm-rep-param.ind_situacao <> 4 THEN DO:
            
            FOR EACH es-tab-preco-repres NO-LOCK WHERE es-tab-preco-repres.cod-rep = repres.cod-rep BREAK BY es-tab-preco-repres.cod-rep:
                IF es-tab-preco-repres.nr-tabpre BEGINS "SAU" THEN
                    l-tabela = YES.
                IF LAST-OF(es-tab-preco-repres.cod-rep) THEN DO:
                    IF NOT l-tabela THEN
                        PUT repres.cod-rep SKIP.
                END.                                                
/*                 DISP pm-rep-param.cod_rep repres.nome es-tab-preco-repres.nr-tabpre.  */
            END.           
        END.            

    END.    
END.
OUTPUT CLOSE.
