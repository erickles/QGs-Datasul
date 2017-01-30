DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
FOR EACH es-solic-mkt WHERE es-solic-mkt.ini-evento         >= 01/01/2017 
                        AND es-solic-mkt.nivel-hierarquia   = 2
                        :
    iCont = iCont + 1.
    es-solic-mkt.nivel-hierarquia   = 1.
END.
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
