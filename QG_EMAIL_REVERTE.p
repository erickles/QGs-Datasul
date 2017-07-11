DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
FOR EACH es-envia-email WHERE codigo-acesso = 'DESCONTO'
                          AND dt-incl       = 04/24/2017
                         AND para = 'muriell.murata@dsm.com':
    iCont = iCont + 1.
    ASSIGN es-envia-email.situacao = 1
           es-envia-email.dt-env   = ?
           es-envia-email.hr-env   = ""
           es-envia-email.erro     = "".
END.

