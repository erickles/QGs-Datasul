DEFINE VARIABLE c-path AS CHARACTER   NO-UNDO FORMAT "X(160)".
DEFINE VARIABLE cDirOrigem AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hAcomp     AS HANDLE      NO-UNDO.
DEFINE VARIABLE cDestino   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPathBase  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i          AS INTEGER     NO-UNDO.
DEFINE VARIABLE cPasta     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-emissao-pedido AS DATE    NO-UNDO.

DEF VAR v_mem   AS MEMPTR       NO-UNDO.
DEF VAR v_dados AS CHARACTER    NO-UNDO.
DEF VAR v_cont  AS INTEGER      NO-UNDO.

DEFINE VARIABLE c-arquivo AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE ttPedidosNaoImplantados NO-UNDO
    FIELD nr-pedcli LIKE ws-p-venda.nr-pedcli
    FIELD full-name AS CHARACTER FORMAT "x(200)"
    INDEX idxNrPedcli IS PRIMARY nr-pedcli.

DEFINE TEMP-TABLE ttFile NO-UNDO
    FIELD cPathName   AS CHARACTER FORMAT "X(200)"
    FIELD cName       AS CHARACTER
    FIELD fileType    AS CHARACTER
    FIELD cFullName   AS CHARACTER FORMAT "x(200)"
    FIELD Data-Transm-Pedmobile AS DATE     
    FIELD Hora-Transm-Pedmobile AS INTEGER 
    INDEX idxName IS PRIMARY cFullName.

DEFINE TEMP-TABLE ttRepres
    FIELD codRep      AS INTEGER
    FIELD cFullDir    AS CHARACTER
    INDEX idxRep IS PRIMARY UNIQUE codRep cFullDir.


c-path = "Y:\Backup".


/* OUTPUT TO "C:\teste.csv".                                              */
/* FOR EACH ws-p-venda WHERE ws-p-venda.dt-impl = 07/26/2011 AND          */
/*                           SUBSTRING(ws-p-venda.char-2,25,1) = 'S'      */
/*                           NO-LOCK:                                     */
/*                                                                        */
/*     PUT ws-p-venda.nr-pedcli                ";"                        */
/*         ws-p-venda.dt-impl                  ";"                        */
/*         c-path + "\" + STRING(ws-p-venda.no-ab-reppri) FORMAT "X(256)" */
/*         SKIP.                                                          */
/* END.                                                                   */
/*                                                                        */
/* OUTPUT CLOSE.                                                          */

RUN readDir("Y:\Backup\1932",YES).

FOR EACH ttFile NO-LOCK:
    DISP ttFile.Data-Transm-Pedmobile.
END.

PROCEDURE readDir :

    DEFINE INPUT PARAMETER cDir       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER lRecursive AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cName             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDiretorio        AS CHARACTER   NO-UNDO.
    
    INPUT FROM OS-DIR (cDir).

    blk_pedido:
    REPEAT:
        MESSAGE "1" cName
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        IMPORT cName.

        IF cName EQ '.'  OR 
           cName EQ '..' THEN NEXT.
        
        FILE-INFO:FILE-NAME = cDir + '\' + cName.

        IF FILE-INFO:FILE-TYPE BEGINS 'D' THEN
            cDiretorio = FILE-INFO:FILE-NAME.

        SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

        c-arquivo = FILE-INFO:FILE-NAME.
        MESSAGE "2"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        INPUT FROM VALUE(c-arquivo) NO-CONVERT.
            IMPORT v_mem.
        INPUT CLOSE.

        v_dados = GET-STRING(v_mem,1).

        SET-SIZE(v_mem)= 0.
        DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):

        
            MESSAGE ENTRY(v_cont, v_dados, CHR(10))
                VIEW-AS alert-BOX INFO BUTTONS OK.

        END.

        IF (cDir <> cDirOrigem) AND FILE-INFO:FILE-CREATE-DATE >= dt-emissao-pedido THEN DO:

            CREATE ttFile.
            ASSIGN ttFile.cPathName = cDir
                   ttFile.cName     = cName
                   ttFile.cFullName = FILE-INFO:FILE-NAME
                   ttFile.fileType  = FILE-INFO:FILE-TYPE
                   ttFile.Data-Transm-Pedmobile = FILE-INFO:FILE-CREATE-DATE 
                   ttFile.Hora-Transm-Pedmobile = INTEGER(FILE-INFO:FILE-CREATE-TIME). 
            
        END.
        ELSE DO:
            IF  FILE-INFO:FILE-TYPE BEGINS 'D' THEN DO:
                FIND ttRepres NO-LOCK
                    WHERE ttRepres.codRep = INT(cName) NO-ERROR.
                IF NOT AVAIL ttRepres THEN DO:

                    CREATE ttRepres.
                    ASSIGN ttRepres.codRep   = INT(cName)
                           ttRepres.cFullDir = FILE-INFO:FILE-NAME.

                END.
            END.
        END.
        
        IF  FILE-INFO:FILE-TYPE BEGINS 'D' AND 
            lRecursive                     THEN

            RUN ReadDir( INPUT FILE-INFO:FILE-NAME, 
                         INPUT YES).

    END.

    INPUT CLOSE.

END PROCEDURE.
