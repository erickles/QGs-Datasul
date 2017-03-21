DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE BUFFER bf_usuar_financ_estab_apb FOR usuar_financ_estab_apb.
FOR EACH usuar_financ_estab_apb WHERE usuar_financ_estab_apb.cod_estab = "19":
    iCont = iCont + 1.
    
    CREATE bf_usuar_financ_estab_apb.
    BUFFER-COPY usuar_financ_estab_apb EXCEPT usuar_financ_estab_apb.cod_estab TO bf_usuar_financ_estab_apb.
    bf_usuar_financ_estab_apb.cod_estab = "36".
    
END.
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
