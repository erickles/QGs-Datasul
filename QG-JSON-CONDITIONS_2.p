DEFINE VARIABLE text-string AS CHARACTER FORMAT "x(76)".
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE cTexto AS CHARACTER   NO-UNDO.
INPUT FROM "C:\Temp\jsonConditions.json".

OUTPUT TO "C:\Temp\jsonConditions2.json".

DO WHILE TRUE ON ENDKEY UNDO, LEAVE:

   IMPORT UNFORMATTED text-string.

    DO iCont = 1 TO 7200:

        ASSIGN cTexto = ""
               cTexto = "/* " + STRING(iCont) + " */".

        IF INDEX(text-string,cTexto) <> 0 THEN DO:
            ASSIGN text-string = REPLACE(text-string, cTexto, ",").
            LEAVE.
        END.

    END.

    PUT text-string SKIP.

   /*
   DISPLAY text-string WITH DOWN FRAME x.
   DOWN WITH FRAME x NO-LABELS.
   */
END.

INPUT CLOSE.

OUTPUT CLOSE.
