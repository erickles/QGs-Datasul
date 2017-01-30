    /*  
    This example shows how to retrieve the data from a file passed on a given request,
    and save it as a file with the same name to the WebSpeed agents working directory.
    Note that 'filename' is the name of the field in the form that was posted. 
    */
    
{src/web/method/cgidefs.i}
{include/i-ambiente.i}

DEFINE VAR mFile AS MEMPTR  NO-UNDO.
DEFINE VAR cfile AS CHAR    NO-UNDO.
/* 'filename' refers to the name of the field in the form.
get±binary±]data returns the contents of the file associated with the form field named 'filename'. */

ASSIGN mFile = GET-BINARY-DATA("filename").

IF mFile <> ? THEN DO:
    ASSIGN cfile = get-value("filename").
    COPY-LOB FROM mFile TO FILE cFile NO-CONVERT.
END.

IF adm-ambiente = "PRODUCAO" THEN DO:
    {&OUT}
    '<HTML>
    <BODY>
        <FORM ENCTYPE="multipart/form-data" ACTION="https://empresa-representante.tortuga.com.br/scripts/cgiip.exe/WService=tortuga-web/ping" METHOD="POST">
            <INPUT type="file" name="filename">
            <INPUT type="submit">
        </FORM>
    </BODY>
    </HTML>'.
END.
ELSE DO:
    {&OUT}
    '<HTML>
    <BODY>
        <FORM ENCTYPE="multipart/form-data" ACTION="https://empresa-representanteteste.tortuga.com.br/scripts/cgiip.exe/WService=tortuga-web/ping" METHOD="POST">
            <INPUT type="file" name="filename">
            <INPUT type="submit">
        </FORM>
    </BODY>
    </HTML>'.
END.
