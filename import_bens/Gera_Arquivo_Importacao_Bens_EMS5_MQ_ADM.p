    {H:\import_bens\Gera_Arquivo_Importacao_Bens_EMS5.i}

    {H:\import_bens\i-variaveis-alocacoes.i}

    {H:\import_bens\i-variaveis-bens.i}

    {H:\import_bens\i-variaveis-valores-e-incorporacoes.i}

    DEFINE VARIABLE cInput AS CHARACTER   NO-UNDO.

    /*cInput = "H:\import_bens\MQ_ADM.csv".*/
    cInput = "H:\import_bens\contabil.csv".

    DEFINE TEMP-TABLE tt-planilha NO-UNDO
        FIELD sequencia         AS CHAR
        FIELD ativoNovo         AS CHAR
        FIELD ativoAnterior     AS CHAR
        FIELD conciliacao       AS CHAR
        FIELD localizacao       AS CHAR
        FIELD codCentroCusto    AS CHAR
        FIELD descCentroCusto   AS CHAR
        FIELD descricao         AS CHAR
        FIELD marca             AS CHAR
        FIELD modelo            AS CHAR
        FIELD serviceTag        AS CHAR.

    EMPTY TEMP-TABLE tt-planilha.

    INPUT FROM VALUE(cInput) CONVERT TARGET "ibm850".

    REPEAT ON ERROR UNDO, NEXT:
       CREATE tt-planilha.
       IMPORT DELIMITER ";"
        tt-planilha.sequencia
        tt-planilha.ativoNovo
        tt-planilha.ativoAnterior
        tt-planilha.conciliacao
        tt-planilha.localizacao
        tt-planilha.codCentroCusto
        tt-planilha.descCentroCusto
        tt-planilha.descricao
        tt-planilha.marca
        tt-planilha.modelo
        tt-planilha.serviceTag.

    END.

    INPUT CLOSE.

    FOR EACH tt-planilha:

        IF tt-planilha.sequencia BEGINS "S" THEN NEXT.

        DISP tt-planilha.sequencia          SKIP
             tt-planilha.ativoNovo          SKIP
             tt-planilha.ativoAnterior      SKIP
             tt-planilha.conciliacao        SKIP
             tt-planilha.localizacao        SKIP
             tt-planilha.codCentroCusto     SKIP
             tt-planilha.descCentroCusto    SKIP
             tt-planilha.descricao          SKIP
             tt-planilha.marca              SKIP
             tt-planilha.modelo             SKIP
             tt-planilha.serviceTag         WITH 1 COL.
    END.
