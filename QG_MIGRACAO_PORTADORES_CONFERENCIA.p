DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE iContPedidos AS INTEGER     NO-UNDO.

DEFINE BUFFER bf-emitente FOR emitente.

FOR EACH emitente WHERE emitente.estado <> "EX"
                    AND emitente.nome-abre = emitente.nome-matriz
                    AND emitente.port-pref = 112
                    NO-LOCK:
    iCont = iCont + 1.

END.

MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
