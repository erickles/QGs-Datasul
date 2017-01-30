define buffer bf-repres-comis   for es-repres-comis.
define buffer bf2-repres-comis   for es-repres-comis.
define buffer bf-repres         for repres.
define variable v-lista as char format "x(40)".
define variable cod_rep as inte.

/* SUPERVISOR       3687 */
/* PROMOTOR         3727 */
/* REPRESENTANTE    3224 */

ASSIGN cod_rep = 2683.

FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = cod_rep NO-LOCK NO-ERROR.
    
IF AVAIL es-repres-comis THEN DO:
    IF es-repres-comis.log-1   = TRUE THEN DO:

        ASSIGN v-lista = ""
               v-lista = v-lista + STRING(cod_rep) + ",".
        FOR EACH bf-repres-comis WHERE bf-repres-comis.cod-emitente = es-repres-comis.cod-emitente
                                    AND bf-repres-comis.cod-rep <> es-repres-comis.cod-rep
                                    AND (bf-repres-comis.situacao = 4
                                    OR bf-repres-comis.situacao = 1) NO-LOCK:
        
            IF INDEX(v-lista,STRING(bf-repres-comis.cod-rep)) = 0 THEN
                ASSIGN v-lista = v-lista + STRING(bf-repres-comis.cod-rep) + ",".
        END.
    END.
    ELSE DO:
        IF UPPER(TRIM(SUBSTRING(es-repres-comis.u-char-2,1,8))) = "PROMOTOR" THEN
            ASSIGN v-lista = ""
               v-lista = v-lista + STRING(cod_rep) + ",".
        
        IF UPPER(TRIM(SUBSTRING(es-repres-comis.u-char-2,1,10))) = "SUPERVISOR" THEN DO:
            FIND FIRST repres WHERE repres.cod-rep = es-repres-comis.cod-rep
                                    NO-LOCK NO-ERROR.

            FOR EACH bf-repres WHERE bf-repres.nome-ab-reg = repres.nome-ab-reg,
                FIRST bf2-repres-comis WHERE bf2-repres-comis.cod-rep = bf-repres.cod-rep
                                         AND (bf2-repres-comis.situacao = 4
                                          OR bf2-repres-comis.situacao = 1):

                ASSIGN v-lista = v-lista + STRING(bf-repres.cod-rep) + ",".
            END.
        END.
    END.
        
END.

MESSAGE v-lista VIEW-AS ALERT-BOX.
