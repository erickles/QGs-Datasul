/* DISABLE TRIGGERS FOR LOAD OF tit_acr.        */
/* DISABLE TRIGGERS FOR LOAD OF movto_tit_acr.  */
/* DISABLE TRIGGERS FOR LOAD OF es-movto-comis. */
/* OUTPUT TO C:\TEMP\COMIS-VDS.D.  */
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
FOR EACH es-movto-comis WHERE es-movto-comis.dt-apuracao >= 01/27/2015
                          AND es-movto-comis.dt-apuracao <= 01/31/2015
                          AND es-movto-comis.tp-movto  = 101
                          AND es-movto-comis.ep-codigo = 1
                            NO-LOCK.

    DISP es-movto-comis.dt-apuracao
         es-movto-comis.dt-trans
         es-movto-comis.u-date-1
         es-movto-comis.dt-today WITH WIDTH 300.

/*     iCont = iCont + 1. */
/*     DISP es-movto-comis EXCEPT u-char-1 u-char-2 WITH WIDTH 300 1 COL. */

/*     ASSIGN es-movto-comis.dt-apuracao = 02/01/2015  */
/*            es-movto-comis.u-date-1    = 01/31/2015. */

/*     EXPORT ES-MOVTO-COMIS. */

END.

/* MESSAGE iCont                          */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK. */

/* OUTPUT CLOSE. */

/* FOR EACH tit_acr NO-LOCK WHERE tit_acr.cod_empresa = "tor"          */
/*                            AND tit_acr.dat_emis_docto = 01/31/2015: */
/*                                                                     */
/*     iCont = iCont + 1.                                              */
/*                                                                     */
/* END.                                                                */
/*                                                                     */
/* MESSAGE icont                                                       */
/*     VIEW-AS ALERT-BOX INFO BUTTONS OK.                              */
