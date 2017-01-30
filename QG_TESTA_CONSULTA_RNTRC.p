DEFINE VARIABLE c-retorno-cgc   AS CHARACTER   FORMAT "X(20)" NO-UNDO.
DEFINE VARIABLE i-id-cliente    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-erro-geral    AS CHARACTER   FORMAT "X(20)" NO-UNDO.

FIND FIRST estabelec WHERE estabelec.cod-estabel = "19" NO-LOCK NO-ERROR.

RUN anp\esan006.p(INPUT  estabelec.cgc,
                  INPUT  "02445500850",
                  INPUT "169354",
                  INPUT 1,
                  OUTPUT i-id-cliente,
                  OUTPUT c-erro-geral).

MESSAGE c-erro-geral
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
