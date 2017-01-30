DEFINE VARIABLE codrepini AS INTEGER     NO-UNDO.
DEFINE VARIABLE codrepfim AS INTEGER     NO-UNDO.


    IF codrepini = codrepfim AND ws-sessao.tipo = "USU" THEN DO:

        FIND repres WHERE 
             repres.cod-rep = codrepfim NO-LOCK NO-ERROR.

        FOR EACH es-loc-entr 
           WHERE es-loc-entr.cod-rep = codrepfim NO-LOCK:

           IF es-loc-entr.ind-situacao = NO THEN NEXT.

           FIND FIRST emitente WHERE emitente.nome-abrev = es-loc-entr.nome-abrev NO-LOCK NO-ERROR.
           IF NOT AVAIL emitente THEN NEXT.
           
           FIND es-emitente-dis WHERE
                es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

           /* Aplica Criterio de Selecao */
           RUN piValidaCliente.
           IF RETURN-VALUE = "NOK" THEN NEXT.

           FIND loc-entr OF es-loc-entr NO-LOCK NO-ERROR.
           IF NOT AVAIL loc-entr THEN NEXT.

           /* Lista Cliente */
           RUN piCriaTTEmitente.

        END. /* for each */    
        
        /* ESS - Cliente Comum */
        FOR EACH ws-p-venda WHERE ws-p-venda.no-ab-reppri = repres.nome-abrev
                              AND ws-p-venda.ind-sit-ped  = 17 /* Faturado */
                              AND ws-p-venda.dt-implant > (TODAY - 180):

            FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
            IF NOT AVAIL emitente THEN NEXT.

            FIND es-emitente-dis WHERE
                 es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

            /* Aplica Criterio de Selecao */
            RUN piValidaCliente.
            IF RETURN-VALUE = "NOK" THEN NEXT.

            FIND FIRST es-loc-entr WHERE 
                       es-loc-entr.nome-abrev  = emitente.nome-abrev    AND 
                       es-loc-entr.cod-entrega = ws-p-venda.cod-entrega AND 
                       es-loc-entr.ind-situacao NO-LOCK NO-ERROR.
            IF NOT AVAIL es-loc-entr THEN NEXT.

            FIND loc-entr OF es-loc-entr NO-LOCK NO-ERROR.
            IF NOT AVAIL loc-entr THEN NEXT.

            /* Lista Cliente */
            RUN piCriaTTEmitente.
            
        END.
        /* ESS - Cliente Comum */

    END.
    ELSE DO:

        DO i-cont = 1 TO NUM-ENTRIES(v-lista):
           
            IF INT(ENTRY(i-cont,v-lista)) < codrepini OR
               INT(ENTRY(i-cont,v-lista)) > codrepfim THEN NEXT.
            
            FIND FIRST repres 
                 WHERE repres.cod-rep = INT(ENTRY(i-cont,v-lista)) NO-LOCK NO-ERROR.
            IF NOT AVAIL repres THEN NEXT.

            /* Verifica Local de Entrega */
            FOR EACH es-loc-entr WHERE es-loc-entr.cod-rep = INTE(ENTRY(i-cont,v-lista)) NO-LOCK:
                
                IF es-loc-entr.ind-situacao = NO THEN NEXT.
    
                FIND FIRST emitente WHERE emitente.nome-abrev = es-loc-entr.nome-abrev NO-LOCK NO-ERROR.
                IF NOT AVAIL emitente THEN NEXT.
                
                FIND es-emitente-dis WHERE
                     es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

                /* Aplica Criterio de Selecao */
                RUN piValidaCliente.
                IF RETURN-VALUE = "NOK" THEN NEXT.

                /* Verifica se Cidade do cliente e atendida pelo representante */
                IF ws-sessao.tipo = "REP" THEN DO:
                   /* Verifica apenas se o repres nao e o codgio logado, se nao for entao cliente tem que estar na cidade */
                   IF repres.cod-rep <> ws-sessao.codigo THEN DO:
                      /* Se mitsuisal nao valida cidade */
                      IF AVAIL es-repres-comis AND es-repres-comis.u-int-1 = 4 /*Mitsuisal*/ THEN.
                      ELSE DO:
                          FIND tt-cidade WHERE 
                               tt-cidade.cidade = es-emitente-dis.cidade AND 
                               tt-cidade.estado = es-emitente-dis.estado NO-LOCK NO-ERROR.
                          IF NOT AVAIL tt-cidade THEN DO:
                              FIND tt-cidade WHERE 
                                   tt-cidade.cidade = es-loc-entr.cidade AND 
                                   tt-cidade.estado = es-loc-entr.estado NO-LOCK NO-ERROR.
                              IF NOT AVAIL tt-cidade THEN NEXT.
                          END.
                      END.
                   END.           
                END.

                FIND loc-entr OF es-loc-entr NO-LOCK NO-ERROR.
                IF NOT AVAIL loc-entr THEN NEXT.

                /* Lista Cliente */
                RUN piCriaTTEmitente.
                
            END. /* for each */

            /* Verifica Cliente */
            FOR EACH emitente WHERE emitente.cod-rep = INTE(ENTRY(i-cont,v-lista)) NO-LOCK:

                FIND FIRST es-loc-entr WHERE 
                           es-loc-entr.nome-abrev  = emitente.nome-abrev  AND 
                           es-loc-entr.cod-entrega = emitente.cod-entrega AND 
                           es-loc-entr.ind-situacao NO-LOCK NO-ERROR.
                IF NOT AVAIL es-loc-entr THEN NEXT.

                FIND es-emitente-dis WHERE
                     es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

                /* Aplica Criterio de Selecao */
                RUN piValidaCliente.
                IF RETURN-VALUE = "NOK" THEN NEXT.

                /* Verifica se Cidade do cliente e atendida pelo representante */
                IF ws-sessao.tipo = "REP" THEN DO:
                   /* Verifica apenas se o repres nao e o codgio logado, se nao for entao cliente tem que estar na cidade */
                   IF repres.cod-rep <> ws-sessao.codigo THEN DO:
                      /* Se mitsuisal nao valida cidade */
                      IF AVAIL es-repres-comis AND es-repres-comis.u-int-1 = 4 /*Mitsuisal*/ THEN.
                      ELSE DO:
                          FIND tt-cidade WHERE 
                               tt-cidade.cidade = es-emitente-dis.cidade AND 
                               tt-cidade.estado = es-emitente-dis.estado NO-LOCK NO-ERROR.
                          IF NOT AVAIL tt-cidade THEN DO:
                              FIND tt-cidade WHERE 
                                   tt-cidade.cidade = es-loc-entr.cidade AND 
                                   tt-cidade.estado = es-loc-entr.estado NO-LOCK NO-ERROR.
                              IF NOT AVAIL tt-cidade THEN NEXT.
                          END.
                      END.
                   END.           
                END.

                FIND loc-entr OF es-loc-entr NO-LOCK NO-ERROR.
                IF NOT AVAIL loc-entr THEN NEXT.

                /* Lista Cliente */
                RUN piCriaTTEmitente.
                
            END. /* for each */
            
            /* ESS - Cliente Comum */
            FOR EACH ws-p-venda WHERE ws-p-venda.no-ab-reppri = repres.nome-abrev
                                  AND ws-p-venda.ind-sit-ped  = 17 /* Faturado */
                                  AND ws-p-venda.dt-implant > (TODAY - 180):

                FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
                IF NOT AVAIL emitente THEN NEXT.

                FIND es-emitente-dis WHERE
                     es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

                /* Aplica Criterio de Selecao */
                RUN piValidaCliente.
                IF RETURN-VALUE = "NOK" THEN NEXT.

                FIND FIRST es-loc-entr WHERE 
                           es-loc-entr.nome-abrev  = emitente.nome-abrev    AND 
                           es-loc-entr.cod-entrega = ws-p-venda.cod-entrega AND 
                           es-loc-entr.ind-situacao NO-LOCK NO-ERROR.
                IF NOT AVAIL es-loc-entr THEN NEXT.

                FIND loc-entr OF es-loc-entr NO-LOCK NO-ERROR.
                IF NOT AVAIL loc-entr THEN NEXT.

                /* Lista Cliente */
                RUN piCriaTTEmitente.
                
            END.
            /* ESS - Cliente Comum */

        END.

    END.
