/*----------------------------------------------------------------------------*/
/*Kleber Sotte - 12/08/2011 - Preparar LayOut Importa‡Æo Bens
 Include para defini‡Æo de vari veis usadas no programa principal*/
/*----------------------------------------------------------------------------*/
  

 
/*informa‡äes obrigat¢rias*/
DEFINE VARIABLE iNrSeqItem       AS INTEGER   NO-UNDO FORMAT 99999999. 
DEFINE VARIABLE cCenarioContabil AS CHARACTER NO-UNDO FORMAT "x(8)".
DEFINE VARIABLE cFinalidade      AS CHARACTER NO-UNDO FORMAT "x(10)".
DEFINE VARIABLE deValorOriginal  AS DECIMAL   NO-UNDO FORMAT "->>,>>9.99".


/*informa‡äes opcionais*/
DEFINE VARIABLE iSeqIncorp            AS INTEGER NO-UNDO FORMAT 99999999.
DEFINE VARIABLE deCorrecaoMonetaria   AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deDprValorOriginal    AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deDprCorrecMonet      AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deCorrecMonetDpr      AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deDeprecIncentiv      AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deDprIncentivCM       AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deCMDprIncentivada    AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deAmortizacaoVO       AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deAmortizacaoCM       AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deCMAmortizacao       AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deAmortizacaoIncent   AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deAmortizacaoIncentCM AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE deCMAmortIncentivada  AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE dePercentualDpr       AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE dePercDprIncentivada  AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".
DEFINE VARIABLE dePercDprReducaoSaldo AS DECIMAL NO-UNDO FORMAT "->>,>>9.99".

