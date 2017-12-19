FIND FIRST tit_acr WHERE tit_acr.cdn_cliente     = 258340
                     AND tit_acr.cod_empresa     = "TOR"
                     AND tit_acr.cod_espec_docto = "AN"
                     AND tit_acr.cod_estab       = "19"
                     AND tit_acr.cod_parcela     = "01"
                     AND tit_acr.cod_ser_docto   = "4"
                     AND tit_acr.cod_tit_acr     = "0425322"
                     NO-LOCK NO-ERROR.

FIND FIRST movto_tit_acr OF tit_acr WHERE movto_tit_acr.ind_trans_acr BEGINS "IMP" NO-LOCK NO-ERROR.
IF AVAIL movto_tit_acr THEN DO:
    FIND FIRST aprop_ctbl_acr OF movto_tit_acr WHERE aprop_ctbl_acr.cod_estab             = movto_tit_acr.cod_estab
                                                 AND aprop_ctbl_acr.num_id_movto_tit_acr  = movto_tit_acr.num_id_movto_tit_acr
                                                 /*AND aprop_ctbl_acr.cod_indic_econ        = "Real"*/
                                                 AND STRING(aprop_ctbl_acr.ind_natur_lancto_ctbl) = "DB"
                                                 NO-LOCK NO-ERROR.
    IF AVAIL aprop_ctbl_acr THEN
        DISP aprop_ctbl_acr.cod_cta_ctbl.
    
END.
