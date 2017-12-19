
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = "mhb66890" NO-LOCK NO-ERROR.
    
FOR EACH es-solic-mkt WHERE es-solic-mkt.cod-usuario = "rsr44439":
    
    iCont = iCont + 1.
    
    ASSIGN es-solic-mkt.cod-usuario = usuar_mestre.cod_usuario
           es-solic-mkt.super-resp  = usuar_mestre.nom_usuario.
    
END.

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
