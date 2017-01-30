    DEFINE VARIABLE cProgramZip                 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDiretorySource             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDiretoryDestiny            AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDiretorySourceAssinatura   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDiretoryDestinyAssinatura  AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cCommand                    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE iAmbiente                   AS INTEGER      NO-UNDO.
    DEFINE VARIABLE bytesPedido                 AS MEMPTR       NO-UNDO.
    DEFINE VARIABLE bytesAssinatura             AS MEMPTR       NO-UNDO.
    DEFINE VARIABLE cVersaoSoftware             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hProgDBO                    AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cArqLogImport               AS CHARACTER    NO-UNDO FORMAT "X(90)".

    DEFINE TEMP-TABLE ttError NO-UNDO
        FIELD codErro     AS CHARACTER FORMAT "X(10)"
        FIELD seqErro     AS INTEGER   FORMAT ">>>9"
        FIELD descErro    AS CHARACTER FORMAT "X(250)"
        INDEX idxSeq IS PRIMARY seqErro.

    /* Define o ambiente */   
    IF SUBSTRING(PROPATH,1,2) = "T:" THEN
        ASSIGN iAmbiente = 1. /*PRODU€ÇO*/
    ELSE
        ASSIGN iAmbiente = 2. /*DESENVOLVIMENTO*/
    
    /* Checa se existe os parametros de comunicacao com o cliente */    
    FIND FIRST es-comunica-cliente-param NO-LOCK NO-ERROR.
    IF NOT AVAIL es-comunica-cliente-param THEN LEAVE.
    
    FIND FIRST pm-param-global NO-LOCK NO-ERROR.
    IF NOT AVAIL pm-param-global THEN
        ASSIGN cArqLogImport = SESSION:TEMP-DIRECTORY.
    ELSE 
        ASSIGN cArqLogImport = pm-param-global.dir_log_import.

    ASSIGN cArqLogImport = cArqLogImport + "\" + "logImporPM_" + STRING(TODAY,"99999999") + ".txt".

    RUN esp/espm1090.p PERSISTENT SET hProgDBO.
    
    ASSIGN cProgramZip  = SEARCH("PACL\paext.exe").
    
    IF cProgramZip <> ? OR cProgramZip <> ? THEN DO:    
        FIND FIRST ws-p-import WHERE ws-p-import.nr-pedcli = "1062-2819" EXCLUSIVE-LOCK NO-ERROR.
        IF AVAIL ws-p-import THEN DO:
            
            FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ws-p-import.nr-pedcli NO-LOCK NO-ERROR.
            IF NOT AVAIL ws-p-venda THEN DO:
            
                /* Provisorio */
                ASSIGN cDiretorySource              = IF iAmbiente = 1 THEN pm-param-global.dir_implantacao ELSE pm-param-global.dir_implantacao_DES
                       cDiretoryDestiny             = cDiretorySource
                       cDiretorySource              = cDiretorySource + "\" + ws-p-import.nr-pedcli + ".zip"
                       cDiretorySourceAssinatura    = IF iAmbiente = 1 THEN es-comunica-cliente-param.assinatura-pedido-producao ELSE pm-param-global.dir_implantacao_DES
                       cDiretoryDestinyAssinatura   = cDiretorySourceAssinatura
                       cDiretorySourceAssinatura    = cDiretorySourceAssinatura + "\" + ws-p-import.nr-pedcli + "_assinatura.zip".
                
                IF ws-p-import.data <> ? THEN DO:
    
                    ASSIGN bytesPedido = ws-p-import.data.
    
                    OUTPUT TO VALUE(cDiretorySource) BINARY NO-MAP NO-CONVERT.
                        EXPORT bytesPedido.
                    OUTPUT CLOSE.
    
                END.
                    
                IF ws-p-import.assinatura <> ? THEN DO:
    
                    ASSIGN bytesAssinatura = ws-p-import.assinatura.
                    
                    OUTPUT TO VALUE(cDiretorySourceAssinatura) BINARY NO-MAP NO-CONVERT.
                        EXPORT bytesAssinatura.
                    OUTPUT CLOSE.
    
                END.                                                                
        
                ASSIGN cCommand = cProgramZip + ' -p' + '"' + cDiretoryDestiny + '" ' + cDiretorySource.
                OS-COMMAND SILENT VALUE(cCommand).
                OS-COMMAND SILENT VALUE("del " + cDiretorySource).
                
                ASSIGN cCommand = cProgramZip + ' -p' + '"' + cDiretoryDestinyAssinatura + '" ' + cDiretorySourceAssinatura.
                OS-COMMAND SILENT VALUE(cCommand).            
                
                /*
                ASSIGN cCommand = 'ren ' + 
                                  cDiretoryDestinyAssinatura + '\' + ws-p-import.nr-pedcli + '-Assinatura' + ' ' + 
                                  cDiretoryDestinyAssinatura + '\' + ws-p-import.nr-pedcli + '-Assinatura.png'.
                
                OS-COMMAND SILENT VALUE(cCommand).
                */
                OS-COMMAND SILENT VALUE("del " + cDiretorySourceAssinatura).
    
                cDiretoryDestiny     = cDiretoryDestiny + "\" + ws-p-import.nr-pedcli.
                
                RUN piImport IN hProgDBO (INPUT ws-p-import.nr-pedcli,INPUT ws-p-import.cod-rep).
                
                RUN getError IN hProgDBO (OUTPUT TABLE ttError).
    
                IF CAN-FIND(FIRST ttError) THEN DO:
                
                    OUTPUT TO VALUE(cArqLogImport) APPEND NO-CONVERT.
                
                    PUT STRING(TODAY,"99/99/9999") FORMAT "X(10)" 
                        " - " 
                        STRING(TIME,"HH:MM:SS") SKIP(1).
                
                    FOR EACH ttError NO-LOCK:
                        DISPLAY ttError WITH 1 DOWN WIDTH 450.
                    END.
                
                    PUT " " SKIP
                        FILL("-",100) FORMAT "X(100)" SKIP(1).
                
                    OUTPUT CLOSE.
                
                END.
                
            END.
            ELSE DO:                               
                                                   
                ASSIGN ws-p-import.erro = YES      
                       ws-p-import.data-erro = NOW.
                                                   
            END.
        END.

    END.

    DELETE PROCEDURE hProgDBO.
