DEFINE VARIABLE cDiretorio  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cArquivo    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE v_mem       AS MEMPTR       NO-UNDO.
DEFINE VARIABLE v_dados     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cConteudo   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_cont      AS INTEGER     NO-UNDO.
DEFINE VARIABLE cComando    AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE tFile NO-UNDO
    FIELD cPathName  AS CHARACTER FORMAT 'x(50)' 
    FIELD cFileName  AS CHARACTER FORMAT 'x(24)'
    FIELD dtModfied  AS DATE      FORMAT '99/99/9999'
    FIELD inTime     AS INTEGER
    FIELD cTipo      AS CHARACTER FORMAT 'X(5)'
    INDEX tFile-prim AS PRIMARY UNIQUE cPathName cFileName
    INDEX tFile-name cFileName dtModfied inTime.

/* Diretorio dos arquivos GCM */
cDiretorio = "\\bovigold\PedMobile_Producao\gcm".

EMPTY TEMP-TABLE tFile.
RUN ReadDir(cDiretorio, NO).

FOR EACH tFile:

    ASSIGN cArquivo = cPathName + cFileName.

    SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

    INPUT FROM VALUE(cArquivo).
        IMPORT v_mem.
    INPUT CLOSE.

    v_dados = GET-STRING(v_mem,1).

    DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):

        cConteudo = ENTRY(v_cont, v_dados, CHR(10)).
    
    END.

    FIND FIRST es-repres-gcm WHERE es-repres-gcm.cod-rep = INTE(cFileName) NO-ERROR.
    IF NOT AVAIL es-repres-gcm THEN
        CREATE es-repres-gcm.
    ASSIGN es-repres-gcm.cod-rep = INTE(cFileName)
           es-repres-gcm.id-gcm  = cConteudo.

    cComando = "DEL " + cArquivo.
    
    OS-COMMAND SILENT "DEL " + VALUE(cComando).

    /*
    MESSAGE cFileName   SKIP
            cConteudo
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
END.

PROCEDURE ReadDir:

    DEFINE INPUT PARAMETER cDir       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER lRecursive AS LOGICAL   NO-UNDO.
   
    DEFINE VARIABLE cFile AS CHARACTER NO-UNDO EXTENT 3.

    INPUT FROM OS-DIR( cDir ).
    REPEAT:
        IMPORT cFile.
      
        /* Skip current and parent dir */
        IF cFile[1] EQ '.' OR cFile[1] EQ '..' THEN NEXT.
     
        /* We only want to store files in the TT, not dirs */
        IF cFile[3] BEGINS 'F' THEN DO:

            FILE-INFO:FILE-NAME = cFile[2].
        
            FIND FIRST tFile WHERE tFile.cFileName = cFile[1] NO-ERROR.
            IF NOT AVAIL tFile THEN 
                CREATE tFile.

            ASSIGN tFile.cPathName  = REPLACE(cFile[2],cFile[1],'') 
                   tFile.cFileName  = cFile[1]
                   tFile.dtModfied  = FILE-INFO:FILE-MOD-DATE
                   tFile.inTime     = FILE-INFO:FILE-MOD-TIME
                   tFile.cTipo      = FILE-INFO:FILE-TYPE.

        END.
     
        /* Recursive read */
        IF cFile[3] BEGINS 'D' AND lRecursive THEN 
            RUN ReadDir( INPUT cFile[2], INPUT yes ).

    END.
    INPUT CLOSE.

END PROCEDURE.
