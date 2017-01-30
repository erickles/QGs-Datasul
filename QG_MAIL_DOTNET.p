USING System.*.
USING System.Collections.Generic.*.
USING System.Linq.*.
USING System.TEXT.*.
USING System.Net.Mail.*.
USING System.IO.*.

{include/i-buffer.i}

DEFINE VARIABLE cMessage    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE clinha      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomeRepres AS CHARACTER   NO-UNDO.

FIND FIRST tit_ap WHERE tit_ap.cod_estab       = "19"
                    AND tit_ap.cod_espec_docto = "PC"
                    AND tit_ap.cod_ser_docto   = ""
                    AND tit_ap.cod_tit_ap      = "0000006"
                    AND tit_ap.cod_parcela     = "1"
                    AND tit_ap.cdn_fornecedor  = 165434
                    NO-LOCK NO-ERROR.
IF AVAIL tit_ap THEN DO:

    FIND FIRST param-global NO-LOCK NO-ERROR.

    FIND FIRST emsuni.fornecedor WHERE emsuni.fornecedor.cdn_fornecedor = tit_ap.cdn_fornecedor NO-LOCK NO-ERROR.
    
    FIND FIRST pessoa_fisic WHERE pessoa_fisic.num_pessoa = emsuni.fornecedor.num_pessoa NO-LOCK NO-ERROR.
    IF AVAIL pessoa_fisic THEN
        ASSIGN cNomeRepres = pessoa_fisic.nom_pessoa.
    ELSE
        FIND FIRST pessoa_jurid WHERE pessoa_jurid.num_pessoa_jurid = emsuni.fornecedor.num_pessoa NO-LOCK NO-ERROR.
        IF AVAIL pessoa_jurid THEN
            ASSIGN cNomeRepres = pessoa_jurid.nom_pessoa.

    INPUT FROM c:\Temp\mail_pag_comissao.html NO-CONVERT.
    
    REPEAT:

        IMPORT UNFORMATTED cLinha.

        cLinha = REPLACE(cLinha,"#nome#",cNomeRepres).
        cLinha = REPLACE(cLinha,"#dt_pag#",STRING(tit_ap.dat_prev_pagto,"99/99/9999")).
        cLinha = REPLACE(cLinha,"#f_pag#","CRêDITO EM CONTA").
        cLinha = REPLACE(cLinha,"#nota#",tit_ap.cod_tit_ap).
        cLinha = REPLACE(cLinha,"#vl_pag#","R$ " + STRING(tit_ap.val_origin_tit_ap)).
        
        cMessage = cMessage + cLinha.
        
    END.
    
    INPUT CLOSE.
    
    RUN enviaEmailComissao(INPUT "erick.souza@tortuga.com.br",
                           INPUT "erick.souza@tortuga.com.br",
                           INPUT "",
                           INPUT "",
                           INPUT "Programaá∆o de pagamento de comiss∆o",
                           INPUT cMessage,
                           INPUT /*param-global.serv-mail*/ "192.168.1.31",
                           INPUT YES).

END.

PROCEDURE enviaEmailComissao:

    DEFINE INPUT PARAMETER cFromMail   AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cTo         AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cCopia      AS CHARACTER   NO-UNDO FORMAT "X(200)".
    DEFINE INPUT PARAMETER cOculta     AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cAssunto    AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cBody       AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cSmtp       AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER isHtml      AS LOGICAL     NO-UNDO.
    
    DEFINE VARIABLE iCont       AS INTEGER      NO-UNDO.
    DEFINE VARIABLE mail        AS MailMessage  NO-UNDO.
    DEFINE VARIABLE smtp        AS SmtpClient   NO-UNDO.
    DEFINE VARIABLE v_mem       AS MEMPTR       NO-UNDO.
    DEFINE VARIABLE v_dados     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE v_cont      AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cLinha      AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE numEmail        AS INTEGER  NO-UNDO.
    DEFINE VARIABLE numEmailSent    AS INTEGER  NO-UNDO.
    
    mail = NEW MailMessage().
    
    mail:From = NEW MailAddress(cFromMail).

    IF cTo <> "" THEN
        mail:To:Add(cTo).
    
    IF cCopia <> "" THEN DO:

        numEmail =  NUM-ENTRIES(cCopia,";").

        IF numEmail > 0 THEN
            DO  WHILE NumEmail > numEmailSent:
                mail:CC:Add(ENTRY(numEmail,cCopia,";")).
                numEmail = numEmail - 1.
            END.
        ELSE DO:
            numEmail =  NUM-ENTRIES(cCopia,",").
            
            IF numEmail > 0 THEN
                DO  WHILE NumEmail > numEmailSent:
                    mail:CC:Add(ENTRY(numEmail,cCopia,",")).
                    numEmail = numEmail - 1.
                END.
            ELSE
                mail:CC:Add(cCopia).
        END.
    END.

    ASSIGN iCont = 0.

    IF cOculta <> "" THEN
        mail:Bcc:Add(cOculta).

    mail:Subject = cAssunto.
    mail:IsBodyHtml = isHtml.
    
    mail:Body = cBody.

    smtp = NEW SmtpClient(cSmtp).
    smtp:Send(mail).

END PROCEDURE.
