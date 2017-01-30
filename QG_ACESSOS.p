OUTPUT TO "C:\Temp\acessos_portal_cliente.csv".

PUT "COD.CLIENTE;"
    "NOME CLIENTE;"
    "DATA ACESSO;"
    "HORA ACESSO"   SKIP.

FOR EACH ws-sessao NO-LOCK WHERE Ws-sessao.Data >= 01/01/2016
                             AND Ws-sessao.Tipo = "EMI":

    FIND FIRST emitente WHERE emitente.cod-emitente = Ws-sessao.codigo NO-LOCK NO-ERROR.

    PUT UNFORM Ws-sessao.codigo                                     ";"
               IF AVAIL emitente THEN emitente.nome-emit ELSE ""    ";"
               Ws-sessao.Data                                       ";"
               Ws-sessao.Hora                                       SKIP.

END.

OUTPUT CLOSE.
