DEFINE VARIABLE iCodFornec AS INTEGER     NO-UNDO.

UPDATE iCodFornec.

FIND FIRST es-emit-fornec WHERE cod-emitente = iCodFornec.
/*
ASSIGN OVERLAY(es-emit-fornec.char-1,32,1) = "X"
       OVERLAY(es-emit-fornec.char-1,57,1) = "X".
       */
ASSIGN OVERLAY(es-emit-fornec.char-1,31,1) = "S".
MESSAGE substr(es-emit-fornec.char-1,31,1)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

