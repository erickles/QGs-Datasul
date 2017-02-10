{H:\import_bens\Gera_Arquivo_Importacao_Bens_EMS5.i}

DEFINE VARIABLE cInput AS CHARACTER   NO-UNDO.

cInput = "H:\import_bens\MQ_IND.csv".

    DEFINE TEMP-TABLE tt-planilha NO-UNDO
        FIELD item              AS CHAR
        FIELD ativo             AS CHAR
        FIELD ativoAnterior     AS CHAR
        FIELD complemento       AS CHAR
        FIELD area              AS CHAR
        FIELD equipamento       AS CHAR
        FIELD planta            AS CHAR
        FIELD centroCusto       AS CHAR
        FIELD descCentroCusto   AS CHAR
        FIELD descricao         AS CHAR
        FIELD marca             AS CHAR
        FIELD modelo            AS CHAR
        FIELD obs               AS CHAR.

    EMPTY TEMP-TABLE tt-planilha.

    INPUT FROM VALUE(cInput) CONVERT TARGET "ibm850".

    REPEAT ON ERROR UNDO, NEXT:
       CREATE tt-planilha.
       IMPORT DELIMITER ";"
        tt-planilha.item           
        tt-planilha.ativo          
        tt-planilha.ativoAnterior  
        tt-planilha.complemento    
        tt-planilha.area           
        tt-planilha.equipamento    
        tt-planilha.planta         
        tt-planilha.centroCusto    
        tt-planilha.descCentroCusto
        tt-planilha.descricao
        tt-planilha.marca
        tt-planilha.modelo
        tt-planilha.obs.

    END.

    INPUT CLOSE.

    FOR EACH tt-planilha:

        IF tt-planilha.item BEGINS "I" THEN NEXT.

        DISP tt-planilha.item               SKIP
             tt-planilha.ativo              SKIP
             tt-planilha.ativoAnterior      SKIP
             tt-planilha.complemento        SKIP
             tt-planilha.area               SKIP
             tt-planilha.equipamento        SKIP
             tt-planilha.planta             SKIP
             tt-planilha.centroCusto        SKIP
             tt-planilha.descCentroCusto    SKIP
             tt-planilha.descricao          SKIP
             tt-planilha.marca              SKIP
             tt-planilha.modelo             SKIP
             tt-planilha.obs                WITH 1 COL.
    END.
