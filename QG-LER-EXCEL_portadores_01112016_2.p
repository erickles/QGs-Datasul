DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-emitente  LIKE emitente.cod-emitente
    FIELD portador      AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Temp\portadores2.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.cod-emitente
    tt-planilha.portador.

END.

INPUT CLOSE.

FOR EACH tt-planilha:

    IF tt-planilha.cod-emitente <> 0 THEN DO:

        FIND FIRST emitente WHERE emitente.cod-emitente = tt-planilha.cod-emitente NO-ERROR.
        IF AVAIL emitente THEN DO:
            
            IF emitente.port-pref = 112 THEN DO:

                emitente.port-pref = 34110.

                FIND FIRST clien_financ WHERE clien_financ.cdn_cliente = emitente.cod-emitente NO-ERROR.
                IF AVAIL clien_financ THEN
                    clien_financ.cod_portad_prefer = "34110".
                iCont = iCont + 1.
            END.

        END.

    END.

END.

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
