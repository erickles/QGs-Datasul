OUTPUT to "c:\pedido-enviado.csv".
PUT "Nr.Pedido"         ";"
     "Cod.Emitente"     ";"
    "E-mail"            ";"
    "Log Envio"         ";"
    "Hora Envio"        ";"
    "Sucesso Envio"     ";"
    "Tentativas Envio"  ";"
    "Data Envio"        SKIP.

FOR EACH es-comunica-cliente-envio NO-LOCK:
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = es-comunica-cliente-envio.nr-pedcli NO-LOCK NO-ERROR.
    FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
    PUT  es-comunica-cliente-envio.nr-pedcli                        ";"
         emitente.cod-emitente                                      ";"
         emitente.e-mail                                            ";"
         es-comunica-cliente-envio.log-envio FORMAT "X(50)"         ";"
         STRING(es-comunica-cliente-envio.hora-envio,"HH:MM:SS")    ";"
         es-comunica-cliente-envio.sucesso-envio                    ";"
         es-comunica-cliente-envio.tentativas-envio                 ";"
         es-comunica-cliente-envio.data-envio
         SKIP.
END.
OUTPUT CLOSE.
