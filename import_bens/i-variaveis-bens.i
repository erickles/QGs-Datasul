/*----------------------------------------------------------------------------*/
/*Kleber Sotte - 12/08/2011 - Preparar LayOut Importa‡Æo Bens
 Include para defini‡Æo de vari veis usadas no programa principal*/
/*----------------------------------------------------------------------------*/
  
/* 
/*informa‡äes obrigat¢rias*/
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

/*informa‡äes opcionais*/
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
*/
DEFINE TEMP-TABLE tt-bens
    FIELD iNrSeqItem                    AS INTEGER    FORMAT 99999999
    FIELD ccEmpresa                     AS CHARACTER  FORMAT "x(3)"
    FIELD cContaPatr                    AS CHARACTER  FORMAT "x(18)"
    FIELD iBemPatrimonial               AS INTEGER    FORMAT 999999999
    FIELD iSeqBem                       AS INTEGER    FORMAT 99999
    FIELD cDescBemPatr                  AS CHARACTER  FORMAT "x(40)"
    FIELD cNumPlaq                      AS CHARACTER  FORMAT "x(20)"
    FIELD iQtBensRepres                 AS INTEGER    FORMAT 99999999
    FIELD cPeriodicidade                AS CHARACTER  FORMAT "x(14)"
    FIELD dtDataAquisicao               AS DATE       FORMAT 99/99/9999
    FIELD cEstabel                      AS CHARACTER  FORMAT "x(5)"
    FIELD lBemImportado                 AS LOGICAL    FORMAT "yes/no"
    FIELD lCreditaPis                   AS LOGICAL    FORMAT "yes/no"
    FIELD lCreditaCofins                AS LOGICAL    FORMAT "yes/no"
    FIELD iNroParcelasCredPisCofins     AS INTEGER    FORMAT 99
    FIELD iParcelasDescontadas          AS INTEGER    FORMAT 99
    FIELD lCreditaCsll                  AS LOGICAL    FORMAT "yes/no"
    FIELD iExerciciosCreditoCsll        AS INTEGER    FORMAT 99
    FIELD cEspeciePatrim                AS CHARACTER  FORMAT "x(6)"
    FIELD cMarca                        AS CHARACTER  FORMAT "x(6)"
    FIELD cModelo                       AS CHARACTER  FORMAT "x(8)"
    FIELD cLicencaUso                   AS CHARACTER  FORMAT "x(12)"
    FIELD cEspecifTecnica               AS CHARACTER  FORMAT "x(8)"
    FIELD cEstadoFisico                 AS CHARACTER  FORMAT "x(8)"
    FIELD cArrendador                   AS CHARACTER  FORMAT "x(6)"
    FIELD cContratoLeasing              AS CHARACTER  FORMAT "x(12)"
    FIELD iFornecedor                   AS INTEGER    FORMAT 999999
    FIELD cLocalizacao                  AS CHARACTER  FORMAT "x(12)"
    FIELD cResponsavel                  AS CHARACTER  FORMAT "x(12)"
    FIELD dtUltimoInvent                AS DATE       FORMAT 99/99/9999
    FIELD cNarrativaBem                 AS CHARACTER  FORMAT "x(2000)"
    FIELD cSeguradora                   AS CHARACTER  FORMAT "x(8)"
    FIELD cApoliceSeguro                AS CHARACTER  FORMAT "x(12)"
    FIELD dtInicValidApol               AS DATE       FORMAT 99/99/9999
    FIELD dtFimValidApol                AS DATE       FORMAT 99/99/9999
    FIELD dePremioSeguro                AS DECIMAL    FORMAT "->>,>>9.99"
    FIELD cSeguradora_1                 AS CHARACTER  FORMAT "x(8)"
    FIELD cApoliceSeguro_1              AS CHARACTER  FORMAT "x(12)"
    FIELD dtInicioValidApolice_1        AS DATE       FORMAT 99/99/9999
    FIELD dtFimValidApolice_1           AS DATE       FORMAT 99/99/9999
    FIELD dePremioSeguro_1              AS DECIMAL    FORMAT "->>,>>9.99"
    FIELD cSeguradora_2                 AS CHARACTER  FORMAT "x(8)"
    FIELD cApoliceSeguro_2              AS CHARACTER  FORMAT "x(12)"
    FIELD dtInicioValidApolice_2        AS DATE       FORMAT 99/99/9999
    FIELD dtFimValidApolice_2           AS DATE       FORMAT 99/99/9999
    FIELD dePremioSeguro_2              AS DECIMAL    FORMAT "->>,>>9.99"
    FIELD cDoctoEntrada                 AS CHARACTER  FORMAT "x(8)"
    FIELD iNumeroItem                   AS INTEGER    FORMAT 999999
    FIELD iPessoaGarantia               AS INTEGER    FORMAT 999999999
    FIELD dtInicioGarantia              AS DATE       FORMAT 99/99/9999
    FIELD dtFimGarantia                 AS DATE       FORMAT 99/99/9999
    FIELD cTermoGarantia                AS CHAR       FORMAT "x(2000)"
    FIELD cGrupoCalculo                 AS CHARACTER  FORMAT "x(6)"
    FIELD dtDataMovimento               AS DATE       FORMAT 99/99/9999
    FIELD dePercBaixado                 AS DECIMAL    FORMAT "->>,>>9.99"
    FIELD dtInicioCalculoDpr            AS DATE       FORMAT 99/99/9999
    FIELD dtDataCalculo                 AS DATE       FORMAT 99/99/9999
    FIELD cSerieNota                    AS CHARACTER  FORMAT "x(3)"
    FIELD deValorCreditoPis             AS DECIMAL    FORMAT "->>,>>9.99"
    FIELD deValorCreditoCofins          AS DECIMAL    FORMAT "->>,>>9.99"
    FIELD deValorBasePis                AS DECIMAL    FORMAT "->>,>>9.99"
    FIELD deValorBaseCofins             AS DECIMAL    FORMAT "->>,>>9.99".
