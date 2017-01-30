DEFINE VARIABLE i-codrep AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-status AS CHARACTER   NO-UNDO.

i-codrep = 3107.

OUTPUT TO "c:\cliente_mobile.txt".

FOR EACH es-loc-entr NO-LOCK 
        WHERE (es-loc-entr.cod-repres = i-codrep OR LOOKUP(STRING(i-codrep),es-loc-entr.char-1) > 0)
        AND es-loc-entr.ind-situacao
        BREAK BY es-loc-entr.nome-abrev:
        
        /*FIND loc-entr OF es-loc-entr NO-LOCK NO-ERROR.*/
        FIND FIRST loc-entr
             WHERE loc-entr.nome-abrev = es-loc-entr.nome-abrev NO-LOCK NO-ERROR.
        IF NOT AVAIL loc-entr THEN NEXT.
    
        IF FIRST-OF(es-loc-entr.nome-abrev) THEN DO:
    
            FOR EACH emitente NO-LOCK
               WHERE emitente.nome-abrev = es-loc-entr.nome-abrev
                 AND (emitente.identific = 1 OR emitente.identific = 3)
                 AND NOT emitente.nome-emit BEGINS "** Eliminado":

                FOR FIRST es-emitente-dis NO-LOCK
                    WHERE es-emitente-dis.cod-emitente = emitente.cod-emitente:
                    
                    c-status = IF SUBSTRING(es-emitente-dis.char-2,210,1) = "N" THEN "N" ELSE "S".

                    PUT emitente.cod-emitente c-status SKIP.
                    
                END.
            END.
        END.        
    END.

OUTPUT CLOSE.
