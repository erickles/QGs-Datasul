DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = "fcs43831" NO-LOCK NO-ERROR.
    
    /**/

FOR EACH es-solic-mkt WHERE (es-solic-mkt.nome-ab-reg = "MA 01"
                         OR es-solic-mkt.nome-ab-reg = "MA 02" 
                         OR es-solic-mkt.nome-ab-reg = "TO 01"
                         OR es-solic-mkt.nome-ab-reg = "TO 02")
                         AND YEAR(es-solic-mkt.ini-evento) = 2017
                         AND es-solic-mkt.nivel-hierarquia = 1:
    /*
    ASSIGN es-solic-mkt.cod-usuario = usuar_mestre.cod_usuario
           es-solic-mkt.super-resp  = usuar_mestre.nom_usuario
    */

    /*ASSIGN es-solic-mkt.nivel-hierarquia = 1.*/

    DISP es-solic-mkt.cod-usuario.
    iCont = iCont + 1.
END.
MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
