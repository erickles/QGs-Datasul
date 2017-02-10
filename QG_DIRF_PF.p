DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

OUTPUT TO "C:\Temp\dirf_pf.csv".

PUT "pessoa"                ";"
    "cod_espec_docto"                ";"  
    "cod_estab"                      ";"  
    "cod_imposto"                    ";"  
    "cod_pais"                       ";"  
    "cod_parcela"                    ";"  
    "cod_ser_docto"                  ";"  
    "cod_tit_ap"                     ";"  
    "cod_unid_federac"               ";"  
    "val_acum_impto_retid_period"    ";"  
    "val_aliq_impto"                 ";"  
    "val_deduc_depend"               ";"  
    "val_deduc_faixa_impto"          ";"  
    "val_deduc_inss"                 ";"  
    "val_deduc_legal"                ";"  
    "val_deduc_pensao"               ";"  
    "val_outras_deduc_impto"         ";"  
    "val_rendto_tribut"              SKIP.

FOR EACH dirf_apb NO-LOCK WHERE YEAR(dirf_apb.dat_refer) = 2016:
    FIND FIRST emsuni.pessoa_fisic WHERE emsuni.pessoa_fisic.num_pessoa_fisic = dirf_apb.num_pessoa NO-LOCK NO-ERROR.
    IF AVAIL emsuni.pessoa_fisic THEN DO:

        PUT emsuni.pessoa_fisic.num_pessoa_fisic    ";"
            dirf_apb.cod_espec_docto                ";"
            dirf_apb.cod_estab                      ";"
            dirf_apb.cod_imposto                    ";"
            dirf_apb.cod_pais                       ";"
            dirf_apb.cod_parcela                    ";"
            dirf_apb.cod_ser_docto                  ";"
            dirf_apb.cod_tit_ap                     ";"
            dirf_apb.cod_unid_federac               ";"
            dirf_apb.val_acum_impto_retid_period    ";"
            dirf_apb.val_aliq_impto                 ";"
            dirf_apb.val_deduc_depend               ";"
            dirf_apb.val_deduc_faixa_impto          ";"
            dirf_apb.val_deduc_inss                 ";"
            dirf_apb.val_deduc_legal                ";"
            dirf_apb.val_deduc_pensao               ";"
            dirf_apb.val_outras_deduc_impto         ";"
            dirf_apb.val_rendto_tribut              ";"
            dirf_apb.dat_refer                      SKIP.
    END.
    
END.
OUTPUT CLOSE.
