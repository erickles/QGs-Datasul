FIND FIRST tit_acr WHERE tit_acr.cdn_cliente     = 265887
                     AND tit_acr.cod_espec_docto = "DP"
                     AND tit_acr.cod_estab       = "19"
                     AND tit_acr.cod_parcela     = "01"
                     AND tit_acr.cod_ser_docto   = "4"
                     AND tit_acr.cod_tit_acr     = "0364116"
                     NO-LOCK NO-ERROR.
IF AVAIL tit_acr THEN DO:
    FOR EACH movto_tit_acr OF tit_acr NO-LOCK:
    
        FOR EACH  aprop_ctbl_acr 
            WHERE aprop_ctbl_acr.num_id_movto_tit_acr = movto_tit_acr.num_id_movto_tit_acr NO-LOCK.
            DISP movto_tit_acr.cod_motiv_movto_tit_acr aprop_ctbl_acr.cod_cta_ctbl.
        END.
    END.
END.
