OUTPUT TO "c:\Cliente.csv".
PUT "Codigo Cliente"    ";"
    "Nome Cliente"      ";"
    "Celular"           ";"
    "Fixo"              ";"
    "E-mail"            SKIP.

FOR EACH nota-fiscal NO-LOCK WHERE nota-fiscal.dt-emis >= (TODAY - 180)
                                AND nota-fiscal.dt-cancel = ?
                                BREAK BY nota-fiscal.cod-emitente:

    IF FIRST-OF(nota-fiscal.cod-emitente) THEN DO:

        FIND FIRST emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
                IF  emitente.telefone[1] <> "" AND (SUBSTRING(emitente.telefone[1],1,1) <> "("  OR SUBSTRING(emitente.telefone[1],4,1) <> ")" OR SUBSTRING(REPLACE(emitente.telefone[1]," ",""),09,1) <> "-")   OR
                    emitente.telefone[2] <> "" AND (SUBSTRING(emitente.telefone[2],1,1) <> "("  OR SUBSTRING(emitente.telefone[2],4,1) <> ")" OR SUBSTRING(REPLACE(emitente.telefone[2]," ",""),09,1) <> "-")   THEN

                PUT emitente.cod-emitente   ";"
                    emitente.nome-emit      ";"
                    emitente.telefone[1]    ";"
                    emitente.telefone[2]    ";"
                    emitente.e-mail         SKIP.            
        END.
    END.
END.

OUTPUT CLOSE.
