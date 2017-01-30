DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FOR EACH tit_acr WHERE tit_acr.cod_espec_docto      = "AV"
                   AND tit_acr.val_sdo_tit_acr      < 50
                   AND tit_acr.val_sdo_tit_acr      > 0
                   AND tit_acr.cod_estab            > ""
                   AND tit_acr.cod_estab            < "ZZZ"
                   AND tit_acr.dat_emis_docto       >= 01/01/2015
                   AND tit_acr.dat_emis_docto       <= 12/31/2015
                   BREAK BY tit_acr.dat_emis_docto:
    /*
    DISP tit_acr.val_origin_tit_acr
         tit_acr.val_sdo_tit_acr
         tit_acr.dat_emis_docto.
    */
    ASSIGN tit_acr.val_sdo_tit_acr = 0.

    iCont = iCont + 1.
END.
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
