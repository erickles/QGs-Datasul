DEFINE VARIABLE docToPdf AS COM-HANDLE NO-UNDO.
/* Chamada da Funcao Pesquisa dentro da DLL */

CREATE "ConvertDocToPdf.DocToPdf" docToPdf /*chFuncao*/ . /*Instancia da DLL*/
docToPdf:convertDOCTOPDf("C:\tmp\09-2-0051350-.doc").

RELEASE OBJECT docToPdf.
