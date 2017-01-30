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


FOR EACH es-envia-email WHERE es-envia-email.situacao = 1:

    IF NOT fnValidaEmail(es-envia-email.para) THEN DO:

        ASSIGN es-envia-email.situacao = 2
               es-envia-email.dt-env   = TODAY
               es-envia-email.hr-env   = STRING(TIME,"HH:MM:SS")
               es-envia-email.erro     = "E-mail destino invalido".
                
    END.

END.
