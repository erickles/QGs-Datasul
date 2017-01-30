FIND sit-nf-eletro WHERE
     sit-nf-eletro.cod-estabel   = "05"     AND
     sit-nf-eletro.cod-serie     = "1"      AND
     sit-nf-eletro.cod-nota-fisc = "0055236"  NO-ERROR.

IF NOT AVAIL sit-nf-eletro THEN NEXT.

MESSAGE AVAIL sit-nf-eletro
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

ASSIGN sit-nf-eletro.idi-sit-nf-eletro = 3.
