DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FOR EACH es-repres-comis WHERE NOT es-repres-comis.log-1
                           AND es-repres-comis.situacao = 1
                           AND es-repres-comis.u-char-2 = "PROMOTOR"
                           /*AND es-repres-comis.u-char-2 = "SUPERVISOR"*/
                           NO-LOCK:
    
    iCont = iCont + 1.
    
END.

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
