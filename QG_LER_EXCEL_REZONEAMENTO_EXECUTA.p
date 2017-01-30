{include/i-freeac.i}

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD regiao-antiga     AS CHAR FORMAT "X(50)"
    FIELD regiao-nova       AS CHAR FORMAT "X(50)"
    FIELD micro-antiga      AS CHAR FORMAT "X(50)"
    FIELD micro-nova        AS CHAR FORMAT "X(50)"
    FIELD gerencia-antiga   AS CHAR FORMAT "X(50)"
    FIELD gerencia-nova     AS CHAR FORMAT "X(50)".

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\lista_rezoneamento.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.regiao-antiga
    tt-planilha.regiao-nova
    tt-planilha.micro-antiga
    tt-planilha.micro-nova
    tt-planilha.gerencia-antiga
    tt-planilha.gerencia-nova.
END.

INPUT CLOSE.

FOR EACH tt-planilha:
    RUN pi-Micro(INPUT tt-planilha.micro-antiga,
                         INPUT tt-planilha.micro-nova).
END.

PROCEDURE pi-Micro:

    DEFINE INPUT PARAMETER cMicroAntiga   AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cMicroNova     AS CHARACTER   NO-UNDO.

    IF cMicroAntiga <> "" AND cMicroNova <> "" THEN DO:

        FOR EACH es-eventos WHERE TRIM(es-eventos.nome-mic-reg) = cMicroAntiga.
            

            FIND FIRST micro-reg WHERE micro-reg.nome-mic-reg = es-eventos.nome-mic-reg NO-LOCK NO-ERROR.
            IF AVAIL micro-reg THEN DO:
                
                RUN pi-Regiao(INPUT es-eventos.cod-evento,
                              INPUT tt-planilha.regiao-antiga,
                              INPUT tt-planilha.regiao-nova).

            END.

            ASSIGN es-eventos.nome-mic-reg = cMicroNova.

        END.

    END.

END.

PROCEDURE pi-Regiao:
    
    DEFINE INPUT PARAMETER iCodigoEvento    AS INTE NO-UNDO.
    DEFINE INPUT PARAMETER cRegiaoAntiga    AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cRegiaoNova      AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cGerenciaNova    AS CHARACTER   NO-UNDO.

    IF cRegiaoNova <> "" THEN DO:

        FOR EACH es-eventos WHERE es-eventos.nome-ab-reg = cRegiaoAntiga:
            ASSIGN es-eventos.nome-ab-reg = cRegiaoNova.
        END.

        FOR EACH es-ev-regiao-unid WHERE  TRIM(es-ev-regiao-unid.nome-ab-reg) = cRegiaoAntiga.
            ASSIGN es-ev-regiao-unid.nome-ab-reg = cRegiaoNova.
        END.
        
        FOR EACH es-ft-gerencias WHERE TRIM(es-ft-gerencias.nome-ab-reg) = cRegiaoAntiga.
            ASSIGN es-ft-gerencias.nome-ab-reg = cRegiaoNova.
        END.

        RUN pi-Gerencia(INPUT cRegiaoNova,
                        INPUT cGerenciaNova).

    END.

END.

PROCEDURE pi-Gerencia:

    DEFINE INPUT PARAMETER cRegiaoNova  AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cGerencia    AS CHARACTER   NO-UNDO.
    
    ASSIGN cGerencia = fn-free-accent(cGerencia).

    FOR EACH es-eventos WHERE es-eventos.nome-ab-reg = cRegiaoNova:
        ASSIGN es-eventos.unidade-vendas = cGerencia.
    END.

    FOR EACH es-ft-gerencias WHERE TRIM(es-ft-gerencias.nome-ab-reg) = cRegiaoNova:
        ASSIGN es-ft-gerencias.unidade-vendas = cGerencia.
    END.

    /*
    FOR EACH es-ev-regiao-unid WHERE TRIM(es-ev-regiao-unid.unidade-vendas) = cUnidadeVendas.
        ASSIGN es-ev-regiao-unid.unidade-vendas = cGerencia.
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
    
    FOR EACH es-ev-permissao WHERE TRIM(es-ev-permissao.unidade-vendas) = cUnidadeVendas.
        ASSIGN es-ev-permissao.unidade-vendas = cGerencia.
    END.
    
    FOR EACH es-ev-unid-tp-ev-hist WHERE TRIM(es-ev-unid-tp-ev-hist.unidade-vendas) = cUnidadeVendas.
        ASSIGN es-ev-unid-tp-ev-hist.unidade-vendas = cGerencia.
    END.
    */
END.
