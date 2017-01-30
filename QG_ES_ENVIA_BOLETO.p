DEFINE BUFFER b-es-envia-email FOR es-envia-email.
DEFINE VARIABLE iSequencia AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

/* QG */
/*
FIND FIRST nota-fiscal NO-LOCK WHERE es-fat-duplic.cod-estabel = nota-fiscal.cod-estabel
                                 AND es-fat-duplic.serie         = nota-fiscal.serie       
                                 AND es-fat-duplic.nr-fatura     = nota-fiscal.nr-fatura
                                 NO-ERROR.
IF AVAIL nota-fiscal THEN DO:

END.
*/
/* QG */

FOR EACH es-envia-boleto WHERE dt-envio = 06/16/2015 NO-LOCK:
    
    ASSIGN iSequencia = 0.        

    /*IF AVAIL nota-fiscal THEN DO:*/
        iCont = iCont + 1.
        /*
        FIND LAST b-es-envia-email USE-INDEX chSeq NO-LOCK NO-ERROR.
        IF NOT AVAIL b-es-envia-email THEN
            ASSIGN iSequencia = 1.
        ELSE
            ASSIGN iSequencia = b-es-envia-email.sequencia + 1.
    
        CREATE es-envia-email.
        ASSIGN es-envia-email.codigo-acesso = "PORTAL"
               es-envia-email.chave-acesso  = nota-fiscal.cod-estabel + "|" + nota-fiscal.serie + "|" + nota-fiscal.nr-nota-fis
               es-envia-email.sequencia     = iSequencia
               es-envia-email.situacao      = 1
               es-envia-email.dt-incl       = TODAY
               es-envia-email.hr-incl       = STRING(TIME,"HH:MM:SS")
               es-envia-email.u-char-1      = "".
    
        ASSIGN es-envia-email.l-xml     = NO
               es-envia-email.l-danfe   = NO
               es-envia-email.l-boleto  = YES.
        */
    /*END.*/
    
END.

MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
