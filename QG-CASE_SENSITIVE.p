DEFINE VARIABLE cTextoIni   AS CHARACTER   NO-UNDO LABEL "Inicio".
DEFINE VARIABLE cTextoFim   AS CHARACTER   NO-UNDO LABEL "Fim".
DEFINE VARIABLE lDiferente  AS LOGICAL     NO-UNDO.

FUNCTION fnTextoDiferente RETURNS LOGICAL (INPUT cTextoOri AS CHAR,
                                           INPUT cTextodes AS CHAR):

    DEFINE VARIABLE cTexto        AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE i             AS INTEGER          NO-UNDO.

    ASSIGN cTexto    = "".

    DO i = 1 TO LENGTH(cTextoOri):
        ASSIGN cTexto = cTexto + STRING(ASC(SUBSTR(cTextoOri,i,1))).
    END.
    ASSIGN cTextoOri = cTexto
            cTexto     = "".

    DO i = 1 TO LENGTH(cTextoDes):
        ASSIGN cTexto = cTexto + STRING(ASC(SUBSTR(cTextoDes,i,1))).
    END.

    ASSIGN cTextoDes = cTexto.

    IF cTextoOri = cTextoDes THEN
        RETURN FALSE.
    ELSE
        RETURN TRUE.
    
END FUNCTION.

MESSAGE fnTextoDiferente("009/11-b","009/11-B")
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE piTextoDiferente:

    DEFINE INPUT    PARAMETER cTextoOri     AS CHARACTER    NO-UNDO.
    DEFINE INPUT    PARAMETER cTextoDes     AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT   PARAMETER lDiferente    AS LOGICAL      NO-UNDO.

    DEFINE VARIABLE cTexto        AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE i             AS INTEGER          NO-UNDO.

    ASSIGN cTexto    = "".

    DO i = 1 TO LENGTH(cTextoOri):
        ASSIGN cTexto = cTexto + STRING(ASC(SUBSTR(cTextoOri,i,1))).
    END.
    ASSIGN cTextoOri = cTexto
            cTexto     = "".

    DO i = 1 TO LENGTH(cTextoDes):
        ASSIGN cTexto = cTexto + STRING(ASC(SUBSTR(cTextoDes,i,1))).
    END.

    ASSIGN cTextoDes = cTexto.

    IF cTextoOri = cTextoDes THEN
        lDiferente = FALSE.
    ELSE
        lDiferente = TRUE.

END PROCEDURE.
