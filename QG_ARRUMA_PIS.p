FOR EACH emitente WHERE emitente.cod-emitente = 232675
                     OR emitente.cod-emitente = 232707
                     OR emitente.cod-emitente = 232713
                     OR emitente.cod-emitente = 232765
                     OR emitente.cod-emitente = 232844
                     OR emitente.cod-emitente = 232865
                     OR emitente.cod-emitente = 232872:

    FIND FIRST es-emit-fornec WHERE es-emit-fornec.cod-emitente = emitente.cod-emitente NO-ERROR.
    IF AVAIL es-emit-fornec THEN
        ASSIGN es-emit-fornec.pis = emitente.cod-inscr-inss.
END.
