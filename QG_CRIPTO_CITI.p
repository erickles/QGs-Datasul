/********************************************************************************
** Copyright DSM
** Author: Erick Souza
** Date: 16/09/2016
*******************************************************************************/

DEFINE VARIABLE cArquivo        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDirRemessa     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDirLog         AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cComando        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cComandoEncrypt AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cResultado      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLog            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDirRemessaBat  AS CHARACTER   NO-UNDO.

ASSIGN cArquivo     = "C:/SMIMETool/data/in/31052017082408.REM"
       cDirRemessa  = "C:/SMIMETool/data/in/"
       cDirLog      = "C:/SMIMETool/data/log/".

IF SEARCH(cArquivo) <> ? THEN DO:

    ASSIGN cDirRemessaBat = REPLACE(cArquivo,".REM",".bat").
    
    OUTPUT TO VALUE(cDirRemessaBat).
    
    PUT UNFORM "CD C:\SMIMETool\run && java -classpath .;C:\SMimeTool\Jar\entbase.jar;C:\SMimeTool\Jar\entcertlist.jar;C:\SMimeTool\Jar\entcms.jar;C:\SMimeTool\Jar\entjsse.jar;C:\SMimeTool\Jar\entp12.jar;C:\SMimeTool\Jar\entp7.jar;C:\SMimeTool\Jar\entsmime.jar;C:\SMimeTool\Jar\entsmimev3.jar;C:\SMimeTool\Jar\enttunnel.jar;C:\SMimeTool\Jar\entuser.jar;C:\SMimeTool\Jar\entp5.jar;C:\SMimeTool\Jar\activation.jar;C:\SMimeTool\Jar\mail.jar;C:\SMimeTool\Jar\providerutil.jar;C:\SMIMETool\RUN; CreateSMime -e C:/SMIMETool/DSM_CITI.pfx -p kDqjWVwIjj9Ue9mUw/1u9Q== -h NJda4ZUfeegSfVjH4ytbSj9R2rI= -i " + 
                cArquivo                                    +
                " -o "                                      +
                cDirRemessa                                 +
                " -c C:\SMIMETool\DSM_CITI_2017.cer -L "    +
                cDirLog                                     +
                " y".
    
    OUTPUT CLOSE.
    
    ASSIGN cComando = cDirRemessaBat.
    
    INPUT THROUGH VALUE(cComando).
    
    REPEAT:
    
        IMPORT UNFORMATTED cResultado.
    
        cLog = cLog + cResultado.
        
    END.
    
    ASSIGN cComando = "DEL " + cDirRemessaBat
           cComando = REPLACE(cComando,"/","\").
    
    OS-COMMAND SILENT VALUE(cComando).
    
END.
