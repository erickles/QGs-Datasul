DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE BUFFER bf_usuar_financ_estab_acr FOR usuar_financ_estab_acr.
FOR EACH usuar_financ_estab_acr WHERE usuar_financ_estab_acr.cod_estab = "19":
    iCont = iCont + 1.
    CREATE bf_usuar_financ_estab_acr.
    BUFFER-COPY usuar_financ_estab_acr EXCEPT usuar_financ_estab_acr.cod_estab TO bf_usuar_financ_estab_acr.
    bf_usuar_financ_estab_acr.cod_estab = "36".
END.
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
