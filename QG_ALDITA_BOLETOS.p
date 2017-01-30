DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
FOR EACH es-fat-duplic WHERE es-fat-duplic.data-geracao >= 10/09/2014
                         AND es-fat-duplic.data-geracao <= 10/12/2014
                         AND es-fat-duplic.u-log-1      = NO
                         NO-LOCK:
    iCont = iCont + 1.
END.
MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
