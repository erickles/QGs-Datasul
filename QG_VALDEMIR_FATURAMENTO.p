DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
/*DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO FORMAT ">>,>>>,>>>,>>9.99".*/

OUTPUT TO "c:\temp\pedidos_mob.csv".

DEFINE TEMP-TABLE tt-planilha
    FIELD cData     AS CHAR    
    FIELD iPedidos  AS INTE
    FIELD iNotas    AS INTE
    FIELD mobilePed AS LOGICAL FORMAT "Sim/Nao"
    FIELD mobileNot AS LOGICAL FORMAT "Sim/Nao".

PUT "Mes"               ";"
    "Ano"               ";"
    "NrPedidos"         ";"
    "Nr Notas"          ";"
    "Via mobile" /*";"
    "Nota via mobile"*/   SKIP.

FOR EACH nota-fiscal WHERE /*nota-fiscal.cod-estabel = "22"
                       AND*/ /*nota-fiscal.emite-duplic = YES
                       AND*/ nota-fiscal.dt-emis >= 02/28/2017
                       AND nota-fiscal.dt-emis <= 02/28/2017
                       AND nota-fiscal.dt-canc = ?
                       NO-LOCK:
    
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = nota-fiscal.nr-pedcli
                            AND ws-p-venda.nome-abrev = nota-fiscal.nome-ab-cli
                            AND ws-p-venda.cod-tipo-oper = 1
                            NO-LOCK NO-ERROR.
    /*IF AVAIL ws-p-venda THEN DO:*/
    
        FIND FIRST tt-planilha WHERE tt-planilha.cData      = STRING(MONTH(nota-fiscal.dt-emis)) + "/" + STRING(YEAR(nota-fiscal.dt-emis))
                                 /*AND tt-planilha.mobileNot = ws-p-venda.log-5*/
                                 NO-ERROR.
    
        IF NOT AVAIL tt-planilha THEN
            CREATE tt-planilha.
            ASSIGN tt-planilha.cData        = STRING(MONTH(nota-fiscal.dt-emis)) + "/" + STRING(YEAR(nota-fiscal.dt-emis))
                   /*tt-planilha.iPedidos =*/
                   tt-planilha.iNotas       = tt-planilha.iNotas + 1
                   /*tt-planilha.mobileNot    = ws-p-venda.log-5*/.
    /*END.*/
    /*
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda AND ws-p-venda.cod-tipo-oper = 1 THEN*/
        /*ASSIGN iCont = iCont + 1*/
               /*deValor = deValor + nota-fiscal.vl-tot-nota*/.

END.

/*
FOR EACH ws-p-venda WHERE ws-p-venda.ind-sit-ped <> 22
                      AND ws-p-venda.dt-implant >= 01/01/2015
                      AND ws-p-venda.dt-implant <= 12/31/2015
                      AND LOOKUP(STRING(ws-p-venda.cod-tipo-oper),"1,2") > 0
                       NO-LOCK:

    FIND FIRST tt-planilha WHERE tt-planilha.iMes       = MONTH(ws-p-venda.dt-implant)
                             AND tt-planilha.iAno       = YEAR(ws-p-venda.dt-implant)
                             AND tt-planilha.mobilePed  = ws-p-venda.log-5
                             NO-ERROR.
    IF NOT AVAIL tt-planilha THEN
        CREATE tt-planilha.
        ASSIGN tt-planilha.iMes     = MONTH(ws-p-venda.dt-implant)
               tt-planilha.iAno     = YEAR(ws-p-venda.dt-implant)
               tt-planilha.iPedidos = tt-planilha.iPedidos + 1
               /*tt-planilha.iNotas   = tt-planilha.iNotas + 1*/
               tt-planilha.mobilePed   = IF AVAIL ws-p-venda THEN ws-p-venda.log-5 ELSE NO.

/*
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda AND ws-p-venda.cod-tipo-oper = 1 THEN*/
        /*ASSIGN iCont = iCont + 1*/
               /*deValor = deValor + nota-fiscal.vl-tot-nota*/.

END.
*/
FOR EACH tt-planilha NO-LOCK BREAK BY tt-planilha.cData:
    /*
    PUT iMes        ";"
        iAno        ";"
        iPedidos    ";"
        iNotas      ";"
        mobilePed   SKIP.
    */
    PUT cData       ";"
        iPedidos    ";"
        iNotas      ";"
        mobileNot   SKIP.

END.

OUTPUT CLOSE.
