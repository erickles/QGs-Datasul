DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE cArquivo AS CHARACTER   NO-UNDO.

/*

Digitacao Web,1,
Pendente,2,
Atualizado,3,
Em Providencia,9

*/

{include/i-ambiente.i}

    OUTPUT TO "C:\Temp\QG_FICHA_DOCS.csv".

DEFINE VARIABLE cMeses      AS CHARACTER EXTENT 12  NO-UNDO
    INIT["JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"].

FOR EACH es-cad-cli-doc NO-LOCK WHERE es-cad-cli-doc.caminho-arquivo <> "":    

    IF adm-ambiente = "PRODUCAO" THEN
        cArquivo = "\\srvvm01\doc-ficha$\" + "PRODUCAO" + "\" + STRING(YEAR(es-cad-cli-doc.date-1)) + "\" + cMeses[MONTH(es-cad-cli-doc.date-1)] + "\" + es-cad-cli-doc.caminho-arquivo.
    ELSE
        cArquivo = "\\srvvm01\doc-ficha$\" + "TESTE" + "\" + STRING(YEAR(es-cad-cli-doc.date-1)) + "\" + cMeses[MONTH(es-cad-cli-doc.date-1)] + "\" + es-cad-cli-doc.caminho-arquivo.

    FILE-INFO:FILE-NAME = cArquivo.

    FIND FIRST es-cad-cli WHERE es-cad-cli.nr-ficha = es-cad-cli-doc.nr-ficha NO-LOCK NO-ERROR.
    IF NOT AVAIL es-cad-cli THEN NEXT.

    IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
        IF es-cad-cli.dt-Atualiz = ? AND es-cad-cli.situacao <> 3 THEN DO:

            FIND FIRST repres WHERE repres.cod-rep = es-cad-cli.cod-rep NO-LOCK NO-ERROR.

            PUT es-cad-cli.nr-ficha     ";"
                es-cad-cli.nome-emit    ";"
                es-cad-cli.estado-entr  ";"
                es-cad-cli.cod-rep      ";"
                repres.nome             ";"
                es-cad-cli.dt-inclusao  ";"
                es-cad-cli.situacao     ";"
                repres.telefone[1]      ";"
                repres.telefone[2]      ";"
                es-cad-cli-doc.caminho-arquivo  SKIP.
            
        END.
    END.

END.

OUTPUT CLOSE.
