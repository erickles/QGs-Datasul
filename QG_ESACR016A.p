OUTPUT TO "c:\es_fat_duplic.csv".

PUT "cod-barra;"
    "cod-estabel;"
    "cod-portador;"
    "data-geracao;"
    "gerou-ava;"
    "linha-dig;"
    "modalidade;"
    "nr-fatura;"
    "parcela;"
    "perc-desconto;"
    "prox-numero;"
    "serie;"
    "titulo-banco;"
    "usuario-geracao;"
    "valor-desconto;"
    "nome-ab-cli;"
    "nr-pedido;"
    "nr-fatura"
    SKIP.

FOR EACH es-fat-duplic WHERE es-fat-duplic.data-geracao >= 08/23/2011
                         AND es-fat-duplic.u-log-1      = NO
                         NO-LOCK:

    FIND FIRST titulo WHERE titulo.ep-codigo   = 1
                        AND titulo.nr-docto    = es-fat-duplic.nr-fatura
                        AND titulo.cod-estabel = es-fat-duplic.cod-estabel
                        AND titulo.serie       = es-fat-duplic.serie
                        AND titulo.parcela     = es-fat-duplic.parcela
                        NO-LOCK NO-ERROR.

    FIND FIRST fat-duplic WHERE fat-duplic.cod-estabel  = es-fat-duplic.cod-estabel
                            AND fat-duplic.serie        = es-fat-duplic.serie
                            AND fat-duplic.nr-fatura    = es-fat-duplic.nr-fatura
                            AND fat-duplic.parcela      = es-fat-duplic.parcela
                            NO-LOCK NO-ERROR.

    IF AVAIL fat-duplic THEN DO:

        FIND FIRST emitente WHERE emitente.nome-abrev = fat-duplic.nome-ab-cli NO-LOCK NO-ERROR.

        PUT es-fat-duplic.cod-barra                             ";"
            es-fat-duplic.cod-estabel                           ";"
            es-fat-duplic.cod-portador                          ";"
            es-fat-duplic.data-geracao                          ";"
            es-fat-duplic.gerou-ava                             ";"
            es-fat-duplic.linha-dig                             ";"
            es-fat-duplic.modalidade                            ";"
            es-fat-duplic.nr-fatura                             ";"
            es-fat-duplic.parcela                               ";"
            es-fat-duplic.perc-desconto                         ";"
            es-fat-duplic.prox-numero                           ";"
            es-fat-duplic.serie                                 ";"
            es-fat-duplic.titulo-banco                          ";"
            es-fat-duplic.usuario-geracao                       ";"
            es-fat-duplic.valor-desconto                        ";"
            IF AVAIL emitente THEN emitente.cod-emitente ELSE 0 ";"
            fat-duplic.nr-pedido                                ";"
            fat-duplic.nr-fatura                                SKIP.
    END.

END.

OUTPUT CLOSE.
