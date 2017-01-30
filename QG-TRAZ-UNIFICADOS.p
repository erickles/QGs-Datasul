def var v-lista as char format "x(30)".
def buffer bf-repres-comis  for  es-repres-comis.
def buffer bf2-repres-comis for  es-repres-comis.
def buffer bf-repres for repres.

def var i-cod as inte.

i-cod = 3727.

FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = i-cod NO-LOCK NO-ERROR.
    
IF AVAIL es-repres-comis THEN DO:
    IF es-repres-comis.log-1   = TRUE THEN DO:

        ASSIGN v-lista = ""
               v-lista = v-lista + STRING(i-cod) + ",".

        FOR EACH bf-repres-comis WHERE bf-repres-comis.cod-emitente =  es-repres-comis.cod-emitente
                                    AND bf-repres-comis.cod-rep     <> es-repres-comis.cod-rep
                                    AND (bf-repres-comis.situacao   =  4
                                    OR bf-repres-comis.situacao     =  1) NO-LOCK:
        
            IF INDEX(v-lista,STRING(bf-repres-comis.cod-rep)) = 0 THEN
                ASSIGN v-lista = v-lista + STRING(bf-repres-comis.cod-rep) + ",".
        END.
    END.
    ELSE DO:
        IF UPPER(TRIM(SUBSTRING(es-repres-comis.u-char-2,1,8))) = "PROMOTOR" THEN
            ASSIGN v-lista = ""
               v-lista = v-lista + STRING(i-cod) + ",".
        
        IF UPPER(TRIM(SUBSTRING(es-repres-comis.u-char-2,1,10))) = "SUPERVISOR" THEN DO:
            FIND FIRST repres WHERE repres.cod-rep = es-repres-comis.cod-rep
                                    NO-LOCK NO-ERROR.
            IF AVAIL repres THEN DO:
                ASSIGN v-lista = "".            
                FOR EACH bf-repres WHERE bf-repres.nome-ab-reg = repres.nome-ab-reg:
    
                    ASSIGN v-lista = v-lista + STRING(bf-repres.cod-rep) + ",".
                END.
            END.
        END.
    END.       
END.

message v-lista view-as alert-box.
