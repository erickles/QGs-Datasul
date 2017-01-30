DEFINE VARIABLE i AS INTEGER     NO-UNDO.
FOR EACH emitente WHERE INTE(emitente.identific) = 2 
                    AND emitente.data-implant    >= (TODAY - 730) NO-LOCK:

    FIND FIRST es-emit-fornec WHERE 
        es-emit-fornec.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    IF AVAIL es-emit-fornec THEN
        IF es-emit-fornec.log-2 = YES THEN
            ASSIGN i = i + 1.
END.

MESSAGE i VIEW-AS ALERT-BOX INFO BUTTONS OK.
