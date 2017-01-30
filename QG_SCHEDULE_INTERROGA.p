DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FOR EACH es-schedule WHERE es-schedule.id = ?:
    iCont = iCont + 1.
    DELETE es-schedule.
END.
DISP iCont.
