DEF VAR v_mem   AS MEMPTR       NO-UNDO.
DEF VAR v_dados AS CHARACTER    NO-UNDO.
DEF VAR v_cont  AS INTEGER      NO-UNDO.

OUTPUT TO "c:\cgc-grife.csv".

FILE-INFO:FILE-NAME = 'C:\cgcs-grifes.txt'.

SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

INPUT FROM VALUE(FILE-INFO:FILE-NAME).
    IMPORT v_mem.
INPUT CLOSE.

v_dados = GET-STRING(v_mem,1).

SET-SIZE(v_mem)= 0.
DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):

    FIND FIRST emitente WHERE emitente.cgc = ENTRY(v_cont, v_dados, CHR(10))                            
                           NO-LOCK NO-ERROR.

    IF AVAIL emitente THEN DO:
        PUT UNFORMATTED emitente.cod-emitente   ";"
                        emitente.cgc            ";"
                        emitente.nome-emit      SKIP.
    END.
    
END.

OUTPUT CLOSE.
