DEFINE TEMP-TABLE tt-acessos
    FIELD codCliente    AS INTE
    FIELD nomeCliente   AS CHAR
    FIELD dataAcesso    AS DATE
    FIELD horaAcesso    AS CHAR.

FOR EACH ws-sessao NO-LOCK WHERE Ws-sessao.Data >= 01/01/2016
                             AND Ws-sessao.Tipo = "EMI":

    FIND FIRST emitente WHERE emitente.cod-emitente = Ws-sessao.codigo NO-LOCK NO-ERROR.

    FIND FIRST tt-acessos WHERE tt-acessos.codCliente = Ws-sessao.codigo NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-acessos THEN DO:
        CREATE tt-acessos.
        ASSIGN tt-acessos.codCliente  = Ws-sessao.codigo
               tt-acessos.nomeCliente = IF AVAIL emitente THEN emitente.nome-emit ELSE ""
               tt-acessos.dataAcesso  = Ws-sessao.Data
               tt-acessos.horaAcesso  = Ws-sessao.Hora.
    END.

END.

OUTPUT TO "C:\Temp\acessos_portal_cliente.csv".

PUT "COD.CLIENTE;"
    "NOME CLIENTE;"
    "DATA ACESSO;"
    "HORA ACESSO"   SKIP.

FOR EACH tt-acessos NO-LOCK BY tt-acessos.dataAcesso:

    PUT UNFORM tt-acessos.codCliente     ";"
               tt-acessos.nomeCliente    ";"
               tt-acessos.dataAcesso     ";"
               tt-acessos.horaAcesso     SKIP.

END.

OUTPUT CLOSE.
