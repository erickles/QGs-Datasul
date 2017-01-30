DEFINE TEMP-TABLE tt-planilha-a NO-UNDO
    FIELD cod-fornec        AS INTE
    FIELD cod-grupo         AS INTE
    FIELD cod-estabel       AS CHAR
    FIELD serie             AS CHAR
    FIELD titulo            AS CHAR
    FIELD parcela           AS CHAR
    FIELD valor             AS DECI
    FIELD especie           AS CHAR.

DEFINE TEMP-TABLE tt-planilha-b NO-UNDO
    FIELD cod-empresa       AS CHAR
    FIELD cod-estabel       AS CHAR
    FIELD titulo            AS CHAR
    FIELD serie             AS CHAR    
    FIELD parcela           AS CHAR
    FIELD especie           AS CHAR.

EMPTY TEMP-TABLE tt-planilha-a.
EMPTY TEMP-TABLE tt-planilha-b.

INPUT FROM "C:\PLAN_A.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha-a.
   IMPORT DELIMITER ";"
    tt-planilha-a.cod-fornec
    tt-planilha-a.cod-grupo
    tt-planilha-a.cod-estabel
    tt-planilha-a.especie
    tt-planilha-a.serie
    tt-planilha-a.titulo
    tt-planilha-a.parcela
    tt-planilha-a.valor.

END.
INPUT CLOSE.

INPUT FROM "C:\PLAN_B.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha-b.
   IMPORT DELIMITER ";"
    tt-planilha-b.cod-empresa
    tt-planilha-b.cod-estabel
    tt-planilha-b.titulo
    tt-planilha-b.serie
    tt-planilha-b.parcela
    tt-planilha-b.especie.

END.
INPUT CLOSE.

OUTPUT TO "c:\titulos_faltantes.csv.".

FOR EACH tt-planilha-a NO-LOCK:

    FIND FIRST tt-planilha-b WHERE tt-planilha-b.titulo      = tt-planilha-a.titulo
                               AND tt-planilha-b.cod-estabel = tt-planilha-a.cod-estabel
                               AND tt-planilha-b.parcela     = tt-planilha-a.parcela
                               AND tt-planilha-b.serie       = tt-planilha-a.serie
                               NO-LOCK NO-ERROR.
    
    IF NOT AVAIL tt-planilha-b THEN
        PUT tt-planilha-a.cod-fornec    ";"
            tt-planilha-a.cod-grupo     ";"
            tt-planilha-a.cod-estabel   ";"
            tt-planilha-a.serie         ";"
            tt-planilha-a.titulo        ";"
            tt-planilha-a.parcela       ";"
            tt-planilha-a.valor         SKIP.
END.

OUTPUT CLOSE.
