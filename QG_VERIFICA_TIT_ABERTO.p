FOR EACH tit_ap NO-LOCK WHERE tit_ap.cod_espec_docto    = "DP"
                          AND tit_ap.cod_empresa        = "TOR"
                          AND tit_ap.cod_estab          = "19"
                          AND tit_ap.cdn_fornecedor     = 174953
                          AND tit_ap.cod_ser_docto      = "1"
                          AND tit_ap.cod_tit_ap         = "0219244"
                          AND tit_ap.cod_parcela        = "1":
    
    /*FIND FIRST movto_tit_ap OF tit_ap WHERE movto_tit_ap.ind_trans_ap_abrev = "IMPL" NO-LOCK NO-ERROR.*/
        
    /*IF AVAIL movto_tit_ap AND movto_tit_ap.dat_transacao <= 04/30/2014 THEN*/
    FOR EACH movto_tit_ap OF tit_ap NO-LOCK:

    
        MESSAGE "tit_ap.cod_empresa             " tit_ap.cod_empresa                SKIP
                "tit_ap.cod_estab               " tit_ap.cod_estab                  SKIP
                "tit_ap.cod_tit_ap              " tit_ap.cod_tit_ap                 SKIP
                "tit_ap.cod_ser_docto           " tit_ap.cod_ser_docto              SKIP
                "tit_ap.cod_parcela             " tit_ap.cod_parcela                SKIP
                "CAPS(tit_ap.cod_espec_docto)   " CAPS(tit_ap.cod_espec_docto)      SKIP
                "tit_ap.dat_liquidac_tit_ap     " tit_ap.dat_liquidac_tit_ap        SKIP
                "tit_ap.val_pagto_tit_ap        " tit_ap.val_pagto_tit_ap           SKIP
                "tit_ap.val_sdo_tit_ap          " tit_ap.val_sdo_tit_ap             SKIP
                "tit_ap.val_origin_tit_ap       " tit_ap.val_origin_tit_ap          SKIP
                "tit_ap.dat_vencto_tit_ap       " tit_ap.dat_vencto_tit_ap          SKIP
                "tit_ap.dat_emis_docto          " tit_ap.dat_emis_docto             SKIP
                "tit_ap.ind_origin_tit_ap       " tit_ap.ind_origin_tit_ap          SKIP
                "movto_tit_ap.ind_trans_ap      " movto_tit_ap.ind_trans_ap         SKIP
                "movto_tit_ap.ind_trans_ap_abrev" movto_tit_ap.ind_trans_ap_abrev   SKIP
                "movto_tit_ap.dat_transacao     " movto_tit_ap.dat_transacao        SKIP
                "movto_tit_ap.val_sdo_apos_movto" movto_tit_ap.val_sdo_apos_movto   SKIP
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
END.
