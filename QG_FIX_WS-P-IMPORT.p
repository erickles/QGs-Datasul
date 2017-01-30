DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
FOR EACH ws-p-import WHERE ws-p-import.implantado = NO:
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ws-p-import.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN
        ASSIGN iCont = iCont + 1
               ws-p-import.implantado = YES.
END.

MESSAGE "1" SKIP
        iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

iCont = 0.

FOR EACH ws-p-import WHERE ws-p-import.erro = YES:
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ws-p-import.nr-pedcli NO-LOCK NO-ERROR.
        IF AVAIL ws-p-venda THEN
            ASSIGN iCont = iCont + 1
                   ws-p-import.erro = NO.
END.

MESSAGE "2" SKIP
        iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

iCont = 0.

FOR EACH ws-p-import WHERE ws-p-import.implantado:
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ws-p-import.nr-pedcli NO-LOCK NO-ERROR.
        IF AVAIL ws-p-venda THEN
            IF ws-p-import.data-implantado = ? THEN
                ASSIGN iCont = iCont + 1
                       ws-p-import.data-implantado = NOW.
END.

MESSAGE "3" SKIP
        iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
