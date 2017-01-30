DEFINE VARIABLE c-nr-nota       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie         AS CHARACTER   NO-UNDO.

UPDATE c-cod-estabel
       c-serie
       c-nr-nota.

FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis    = c-nr-nota
                         AND nota-fiscal.serie          = c-serie
                         AND nota-fiscal.cod-estabel    = c-cod-estabel
                         EXCLUSIVE-LOCK.

ASSIGN nota-fiscal.dt-at-ofest = ?.
