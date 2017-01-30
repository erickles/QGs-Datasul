{include/i-buffer.i}

DEFINE VARIABLE c-destino AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-gerente AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRegiao AS CHARACTER    NO-UNDO.

UPDATE cRegiao.

FOR EACH es-usuario-ger NO-LOCK WHERE es-usuario-ger.nome-ab-reg = cRegiao:
    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = es-usuario-ger.cod_usuario NO-LOCK NO-ERROR.
    IF AVAIL usuar_mestre THEN DO:
        FOR EACH es-repres-comis NO-LOCK WHERE es-repres-comis.cod-rep  = INTE(TRIM(usuar_mestre.char-1))
                               AND es-repres-comis.situacao             = 1
                               AND es-repres-comis.log-1                = NO
                               AND TRIM(es-repres-comis.u-char-2)       = "GERENTE DISTRITAL":

            ASSIGN c-destino = c-destino + usuar_mestre.cod_e_mail_local.

            FIND FIRST repres WHERE repres.cod-rep = es-repres-comis.cod-rep NO-LOCK NO-ERROR.
            IF AVAIL repres THEN
                ASSIGN c-gerente = c-gerente + repres.nome.
        END.
    END.
END.

MESSAGE c-destino SKIP
        c-gerente
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
