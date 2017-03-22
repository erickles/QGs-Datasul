/* Envio da DANFE por e-mail */
DEFINE VARIABLE c-cam-xml       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cam-danfe     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cam-boleto    AS CHARACTER   NO-UNDO EXTENT 12.
DEFINE VARIABLE da-data-emis    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-serie         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-estabel   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iSequencia      AS INTEGER     NO-UNDO.

DEFINE BUFFER b1-es-envia-email FOR es-envia-email.

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

    FOR EACH nota-fiscal WHERE nota-fiscal.cod-estabel   = "19"
                            AND nota-fiscal.serie         = "4"
                            AND YEAR(nota-fiscal.dt-emis) = 2017
                            AND MONTH(nota-fiscal.dt-emis) = 2
                            AND nota-fiscal.ind-sit-nota = 2
                            NO-LOCK:

        FIND FIRST es-param-portal NO-LOCK WHERE es-param-portal.ep-codigo = "1" NO-ERROR.

        FIND FIRST emitente NO-LOCK WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli NO-ERROR.
    
        FIND FIRST cont-emit NO-LOCK OF emitente WHERE cont-emit.sequencia = 0 NO-ERROR.
        
        RUN esp\esapi300.p  (INPUT nota-fiscal.cgc,
                             INPUT nota-fiscal.nr-nota-fis,
                             INPUT YES,
                             INPUT NO,
                             INPUT NO,
                             OUTPUT c-cod-estabel,
                             OUTPUT c-serie      ,
                             OUTPUT da-data-emis ,
                             OUTPUT c-cam-xml    ,
                             OUTPUT c-cam-danfe  ,
                             OUTPUT c-cam-boleto).        
        
        /* Gera Pedido de Envio de Email para a DANFE */
        FIND LAST b1-es-envia-email USE-INDEX chSeq NO-LOCK NO-ERROR.
        IF  NOT AVAIL b1-es-envia-email THEN
            ASSIGN iSequencia = 1.
        ELSE
            ASSIGN iSequencia = b1-es-envia-email.sequencia + 1.
    
        CREATE es-envia-email.
        ASSIGN es-envia-email.codigo-acesso = "PORTAL"
               es-envia-email.chave-acesso  = nota-fiscal.cod-estabel + "|" + nota-fiscal.serie + "|" + nota-fiscal.nr-nota-fis
               es-envia-email.sequencia     = iSequencia
               es-envia-email.de            = /*es-param-portal.u-char-2*/ "sac.tortuga@dsm.com"
               es-envia-email.para          = "erick.souza@dsm.com"
               es-envia-email.assunto       = "DANFE_DSM"
               es-envia-email.texto         = SEARCH("esp/doc/portal_cliente_danfe.html")           
               es-envia-email.situacao      = 1
               es-envia-email.anexos[1]     = c-cam-danfe
               es-envia-email.anexos[2]     = c-cam-xml
               es-envia-email.dt-incl       = TODAY
               es-envia-email.hr-incl       = STRING(TIME,"HH:MM:SS")
               es-envia-email.dt-env        = ?
               es-envia-email.l-danfe       = YES
               es-envia-email.hr-env        = ?
               es-envia-email.erro          = ""
               es-envia-email.u-char-1      = "".
    
        /* Tratativa para cliente com e-mail vazio e com "@" */
        IF (TRIM(es-envia-email.para) = "" OR TRIM(es-envia-email.para) = "@") AND TRIM(es-envia-email.u-char-1) <> "" THEN
            ASSIGN es-envia-email.para = "".
    
        RELEASE es-envia-email.

        FIND FIRST emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.
        IF fnValidaEmail(emitente.e-mail) THEN
            LEAVE.

    END.
