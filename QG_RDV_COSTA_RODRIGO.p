OUTPUT TO "C:\Temp\rdv.csv".
FOR EACH es-rdv-aponta WHERE es-rdv-aponta.cod-emitente = 51431 NO-LOCK:
    PUT es-rdv-aponta.cod-emitente      ";" 
        es-rdv-aponta.mes-aponta        ";"
        es-rdv-aponta.nr-apontamento    ";"
        es-rdv-aponta.lotacao           ";"
        es-rdv-aponta.dat-digitacao     SKIP.
END.

OUTPUT CLOSE.
