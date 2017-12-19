OUTPUT TO "C:\temp\repres_15112017.csv".

PUT "COD REPRES;COD EMITENTE;NOME;SITUACAO" SKIP.

DEFINE VARIABLE cSituacao AS CHARACTER   NO-UNDO.

FOR EACH repres NO-LOCK,
    EACH es-repres-comis WHERE repres.cod-rep = es-repres-comis.cod-rep NO-LOCK:
    
    cSituacao = "".

    CASE es-repres-comis.situacao:

        WHEN 1 THEN
            cSituacao = "ATIVO".

        WHEN 2 THEN
            cSituacao = "SUSPENSO FINANCEIRO".

        WHEN 3 THEN
            cSituacao = "DESLIGADO".

        WHEN 4 THEN
            cSituacao = "ATIVO UNIFICADO".

        WHEN 5 THEN
            cSituacao = "SUSPENSO COMERCIAL".

    END CASE.

    IF cSituacao = "" THEN
        cSituacao = STRING(es-repres-comis.situacao).

    PUT UNFORM
        repres.cod-rep                  ";"
        es-repres-comis.cod-emitente    ";"
        repres.nome                     ";"
        cSituacao                       SKIP.


END.

OUTPUT CLOSE.
