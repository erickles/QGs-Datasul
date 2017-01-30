OUTPUT TO "c:\clientes_nota.csv".

DEFINE VARIABLE cliente-novo AS CHARACTER   NO-UNDO.
DEFINE VARIABLE email AS CHARACTER FORMAT "X(60)"  NO-UNDO.
DEFINE VARIABLE email-nfe AS CHARACTER FORMAT "X(60)"  NO-UNDO.
DEFINE BUFFER bf-nota-fiscal FOR nota-fiscal.

PUT "NR NOTA"       ";"
    "DT NOTA"       ";"
    "COD CLIENTE"   ";"
    "EMAIL NFE"     ";"
    "EMAIL COMUM"   ";"
    "NOVO\ANTIGO"   ";"
    "CONTAGEM"      ";"
    "CONTAGEM 2"      ";"
    SKIP.

FOR EACH nota-fiscal NO-LOCK WHERE nota-fiscal.dt-emis >= 05/01/2011
                               AND nota-fiscal.dt-emis <= 04/13/2012
                               AND nota-fiscal.emite-duplic,
                               EACH emitente OF nota-fiscal
                               BREAK BY nota-fiscal.cod-emitente:

    FIND FIRST cont-emit WHERE cont-emit.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    FIND FIRST bf-nota-fiscal WHERE bf-nota-fiscal.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL bf-nota-fiscal 
         AND bf-nota-fiscal.dt-emis < 05/01/2011 THEN
        cliente-novo = "ANTIGO".
    ELSE
        cliente-novo = "NOVO".

    IF AVAIL cont-emit THEN
        ASSIGN email-nfe = REPLACE(cont-emit.e-mail,";","|").
    ELSE email-nfe = "".

    IF TRIM(email-nfe) = "@" THEN NEXT.
    IF INDEX(email-nfe,"@") = 0 THEN NEXT.
    email-nfe = REPLACE(email-nfe,CHR(10),"").

    email = REPLACE(emitente.e-mail,";","|").

    /*IF FIRST-OF(nota-fiscal.cod-emitente) THEN DO:*/
        PUT nota-fiscal.nr-nota-fis         ";"
            nota-fiscal.dt-emis             ";"
            nota-fiscal.cod-emitente        ";"
            email-nfe                       ";"
            email                           ";"
            cliente-novo                    ";"
            "1"                             ";"
            IF FIRST-OF(nota-fiscal.cod-emitente) THEN "1" ELSE "" ";"
            SKIP.
    /*END.*/

END.

OUTPUT CLOSE.
