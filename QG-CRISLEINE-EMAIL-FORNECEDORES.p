OUTPUT TO "c:\Emails_transportadores.csv".
/* FOR EACH emitente WHERE INTE(emitente.identific) = 2,                             */
/*     EACH es-emit-fornec WHERE es-emit-fornec.cod-emitente = emitente.cod-emitente */
/*                           AND es-emit-fornec.log-2 NO-LOCK:                       */
/*     PUT emitente.nome-emit ";"                                                    */
/*         emitente.e-mail SKIP.                                                     */
/* END.                                                                              */
PUT "Cod.Transp " ";"
    "Nome Transp" ";"
    "E-mail"      SKIP.  
FOR EACH cont-tran NO-LOCK,
    EACH transporte WHERE transporte.cod-transp = cont-tran.cod-transp NO-LOCK:
    PUT cont-tran.cod-transp ";"
        transporte.nome      ";"
        REPLACE(cont-tran.e-mail,CHR(10),"") FORMAT "X(40)" SKIP.
END.
OUTPUT CLOSE.
