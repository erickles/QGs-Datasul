DEF VAR v_mem   AS MEMPTR       NO-UNDO.
DEF VAR v_dados AS CHARACTER    NO-UNDO.
DEF VAR v_cont  AS INTEGER      NO-UNDO.

FILE-INFO:FILE-NAME = 'C:\temp\itemsaude.txt'.

SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

DEFINE VARIABLE cLinha AS CHARACTER   NO-UNDO.

INPUT FROM VALUE(FILE-INFO:FILE-NAME).
    IMPORT v_mem.
INPUT CLOSE.

v_dados = GET-STRING(v_mem,1).

SET-SIZE(v_mem)= 0.
DO v_cont= 2 TO NUM-ENTRIES(v_dados,CHR(10)):
    
    cLinha = ENTRY(v_cont, v_dados, CHR(10)).
    /*
    MESSAGE ENTRY(5,cLinha,";":u)
            VIEW-AS alert-BOX INFO BUTTONS OK.
    */

    IF ENTRY(1,cLinha,";":u) <> "" THEN DO:
        FIND FIRST es-item WHERE es-item.it-codigo = ENTRY(1,cLinha,";":u) EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL es-item THEN
            ASSIGN es-item.desc-item-web = ENTRY(5,cLinha,";":u).
    END.       
    
END.
