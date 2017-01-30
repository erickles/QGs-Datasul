DEFINE VARIABLE i-ultimo-dia-mes    AS INTEGER  NO-UNDO.
DEFINE VARIABLE i-mes               AS INTEGER  NO-UNDO.
DEFINE VARIABLE i-mes-p             AS INTEGER  NO-UNDO.
DEFINE VARIABLE i-ano               AS INTEGER  NO-UNDO.
DEFINE VARIABLE dt-data-ini         AS DATE     FORMAT "99/99/9999" NO-UNDO.
DEFINE VARIABLE dt-data-fim         AS DATE     FORMAT "99/99/9999" NO-UNDO.

UPDATE i-mes.

IF i-mes = 12 THEN
    ASSIGN i-ano   = YEAR(TODAY) + 1
           i-mes-p = 01.
ELSE
    ASSIGN i-ano   = YEAR(TODAY)
           i-mes-p = i-mes + 1.

ASSIGN dt-data-ini = DATE("01/" + STRING(i-mes) + "/" + STRING(YEAR(TODAY)))
       dt-data-fim = DATE("01/" + STRING(i-mes-p) + "/" + STRING(i-ano)).

ASSIGN i-ultimo-dia-mes = INTERVAL(dt-data-fim, dt-data-ini, "DAYS").

MESSAGE i-ultimo-dia-mes
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
