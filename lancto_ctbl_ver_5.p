{include/i-buffer.i}

DEFINE VARIABLE cDescricao  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE deValor     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deSaldo     AS DECIMAL     NO-UNDO.

DEFINE TEMP-TABLE tt-lancto-ctbl NO-UNDO
    FIELD num_lote_ctbl         AS INTE
    FIELD num_lancto_ctbl       AS INTE
    FIELD cod-estab             AS CHAR
    FIELD cenario               AS CHAR
    FIELD un-negocio            AS CHAR
    FIELD conta                 AS CHAR
    FIELD desc-conta            AS CHAR
    FIELD dt-lancto             AS DATE
    FIELD conta-contra          AS CHAR
    FIELD desc-contra           AS CHAR
    FIELD dt-lancto-contra      AS DATE
    FIELD num-lote              AS CHAR
    FIELD descr-lote            AS CHAR
    FIELD modulo                AS CHAR
    FIELD sequencia             AS INTE
    FIELD num-lancto            AS INTE
    FIELD vlr-cred              AS DECI
    FIELD vlr-deb               AS DECI
    FIELD cod-usuario           AS CHAR
    FIELD nome-usuario          AS CHAR
    FIELD hist-contab           AS CHAR.

FOR EACH lancto_ctbl NO-LOCK WHERE lancto_ctbl.cod_empresa = "TOR"
                               AND lancto_ctbl.dat_lancto_ctbl >= 12/01/2016
                               AND lancto_ctbl.dat_lancto_ctbl <= 12/01/2016
                               AND lancto_ctbl.num_lote_ctbl = 250219
                               BY lancto_ctbl.num_lote_ctbl
                               BY lancto_ctbl.num_lancto_ctbl
                               /*AND lancto_ctbl.cod_cenar_ctbl = "FISCAL"*/:

    FIND FIRST lote_ctbl OF lancto_ctbl NO-LOCK NO-ERROR.

    FOR EACH item_lancto_ctbl OF lancto_ctbl WHERE item_lancto_ctbl.cod_unid_negoc <> "80"
                                               AND item_lancto_ctbl.cod_unid_negoc <> "81"
                                               AND item_lancto_ctbl.cod_unid_negoc <> "82"
                                               AND item_lancto_ctbl.cod_unid_negoc <> "83"
                                               AND item_lancto_ctbl.cod_unid_negoc <> "84"
                                               AND NOT item_lancto_ctbl.cod_unid_negoc BEGINS "E"
                                               NO-LOCK BREAK /*BY item_lancto_ctbl.cod_cta_ctbl*/
                                                             BY item_lancto_ctbl.num_seq_lancto_ctbl:

        FIND FIRST aprop_lancto_ctbl OF item_lancto_ctbl WHERE aprop_lancto_ctbl.cod_finalid_econ = "Corrente" NO-LOCK NO-ERROR.
        /*IF aprop_lancto_ctbl.cod_finalid_econ = "Corrente" THEN DO:*/
        
        /*IF FIRST-OF(item_lancto_ctbl.cod_cta_ctbl) THEN*/
            FIND FIRST cta_ctbl WHERE cta_ctbl.cod_cta_ctbl = item_lancto_ctbl.cod_cta_ctbl NO-LOCK NO-ERROR.
            IF AVAIL cta_ctbl THEN
                ASSIGN cDescricao = cta_ctbl.des_tit_ctbl.
    
        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = lote_ctbl.cod_usuar_ult_atualiz NO-LOCK NO-ERROR.
        
        ASSIGN deValor = IF AVAIL aprop_lancto_ctbl THEN aprop_lancto_ctbl.val_lancto_ctbl ELSE item_lancto_ctbl.val_lancto_ctbl.

        IF item_lancto_ctbl.ind_natur_lancto_ctbl = "DB" THEN DO:

            ASSIGN deSaldo = deValor.

            FIND FIRST tt-lancto-ctbl WHERE tt-lancto-ctbl.num_lote_ctbl    = lancto_ctbl.num_lote_ctbl
                                        AND tt-lancto-ctbl.num_lancto_ctbl  = lancto_ctbl.num_lancto_ctbl
                                        AND tt-lancto-ctbl.sequencia        = item_lancto_ctbl.num_seq_lancto_ctbl
                                        NO-ERROR.

             IF NOT AVAIL tt-lancto-ctbl THEN DO:

                CREATE tt-lancto-ctbl.
                ASSIGN tt-lancto-ctbl.num_lote_ctbl     = lancto_ctbl.num_lote_ctbl
                       tt-lancto-ctbl.num_lancto_ctbl   = lancto_ctbl.num_lancto_ctbl
                       tt-lancto-ctbl.sequencia         = item_lancto_ctbl.num_seq_lancto_ctbl
                       tt-lancto-ctbl.cod-estab         = item_lancto_ctbl.cod_estab
                       tt-lancto-ctbl.cenario           = REPLACE(lancto_ctbl.cod_cenar_ctbl,CHR(10),"")
                       tt-lancto-ctbl.un-negocio        = REPLACE(item_lancto_ctbl.cod_unid_negoc,CHR(10),"")
                       tt-lancto-ctbl.conta-contra      = REPLACE(item_lancto_ctbl.cod_cta_ctbl,CHR(10),"")
                       tt-lancto-ctbl.desc-contra       = cDescricao
                       tt-lancto-ctbl.dt-lancto-contra  = lancto_ctbl.dat_lancto_ctbl
                       tt-lancto-ctbl.dt-lancto         = lancto_ctbl.dat_lancto_ctbl
                       tt-lancto-ctbl.num-lote          = STRING(item_lancto_ctbl.num_lote_ctbl)                        
                       tt-lancto-ctbl.descr-lote        = lote_ctbl.des_lote_ctbl
                       tt-lancto-ctbl.modulo            = lote_ctbl.cod_modul_dtsul
                       tt-lancto-ctbl.sequencia         = item_lancto_ctbl.num_seq_lancto_ctbl
                       tt-lancto-ctbl.num-lancto        = item_lancto_ctbl.num_lancto_ctbl
                       tt-lancto-ctbl.vlr-deb           = IF AVAIL aprop_lancto_ctbl THEN aprop_lancto_ctbl.val_lancto_ctbl ELSE item_lancto_ctbl.val_lancto_ctbl
                       tt-lancto-ctbl.cod-usuario       = IF AVAIL lote_ctbl THEN lote_ctbl.cod_usuar_ult_atualiz ELSE ""
                       tt-lancto-ctbl.nome-usuario      = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""
                       tt-lancto-ctbl.hist-contab       = REPLACE(item_lancto_ctbl.des_histor_lancto_ctbl,CHR(10),"").
            END.
        END.
        ELSE DO:
                MESSAGE "1" deSaldo
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ASSIGN deSaldo = deSaldo - deValor.
                MESSAGE "2" deSaldo
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                IF deSaldo = 0 THEN DO:
                    ASSIGN tt-lancto-ctbl.conta         = REPLACE(item_lancto_ctbl.cod_cta_ctbl,CHR(10),"")
                           tt-lancto-ctbl.desc-conta    = cDescricao                       
                           tt-lancto-ctbl.vlr-cred      = IF AVAIL aprop_lancto_ctbl THEN aprop_lancto_ctbl.val_lancto_ctbl ELSE item_lancto_ctbl.val_lancto_ctbl.
                END.

        END.
        /*END.*/
    END.    
    
