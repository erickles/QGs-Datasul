/*----------------------------------------------------------------------------*/
/*Kleber Sotte - 12/08/2011 - Preparar LayOut Importa��o Bens
 Include para defini��o de vari�veis usadas no programa principal*/
/*----------------------------------------------------------------------------*/
  

 
/*informa��es obrigat�rias*/
DEFINE VARIABLE iNrSeqItem                AS INTEGER   NO-UNDO FORMAT 99999999. 
DEFINE VARIABLE ccEmpresa                 AS CHARACTER NO-UNDO FORMAT "x(3)".
DEFINE VARIABLE cContaPatr                AS CHARACTER NO-UNDO FORMAT "x(18)".
DEFINE VARIABLE iBemPatrimonial           AS INTEGER   NO-UNDO FORMAT 999999999.
DEFINE VARIABLE iSeqBem                   AS INTEGER   NO-UNDO FORMAT 99999.
DEFINE VARIABLE cDescBemPatr              AS CHARACTER NO-UNDO FORMAT "x(40)".
DEFINE VARIABLE cNumPlaq                  AS CHARACTER NO-UNDO FORMAT "x(20)".
DEFINE VARIABLE iQtBensRepres             AS INTEGER   NO-UNDO FORMAT 99999999.
DEFINE VARIABLE cPeriodicidade            AS CHARACTER NO-UNDO FORMAT "x(14)".
DEFINE VARIABLE dtDataAquisicao           AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE cEstabel                  AS CHARACTER NO-UNDO FORMAT "x(3)".
DEFINE VARIABLE lBemImportado             AS LOGICAL   NO-UNDO FORMAT "yes/no".
DEFINE VARIABLE lCreditaPis               AS LOGICAL   NO-UNDO FORMAT "yes/no".
DEFINE VARIABLE lCreditaCofins            AS LOGICAL   NO-UNDO FORMAT "yes/no".
DEFINE VARIABLE iNroParcelasCredPisCofins AS INTEGER   NO-UNDO FORMAT 99.
DEFINE VARIABLE iParcelasDescontadas      AS INTEGER   NO-UNDO FORMAT 99.
DEFINE VARIABLE lCreditaCsll              AS LOGICAL   NO-UNDO FORMAT "yes/no".
DEFINE VARIABLE iExerciciosCreditoCsll    AS INTEGER   NO-UNDO FORMAT 99.

/*informa��es opcionais*/
DEFINE VARIABLE cEspeciePatrim            AS CHARACTER NO-UNDO FORMAT "x(6)".
DEFINE VARIABLE cMarca                    AS CHARACTER NO-UNDO FORMAT "x(6)".
DEFINE VARIABLE cModelo                   AS CHARACTER NO-UNDO FORMAT "x(8)".
DEFINE VARIABLE cLicencaUso               AS CHARACTER NO-UNDO FORMAT "x(12)".
DEFINE VARIABLE cEspecifTecnica           AS CHARACTER NO-UNDO FORMAT "x(8)".
DEFINE VARIABLE cEstadoFisico             AS CHARACTER NO-UNDO FORMAT "x(8)".
DEFINE VARIABLE cArrendador               AS CHARACTER NO-UNDO FORMAT "x(6)".
DEFINE VARIABLE cContratoLeasing          AS CHARACTER NO-UNDO FORMAT "x(12)".
DEFINE VARIABLE cFornecedor               AS INTEGER   NO-UNDO FORMAT 999999.
DEFINE VARIABLE cLocalizacao              AS CHARACTER NO-UNDO FORMAT "x(12)".
DEFINE VARIABLE cResponsavel              AS CHARACTER NO-UNDO FORMAT "x(12)".
DEFINE VARIABLE dtUltimoInvent            AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE cNarrativaBem             AS CHARACTER NO-UNDO FORMAT "x(2000)".
DEFINE VARIABLE cSeguradora               AS CHARACTER NO-UNDO FORMAT "x(8)".
DEFINE VARIABLE cApoliceSeguro            AS CHARACTER NO-UNDO FORMAT "x(12)".
DEFINE VARIABLE dtInicValidApol           AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE dtFimValidApol            AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE dePremioSeguro            AS DECIMAL   NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE cSeguradora_1             AS CHARACTER NO-UNDO FORMAT "x(8)".
DEFINE VARIABLE cApoliceSeguro_1          AS CHARACTER NO-UNDO FORMAT "x(12)".
DEFINE VARIABLE dtInicioValidApolice_1    AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE dtFimValidApolice_1       AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE dePremioSeguro_1          AS DECIMAL   NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE cSeguradora_2             AS CHARACTER NO-UNDO FORMAT "x(8)".
DEFINE VARIABLE cApoliceSeguro_2          AS CHARACTER NO-UNDO FORMAT "x(12)".
DEFINE VARIABLE dtInicioValidApolice_2    AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE dtFimValidApolice_2       AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE dePremioSeguro_2          AS DECIMAL   NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE cDoctoEntrada             AS CHARACTER NO-UNDO FORMAT "x(8)".
DEFINE VARIABLE iNumeroItem               AS INTEGER   NO-UNDO FORMAT 999999.
DEFINE VARIABLE iPessoaGarantia           AS INTEGER   NO-UNDO FORMAT 999999999.
DEFINE VARIABLE dtInicioGarantia          AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE dtFimGarantia             AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE cGrupoCalculo             AS CHARACTER NO-UNDO FORMAT "x(6)".
DEFINE VARIABLE dtDataMovimento           AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE dePercBaixado             AS DECIMAL   NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE dtInicioCalculoDpr        AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE dtDataCalculo             AS DATE      NO-UNDO FORMAT 99/99/9999.
DEFINE VARIABLE cSerieNota                AS CHARACTER NO-UNDO FORMAT "x(3)".
DEFINE VARIABLE deValorCreditoPis         AS DECIMAL   NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deValorCreditoCofins      AS DECIMAL   NO-UNDO FORMAT "->>,>>9.99".









