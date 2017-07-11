{include/i-buffer.i}

DEFINE VARIABLE c-destino AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-gerente AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRegiao AS CHARACTER    NO-UNDO.

OUTPUT TO "C:\temp\gerentes.csv".

PUT "CODIGO"    ";"
    "NOME"      ";"
    "CARGO"     SKIP.

FOR EACH es-repres-comis NO-LOCK WHERE es-repres-comis.situacao             = 1
                                   AND es-repres-comis.log-1                = NO
                                   AND TRIM(es-repres-comis.u-char-2)       BEGINS "GERENTE":

    FIND FIRST repres WHERE repres.cod-rep = es-repres-comis.cod-rep NO-LOCK NO-ERROR.
    IF AVAIL repres AND NOT repres.nome BEGINS "DSM" AND NOT repres.nome BEGINS "GERENCIA" AND NOT repres.nome BEGINS "ALLIMENTA"   THEN DO:
        PUT UNFORM 
            repres.cod-rep                  ";"
            repres.nome                     ";"
            TRIM(es-repres-comis.u-char-2)  SKIP.
    END.
END.

OUTPUT CLOSE.
