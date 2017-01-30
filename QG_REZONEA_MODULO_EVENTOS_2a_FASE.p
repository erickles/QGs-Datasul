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

INPUT FROM "C:\Listas_Rezoneamento\lista_rezoEventosCHAPECO.csv" CONVERT TARGET "ibm850".

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

FOR EACH tt-planilha NO-LOCK:
    
    /* Regiao nova */
    FOR EACH es-eventos WHERE TRIM(es-eventos.nome-mic-reg) = TRIM(tt-planilha.micro-nova).
        ASSIGN es-eventos.nome-mic-reg  = tt-planilha.micro-nova
               es-eventos.nome-ab-reg   = tt-planilha.regiao-nova
               es-eventos.unidade-venda = tt-planilha.gerencia-nova.
    END.

    FOR EACH es-eventos WHERE TRIM(es-eventos.nome-ab-reg) = TRIM(tt-planilha.regiao-nova).
        ASSIGN es-eventos.unidade-venda = tt-planilha.gerencia-nova.
    END.

    FOR EACH es-ev-regiao-unid WHERE TRIM(es-ev-regiao-unid.nome-ab-reg) = TRIM(tt-planilha.regiao-nova):

        FIND FIRST bf-ev-regiao-unid WHERE bf-ev-regiao-unid.unidade-vendas = tt-planilha.gerencia-nova
                                       AND bf-ev-regiao-unid.nome-ab-reg    = tt-planilha.regiao-nova
                                       NO-LOCK NO-ERROR.

        IF NOT AVAIL bf-ev-regiao-unid THEN
            ASSIGN es-ev-regiao-unid.nome-ab-reg    = tt-planilha.regiao-nova
                   es-ev-regiao-unid.unidade-venda  = tt-planilha.gerencia-nova.

    END.

    FOR EACH es-ft-gerencias WHERE TRIM(es-ft-gerencias.nome-ab-reg) = TRIM(tt-planilha.regiao-nova).
        FIND FIRST bf-ft-gerencias WHERE bf-ft-gerencias.nome-ab-reg = tt-planilha.regiao-nova NO-LOCK NO-ERROR.
        IF NOT AVAIL bf-ft-gerencias THEN
            ASSIGN es-ft-gerencias.nome-ab-reg      = tt-planilha.regiao-nova
                   es-ft-gerencias.unidade-venda    = tt-planilha.gerencia-nova.
    END.

END.
