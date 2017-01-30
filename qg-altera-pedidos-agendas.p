DEF VAR v_mem   AS MEMPTR       NO-UNDO.
DEF VAR v_dados AS CHARACTER    NO-UNDO.
DEF VAR v_cont  AS INTEGER      NO-UNDO.

FILE-INFO:FILE-NAME = 'C:\PEDIDOS_RS.txt'.

SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

INPUT FROM VALUE(FILE-INFO:FILE-NAME).
    IMPORT v_mem.
INPUT CLOSE.

v_dados = GET-STRING(v_mem,1).

SET-SIZE(v_mem)= 0.
DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):

    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = TRIM(ENTRY(v_cont, v_dados, CHR(10))) EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN DO:
        ASSIGN ws-p-venda.ind-sit-ped = 22.
    END.
    /*
    MESSAGE ENTRY(v_cont, v_dados, CHR(10))
        VIEW-AS alert-BOX INFO BUTTONS OK.
    */
END.
