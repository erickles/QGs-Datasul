    
    DEFINE VARIABLE de-valor-provisionado AS DECIMAL     NO-UNDO.

    FIND FIRST es-ev-ocorrencias WHERE es-ev-ocorrencias.cod-evento = 017478
                                   AND es-ev-ocorrencias.ano-referencia = 2012
                                   NO-LOCK NO-ERROR.
    
    IF AVAIL es-ev-ocorrencias THEN DO:
        FOR EACH es-ev-integr-desp NO-LOCK WHERE es-ev-integr-desp.cod-evento     = es-ev-ocorrencias.cod-evento
                                             AND es-ev-integr-desp.ano-referencia = es-ev-ocorrencias.ano-referencia
                                             AND es-ev-integr-desp.atualizado     = NO:

            ASSIGN de-valor-provisionado = de-valor-provisionado + es-ev-integr-desp.vl-total.

            MESSAGE "Origem         "   es-ev-integr-desp.origem        SKIP
                    "Nr Contrato    "   es-ev-integr-desp.nr-contrato   SKIP
                    "Nr Docto       "   es-ev-integr-desp.nr-docto      SKIP
                    "Nr Pedido      "   es-ev-integr-desp.nr-pedcli     SKIP
                    "Nr Requisicao  "   es-ev-integr-desp.nr-requisicao SKIP
                    "Nr Ordem       "   es-ev-integr-desp.numero-ordem  SKIP
                    "Vlr Total Desp "   es-ev-integr-desp.vl-total
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

        END.
    END.

    /*
    MESSAGE de-valor-provisionado
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
