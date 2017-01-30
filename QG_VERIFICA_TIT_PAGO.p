FOR EACH tit_ap NO-LOCK WHERE tit_ap.cod_espec_docto    = "DP"
                          AND tit_ap.cod_empresa        = "TOR"
                          AND tit_ap.cod_estab          = "05"
                          AND tit_ap.cdn_fornecedor     = 205227
                          AND tit_ap.cod_ser_docto      = "3"
                          AND tit_ap.cod_tit_ap         = "0036120"
                          AND tit_ap.cod_parcela        = "1":

    MESSAGE tit_ap.dat_liquidac_tit_ap  SKIP
            tit_ap.val_sdo_tit_ap       SKIP
            tit_ap.val_origin_tit_ap    SKIP
            tit_ap.dat_vencto_tit_ap    SKIP
            tit_ap.cod_estab            SKIP
            tit_ap.cdn_fornecedor       SKIP
            tit_ap.cod_espec_docto      SKIP
            tit_ap.cod_ser_docto        SKIP
            tit_ap.cod_tit_ap           SKIP
            tit_ap.cod_parcela    
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    /*
    FIND LAST movto_tit_ap OF tit_ap /*WHERE movto_tit_ap.ind_trans_ap_abrev = "BXA"*/ NO-LOCK NO-ERROR.
    IF AVAIL movto_tit_ap THEN DO:
    */
    FOR EACH movto_tit_ap OF tit_ap /*WHERE movto_tit_ap.ind_trans_ap_abrev = "BXA"*/ NO-LOCK BY movto_tit_ap.dat_transacao:
    
        MESSAGE "tit_ap.cod_empresa             " tit_ap.cod_empresa              SKIP
                "tit_ap.cod_estab               " tit_ap.cod_estab                SKIP
                "tit_ap.cod_tit_ap              " tit_ap.cod_tit_ap               SKIP
                "tit_ap.cod_ser_docto           " tit_ap.cod_ser_docto            SKIP
                "tit_ap.cod_parcela             " tit_ap.cod_parcela              SKIP
                "tit_ap.cod_espec_docto         " CAPS(tit_ap.cod_espec_docto)    SKIP
                "tit_ap.dat_liquidac_tit_ap     " tit_ap.dat_liquidac_tit_ap      SKIP
                "tit_ap.val_pagto_tit_ap        " tit_ap.val_pagto_tit_ap         SKIP
                "tit_ap.val_sdo_tit_ap          " tit_ap.val_sdo_tit_ap           SKIP
                "tit_ap.val_origin_tit_ap       " tit_ap.val_origin_tit_ap        SKIP
                "tit_ap.dat_vencto_tit_ap       " tit_ap.dat_vencto_tit_ap        SKIP
                "tit_ap.dat_emis_docto          " tit_ap.dat_emis_docto           SKIP
                "tit_ap.ind_origin_tit_ap       " tit_ap.ind_origin_tit_ap        SKIP
                "movto_tit_ap.ind_trans_ap_abrev" movto_tit_ap.ind_trans_ap       SKIP
                "movto_tit_ap.ind_trans_ap_abrev" movto_tit_ap.ind_trans_ap_abrev SKIP
                "movto_tit_ap.dat_transacao     " movto_tit_ap.dat_transacao      SKIP
                "movto_tit_ap.dat_gerac_movto   " movto_tit_ap.dat_gerac_movto    SKIP
                "movto_tit_ap.hra_gerac_movto   " movto_tit_ap.hra_gerac_movto    SKIP
                "movto_tit_ap.cod_refer         " movto_tit_ap.cod_refer
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
    END.
            
END.
