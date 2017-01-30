OUTPUT TO "c:\temp\relat_portal_email.csv".

PUT "COD EMITENTE"  ";"
    "NOME EMITENTE" ";"
    "DATA"SKIP.

FOR EACH es-envia-email NO-LOCK WHERE (es-envia-email.codigo-acesso = "BOLETOS"
                                   OR es-envia-email.codigo-acesso = "DANFE")
                                  AND TRIM(es-envia-email.para) <> "@"
                                   BREAK BY es-envia-email.para
                                         BY es-envia-email.dt-env:
    IF FIRST-OF(es-envia-email.para)    AND
       FIRST-OF(es-envia-email.dt-env)  THEN DO:
        FIND FIRST emitente WHERE emitente.e-mail = es-envia-email.para NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            PUT emitente.cod-emitente ";"
                emitente.nome-emit    ";"
                es-envia-email.dt-env SKIP.
        END.
    END.
END.

OUTPUT CLOSE.
