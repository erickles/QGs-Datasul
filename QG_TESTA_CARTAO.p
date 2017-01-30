DEFINE VARIABLE c-retorno-cgc   AS CHARACTER   FORMAT "X(20)" NO-UNDO.
DEFINE VARIABLE i-id-cliente    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-erro-geral    AS CHARACTER   FORMAT "X(20)" NO-UNDO.

FIND FIRST estabelec WHERE estabelec.cod-estabel = "19" NO-LOCK NO-ERROR.
                                         
RUN anp\esan002.p(INPUT  4417810094176014,
                  INPUT  estabelec.cgc,
                  OUTPUT c-retorno-cgc,
                  OUTPUT i-id-cliente,
                  OUTPUT c-erro-geral).

MESSAGE c-erro-geral
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
