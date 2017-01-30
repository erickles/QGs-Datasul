DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
FOR EACH recebimento WHERE recebimento.conta-contabil = 0 
                       AND YEAR(recebimento.data-movto) = 2012
                       NO-LOCK:

    iCont = iCont + 1.

END.
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
