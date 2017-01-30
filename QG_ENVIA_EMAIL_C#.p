USING System.*.
USING System.Collections.Generic.*.
USING System.Linq.*.
USING System.TEXT.*.
USING System.Net.Mail.*.
USING System.IO.*.

FIND FIRST param-global NO-LOCK NO-ERROR.

DEFINE VARIABLE cAnexos AS CHARACTER   NO-UNDO EXTENT 12.

ASSIGN cAnexos[1] = "C:\Temp\teste.txt".

RUN piEnviaEmail(INPUT "erick.souza@tortuga.com.br",
               INPUT "erick.souza@tortuga.com.br",
               INPUT "",
               INPUT "",
               INPUT "TESTE",
               INPUT "TESTE",
               INPUT STRING(param-global.serv-mail),
               INPUT cAnexos,
               INPUT NO).

FUNCTION fnValidaEmail RETURNS LOGICAL
  ( INPUT cMail AS char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    /*  
    Observacoes:    cMail   - Recebe o campo com o valor do e-mail
                    lValido - Retorna um valor logico se o e-mail e valido ou nao yes (e-mail valida) | false (e-mail invalido)
                    {3} - seta variavel para mais de uma chamada no programa
    */    

    DEFINE VARIABLE iCont      AS INTEGER INITIAL 0.
    DEFINE VARIABLE contponto  AS INTEGER INITIAL 0.
    DEFINE VARIABLE contarroba AS INTEGER INITIAL 0.
    DEFINE VARIABLE vmail2     AS CHAR.
    DEFINE VARIABLE vchar      AS CHAR INITIAL " ,/,:,;,(,),=,',`,^,~,†,Ö,Ç,ä,°,ç,¢,„,∆,§,á,+,&,#,$,%,?,!,*,\,|".

    DEFINE VARIABLE lValido AS LOGICAL     NO-UNDO.

    ASSIGN lValido = TRUE.

    /** VALIDA TAMANHO DO E-MAIL **/
    IF LENGTH(cMail) < 5 THEN
        ASSIGN lValido = false.

    /** VALIDA NUMERO DE @ **/
    contarroba = 0.

    do icont = 1 to length(cMail):
        if (lookup(substring(cMail, icont, 1), "@") > 0) then
            contarroba = contarroba + 1.
    end.

    if  contarroba > 1 or
        contarroba = 0 then
        assign lValido = false.
    else do:
        /** VALIDA SE PRIMEIRO OU ULTIMO EH . OU @ **/
        if substring(cMail, 1, 1)                     = "@" or
            substring(cMail, 1, 1)                     = "." or
            substring(cMail, length(cMail), 1)           = "@" or
            substring(cMail, length(cMail), 1)           = "." then
            assign lValido = false.
        
        /** VALIDA SE APOS OU ANTES DA @ EH . **/
        else 
            if substring(cMail, r-index(cMail, "@") - 1, 1) = "." OR substring(cMail, r-index(cMail, "@") + 1, 1) = "." then
                assign lValido = false.
    end.

    /** VALIDA CARACTERES ESPECIAIS E SEQUENCIA .. **/
    do icont = 1 to length(cMail):
        if lookup(substring(cMail, icont, 1), vchar) > 0 then
            assign lValido = false.
        if lookup(substring(cMail, icont, 2), "..") > 0 then
            assign lValido = false.
    end.

    /** VALIDA A QUANTIDADE DE . APOS @ **/
    vmail2 = "".
    contponto = 0.

    vmail2 = substring(cMail, index(cMail, "@") + 1, length(cMail)).
    do icont = 1 to length(vmail2):
        if lookup(substring(vmail2, icont, 1), ".") > 0 then
            contponto = contponto + 1.
    end.

    if contponto = 0 or
        contponto > 3 then
        assign lValido = false.

    RETURN lValido.   /* Function return value. */

END FUNCTION.

PROCEDURE piEnviaEmail:
    DEFINE INPUT PARAMETER cFromMail   AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cTo         AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cCopia      AS CHARACTER   NO-UNDO FORMAT "X(200)".
    DEFINE INPUT PARAMETER cOculta     AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cAssunto    AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cBody       AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cSmtp       AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER cAnexos     AS CHARACTER   NO-UNDO EXTENT 12.
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

    DEFINE VARIABLE xi              AS INTEGER  NO-UNDO.

    mail = NEW MailMessage().
    
    IF cFromMail = "" OR cFromMail = ? THEN
        cFromMail = "atendimentosac@tortuga.com.br".

    mail:From = NEW MailAddress(cFromMail).

    IF cTo <> "" AND INDEX(cTo,"@") > 0 THEN
        mail:To:Add(cTo).
    
    IF cCopia <> "" THEN DO:

        numEmail =  NUM-ENTRIES(cCopia,";").

        IF numEmail > 0 THEN
            DO  WHILE NumEmail > numEmailSent:

                IF INDEX(ENTRY(numEmail,cCopia,";"),"@") > 0 THEN
                    mail:CC:Add(ENTRY(numEmail,cCopia,";")).

                numEmail = numEmail - 1.
            END.
        ELSE DO:
            numEmail =  NUM-ENTRIES(cCopia,",").
            
            IF numEmail > 0 THEN
                DO  WHILE NumEmail > numEmailSent:
                    IF INDEX(ENTRY(numEmail,cCopia,";"),"@") > 0 THEN
                        IF fnValidaEmail(ENTRY(numEmail,cCopia,",")) THEN
                            mail:CC:Add(ENTRY(numEmail,cCopia,",")).
                    numEmail = numEmail - 1.
                END.
            ELSE
                IF fnValidaEmail(cCopia) THEN
                    mail:CC:Add(cCopia).
        END.
    END.

    ASSIGN iCont = 0.

    IF cOculta <> "" THEN
        mail:Bcc:Add(cOculta).

    mail:Subject = cAssunto.
    mail:IsBodyHtml = isHtml.
    
    IF isHtml THEN DO:
        
        IF SEARCH(cBody) <> ? THEN DO:
            
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

    END.
    ELSE DO:
        mail:Body = cBody.
    END.    
    
    DO iCont = 1 TO 12:

        IF TRIM(cAnexos[iCont]) <> "" THEN DO:
            
            IF SEARCH(TRIM(cAnexos[iCont])) <> ? AND SEARCH(TRIM(cAnexos[iCont])) <> "" THEN DO:

                /*mail:Attachments:Add(NEW Attachment(cAnexos[iCont])).*/
                
                DO ON ERROR UNDO, LEAVE:

                    mail:Attachments:Add(NEW Attachment(cAnexos[iCont])).
            
                    CATCH erro AS System.IO.FileNotFoundException:
                                            
                        REPEAT xi = 1 TO erro:NumMessages:
                            /*
                            MESSAGE "C¢digo do Erro: " + STRING(erro:GetMessageNum(xi)) SKIP
                                    "Mensagem: " + erro:GetMessage(xi)
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            */
                        END.
                    END CATCH.
                    FINALLY: 
                        /*
                        MESSAGE "Executa Sempre!"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        */
                    END FINALLY. 
                END.
            END.
        END.
    END.
    
    smtp = NEW SmtpClient(cSmtp).
    smtp:Send(mail).

END PROCEDURE.
