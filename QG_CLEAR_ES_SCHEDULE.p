DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FOR EACH es-schedule WHERE es-schedule.id = ?:
    iCont = iCont + 1.
    DELETE es-schedule.
END.

MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
