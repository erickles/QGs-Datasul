FIND FIRST es-ev-despesas WHERE es-ev-despesas.cod-evento = 17038 NO-LOCK NO-ERROR.
IF NOT AVAIL es-ev-despesas THEN
    MESSAGE "NOK"
            
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
ELSE DO:
    
    MESSAGE es-ev-despesas.ano-referencia
        es-ev-despesas.data-emissao
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    FIND FIRST es-ev-integr-desp WHERE es-ev-integr-desp.cod-evento     = es-ev-despesas.cod-evento
                                            /*
                                           AND es-ev-integr-desp.ano-referencia = es-ev-despesas.ano-referencia
                                           AND es-ev-integr-desp.tipo-item      = es-ev-despesas.tipo-item
                                           AND es-ev-integr-desp.vl-total       = es-ev-despesas.valor-despesado
                                           */
                                           NO-LOCK NO-ERROR.

    IF AVAIL es-ev-integr-desp THEN DO:
        MESSAGE "OK"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE
        MESSAGE "NAO TEM INTEGRACAO DE DESPESAS!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.
    
