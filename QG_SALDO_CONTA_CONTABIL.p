FOR EACH cta_ctbl WHERE cta_ctbl.cod_cta_ctbl = "2110105", 
                   EACH sdo_cta_ctbl OF cta_ctbl WHERE MONTH(sdo_cta_ctbl.dat_sdo_ctbl) = 04
                                                   AND YEAR(sdo_cta_ctbl.dat_sdo_ctbl) = 2014
                                                   NO-LOCK:

    DISP sdo_cta_ctbl.val_sdo_ctbl_cr
         sdo_cta_ctbl.val_sdo_ctbl_db
         sdo_cta_ctbl.val_sdo_ctbl_fim.

END.
