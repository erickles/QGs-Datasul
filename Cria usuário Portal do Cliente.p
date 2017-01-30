DEFINE VARIABLE iCodEmitente AS INTEGER     NO-UNDO.
DEFINE BUFFER bws-emitente FOR ws-emitente.

UPDATE iCodEmitente LABEL "Cod. Emitente".

/*alterar este c¢digo para o Cliente que quer criar a ws-emitente*/
FIND FIRST emitente WHERE emitente.cod-emitente = iCodEmitente NO-LOCK NO-ERROR.
FIND FIRST ws-emitente WHERE ws-emitente.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
IF AVAIL ws-emitente THEN DO:
    DELETE FROM ws-emitente WHERE ws-emitente.cod-emitente = emitente.cod-emitente.
END.
/**/

/*P.F¡sica*/
FIND FIRST bws-emitente WHERE bws-emitente.cod-emitente = 108028 NO-LOCK NO-ERROR.
/**/

/*P.Jur¡dica
FIND FIRST bws-emitente WHERE bws-emitente.cod-emitente = xxxxxx NO-LOCK NO-ERROR.
*/

CREATE ws-emitente.
BUFFER-COPY bws-emitente EXCEPT bws-emitente.cod-emitente bws-emitente.cgc TO ws-emitente.

ASSIGN ws-emitente.cod-emitente = emitente.cod-emitente
       ws-emitente.cgc          = emitente.cgc
       ws-emitente.u-log-1      = YES
       ws-emitente.u-int-3      = 0
       ws-emitente.dt-geracao   = TODAY.
