
DEFINE VARIABLE w-Result AS CHARACTER NO-UNDO.
DEFINE VARIABLE w-Command AS CHARACTER NO-UNDO.
DEFINE VARIABLE cResultado AS CHARACTER   NO-UNDO.

OUTPUT TO "C:\Temp\rodajava.bat".

PUT "CD C:\SMIMETool\run && java -classpath .;C:\SMimeTool\Jar\entbase.jar;C:\SMimeTool\Jar\entcertlist.jar;C:\SMimeTool\Jar\entcms.jar;C:\SMimeTool\Jar\entjsse.jar;C:\SMimeTool\Jar\entp12.jar;C:\SMimeTool\Jar\entp7.jar;C:\SMimeTool\Jar\entsmime.jar;C:\SMimeTool\Jar\entsmimev3.jar;C:\SMimeTool\Jar\enttunnel.jar;C:\SMimeTool\Jar\entuser.jar;C:\SMimeTool\Jar\entp5.jar;C:\SMimeTool\Jar\activation.jar;C:\SMimeTool\Jar\mail.jar;C:\SMimeTool\Jar\providerutil.jar;C:\SMIMETool\RUN; CreateSMime".

OUTPUT CLOSE.

/*ASSIGN w-Command = "java -classpath c:\SMIMETool\RUN CreateSMime".*/

ASSIGN w-Command = "C:\Temp\rodajava.bat".

INPUT THROUGH VALUE(w-Command).

REPEAT:

    IMPORT UNFORMATTED w-Result.

    cResultado = cResultado + w-Result.
    
END.

/*
ASSIGN w-Command = "DEL C:\Temp\rodajava.bat".
OS-COMMAND SILENT VALUE(w-Command).
*/

OUTPUT TO "C:\Temp\resultado.txt".
PUT UNFORM cResultado.
OUTPUT CLOSE.


