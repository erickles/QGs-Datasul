DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD portador-orig     AS CHAR
    FIELD portador-dest     AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Temp\portadores.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.cod-emitente
    tt-planilha.portador-orig
    tt-planilha.portador-dest.

END.
INPUT CLOSE.

FOR EACH tt-planilha:

    IF tt-planilha.cod-emitente <> 0 THEN DO:

        FIND FIRST emitente WHERE emitente.cod-emitente = tt-planilha.cod-emitente NO-ERROR.
        IF AVAIL emitente THEN DO:

            IF STRING(emitente.port-pref) <> tt-planilha.portador-dest THEN
                MESSAGE tt-planilha.cod-emitente    SKIP
                        STRING(emitente.port-pref)  SKIP
                        tt-planilha.portador-orig   SKIP
                        tt-planilha.portador-dest
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

            /*
            IF STRING(emitente.port-pref) = tt-planilha.portador-orig THEN DO:
                iCont = iCont + 1.
                /*emitente.port-pref = INTE(tt-planilha.portador-dest).*/
            END.
            ELSE
                MESSAGE tt-planilha.cod-emitente    SKIP
                        STRING(emitente.port-pref)  SKIP
                        tt-planilha.portador-orig   SKIP
                        tt-planilha.portador-dest
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            */
        END.
        /*
        DISP tt-planilha.cod-emitente   SKIP      
             tt-planilha.portador-orig  SKIP
             tt-planilha.portador-dest  WITH 1 COL.
        */

    END.

END.

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
