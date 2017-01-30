OUTPUT TO "c:\Cliente_pedidos.csv".
PUT "Codigo Cliente"    ";"
    "Nome Cliente"      ";"
    "Celular"           ";"
    "Fixo"              ";"
    "Cep"               SKIP.

FOR EACH ws-p-venda NO-LOCK WHERE ws-p-venda.ind-sit-ped = 5
                               OR ws-p-venda.ind-sit-ped = 9
                             BREAK BY ws-p-venda.nome-abrev:

    IF FIRST-OF(ws-p-venda.nome-abrev) THEN DO:

        FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
                IF  emitente.telefone[1] <> "" AND (SUBSTRING(emitente.telefone[1],1,1) <> "("  OR SUBSTRING(emitente.telefone[1],4,1) <> ")" OR SUBSTRING(REPLACE(emitente.telefone[1]," ",""),09,1) <> "-")   OR
                    emitente.telefone[2] <> "" AND (SUBSTRING(emitente.telefone[2],1,1) <> "("  OR SUBSTRING(emitente.telefone[2],4,1) <> ")" OR SUBSTRING(REPLACE(emitente.telefone[2]," ",""),09,1) <> "-")   THEN

                PUT emitente.cod-emitente   ";"
                    emitente.nome-emit      ";"
                    emitente.telefone[1]    ";"
                    emitente.telefone[2]    ";"
                    "'" + emitente.cep      SKIP.
        END.
    END.
END.

OUTPUT CLOSE.
