DEFINE VARIABLE c1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c2 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c3 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c4 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c5 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c6 AS CHARACTER   NO-UNDO EXTENT 12.

RUN esp\esapi300.p(INPUT "00391442082",
                   INPUT "0062813",
                   INPUT YES,
                   INPUT NO,
                   INPUT NO,
                   OUTPUT c1,
                   OUTPUT c2,
                   OUTPUT c3,
                   OUTPUT c4,
                   OUTPUT c5,
                   OUTPUT c6).

MESSAGE c1  SKIP
        c2  SKIP
        c3  SKIP
        c4  SKIP
        c5  SKIP
        c6[1]
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
