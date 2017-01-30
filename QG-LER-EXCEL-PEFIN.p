DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD tipo          AS CHAR
    FIELD especie       AS CHAR
    FIELD valor         AS DECI
    FIELD cod-estab     AS CHAR FORMAT "99"
    FIELD titulo        AS CHAR FORMAT "9999999"
    FIELD serie         AS CHAR
    FIELD parcela       AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\exclusao2.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.tipo
    tt-planilha.especie
    tt-planilha.valor
    tt-planilha.cod-estab
    tt-planilha.titulo
    tt-planilha.serie
    tt-planilha.parcela.

END.
INPUT CLOSE.

FOR EACH tt-planilha:

    IF LENGTH(tt-planilha.cod-estab) = 1 THEN
        ASSIGN tt-planilha.cod-estab = "0" + tt-planilha.cod-estab.

    IF LENGTH(tt-planilha.titulo) < 7 THEN DO:
        ASSIGN tt-planilha.titulo = FILL("0",7 - LENGTH(tt-planilha.titulo)) + tt-planilha.titulo.
    END.

    IF LENGTH(tt-planilha.parcela) = 1 THEN
        ASSIGN tt-planilha.parcela = "0" + tt-planilha.parcela.

    FIND es-titulo-cr WHERE es-titulo-cr.ep-codigo   = 1
                        AND es-titulo-cr.cod-estabel = tt-planilha.cod-estab
                        AND es-titulo-cr.cod-esp     = "DP"
                        AND es-titulo-cr.serie       = tt-planilha.serie
                        AND es-titulo-cr.nr-docto    = tt-planilha.titulo
                        AND es-titulo-cr.parcela     = tt-planilha.parcela
                        NO-ERROR.

    IF AVAIL es-titulo-cr THEN DO:
        /*UPDATE es-titulo-cr.situacao-pefin.*/

        DISP tt-planilha.tipo               SKIP
             tt-planilha.especie            SKIP
             tt-planilha.cod-estab          SKIP
             tt-planilha.titulo             SKIP
             tt-planilha.serie              SKIP
             tt-planilha.parcela            SKIP
             es-titulo-cr.situacao-pefin    SKIP
             es-titulo-cr.tem-pefin
             WITH 1 COL.
        ASSIGN es-titulo-cr.tem-pefin = NO.
        /*ASSIGN es-titulo-cr.situacao-pefin = 6.*/

    END.

    /*
    DISP tt-planilha.tipo       SKIP
         tt-planilha.especie    SKIP
         tt-planilha.cod-estab  SKIP
         tt-planilha.titulo     SKIP
         tt-planilha.serie      SKIP
         tt-planilha.parcela    WITH 1 COL.
    */
    
END.
