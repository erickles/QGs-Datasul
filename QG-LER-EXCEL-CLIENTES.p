DEFINE VARIABLE idx         AS INTEGER     NO-UNDO.
DEFINE VARIABLE contador    AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-emitente      AS INTEGER    
    FIELD email             AS CHAR FORMAT "X(60)"
    FIELD novo              AS LOGICAL.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Hell.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";" 
    tt-planilha.cod-emitente
    tt-planilha.email.
END.
INPUT CLOSE.

FOR EACH tt-planilha:

    FIND FIRST emitente WHERE emitente.cod-emitente = tt-planilha.cod-emitente NO-LOCK NO-ERROR.
    /*
    FIND FIRST cont-emit WHERE cont-emit.cod-emitente = tt-planilha.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL cont-emit THEN
        ASSIGN tt-planilha.email = cont-emit.e-mail.
    */
    
    IF emitente.data-implant >= 05/01/2011 AND
       emitente.data-implant <= TODAY  THEN
        tt-planilha.novo = YES.
        
END.

OUTPUT TO "C:\Helatorio.CSV".

PUT "Cod Cliente"         ";"
    "Mail"       ";"
    "Novo"      SKIP.

FOR EACH tt-planilha NO-LOCK:
    PUT tt-planilha.cod-emitente              ";"
        tt-planilha.email                     ";"
        tt-planilha.novo                      SKIP.
        
END.

OUTPUT CLOSE.
