DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FOR EACH es-repres-comis WHERE es-repres-comis.log-1 
                           AND es-repres-comis.situacao = 1
                           NO-LOCK:
    
    iCont = iCont + 1.
    
END.

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
