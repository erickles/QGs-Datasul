DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

OUTPUT TO "C:\Temp\inscs.csv".

DEFINE TEMP-TABLE tt-inscricoes NO-UNDO
    FIELD uf AS CHAR
    FIELD inscricao AS CHAR.

FOR EACH emitente WHERE TRIM(emitente.ins-estadual) <> "ISENTO"
                      AND TRIM(emitente.ins-estadual) <> ""
                      NO-LOCK:

    FIND FIRST tt-inscricoes WHERE tt-inscricoes.uf = emitente.estado-entr 
                               AND TRIM(es-cad-cli.ins-estadual) <> "ISENTO"
                               AND TRIM(es-cad-cli.ins-estadual) <> ""
                               NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-inscricoes THEN DO:
        
        iCont = iCont + 1.

        CREATE tt-inscricoes.
        ASSIGN tt-inscricoes.uf        = es-cad-cli.estado-entr
               tt-inscricoes.inscricao = es-cad-cli.ins-estadual.

    END.

    IF iCont = 27 THEN
        LEAVE.

END.

FOR EACH tt-inscricoes NO-LOCK:

    PUT tt-inscricoes.uf        ";"
        tt-inscricoes.inscricao SKIP.
END.

OUTPUT CLOSE.
