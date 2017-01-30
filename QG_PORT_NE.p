OUTPUT TO "c:\clientes_portadores.csv".

PUT "Codigo;portador" SKIP.

FOR EACH emitente WHERE emitente.port-prefer = 411 NO-LOCK:
    PUT emitente.cod-emitente ";"
        emitente.port-prefer  SKIP.
END.

OUTPUT CLOSE.                                                                                                                                                                              
