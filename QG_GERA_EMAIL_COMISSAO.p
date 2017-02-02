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

{include\i-ambiente.i}
{include\i-smtprelay.i 1}

DEFINE VARIABLE dtParametro AS DATE        NO-UNDO FORMAT "99/99/9999".
DEFINE BUFFER bf-envia-email FOR es-envia-email.

DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

dtParametro = TODAY.

UPDATE dtParametro.

FOR EACH tit_ap WHERE tit_ap.dat_emis_docto     = dtParametro 
                  AND tit_ap.cod_espec_docto    = "PC"
                  AND tit_ap.cod_empresa        = "TOR"
                  NO-LOCK:
    RUN pi-mail-repres.
END.

PROCEDURE pi-mail-repres:

    DEFINE VARIABLE iSequencia  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cNomeRepres AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cMensagem   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cLinha      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cModelo     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cChave      AS CHARACTER   NO-UNDO.

    IF tit_ap.cod_espec_docto = "PC" THEN DO:

        cChave = tit_ap.cod_estab           + "|" +
                 STRING(tit_ap.cdn_fornec)  + "|" +
                 tit_ap.cod_espec_docto     + "|" +
                 tit_ap.cod_ser_docto       + "|" +
                 tit_ap.cod_tit_ap          + "|" +
                 tit_ap.cod_parcela.

        FIND FIRST emsuni.fornecedor WHERE emsuni.fornecedor.cdn_fornecedor = tit_ap.cdn_fornecedor NO-LOCK NO-ERROR.

        FIND FIRST emsuni.pessoa_fisic WHERE emsuni.pessoa_fisic.num_pessoa_fisic = emsuni.fornecedor.num_pessoa NO-LOCK NO-ERROR.
        IF AVAIL emsuni.pessoa_fisic AND fnValidaEmail(TRIM(emsuni.pessoa_fisic.cod_e_mail)) THEN DO:
            
            ASSIGN cNomeRepres = emsuni.pessoa_fisic.nom_pessoa.

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 27100,
                               INPUT "Gerar e-mail?~~Deseja gerar o envio de e-mail para o representante " + cNomeRepres + "?").

            IF RETURN-VALUE = "YES" THEN DO:

                IF adm-ambiente = "PRODUCAO" THEN DO:
    
                    cModelo = SEARCH("doc\mail_pag_comissao.html").
    
                    IF cModelo <> ? AND cModelo <> "" THEN
                        INPUT FROM VALUE(cModelo) NO-CONVERT.
                    ELSE
                        INPUT FROM T:\EMS2.06B\esp\doc\mail_pag_comissao.html NO-CONVERT.
                END.
                ELSE DO:
    
                    cModelo = SEARCH("doc\mail_pag_comissao.html").
    
                    IF cModelo <> ? AND cModelo <> "" THEN
                        INPUT FROM VALUE(cModelo) NO-CONVERT.
                    ELSE
                        INPUT FROM U:\EMS2.06B\esp\doc\mail_pag_comissao.html NO-CONVERT.
                END.
    
                REPEAT:
            
                    IMPORT UNFORMATTED cLinha.
            
                    cLinha = REPLACE(cLinha,"#nome#",cNomeRepres).
                    cLinha = REPLACE(cLinha,"#dt_pag#",STRING(tit_ap.dat_prev_pagto,"99/99/9999")).
                    cLinha = REPLACE(cLinha,"#f_pag#","CRêDITO EM CONTA").
                    cLinha = REPLACE(cLinha,"#nota#",tit_ap.cod_tit_ap).
                    cLinha = REPLACE(cLinha,"#vl_pag#","R$ " + STRING(tit_ap.val_origin_tit_ap)).
                    
                    cMensagem = cMensagem + cLinha.
                    
                END.
                
                INPUT CLOSE.
    
                FIND LAST bf-envia-email USE-INDEX chSeq NO-LOCK NO-ERROR.                    
                iSequencia = bf-envia-email.sequencia + 1.
                
                FIND FIRST es-envia-email WHERE es-envia-email.chave-acesso = cChave NO-ERROR.
                IF NOT AVAIL es-envia-email THEN DO:
                    
                    CREATE es-envia-email.
                    ASSIGN es-envia-email.codigo-acesso = "COMISSAO"
                           es-envia-email.chave-acesso  = cChave
                           es-envia-email.sequencia     = iSequencia
                           es-envia-email.de            = /* Rubens Souza - 19/05/16 "naoresponda@dsm.com" */ c-endereco
                           es-envia-email.para          = emsuni.pessoa_fisic.cod_e_mail
                           es-envia-email.assunto       = "Programaá∆o de pagamento de comiss∆o"
                           es-envia-email.texto         = cMensagem
                           es-envia-email.situacao      = 1
                           es-envia-email.dt-incl       = TODAY
                           es-envia-email.hr-incl       = STRING(TIME,"HH:MM:SS")
                           es-envia-email.dt-env        = ?
                           es-envia-email.hr-env        = ?
                           es-envia-email.erro          = ""
                           es-envia-email.u-char-1      = "".
                END.
            END.
        END.
        ELSE DO:
            
            FIND FIRST emsuni.pessoa_jurid WHERE emsuni.pessoa_jurid.num_pessoa_jurid = emsuni.fornecedor.num_pessoa NO-LOCK NO-ERROR.
            IF AVAIL emsuni.pessoa_jurid AND fnValidaEmail(TRIM(emsuni.pessoa_jurid.cod_e_mail)) THEN DO:
                
                ASSIGN cNomeRepres = emsuni.pessoa_jurid.nom_pessoa.

                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 27100,
                                   INPUT "Gerar e-mail?~~Deseja gerar o envio de e-mail para o representante " + cNomeRepres + "?").

                IF RETURN-VALUE = "YES" THEN DO:
                

                IF adm-ambiente = "PRODUCAO" THEN DO:

                    cModelo = SEARCH("doc\mail_pag_comissao.html").
    
                    IF cModelo <> ? AND cModelo <> "" THEN
                        INPUT FROM VALUE(cModelo) NO-CONVERT.
                    ELSE
                        INPUT FROM T:\EMS2.06B\esp\doc\mail_pag_comissao.html NO-CONVERT.
                END.
                ELSE DO:
    
                    cModelo = SEARCH("doc\mail_pag_comissao.html").
    
                    IF cModelo <> ? AND cModelo <> "" THEN
                        INPUT FROM VALUE(cModelo) NO-CONVERT.
                    ELSE
                        INPUT FROM U:\EMS2.06B\esp\doc\mail_pag_comissao.html NO-CONVERT.
                END.

                REPEAT:
            
                    IMPORT UNFORMATTED cLinha.
            
                    cLinha = REPLACE(cLinha,"#nome#",cNomeRepres).
                    cLinha = REPLACE(cLinha,"#dt_pag#",STRING(tit_ap.dat_prev_pagto,"99/99/9999")).
                    cLinha = REPLACE(cLinha,"#f_pag#","CRêDITO EM CONTA").
                    cLinha = REPLACE(cLinha,"#nota#",tit_ap.cod_tit_ap).
                    cLinha = REPLACE(cLinha,"#vl_pag#","R$ " + STRING(tit_ap.val_origin_tit_ap)).
                    
                    cMensagem = cMensagem + cLinha.
                    
                END.
                
                INPUT CLOSE.
    
                FIND LAST bf-envia-email USE-INDEX chSeq NO-LOCK NO-ERROR.                    
                iSequencia = bf-envia-email.sequencia + 1.
                
                FIND FIRST es-envia-email WHERE es-envia-email.chave-acesso = cChave NO-ERROR.
                IF NOT AVAIL es-envia-email THEN DO:
                    
                    CREATE es-envia-email.
                    ASSIGN es-envia-email.codigo-acesso = "COMISSAO"
                           es-envia-email.chave-acesso  = "COMISSAO"
                           es-envia-email.sequencia     = iSequencia
                           es-envia-email.de            = /* Rubens Souza - 19/05/16  "naoresponda@dsm.com" */ c-endereco
                           es-envia-email.para          = emsuni.pessoa_jurid.cod_e_mail
                           es-envia-email.assunto       = "Programaá∆o de pagamento de comiss∆o"
                           es-envia-email.texto         = cMensagem
                           es-envia-email.situacao      = 1
                           es-envia-email.dt-incl       = TODAY
                           es-envia-email.hr-incl       = STRING(TIME,"HH:MM:SS")
                           es-envia-email.dt-env        = ?
                           es-envia-email.hr-env        = ?
                           es-envia-email.erro          = ""
                           es-envia-email.u-char-1      = "".
                    END.
                END.
            END.
        END.
    END.

END PROCEDURE.
