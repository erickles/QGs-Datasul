USING System.*.
USING System.Collections.Generic.*.
USING System.Linq.*.
USING System.TEXT.*.
USING System.Net.Mail.*.
USING System.IO.*.

DEFINE VARIABLE cFromMail   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCopia      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOculta     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAssunto    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cBody       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSmtp       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAnexos     AS CHARACTER   NO-UNDO EXTENT 120.
DEFINE VARIABLE isHtml      AS LOGICAL     NO-UNDO.

ASSIGN cFromMail    = "sac@tortuga.com.br"
       cTo          = "erick.souza@dsm.com"
       cCopia       = "erick842006@gmail.com"
       cOculta      = ""
       cAssunto     = "DANFE_DSM"
       cBody        = "U:\EMS2.06B\esp\doc\portal_cliente_danfe.html"
       cSmtp        = "192.168.1.31"
       cAnexos[1]   = "Z:\producao\2014\OUT\Danfe\DANFE-05-1-0092090.pdf"
       cAnexos[2]   = "Y:\PRODUCAO\Processados\050010092136.xml"
       isHtml       = TRUE.

RUN EnviaEmail(INPUT cFromMail,
               INPUT cTo,
               INPUT cCopia,
               INPUT cOculta,
               INPUT cAssunto,
               INPUT cBody,
               INPUT cSmtp,
               INPUT cAnexos,
               INPUT isHtml).

PROCEDURE EnviaEmail:

    DEFINE INPUT PARAMETER cFromMail   AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cTo         AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cCopia      AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cOculta     AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cAssunto    AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cBody       AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cSmtp       AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cAnexos     AS CHARACTER   NO-UNDO EXTENT 120.
    DEFINE INPUT PARAMETER isHtml      AS LOGICAL     NO-UNDO.
    
    DEFINE VARIABLE iCont       AS INTEGER      NO-UNDO.
    DEFINE VARIABLE mail        AS MailMessage  NO-UNDO.
    DEFINE VARIABLE smtp        AS SmtpClient   NO-UNDO.
    DEFINE VARIABLE v_mem       AS MEMPTR       NO-UNDO.
    DEFINE VARIABLE v_dados     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE v_cont      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cLinha      AS CHARACTER    NO-UNDO.
    
    mail = NEW MailMessage().
    mail:From = NEW MailAddress(cFromMail).

    IF cTo = "" THEN
        RETURN "NOK".

    mail:To:Add(cTo).

    IF cCopia <> "" THEN
        mail:CC:Add(cCopia).

    IF cOculta <> "" THEN
        mail:Bcc:Add(cOculta).

    mail:Subject = cAssunto.
    mail:IsBodyHtml = isHtml.
    
    IF isHtml THEN DO:
            
        INPUT FROM VALUE(cBody) NO-CONVERT.
    
        REPEAT:
            IMPORT UNFORMATTED cLinha.
            
            mail:Body = mail:Body + cLinha.
        END.
    
        INPUT CLOSE.
    END.
    ELSE DO:
        mail:Body = cBody.
    END.
    
    DO iCont = 1 TO 120:
        IF cAnexos[iCont] <> "" THEN        
            mail:Attachments:Add(NEW Attachment(cAnexos[iCont])).
    END.
    
    smtp = NEW SmtpClient(cSmtp).
    smtp:Send(mail).

END PROCEDURE.
