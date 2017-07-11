DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FOR EACH es-solic-mkt WHERE es-solic-mkt.cod-usuario = "gme69889":

    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = "rsr44439" NO-LOCK NO-ERROR.
        
    ASSIGN es-solic-mkt.cod-usuario = usuar_mestre.cod_usuario
           es-solic-mkt.super-resp  = usuar_mestre.nom_usuario.
    iCont = iCont + 1.
END.

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
