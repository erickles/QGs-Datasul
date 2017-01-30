DEFINE VARIABLE cDir        AS CHARACTER NO-UNDO INITIAL '\\srvvm27\pedmobile_producao$\Backup'.
DEFINE VARIABLE cFileStream AS CHARACTER NO-UNDO.
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE cComando AS CHARACTER   NO-UNDO.

INPUT FROM OS-DIR (cDir) ECHO.

REPEAT:
    IMPORT cFileStream.
    FILE-INFO:FILE-NAME = cDir + cFileStream.

    IF NOT cFileStream BEGINS "." THEN DO:

        FIND FIRST pm-rep-param WHERE pm-rep-param.ind_situacao = 4
                                  AND pm-rep-param.cod_rep      = INTE(TRIM(cFileStream))
                                  NO-LOCK NO-ERROR.
        
        IF AVAIL pm-rep-param THEN DO:

            FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = pm-rep-param.cod_rep
                                         AND es-repres-comis.situacao = 3
                                         NO-LOCK NO-ERROR.
            IF AVAIL es-repres-comis THEN DO:

                iCont = iCont + 1.

                cComando = "RMDIR " + "\\srvvm27\pedmobile_producao$\Backup\" + cFileStream.
                /*
                DISPLAY cFileStream FORMAT "X(18)" LABEL 'Nome da pasta'
                        FILE-INFO:FULL-PATHNAME FORMAT "X(21)" LABEL 'FULL-PATHNAME'
                        FILE-INFO:PATHNAME FORMAT "X(21)" LABEL 'PATHNAME'
                        FILE-INFO:FILE-TYPE FORMAT "X(5)" LABEL 'FILE-TYPE'
                        cComando FORMAT "X(60)".
                */
                OS-COMMAND SILENT VALUE(cComando).
            END.
                            
        END.

    END.
        
END.

MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
