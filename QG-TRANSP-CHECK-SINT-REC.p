FIND FIRST es-emit-fornec WHERE cod-emitente = 235669 NO-LOCK.
MESSAGE "Sintegra"                                                      SKIP
        "Ativo\Inativo      : " + SUBSTR(es-emit-fornec.char-1,31,1)    SKIP
        "Marcado p/ Check   : " + SUBSTR(es-emit-fornec.char-1,32,1)    SKIP
        "Liberado           : " + SUBSTR(es-emit-fornec.char-1,33,1)    SKIP
        "Dt Libera          : " + SUBSTR(es-emit-fornec.char-1,34,10)   SKIP
        "Usuario Lib        : " + SUBSTR(es-emit-fornec.char-1,44,12)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

MESSAGE "Receita"                                                       SKIP
        "Ativo\Inativo      : " + SUBSTR(es-emit-fornec.char-1,56,1)    SKIP
        "Marcado p/ Check   : " + SUBSTR(es-emit-fornec.char-1,57,1)    SKIP
        "Liberado           : " + SUBSTR(es-emit-fornec.char-1,58,1)    SKIP
        "Dt Libera          : " + SUBSTR(es-emit-fornec.char-1,59,10)   SKIP
        "Usuario Lib        : " + SUBSTR(es-emit-fornec.char-1,69,12)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
