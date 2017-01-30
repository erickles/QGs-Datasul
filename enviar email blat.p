DEFINE VARIABLE cAttach       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cEmailDestino AS CHARACTER   NO-UNDO.

ASSIGN cEmailDestino = "erickles@msn.com".
/*"antonio-ruy.freire@tortuga.com.br"*/

RUN piEnviarEmail.

PROCEDURE piEnviarEmail :

DEFINE VARIABLE cBlat              AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-path-corpo-email AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-server           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-comando          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-out-de           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cBody              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSubject           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSignature         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cUsuarioExch       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSenhaUsuarioExch  AS CHARACTER   NO-UNDO.

OUTPUT TO "c:\blat.txt".

ASSIGN c-out-de = "no-reply@tortuga.com.br". 
    
FIND FIRST param-global NO-LOCK NO-ERROR.
IF AVAIL param-global THEN 
    ASSIGN c-server = param-global.serv-mail.
ELSE 
    RETURN 'NOK'.
    
ASSIGN cBody              = "Segue_anexo_boleto_em_formato_PDF"
       cSubject           = "Teste"
       cSignature         = "Teste"
       c-path-corpo-email = "Teste" /*SEARCH("esp/doc/envio_boleto_PDF.html")*/
       cUsuarioExch       = "TORTUGA\no-reply"      /*usuario exchange*/
       cSenhaUsuarioExch  = "@tortuga1010". /*senha usuario exchange*/    

ASSIGN cBlat     = SEARCH("interfac/mail/blat.exe").
ASSIGN c-comando = cBlat               + 
                   " "                 +                                      
                   " -body "           +
                   "Teste"             +
                   " -server "         + 
                   c-server            + 
                   " -f "              + 
                   c-out-de            + 
                   cAttach             +
                   " -to "             +  
                   cEmailDestino       +                    
                   " -subject "        + 
                   cSubject            +
                   " -u "              + 
                   cUsuarioExch        +
                   " -pw "             +
                   cSenhaUsuarioExch.

PUT c-comando FORMAT "X(300)".
OUTPUT CLOSE.
    
OS-COMMAND SILENT VALUE (c-comando).

RETURN "OK".

END PROCEDURE.
