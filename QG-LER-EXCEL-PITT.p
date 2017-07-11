DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-emitente      AS INTEGER
    FIELD pitt              AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Temp\PITT.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.cod-emitente
    tt-planilha.PITT.
END.
INPUT CLOSE.

OUTPUT TO "C:\Temp\PITT2.csv".

PUT "CODIGO;PITT" SKIP.

FOR EACH tt-planilha WHERE tt-planilha.cod-emitente <> 0:

    FIND FIRST emitente WHERE emitente.cod-emitente = tt-planilha.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:

        FIND FIRST es-emitente-dis WHERE es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL es-emitente-dis THEN DO:            

            PUT UNFORM tt-planilha.cod-emitente ";"
                       STRING(es-emitente-dis.pitt)         SKIP.

        END.

    END.

END.

OUTPUT CLOSE.
