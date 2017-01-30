DEFINE VARIABLE v_mem   AS MEMPTR       NO-UNDO.
DEFINE VARIABLE v_dados AS CHARACTER    NO-UNDO.
DEFINE VARIABLE v_cont  AS INTEGER      NO-UNDO.

DEFINE VARIABLE i-ttfile AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE ttFile NO-UNDO
    FIELD cPathName             AS CHARACTER FORMAT "X(200)"
    FIELD cName                 AS CHARACTER
    FIELD fileType              AS CHARACTER
    FIELD cFullName             AS CHARACTER
    FIELD Data-Transm-Pedmobile AS DATE     /*KSR - 31.01.2009*/
    FIELD Hora-Transm-Pedmobile AS INTEGER /*KSR - 31.01.2009*/
    INDEX idxName IS PRIMARY cFullName.

OUTPUT TO "c:\pedidos.csv".

FOR EACH ws-p-venda WHERE ws-p-venda.dt-impl = 07/26/2011 AND         
                          SUBSTRING(ws-p-venda.char-2,25,1) = 'S'     
                          NO-LOCK BREAK BY ws-p-venda.no-ab-reppri:

    IF FIRST-OF(ws-p-venda.no-ab-reppri) THEN
        RUN readDir ("Y:\Backup\" + ws-p-venda.no-ab-reppri, YES, NO).
    
END.

/* FIND FIRST ttFile WHERE ttFile.cFullName = "Y:\Backup\1050\0105014062011140227.TXT" NO-LOCK NO-ERROR. */
/*                                                                                                       */
/* FILE-INFO:FILE-NAME = "Y:\Backup\1932\3193206052011153658.TXT".                                       */
/*                                                                                                       */
/* SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.                                                                 */
/*                                                                                                       */
/* INPUT FROM VALUE(FILE-INFO:FILE-NAME).                                                                */
/*     IMPORT v_mem.                                                                                     */
/* INPUT CLOSE.                                                                                          */
/*                                                                                                       */
/* v_dados = GET-STRING(v_mem,1).                                                                        */
/*                                                                                                       */
/* SET-SIZE(v_mem)= 0.                                                                                   */
/*                                                                                                       */
/* DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):                                                         */
/*                                                                                                       */
/*     IF SUBSTRING(ENTRY(v_cont, v_dados, CHR(10)),1,1) = "1" THEN                                      */
/*         MESSAGE SUBSTRING(ENTRY(v_cont, v_dados, CHR(10)),1,1)                                        */
/*                 SUBSTRING(ENTRY(v_cont, v_dados, CHR(10)),790,12)                                     */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.                                                    */
/*                                                                                                       */
/* END.                                                                                                  */

FOR EACH ttFile NO-LOCK:
                              
    SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

    INPUT FROM VALUE(ttFile.cFullName).
        IMPORT v_mem.
    INPUT CLOSE.

    v_dados = GET-STRING(v_mem,1).

    SET-SIZE(v_mem)= 0.

    DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):
        
        FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = SUBSTRING(ENTRY(v_cont, v_dados, CHR(10)),790,12)
            NO-LOCK NO-ERROR.
        IF SUBSTRING(ENTRY(v_cont, v_dados, CHR(10)),1,1) = "1" THEN            
            PUT cPathName                   FORMAT "X(80)"          ";"
                cName                       FORMAT "X(80)"          ";"
                fileType                                            ";"
                cFullName                   FORMAT "X(80)"          ";"
                Data-Transm-Pedmobile                               ";"
                Hora-Transm-Pedmobile                               ";"
                ws-p-venda.dt-impl                                  ";"
                SUBSTRING(ENTRY(v_cont, v_dados, CHR(10)),790,12)   SKIP.        
    END.
END.   

OUTPUT CLOSE.

PROCEDURE readDir:

    DEFINE INPUT PARAMETER cDir       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER lRecursive AS LOGICAL   NO-UNDO.
    DEFINE INPUT PARAMETER lLeave     AS LOGICAL   NO-UNDO.

    DEFINE VARIABLE cName    AS CHARACTER  NO-UNDO.

    INPUT FROM OS-DIR (cDir).

    REPEAT:

        IMPORT cName.
        
        IF cName EQ '.'  OR cName EQ '..' THEN NEXT.
        
        FILE-INFO:FILE-NAME = cDir + '\' + cName.    

        IF INDEX(FILE-INFO:FILE-NAME,".TXT") > 1 THEN DO: /*Sà CONTROLA OS ARQUIVOS .TXT*/            
                
                CREATE ttFile.
                ASSIGN ttFile.cPathName = /*FILE-INFO:FILE-NAME*/ cDir
                       ttFile.cName     = cName
                       ttFile.cFullName = FILE-INFO:FILE-NAME
                       ttFile.fileType  = FILE-INFO:FILE-TYPE
                       ttFile.Data-Transm-Pedmobile = FILE-INFO:FILE-CREATE-DATE /*KSR - 31.01.2009 - data de cria»’o do arquivo no ftp*/
                       ttFile.Hora-Transm-Pedmobile = INTEGER(FILE-INFO:FILE-CREATE-TIME). /*KSR - 31.01.2009 - data de cria»’o do arquivo no ftp*/                                   
    
                IF FILE-INFO:FILE-TYPE BEGINS 'F' AND lLeave THEN LEAVE.            
        END.
               
        IF  FILE-INFO:FILE-TYPE BEGINS 'D' AND 
            lRecursive                     THEN
            RUN ReadDir( INPUT FILE-INFO:FILE-NAME, 
                         INPUT YES,
                         INPUT lLeave).

    END.

    INPUT CLOSE.

END PROCEDURE.
