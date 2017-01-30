DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-emitente      AS INTEGER
    FIELD nome-emitente     AS CHAR
    FIELD envio             AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Temp\BOLETOS.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.cod-emitente
    tt-planilha.nome-emitente
    tt-planilha.envio.

END.
INPUT CLOSE.

OUTPUT TO "C:\Temp\BOLETOS_.csv".

PUT "CODIGO;NOME;ENVIO" SKIP.

FOR EACH tt-planilha:

    FIND FIRST emitente WHERE emitente.cod-emitente = tt-planilha.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:

        FIND FIRST es-loc-entr WHERE es-loc-entr.nome-abrev  = emitente.nome-abrev
                                 AND es-loc-entr.cod-entrega BEGINS "Padr"
                                 NO-LOCK NO-ERROR.
        IF AVAIL es-loc-entr THEN DO:

            IF es-loc-entr.boleto = 1 THEN
                ASSIGN tt-planilha.envio = "ACOMPANHA NF".
            ELSE
                ASSIGN tt-planilha.envio = "CORREIO".            
            
            PUT UNFORM  tt-planilha.cod-emitente    ";"
                        tt-planilha.nome-emitente   ";"
                        tt-planilha.envio           SKIP.
            
        END.
        ELSE DO:

            FIND FIRST es-loc-entr WHERE es-loc-entr.nome-abrev  = emitente.nome-abrev
                                    NO-LOCK NO-ERROR.

            IF AVAIL es-loc-entr THEN DO:

            IF es-loc-entr.boleto = 1 THEN
                ASSIGN tt-planilha.envio = "ACOMPANHA NF".
            ELSE
                ASSIGN tt-planilha.envio = "CORREIO".            
            
            PUT UNFORM  tt-planilha.cod-emitente    ";"
                        tt-planilha.nome-emitente   ";"
                        tt-planilha.envio           SKIP.
            
            END.
        END.

    END.

END.

OUTPUT CLOSE.