END.

    OUTPUT TO "C:\temp\lancto_ctbl_122016_.csv.".

    PUT "num_lote_ctbl;"
        "num_lancto_ctbl;"
        "Estab;"
        "Cenario;"
        "Unid. Negocio;"
        "Conta;"
        "Descricao Conta;"
        "Dt Lancto;"
        "Conta Contrapartida;"
        "Descricao Conta Contra;"
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

    FOR EACH tt-lancto-ctbl NO-LOCK:

        PUT UNFORM tt-lancto-ctbl.num_lote_ctbl                         ";"
                   tt-lancto-ctbl.num_lancto_ctbl                       ";"
                   tt-lancto-ctbl.cod-estab                             ";"
                   tt-lancto-ctbl.cenario                               ";"
                   tt-lancto-ctbl.un-negocio                            ";"
                   tt-lancto-ctbl.conta                                 ";"
                   tt-lancto-ctbl.desc-conta                            ";"
                   tt-lancto-ctbl.dt-lancto                             ";"
                   tt-lancto-ctbl.conta-contra                          ";"
                   tt-lancto-ctbl.desc-contra                           ";"
                   tt-lancto-ctbl.dt-lancto-contra                      ";"
                   tt-lancto-ctbl.num-lote                              ";"
                   tt-lancto-ctbl.descr-lote                            ";"
                   tt-lancto-ctbl.modulo                                ";"
                   tt-lancto-ctbl.sequencia                             ";"
                   tt-lancto-ctbl.num-lancto                            ";"
                   tt-lancto-ctbl.vlr-cred                              ";"
                   tt-lancto-ctbl.vlr-deb                               ";"
                   tt-lancto-ctbl.cod-usuario                           ";"
                   tt-lancto-ctbl.nome-usuario                          ";"
                   tt-lancto-ctbl.hist-contab                           SKIP.

    END.

    OUTPUT CLOSE.
