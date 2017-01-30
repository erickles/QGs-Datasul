DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FOR EACH es-fat-duplic WHERE es-fat-duplic.u-log-1 = NO
                         AND es-fat-duplic.data-geracao >= 11/23/2011
                         NO-LOCK:
    iCont = iCont + 1.
END.
MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
