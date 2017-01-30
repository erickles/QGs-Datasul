DEF VAR v_mem   AS MEMPTR       NO-UNDO.
DEF VAR v_dados AS CHARACTER    NO-UNDO.
DEF VAR v_cont  AS INTEGER      NO-UNDO.

DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FILE-INFO:FILE-NAME = 'C:\Temp\portador_112.txt'.

SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

INPUT FROM VALUE(FILE-INFO:FILE-NAME).
    IMPORT v_mem.
INPUT CLOSE.

v_dados = GET-STRING(v_mem,1).

OUTPUT TO "c:\Temp\portadores_para_112.csv".
PUT "emitente;portador" SKIP.

SET-SIZE(v_mem)= 0.
DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):    

    /*DISP INTE(ENTRY(v_cont, v_dados, CHR(10))).*/
    
    FIND FIRST emitente WHERE emitente.cod-emitente = INTE(ENTRY(v_cont, v_dados, CHR(10))).
    IF AVAIL emitente AND emitente.identific = 1 THEN DO:

        IF emitente.portador <> 112 THEN DO:
            
            ASSIGN emitente.portador = 112
                   emitente.port-prefer = 112.

            PUT emitente.cod-emitente ";"
                emitente.portador     SKIP.

        END.
        /*iCont = iCont + 1.*/
    END.
    
    /*
    MESSAGE ENTRY(v_cont, v_dados, CHR(10))
        VIEW-AS alert-BOX INFO BUTTONS OK.
    */
END.
OUTPUT CLOSE.
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
