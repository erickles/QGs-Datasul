DEFINE VARIABLE lNovo AS LOGICAL     NO-UNDO FORMAT "Sim/Nao".

OUTPUT TO "C:\tmp\relat_repres_comis.csv".

PUT "NOVO;"
    "DATA CONTRATO;"
    "CODIGO REPRES;"
    "RAZAO SOCIAL;"
    "REGIOES;"
    "MICRO REGIAO;"
    "NOTA FISCAL;"
    "EMISSAO;"
    "PAGAMENTO;"
    "A/M;"
    "VALOR DE VENDAS;"
    "COMISSAO S/ VENDAS;"
    "%;"
    "VALOR DE COBRANCA;"
    "%;"
    "ESTORNOS;"
    "DEBITOS;"
    "CREDITOS;"
    "VALOR BRUTO;"
    "IMPOSTOS;"
    "VALOR A PAGAR" SKIP.

FOR EACH repres WHERE repres.cod-rep = 3076 NO-LOCK,
    EACH es-repres-comis WHERE es-repres-comis.cod-rep = repres.cod-rep NO-LOCK,
    EACH es-repres-docum WHERE es-repres-docum.cod-emitente = es-repres-comis.cod-emitente:

    IF (MONTH(es-repres-comis.dt-inicio) = MONTH(TODAY) AND YEAR(es-repres-comis.dt-inicio) = YEAR(TODAY)) THEN
        lNovo = YES.
    ELSE
        lNovo = NO.

    FIND FIRST rep-micro WHERE rep-micro.nome-ab-rep = repres.nome-abrev NO-LOCK NO-ERROR.
                                                         
    PUT lNovo                                                   ";"
        es-repres-comis.dt-inicio                               ";"
        repres.cod-rep                                          ";"
        repres.nome                                             ";"
        repres.nome-ab-reg                                      ";"
        IF AVAIL rep-micro THEN rep-micro.nome-mic-reg ELSE ""  ";"
        es-repres-docum.nro-docto                               ";"
                                                                ";"
                                                                ";"
                                                                ";"
        es-repres-docum.vl-saldo
        SKIP.

END.

OUTPUT CLOSE.
