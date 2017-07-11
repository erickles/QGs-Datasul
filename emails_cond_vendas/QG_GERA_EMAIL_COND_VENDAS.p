{include\i-ambiente.i}
{include\i-smtprelay.i 1}

DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE cChave      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cModelo     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLinha      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cMensagem   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAnexo      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iSequencia  AS INTEGER     NO-UNDO.

DEFINE BUFFER bf-envia-email FOR es-envia-email.
DEFINE BUFFER bf2-envia-email FOR es-envia-email.

DEFINE VARIABLE lTeste AS LOGICAL     NO-UNDO INITIAL NO.

DEFINE VARIABLE hAcomp        AS HANDLE      NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD codigo    AS CHAR
    FIELD nome      AS CHAR
    FIELD email     AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Users\ess55813\Documents\GitHub\QGs-Datasul\emails_cond_vendas\ENVIAREMAIL.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.codigo
    tt-planilha.nome
    tt-planilha.email.

END.

INPUT CLOSE.

IF NOT VALID-HANDLE(hAcomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET hAcomp.

RUN pi-inicializar IN hAcomp(INPUT "Gerando e-mails...").

OUTPUT TO "C:\Users\ess55813\Documents\GitHub\QGs-Datasul\emails_cond_vendas\emails_25052017.csv".

PUT "codigo;nome;email" SKIP.

FOR EACH tt-planilha NO-LOCK:

    IF tt-planilha.codigo = "" OR tt-planilha.codigo = "codigo" THEN
        NEXT.

    FIND FIRST es-envia-email WHERE es-envia-email.chave-acesso  = tt-planilha.codigo 
                                AND es-envia-email.dt-incl      >= 05/25/2017
                                AND es-envia-email.codigo-acesso = "COND_VENDAS"
                                NO-ERROR.
    IF AVAIL es-envia-email THEN DO:
        PUT UNFORM tt-planilha.codigo  ";"
                   tt-planilha.nome    ";"
                   tt-planilha.email   SKIP.
        NEXT.
    END.

    RUN pi-acompanhar IN hAcomp (INPUT "Cliente " + tt-planilha.codigo).

    /* Crio os e-mails */            
    ASSIGN cChave       = tt-planilha.codigo
           cModelo      = SEARCH("C:\Users\ess55813\Documents\GitHub\QGs-Datasul\emails_cond_vendas\cond_vendas_email.html")
           cAnexo       = SEARCH("\\srvvm01\comunica-cliente\Condi‡äes gerais de vendas DSM.pdf")
           cMensagem    = "".
    
    INPUT FROM VALUE(cModelo) NO-CONVERT.

        REPEAT:
        
            IMPORT UNFORMATTED cLinha.
        
            cLinha = REPLACE(cLinha,"#codEmitente#", tt-planilha.codigo).
            cMensagem = cMensagem + cLinha.
                
        END.
            
    INPUT CLOSE.
    
    IF NOT lTeste THEN DO:

        FIND LAST bf-envia-email USE-INDEX chSeq NO-LOCK NO-ERROR.
        iSequencia = bf-envia-email.sequencia + 1.
    
        iCont = iCont + 1.
                        
        CREATE bf2-envia-email.
        ASSIGN bf2-envia-email.codigo-acesso = "COND_VENDAS"
               bf2-envia-email.chave-acesso  = cChave
               bf2-envia-email.sequencia     = iSequencia
               bf2-envia-email.de            = "sac.tortuga@dsm.com"
               bf2-envia-email.para          = TRIM(tt-planilha.email)
               bf2-envia-email.assunto       = "Atualiza‡Æo condi‡äes gerais de vendas"
               bf2-envia-email.texto         = cMensagem
               bf2-envia-email.situacao      = 1
               bf2-envia-email.dt-incl       = TODAY
               bf2-envia-email.hr-incl       = STRING(TIME,"HH:MM:SS")
               bf2-envia-email.dt-env        = ?
               bf2-envia-email.hr-env        = ?
               bf2-envia-email.erro          = ""
               bf2-envia-email.u-char-1      = "" 
               bf2-envia-email.anexo[1]      = cAnexo.
        
        RELEASE bf2-envia-email.

    END.
    ELSE DO:

        FIND LAST bf-envia-email USE-INDEX chSeq NO-LOCK NO-ERROR.
        iSequencia = bf-envia-email.sequencia + 1.
    
        iCont = iCont + 1.
                        
        CREATE bf2-envia-email.
        ASSIGN bf2-envia-email.codigo-acesso = "COND_VENDAS"
               bf2-envia-email.chave-acesso  = cChave
               bf2-envia-email.sequencia     = iSequencia
               bf2-envia-email.de            = "sac.tortuga@dsm.com"
               bf2-envia-email.para          = "erick.souza@dsm.com"
               bf2-envia-email.assunto       = "Atualiza‡Æo condi‡äes gerais de vendas"
               bf2-envia-email.texto         = cMensagem
               bf2-envia-email.situacao      = 1
               bf2-envia-email.dt-incl       = TODAY
               bf2-envia-email.hr-incl       = STRING(TIME,"HH:MM:SS")
               bf2-envia-email.dt-env        = ?
               bf2-envia-email.hr-env        = ?
               bf2-envia-email.erro          = ""
               bf2-envia-email.u-char-1      = "" 
               bf2-envia-email.anexo[1]      = cAnexo.
        
        RELEASE bf2-envia-email.
        LEAVE.

    END.
    
    /*
    IF iCont = 2000 THEN DO:
        MESSAGE iCont
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        LEAVE.
    END.
    */    
END.

OUTPUT CLOSE.

RUN pi-finalizar IN hAcomp.
