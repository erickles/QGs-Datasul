DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
FOR EACH ws-p-import WHERE DATE(ws-p-import.data-envio) >= 02/05/2016 NO-LOCK:

    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ws-p-import.nr-pedcli NO-LOCK NO-ERROR.
    IF NOT AVAIL ws-p-venda THEN DO:
        iCont = iCont + 1.
    END.

END.

DISP iCont.
