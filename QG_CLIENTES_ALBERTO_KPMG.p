OUTPUT TO "c:\temp\clientes.csv".

PUT "CODIGO;RAZAO SOCIAL" SKIP.

FOR EACH emitente NO-LOCK WHERE emitente.identific = 1 OR emitente.identific = 3:

    PUT UNFORMA emitente.cod-emitente   ";"
                emitente.nome-emit      SKIP.

END.

OUTPUT CLOSE.
