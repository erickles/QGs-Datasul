DEFINE VARIABLE cArquivo            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDirLocal           AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cComando            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE path_configuracao   AS CHARACTER   NO-UNDO.

ASSIGN cArquivo  = "1050.zip"
       cDirLocal = "\\srvvm27\PedMobile_Producao$\Backup\1050\json".

/* Preciso garantir um C:\Temp na maquina do usuario */
FILE-INFO:FILE-NAME = "C:\Temp".
IF FILE-INFO:FULL-PATHNAME EQ ? THEN DO:
    OS-CREATE-DIR VALUE("C:\Temp") NO-ERROR.
END.

/* Copio a carga de backup do diretorio da rede para o C:\Temp */
ASSIGN cComando = "COPY " + cDirLocal + "\" + cArquivo + " " + "C:\Temp\" + cArquivo.
OS-COMMAND SILENT VALUE(cComando).
ASSIGN cComando = "".

ASSIGN path_configuracao = "C:\Temp\ftpcmd".

OUTPUT TO VALUE(path_configuracao).

    PUT UNFORM  "open ftp877.locaweb.com.br"    SKIP
                "tortuga"                       SKIP
                "pfl0rth@l"                     SKIP
                "cd Web\pedmobile_PRO\bkp"      SKIP
                "put " + cArquivo               SKIP
                "bye"
                FORMAT "x(300)".

OUTPUT CLOSE.

OS-COMMAND SILENT VALUE("cd " + "C:\Temp" + " && " + "(cmd /c ftp -i -s:ftpcmd) 1>2>>ftp.log").

ASSIGN cComando = "DEL " + "C:\Temp\" + cArquivo.
OS-COMMAND SILENT VALUE(cComando).
