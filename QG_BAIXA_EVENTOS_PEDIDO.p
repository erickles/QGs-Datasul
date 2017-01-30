DEFINE VARIABLE cNrPedcli   AS CHARACTER   NO-UNDO FORMAT "X(12)".
DEFINE VARIABLE cNomeAbrev  AS CHARACTER   NO-UNDO FORMAT "X(12)".
DEFINE VARIABLE cItCodigo   AS CHARACTER   NO-UNDO.

UPDATE cNrPedcli.

RUN piEventoIntegrDesp.

PROCEDURE piEventoIntegrDesp:

    FOR EACH es-ev-integr-desp WHERE es-ev-integr-desp.origem     = "PV"
                                AND es-ev-integr-desp.nr-pedcli  = cNrPedcli:
      /*AND es-ev-integr-desp.it-codigo  = cItCodigo:*/       
        
        FIND FIRST es-ev-despesas
            WHERE es-ev-despesas.cod-evento     = es-ev-integr-desp.cod-evento    
              AND es-ev-despesas.ano-referencia = es-ev-integr-desp.ano-referencia
              AND es-ev-despesas.seq-desp       = es-ev-integr-desp.seq-desp NO-ERROR.
        
        IF AVAIL es-ev-despesas THEN
            DELETE es-ev-despesas.    
    
        DELETE es-ev-integr-desp.
    
    END.
 
END PROCEDURE.
