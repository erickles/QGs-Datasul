DEFINE VARIABLE v-lista AS CHARACTER   NO-UNDO.
DEFINE BUFFER bf-repres-comis FOR es-repres-comis.
ASSIGN v-lista = "3224,".

FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = INTE(REPLACE(v-lista,",","")) NO-LOCK NO-ERROR.
FOR EACH bf-repres-comis WHERE bf-repres-comis.cod-emitente = es-repres-comis.cod-emitente 
                           AND (bf-repres-comis.situacao = 4 
                            OR bf-repres-comis.situacao = 1) NO-LOCK:

    IF INDEX(v-lista,STRING(bf-repres-comis.cod-rep)) = 0 THEN
        ASSIGN v-lista = v-lista + STRING(bf-repres-comis.cod-rep) + ",".    
    
END.

MESSAGE v-lista
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

