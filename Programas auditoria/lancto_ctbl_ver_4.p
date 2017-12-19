{include/i-buffer.i}

DEFINE VARIABLE cDescricao AS CHARACTER   NO-UNDO.

OUTPUT TO "C:\temp\lancto_ctbl_01_2017_11_2017.csv.".

PUT "num_lote_ctbl;"
    "num_lancto_ctbl;"
    "Estab;"
    "Cenario;"
    "Unid. Negocio;"
    "Conta;"
    "Descricao Conta;"
    "Dt Lancto;"
    "Num Lote;"
    "Descr. Lote;"
    "Modulo DtSul;"
    "Sequencia Lancto;"
    "Num Lancto Ctbl;"
    "Valor Cred.;"
    "Valor Deb.;"
    "Cod Usuario;"
    "Nome Usuario;"
    "Hist. Contab"
    SKIP.

FOR EACH lancto_ctbl NO-LOCK WHERE lancto_ctbl.cod_empresa = "TOR"
                               AND lancto_ctbl.dat_lancto_ctbl >= 01/01/2017
                               AND lancto_ctbl.dat_lancto_ctbl <= 11/30/2017
                               /*AND lancto_ctbl.cod_cenar_ctbl = "FISCAL"*/:

    FIND FIRST lote_ctbl OF lancto_ctbl NO-LOCK NO-ERROR.

    FOR EACH item_lancto_ctbl OF lancto_ctbl WHERE item_lancto_ctbl.cod_unid_negoc <> "80"
                                               AND item_lancto_ctbl.cod_unid_negoc <> "81"
                                               AND item_lancto_ctbl.cod_unid_negoc <> "82"
                                               AND item_lancto_ctbl.cod_unid_negoc <> "83"
                                               AND item_lancto_ctbl.cod_unid_negoc <> "84"
                                               AND NOT item_lancto_ctbl.cod_unid_negoc BEGINS "E"
                                               NO-LOCK BREAK BY item_lancto_ctbl.cod_cta_ctbl:

        FIND FIRST aprop_lancto_ctbl OF item_lancto_ctbl WHERE aprop_lancto_ctbl.cod_finalid_econ = "Corrente" NO-LOCK NO-ERROR.
        /*IF aprop_lancto_ctbl.cod_finalid_econ = "Corrente" THEN DO:*/
        
            IF FIRST-OF(item_lancto_ctbl.cod_cta_ctbl) THEN
                FIND FIRST cta_ctbl WHERE cta_ctbl.cod_cta_ctbl = item_lancto_ctbl.cod_cta_ctbl NO-LOCK NO-ERROR.
                IF AVAIL cta_ctbl THEN
                    ASSIGN cDescricao = cta_ctbl.des_tit_ctbl.
    
            FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = lote_ctbl.cod_usuar_ult_atualiz NO-LOCK NO-ERROR.
                
            PUT UNFORM  lancto_ctbl.num_lote_ctbl                                                                                                                           ";"
                        lancto_ctbl.num_lancto_ctbl                                                                                                                         ";"
                        item_lancto_ctbl.cod_estab                                                                                                                          ";"
                        REPLACE(lancto_ctbl.cod_cenar_ctbl,CHR(10),"")                                                                                                      ";"
                        REPLACE(item_lancto_ctbl.cod_unid_negoc,CHR(10),"")                                                                                                 ";"
                        REPLACE(item_lancto_ctbl.cod_cta_ctbl,CHR(10),"")                                                                                                   ";"
                        cDescricao                                                                                                                                          ";"
                        STRING(lancto_ctbl.dat_lancto_ctbl,"99/99/9999")                                                                                                    ";"
                        STRING(item_lancto_ctbl.num_lote_ctbl)                                                                                                              ";"
                        lote_ctbl.des_lote_ctbl                                                                                                                             ";"
                        lote_ctbl.cod_modul_dtsul                                                                                                                           ";"
                        item_lancto_ctbl.num_seq_lancto_ctbl                                                                                                                ";"
                        STRING(item_lancto_ctbl.num_lancto_ctbl)                                                                                                            ";"

                        IF item_lancto_ctbl.ind_natur_lancto_ctbl = "CR" THEN (IF AVAIL aprop_lancto_ctbl THEN 
                                                                                    STRING(aprop_lancto_ctbl.val_lancto_ctbl,">>>,>>>,>>9.9999") 
                                                                               ELSE 
                                                                                    STRING(item_lancto_ctbl.val_lancto_ctbl,">>>,>>>,>>9.9999")) 
                        ELSE 
                            STRING(0,">>>,>>>,>>9.9999") ";"

                        IF item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" THEN (IF AVAIL aprop_lancto_ctbl THEN
                                                                                    STRING(aprop_lancto_ctbl.val_lancto_ctbl,">>>,>>>,>>9.9999") 
                                                                               ELSE
                                                                                   STRING(item_lancto_ctbl.val_lancto_ctbl,">>>,>>>,>>9.9999"))
                        ELSE 
                            STRING(0,">>>,>>>,>>9.9999") ";"

                        IF AVAIL lote_ctbl THEN lote_ctbl.cod_usuar_ult_atualiz ELSE ""                                                                                     ";"
                        IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""                                                                                         ";"
                        REPLACE(item_lancto_ctbl.des_histor_lancto_ctbl,CHR(10),"")                                                                                         ";"
                        SKIP.
        /*END.*/
    END.

END.

OUTPUT CLOSE.
