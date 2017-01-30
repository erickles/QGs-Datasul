DEFINE BUFFER bf-ev-permissao           FOR es-ev-permissao.
DEFINE BUFFER bf-ev-unid-tp-ev-hist     FOR es-ev-unid-tp-ev-hist.
DEFINE BUFFER bf-ev-unid-tp-ev          FOR es-ev-unid-tp-ev.
DEFINE BUFFER bf-ev-unid-vendas         FOR es-ev-unid-vendas.
DEFINE BUFFER bf-ev-unid-vendas-hist    FOR es-ev-unid-vendas-hist.
DEFINE BUFFER bf-ev-regiao-unid         FOR es-ev-regiao-unid.
DEFINE BUFFER bf-ft-gerencias           FOR es-ft-gerencias.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD unidade-venda     AS CHAR FORMAT "X(60)"
    FIELD regiao-antiga     AS CHAR FORMAT "X(12)"
    FIELD regiao-nova       AS CHAR FORMAT "X(12)"
    FIELD micro-antiga      AS CHAR FORMAT "X(12)"
    FIELD micro-nova        AS CHAR FORMAT "X(12)"
    FIELD gerencia-antiga   AS CHAR FORMAT "X(60)"
    FIELD gerencia-nova     AS CHAR FORMAT "X(60)".

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Listas_Rezoneamento\lista_rezoEventosPORTO ALEGRE.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";" 
    tt-planilha.unidade-venda
    tt-planilha.regiao-antiga
    tt-planilha.regiao-nova
    tt-planilha.micro-antiga
    tt-planilha.micro-nova
    tt-planilha.gerencia-antiga
    tt-planilha.gerencia-nova.

END.
INPUT CLOSE.

/* Gerencias */

FOR EACH tt-planilha NO-LOCK:
    
    FOR EACH es-ev-permissao WHERE TRIM(es-ev-permissao.unidade-vendas) = TRIM(tt-planilha.unidade-venda).
        FIND FIRST bf-ev-permissao WHERE bf-ev-permissao.cod-usuario    = es-ev-permissao.cod-usuario
                                     AND bf-ev-permissao.unidade-vendas = tt-planilha.gerencia-nova
                                     NO-LOCK NO-ERROR.

        IF NOT AVAIL bf-ev-permissao THEN
            ASSIGN es-ev-permissao.unidade-vendas = tt-planilha.gerencia-nova.
    END.
    
    FOR EACH es-ev-unid-tp-ev-hist WHERE TRIM(es-ev-unid-tp-ev-hist.unidade-vendas) = TRIM(tt-planilha.unidade-venda).
        FIND FIRST bf-ev-unid-tp-ev-hist WHERE bf-ev-unid-tp-ev-hist.unidade-vendas = tt-planilha.gerencia-nova
                                           AND bf-ev-unid-tp-ev-hist.tipo-verba     = es-ev-unid-tp-ev-hist.tipo-verba
                                           AND bf-ev-unid-tp-ev-hist.ano-referencia = es-ev-unid-tp-ev-hist.ano-referencia
                                           AND bf-ev-unid-tp-ev-hist.tipo-evento    = es-ev-unid-tp-ev-hist.tipo-evento
                                           AND bf-ev-unid-tp-ev-hist.dat-alter      = es-ev-unid-tp-ev-hist.dat-alter
                                           AND bf-ev-unid-tp-ev-hist.hr-alteracao   = es-ev-unid-tp-ev-hist.hr-alteracao
                                           NO-LOCK NO-ERROR.

        IF NOT AVAIL bf-ev-unid-tp-ev-hist THEN
            ASSIGN es-ev-unid-tp-ev-hist.unidade-vendas = tt-planilha.gerencia-nova.        
    END.

    FOR EACH es-ev-unid-tp-ev WHERE TRIM(es-ev-unid-tp-ev.unidade-vendas) = TRIM(tt-planilha.unidade-venda).
        FIND FIRST bf-ev-unid-tp-ev WHERE bf-ev-unid-tp-ev.unidade-vendas   = tt-planilha.gerencia-nova
                                      AND bf-ev-unid-tp-ev.tipo-verba       = es-ev-unid-tp-ev.tipo-verba    
                                      AND bf-ev-unid-tp-ev.ano-referencia   = es-ev-unid-tp-ev.ano-referencia
                                      AND bf-ev-unid-tp-ev.tipo-evento      = es-ev-unid-tp-ev.tipo-evento
                                      NO-ERROR.
        IF NOT AVAIL bf-ev-unid-tp-ev THEN
            ASSIGN es-ev-unid-tp-ev.unidade-vendas = tt-planilha.gerencia-nova.
        ELSE DO:
            bf-ev-unid-tp-ev.valor-verba = bf-ev-unid-tp-ev.valor-verba + es-ev-unid-tp-ev.valor-verba.
            DELETE es-ev-unid-tp-ev.
        END.
    END.
    
    FOR EACH es-ev-unid-vendas WHERE TRIM(es-ev-unid-vendas.unidade-vendas) = TRIM(tt-planilha.unidade-venda).
        FIND FIRST bf-ev-unid-vendas WHERE bf-ev-unid-vendas.unidade-vendas = tt-planilha.gerencia-nova
                                       AND bf-ev-unid-vendas.tipo-verba     = es-ev-unid-vendas.tipo-verba    
                                       AND bf-ev-unid-vendas.ano-referencia = es-ev-unid-vendas.ano-referencia
                                       NO-ERROR.
        IF NOT AVAIL bf-ev-unid-vendas THEN
            ASSIGN es-ev-unid-vendas.unidade-vendas = tt-planilha.gerencia-nova.
        ELSE DO:
            ASSIGN bf-ev-unid-vendas.valor-verba = bf-ev-unid-vendas.valor-verba + es-ev-unid-vendas.valor-verba.
            DELETE es-ev-unid-vendas.
        END.
    END.
    
    FOR EACH es-ev-unid-vendas-hist WHERE TRIM(es-ev-unid-vendas-hist.unidade-vendas) = TRIM(tt-planilha.unidade-venda).
        FIND FIRST bf-ev-unid-vendas-hist WHERE bf-ev-unid-vendas-hist.unidade-vendas = tt-planilha.gerencia-nova
                                            AND bf-ev-unid-vendas-hist.tipo-verba     = es-ev-unid-vendas-hist.tipo-verba
                                            AND bf-ev-unid-vendas-hist.ano-referencia = es-ev-unid-vendas-hist.ano-referencia
                                            AND bf-ev-unid-vendas-hist.dat-alter      = es-ev-unid-vendas-hist.dat-alter
                                            AND bf-ev-unid-vendas-hist.hr-alteracao   = es-ev-unid-vendas-hist.hr-alteracao
                                            NO-LOCK NO-ERROR.
        IF NOT AVAIL bf-ev-unid-vendas-hist THEN
            ASSIGN es-ev-unid-vendas-hist.unidade-vendas = tt-planilha.gerencia-nova.
    END.

    FOR EACH es-eventos WHERE es-eventos.unidade-vendas = tt-planilha.unidade-venda:
        ASSIGN es-eventos.unidade-vendas = tt-planilha.gerencia-nova.
    END.

END.
