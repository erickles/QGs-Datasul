/*----------------------------------------------------------------------------*/
/*Kleber Sotte - 12/08/2011 - Preparar LayOut Importa‡Æo Bens
 Include para defini‡Æo de vari veis usadas no programa principal*/
/*----------------------------------------------------------------------------*/

/* informa‡äes obrigat¢rias */
/*
DEFINE VARIABLE iNrSeqItem         AS INTEGER   NO-UNDO FORMAT 99999999. 
DEFINE VARIABLE cPlanoCentrosCusto AS CHARACTER NO-UNDO FORMAT "x(8)".
DEFINE VARIABLE cCentroCusto       AS CHARACTER NO-UNDO FORMAT "x(11)".
DEFINE VARIABLE cUnidNegocio       AS CHARACTER NO-UNDO FORMAT "x(3)".
DEFINE VARIABLE dePercApropriacao  AS DECIMAL   NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE lCcustoUnPrincipal AS LOGICAL   NO-UNDO FORMAT "yes/no".
*/
DEFINE TEMP-TABLE tt-alocacoes
    FIELD iNrSeqItem         AS INTEGER   FORMAT 99999999
    FIELD cPlanoCentrosCusto AS CHARACTER FORMAT "x(8)"
    FIELD cCentroCusto       AS CHARACTER FORMAT "x(4)"
    FIELD cUnidNegocio       AS CHARACTER FORMAT "x(2)"
    FIELD dePercApropriacao  AS DECIMAL   FORMAT "999999.9999"
    FIELD lCcustoUnPrincipal AS LOGICAL   FORMAT "yes/no".
