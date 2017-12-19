
OUTPUT TO "C:\temp\fornecs_viagem.csv".

PUT "CODIGO;NOME" SKIP.

FOR EACH es-fornec-rdv NO-LOCK:

    FIND FIRST emitente WHERE emitente.cod-emitente = es-fornec-rdv.cod-emitente NO-LOCK NO-ERROR.

    PUT UNFORM es-fornec-rdv.cod-emitente                      ";"
               IF AVAIL emitente THEN emitente.nome-emit ELSE ""    SKIP.
        
END.

OUTPUT CLOSE.
