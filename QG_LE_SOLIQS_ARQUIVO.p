DEF VAR v_mem   AS MEMPTR       NO-UNDO.
DEF VAR v_dados AS CHARACTER    NO-UNDO.
DEF VAR v_cont  AS INTEGER      NO-UNDO.

DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE VARIABLE cFile AS CHARACTER NO-UNDO EXTENT 3.

FILE-INFO:FILE-NAME = 'C:\Temp\soliqs.txt'.

SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

INPUT FROM VALUE(FILE-INFO:FILE-NAME).
    IMPORT v_mem.
INPUT CLOSE.

v_dados = GET-STRING(v_mem,1).

SET-SIZE(v_mem)= 0.
DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):

     
    FIND FIRST es-solic-mkt WHERE es-solic-mkt.nr-seq = INTE(ENTRY(v_cont, v_dados, CHR(10))) NO-ERROR.
    IF AVAIL es-solic-mkt THEN DO:
        iCont = iCont + 1.
        es-solic-mkt.nivel-hierarquia = 4.
    END.
    /*
    MESSAGE ENTRY(v_cont, v_dados, CHR(10))
        VIEW-AS alert-BOX INFO BUTTONS OK.
    */
END.

MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
