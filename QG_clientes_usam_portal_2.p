OUTPUT TO "c:\temp\relat_portal_impressao.csv".

PUT "COD EMITENTE"  ";"
    "NOME EMITENTE" SKIP.

FOR EACH es-nota-fiscal-portal NO-LOCK,
    EACH nota-fiscal WHERE nota-fiscal.nr-nota-fis = es-nota-fiscal-portal.nr-nota-fis
                       AND nota-fiscal.cod-estabel = es-nota-fiscal-portal.cod-estabel
                       AND nota-fiscal.serie       = es-nota-fiscal-portal.serie
                       NO-LOCK,
                       EACH emitente OF nota-fiscal BREAK BY emitente.cod-emitente:

    IF FIRST-OF(emitente.cod-emitente) THEN DO:
        PUT emitente.cod-emitente ";"
            emitente.nome-emit    SKIP.
    END.

END.

OUTPUT CLOSE.
