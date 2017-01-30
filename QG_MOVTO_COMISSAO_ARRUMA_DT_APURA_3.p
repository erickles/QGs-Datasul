DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO.

OUTPUT TO "C:\Temp\comissoes.csv".

PUT "COD REP;REP NOME;DT PROCESSAMENTO;DT APURACAO;TIPO MOV;VALOR" SKIP.

FOR EACH es-movto-comis WHERE es-movto-comis.dt-today >= 12/20/2016
                          AND es-movto-comis.dt-today <= 12/31/2016
                          NO-LOCK BY es-movto-comis.dt-today:

    FIND FIRST repres WHERE repres.cod-rep = es-movto-comis.cod-rep NO-LOCK NO-ERROR.

    PUT es-movto-comis.cod-rep      ";"
        repres.nome                 ";"
        es-movto-comis.dt-today     ";"
        es-movto-comis.dt-apuracao  ";"
        es-movto-comis.tp-movto     ";"
        es-movto-comis.valor        SKIP.

END.

OUTPUT CLOSE.
