FIND FIRST bord_ap WHERE bord_ap.cod_estab_bord = "01"
                     AND bord_ap.cod_portador   = "34110"
                     AND bord_ap.num_bord_ap    = 1562
                     NO-ERROR.
IF AVAIL bord_ap THEN DO:
    /*UPDATE bord_ap.ind_sit_bord_ap bord_ap.log_bord_ap_escrit_envdo.*/

    FOR EACH item_bord_ap OF bord_ap:
        /*UPDATE item_bord_ap.ind_sit_envio_escrit.*/
        /*
        DISP item_bord_ap.cod_tit_ap 
             item_bord_ap.cdn_fornecedor              
             item_bord_ap.cod_espec_docto 
             item_bord_ap.cod_estab 
             item_bord_ap.cod_parcela 
             item_bord_ap.cod_ser_docto
             item_bord_ap.val_pagto.
        */

        /*DISP item_bord_ap WITH WIDTH 300.*/

        
        IF item_bord_ap.cod_tit_ap <> "" THEN DO:
        
            
            FIND FIRST tit_ap OF item_bord_ap NO-LOCK NO-ERROR.
            
            DISP IF AVAIL tit_ap THEN STRING(TRIM(tit_ap.cb4_tit_ap_bco_cobdor),"99999999999999999999999999999999999999999999999999.") ELSE ""
                 item_bord_ap.cod_tit_ap 
                 item_bord_ap.cdn_fornecedor              
                 item_bord_ap.cod_espec_docto 
                 item_bord_ap.cod_estab 
                 item_bord_ap.cod_parcela 
                 item_bord_ap.cod_ser_docto
                 item_bord_ap.val_pagto.
                 
        END.
        ELSE DO:
            FIND FIRST movto_tit_ap USE-INDEX mvtttp_refer WHERE movto_tit_ap.cod_refer            = item_bord_ap.cod_refer_antecip_pef
                                                             AND movto_tit_ap.cod_estab            = item_bord_ap.cod_estab
                                                             AND movto_tit_ap.cdn_fornecedor       = item_bord_ap.cdn_fornecedor
                                                             AND (movto_tit_ap.ind_trans_ap_abrev  = "PGEF" OR movto_tit_ap.ind_trans_ap_abrev  = "PECR")
                                                             NO-LOCK NO-ERROR.
            IF AVAIL movto_tit_ap THEN DO:

                FIND FIRST antecip_pef_pend WHERE antecip_pef_pend.cod_estab = movto_tit_ap.cod_estab
                                              AND antecip_pef_pend.cod_refer = movto_tit_ap.cod_refer
                                              NO-LOCK NO-ERROR.
                IF AVAIL antecip_pef_pend THEN
                    DISP antecip_pef_pend.cb4_tit_ap_bco_cobdor "OK".

            END.
        END.
            
    END.

END.
