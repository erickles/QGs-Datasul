DEF VAR v_mem   AS MEMPTR       NO-UNDO.
DEF VAR v_dados AS CHARACTER    NO-UNDO.
DEF VAR v_cont  AS INTEGER      NO-UNDO.

{include/i-freeac.i}

FILE-INFO:FILE-NAME = 'C:\concorrente_tortuga.txt'.

SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

INPUT FROM VALUE(FILE-INFO:FILE-NAME).
    IMPORT v_mem.
INPUT CLOSE.

v_dados = GET-STRING(v_mem,1).

SET-SIZE(v_mem)= 0.
DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):
    
    
    CREATE es-concorrente.
    ASSIGN es-concorrente.sequencia         = v_cont
           es-concorrente.nome-concorrente  = CAPS(fn-free-accent(ENTRY(v_cont, v_dados, CHR(10)))).
    
    /*
    MESSAGE v_cont 
            CAPS(fn-free-accent(ENTRY(v_cont, v_dados, CHR(10))))
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
END.
