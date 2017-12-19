DEFINE VARIABLE c-situacao        AS CHARACTER   NO-UNDO EXTENT 6 INIT ["Marcado para Inclusao","Enviado para Inclusao","Incluido no Pefin","Marcado para Exclusao","Enviado para Exclusao","Excluido do Pefin"].

FIND FIRST es-titulo-cr WHERE es-titulo-cr.ep-codigo   = "1"
                          AND es-titulo-cr.cod-estabel = "23"
                          AND es-titulo-cr.cod-esp     = "DP"
                          AND es-titulo-cr.serie       = "1"
                          AND es-titulo-cr.nr-docto    = "0001215"
                          AND es-titulo-cr.parcela     = "02"
                          NO-ERROR.
IF AVAIL es-titulo-cr THEN DO:

    /*iCont = iCont + 1.*/
    
    ASSIGN es-titulo-cr.situacao-pefin = 0.
    
    IF es-titulo-cr.tem-pefin THEN
        MESSAGE "Tem pefin" 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ELSE
        IF es-titulo-cr.situacao-pefin > 0 AND es-titulo-cr.situacao-pefin < 5 THEN
                MESSAGE "Aparece triangulo"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ELSE 
            MESSAGE "Nao aparece triangulo"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

        IF es-titulo-cr.situacao-pefin > 0 AND es-titulo-cr.situacao-pefin < 7 THEN
            MESSAGE "Pefin Serasa - " + c-situacao[es-titulo-cr.situacao-pefin]
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        ELSE 
            MESSAGE "Pefin Serasa"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
END.
