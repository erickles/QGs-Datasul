
DEFINE TEMP-TABLE tt-log NO-UNDO
    FIELD cod-emitent   AS INTE
    FIELD nome-emit     AS CHAR
    FIELD cod-estabel   AS CHAR
    FIELD desc-trans    AS CHAR
    FIELD nr-nota-fis   AS CHAR
    FIELD nr-pedcli     AS CHAR
    FIELD parcela       AS CHAR
    FIELD serie         AS CHAR
    FIELD data          AS DATE
    FIELD contador      AS INTE.

/* Pega a parte de impressao */
FOR EACH ws-logextranet WHERE ws-logextranet.data     >= 01/01/2015
                          AND ws-logextranet.data     <= 01/31/2015
                          AND ws-logextranet.tipo-usu = "EMI"
                          NO-LOCK.

    FIND FIRST emitente WHERE emitente.cod-emitente = ws-logextranet.cod-emitente NO-LOCK NO-ERROR.

    CREATE tt-log.
    ASSIGN tt-log.cod-emitent = ws-logextranet.cod-emitente
           tt-log.cod-estabel = ws-logextranet.cod-estabel
           tt-log.nome-emit   = emitente.nome-emit
           tt-log.desc-trans  = ws-logextranet.desc-trans
           tt-log.nr-nota-fis = ws-logextranet.nr-nota-fis
           tt-log.nr-pedcli   = ws-logextranet.nr-pedcli
           tt-log.parcela     = ws-logextranet.parcela
           tt-log.serie       = ws-logextranet.serie
           tt-log.data        = ws-logextranet.data
           tt-log.contador    = 1.

END.

/* Pega a parte de envio de e-mail */
FOR EACH es-envia-email WHERE es-envia-email.dt-incl       >= 01/01/2015
                          AND es-envia-email.dt-incl       <= 01/31/2015
                          AND (es-envia-email.codigo-acesso = "DANFE" OR
                              es-envia-email.codigo-acesso = "BOLETO")
                          NO-LOCK:

    FIND FIRST nota-fiscal NO-LOCK WHERE nota-fiscal.cod-estabel = ENTRY(1,es-envia-email.chave-acesso,"|")
                                     AND nota-fiscal.serie       = ENTRY(2,es-envia-email.chave-acesso,"|")
                                     AND nota-fiscal.nr-nota-fis = ENTRY(3,es-envia-email.chave-acesso,"|")
                                     NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        
        FIND FIRST emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

        IF es-envia-email.codigo-acesso = "DANFE" THEN DO:

            CREATE tt-log.
            ASSIGN tt-log.cod-emitent = nota-fiscal.cod-emitente
                   tt-log.nome-emit   = emitente.nome-emit
                   tt-log.cod-estabel = nota-fiscal.cod-estabel
                   tt-log.desc-trans  = "Envio de DANFE"
                   tt-log.nr-nota-fis = nota-fiscal.nr-nota-fis
                   tt-log.nr-pedcli   = nota-fiscal.nr-pedcli
                   tt-log.parcela     = ""
                   tt-log.serie       = nota-fiscal.serie
                   tt-log.data        = es-envia-email.dt-incl
                   tt-log.contador    = 1.

        END.
        ELSE DO:
        
            FOR EACH fat-duplic WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                                  AND fat-duplic.serie       = nota-fiscal.serie
                                  AND fat-duplic.nr-fatura   = nota-fiscal.nr-nota-fis
                                  NO-LOCK:

                CREATE tt-log.
                ASSIGN tt-log.cod-emitent = nota-fiscal.cod-emitente
                       tt-log.nome-emit   = emitente.nome-emit
                       tt-log.cod-estabel = nota-fiscal.cod-estabel
                       tt-log.desc-trans  = "Envio de Boleto"
                       tt-log.nr-nota-fis = nota-fiscal.nr-nota-fis
                       tt-log.nr-pedcli   = nota-fiscal.nr-pedcli
                       tt-log.parcela     = fat-duplic.parcela
                       tt-log.serie       = nota-fiscal.serie
                       tt-log.data        = es-envia-email.dt-incl
                       tt-log.contador    = 1.
            END.
        END.
    END.
END.

OUTPUT TO "c:\temp\LOG_portal.csv".

PUT UNFORM "COD CLIENTE"        ";"
           "NOME CLIENTE"       ";"
           "ESTABELECIMENTO"    ";"
           "TRANSACAO"          ";"
           "NOTA"               ";"
           "PEDIDO"             ";"
           "PARCELA"            ";"
           "SERIE"              ";"
           "DATA"               ";"
           "CONTADOR"          SKIP.

FOR EACH tt-log NO-LOCK:

    PUT UNFORM tt-log.cod-emitent   ";"
               tt-log.nome-emit     ";"
               tt-log.cod-estabel   ";"
               tt-log.desc-trans    ";"
               tt-log.nr-nota-fis   ";"
               tt-log.nr-pedcli     ";"
               tt-log.parcela       ";"
               tt-log.serie         ";"
               tt-log.data          ";"
               tt-log.contador      SKIP.

END.

OUTPUT CLOSE.
