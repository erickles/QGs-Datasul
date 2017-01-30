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

DEFINE VARIABLE cDirOrigem AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hAcomp     AS HANDLE      NO-UNDO.
DEFINE VARIABLE cDestino   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cPathBase  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i          AS INTEGER     NO-UNDO.
DEFINE VARIABLE cPasta     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dt-emissao-pedido AS DATE    NO-UNDO.

EMPTY TEMP-TABLE ttFile.
EMPTY TEMP-TABLE ttRepres.
EMPTY TEMP-TABLE ttPedidosNaoImplantados.

ASSIGN cPathBase = "\\BOVIGOLD\PEDMOBILE_PRODUCAO\".

MESSAGE "Informe a data de inicio para analisar os arquivos"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

UPDATE dt-emissao-pedido.

RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
RUN pi-inicializar IN hAcomp(INPUT "Analisando...").

DO i = 1 TO 2:
    CASE i:
        WHEN 1 THEN
        DO:
            ASSIGN cPasta     = "Backup"
                   cDirOrigem = cPathBase + cPasta + "\".
        END.
        WHEN 2 THEN
        DO:
            ASSIGN 
                cPasta     = "Arquivos com erro"
                cDirOrigem = cPathBase + cPasta + "\".
        END.
    END CASE.
    RUN readDir (cDirOrigem, YES).
END.


PROCEDURE readDir :

    DEFINE INPUT PARAMETER cDir       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER lRecursive AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cName             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDiretorio        AS CHARACTER   NO-UNDO.
    
    INPUT FROM OS-DIR (cDir).

    blk_pedido:
    REPEAT:
        
        IMPORT cName.

        IF cName EQ '.'  OR 
           cName EQ '..' THEN NEXT.
        
        FILE-INFO:FILE-NAME = cDir + '\' + cName.
        
        IF FILE-INFO:FILE-TYPE BEGINS 'D' THEN
            cDiretorio = FILE-INFO:FILE-NAME.

        RUN pi-acompanhar IN hAcomp (INPUT "Diret¢rio: " + cDiretorio + "-" + "Arquivo: " + FILE-INFO:FILE-NAME).
    
        IF (cDir <> cDirOrigem) AND FILE-INFO:FILE-CREATE-DATE >= dt-emissao-pedido THEN DO:

            CREATE ttFile.
            ASSIGN 
                ttFile.cPathName = cDir
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
                    ASSIGN 
                        ttRepres.codRep   = INT(cName)
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

FOR EACH ttFile NO-LOCK
    WHERE ttFile.fileType <> "D"
      and ttFile.Data-Transm-Pedmobile >= dt-emissao-pedido
    :

    RUN pi-acompanhar IN hAcomp (INPUT "Verif Arq: " + ttFile.cFullName).
    RUN piVerificaArquivo (INPUT ttFile.cFullName,
                           INPUT ttFile.cPathName).
END.

OUTPUT TO c:\temp\pedidos_backup_nao_incluidos.csv.
FOR EACH ttPedidosNaoImplantados:
    
    cDestino = REPLACE(ttPedidosNaoImplantados.full-name,cPasta,"AREA TRANSFERENCIA").
    OS-COPY VALUE(ttPedidosNaoImplantados.full-name) VALUE(cDestino).
    
    PUT
        nr-pedcli ";"
        SKIP
        .
        
END.
OUTPUT CLOSE.

RUN pi-finalizar IN hAcomp.

PROCEDURE piVerificaArquivo:

    DEFINE INPUT PARAMETER pcFileImport AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcDirImport  AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE cLinha        AS CHARACTER NO-UNDO FORMAT "X(2000)".
    DEFINE VARIABLE cTipoRegistro AS character NO-UNDO.
    
    INPUT FROM VALUE(pcFileImport). 
    REPEAT:
        IMPORT UNFORMATTED cLinha. 
        ASSIGN cTipoRegistro   = SUBSTRING(cLinha,1,1).
        IF cTipoRegistro = "1" THEN DO:
            FIND FIRST ws-p-venda 
                 WHERE ws-p-venda.nr-pedcli = SUBSTRING(cLinha,790,12) NO-LOCK NO-ERROR.
            IF NOT AVAIL ws-p-venda THEN DO:
                CREATE ttPedidosNaoImplantados.
                ASSIGN
                    ttPedidosNaoImplantados.nr-pedcli = SUBSTRING(cLinha,790,12)
                    ttPedidosNaoImplantados.full-name = pcFileImport
                    .
            END.
        END.
    END.
    INPUT CLOSE.

END PROCEDURE.

