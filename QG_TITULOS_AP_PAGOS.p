DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO.

{include/i-freeac.i}

DEFINE VARIABLE dtApuracao  AS DATE        NO-UNDO.
DEFINE VARIABLE dtInicial   AS DATE        NO-UNDO.
DEFINE VARIABLE dtFinal     AS DATE        NO-UNDO.

/*
cod_estab
cdn_fornecedor
cod_espec_docto
cod_ser_docto
cod_tit_ap
cod_parcela
*/

DEFINE TEMP-TABLE tt-pagamentos
    FIELD cod_empresa           AS CHAR
    FIELD cod_estab             AS CHAR
    FIELD cod_tit_ap            AS CHAR
    FIELD cod_espec_docto       AS CHAR
    FIELD serie_tit             AS CHAR
    FIELD cod_ser_docto         AS CHAR
    FIELD parcela               AS CHAR
    FIELD cod_parcela           AS CHAR
    FIELD especie               AS CHAR
    FIELD dt_liquida            AS DATE FORMAT 99/99/9999
    FIELD valor_pagamento       AS DECI FORMAT "->>>,>>>,>>9.99"
    FIELD valor_saldo           AS DECI FORMAT "->>>,>>>,>>9.99"
    FIELD valor_original        AS DECI FORMAT "->>>,>>>,>>9.99"
    FIELD dt_vencimento         AS DATE FORMAT 99/99/9999
    FIELD cdn_fornecedor        AS INTE
    FIELD nome_fornecedor       AS CHAR FORMAT "X(40)"
    FIELD nome_abrev_fornec     AS CHAR
    FIELD cod_grp_fornec        AS CHAR
    FIELD nome_grp_fornec       AS CHAR
    FIELD dat_emis_docto        AS DATE FORMAT 99/99/9999
    FIELD ind_origin_tit_ap     AS CHAR
    FIELD ind_trans_ap          AS CHAR
    FIELD ind_trans_ap_abrev    AS CHAR
    FIELD dat_transacao         AS DATE FORMAT 99/99/9999
    FIELD cod_portador          AS CHAR
    FIELD dat_prev_pagto        AS DATE FORMAT 99/99/9999
    FIELD cod_indic_econ        AS CHAR
    FIELD valor_multa           AS DECI FORMAT "->>>,>>>,>>9.99"
    FIELD valor_juros           AS DECI FORMAT "->>>,>>>,>>9.99"
    FIELD valor_cm              AS DECI FORMAT "->>>,>>>,>>9.99"
    FIELD valor_desconto        AS DECI FORMAT "->>>,>>>,>>9.99"
    FIELD valor_abatimento      AS DECI FORMAT "->>>,>>>,>>9.99"
    FIELD cod_refer             AS CHAR
    FIELD cod_forma_pagto       AS CHAR
    FIELD cod_contrat_leas      AS CHAR
    FIELD dt_apuracao           AS DATE.

DEFINE BUFFER bf-pagamentos FOR tt-pagamentos.

ASSIGN dtApuracao = 03/01/2014.

ASSIGN dtInicial = DATE("01/" + STRING(MONTH(dtApuracao)) + "/" + STRING(YEAR(dtApuracao)))
       dtFinal   = DATE("01/" + STRING(MONTH(dtApuracao) + 1) + "/" + STRING(YEAR(dtApuracao))) - 1.

/* Fase 1 - lista todos os adiantamentos da empresa TOR, com saldo zerado (pago), com valor maior que zero e vencimeno dentro do mes de apuracao*/
FOR EACH tit_ap NO-LOCK WHERE tit_ap.cod_espec_docto        = "AF"
                          AND tit_ap.cod_empresa            = "TOR"
                          AND tit_ap.dat_vencto_tit_ap      >= dtInicial
                          AND tit_ap.dat_vencto_tit_ap      <= dtFinal
                          AND tit_ap.val_sdo_tit_ap         = 0
                          AND tit_ap.val_origin_tit_ap      > 0,
                          EACH emsuni.fornecedor OF tit_ap WHERE fornecedor.cod_grp_fornec = "1"
                                                              OR fornecedor.cod_grp_fornec = "3" NO-LOCK:

    FIND LAST movto_tit_ap OF tit_ap WHERE movto_tit_ap.ind_trans_ap_abrev = "BXA" NO-LOCK NO-ERROR.

    IF AVAIL movto_tit_ap THEN DO:

        FIND FIRST grp_fornec WHERE grp_fornec.cod_grp_fornec = emsuni.fornecedor.cod_grp_fornec NO-LOCK NO-ERROR.

        FIND FIRST tt-pagamentos WHERE tt-pagamentos.cod_estab       = tit_ap.cod_estab
                                   AND tt-pagamentos.cdn_fornecedor  = fornecedor.cdn_fornecedor
                                   AND tt-pagamentos.cod_espec_docto = tit_ap.cod_espec_docto
                                   AND tt-pagamentos.cod_ser_docto   = tit_ap.cod_ser_docto
                                   AND tt-pagamentos.cod_tit_ap      = tit_ap.cod_tit_ap
                                   AND tt-pagamentos.cod_parcela     = tit_ap.cod_parcela
                                   NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-pagamentos THEN DO:

            CREATE tt-pagamentos.
            ASSIGN tt-pagamentos.cod_empresa        = tit_ap.cod_empresa
                   tt-pagamentos.cod_estab          = tit_ap.cod_estab
                   tt-pagamentos.cod_tit_ap         = tit_ap.cod_tit_ap
                   tt-pagamentos.cod_espec_docto    = tit_ap.cod_espec_docto
                   tt-pagamentos.serie_tit          = tit_ap.cod_ser_docto
                   tt-pagamentos.cod_ser_docto      = tit_ap.cod_ser_docto
                   tt-pagamentos.parcela            = tit_ap.cod_parcela
                   tt-pagamentos.cod_parcela        = tit_ap.cod_parcela
                   tt-pagamentos.especie            = CAPS(tit_ap.cod_espec_docto)
                   tt-pagamentos.dt_liquida         = tit_ap.dat_liquidac_tit_ap
                   tt-pagamentos.valor_pagamento    = tit_ap.val_pagto_tit_ap
                   tt-pagamentos.valor_saldo        = tit_ap.val_sdo_tit_ap
                   tt-pagamentos.valor_original     = tit_ap.val_origin_tit_ap
                   tt-pagamentos.dt_vencimento      = tit_ap.dat_vencto_tit_ap
                   tt-pagamentos.cdn_fornecedor     = fornecedor.cdn_fornecedor
                   tt-pagamentos.nome_fornecedor    = fornecedor.nom_pessoa
                   tt-pagamentos.nome_abrev_fornec  = fornecedor.nom_abrev
                   tt-pagamentos.cod_grp_fornec     = fornecedor.cod_grp_fornec
                   tt-pagamentos.nome_grp_fornec    = IF AVAIL grp_fornec THEN grp_fornec.des_grp_fornec ELSE ""
                   tt-pagamentos.dat_emis_docto     = tit_ap.dat_emis_docto
                   tt-pagamentos.ind_origin_tit_ap  = tit_ap.ind_origin_tit_ap
                   tt-pagamentos.ind_trans_ap       = fn-free-accent(movto_tit_ap.ind_trans_ap)
                   tt-pagamentos.ind_trans_ap_abrev = fn-free-accent(movto_tit_ap.ind_trans_ap_abrev)
                   tt-pagamentos.dat_transacao      = movto_tit_ap.dat_gerac_movto
                   tt-pagamentos.cod_portador       = tit_ap.cod_portador
                   tt-pagamentos.dat_prev_pagto     = tit_ap.dat_prev_pagto
                   tt-pagamentos.cod_indic_econ     = tit_ap.cod_indic_econ
                   tt-pagamentos.valor_multa        = tit_ap.val_multa_tit_ap
                   tt-pagamentos.valor_juros        = tit_ap.val_juros
                   tt-pagamentos.valor_cm           = tit_ap.val_cm_tit_ap
                   tt-pagamentos.valor_desconto     = tit_ap.val_desconto
                   tt-pagamentos.valor_abatimento   = tit_ap.val_abat_tit_ap
                   tt-pagamentos.cod_refer          = tit_ap.cod_refer
                   tt-pagamentos.cod_forma_pagto    = tit_ap.cod_forma_pagto
                   tt-pagamentos.cod_contrat_leas   = tit_ap.cod_contrat_leas
                   tt-pagamentos.dt_apuracao        = dtApuracao.
        END.
    END.
END.

/* Fase 2 - Lista as duplicatas. Caso haja adiantamento do fornecedor, considerar apenas o mesmo no relatorio */
FOR EACH tit_ap NO-LOCK WHERE tit_ap.cod_espec_docto        = "DP"
                          AND tit_ap.cod_empresa            = "TOR"
                          AND tit_ap.dat_liquidac_tit_ap    >= dtInicial
                          AND tit_ap.dat_liquidac_tit_ap    <= dtFinal
                          AND tit_ap.dat_vencto_tit_ap      >= dtInicial
                          AND tit_ap.dat_vencto_tit_ap      <= dtFinal
                          AND tit_ap.val_sdo_tit_ap         = 0
                          AND tit_ap.val_origin_tit_ap      > 0,
                          EACH emsuni.fornecedor OF tit_ap WHERE fornecedor.cod_grp_fornec = "1"
                                                              OR fornecedor.cod_grp_fornec = "3" NO-LOCK:

    FIND LAST movto_tit_ap OF tit_ap WHERE movto_tit_ap.ind_trans_ap_abrev = "BXA" NO-LOCK NO-ERROR.

    IF AVAIL movto_tit_ap AND movto_tit_ap.dat_transacao <= dtFinal
                          AND movto_tit_ap.dat_transacao >= dtInicial  THEN DO:

        FIND FIRST grp_fornec WHERE grp_fornec.cod_grp_fornec = emsuni.fornecedor.cod_grp_fornec NO-LOCK NO-ERROR.

        FIND FIRST tt-pagamentos WHERE tt-pagamentos.cod_estab       = tit_ap.cod_estab
                                   AND tt-pagamentos.cdn_fornecedor  = emsuni.fornecedor.cdn_fornecedor
                                   AND tt-pagamentos.cod_espec_docto = tit_ap.cod_espec_docto
                                   AND tt-pagamentos.cod_ser_docto   = tit_ap.cod_ser_docto
                                   AND tt-pagamentos.cod_tit_ap      = tit_ap.cod_tit_ap
                                   AND tt-pagamentos.cod_parcela     = tit_ap.cod_parcela
                                   NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-pagamentos THEN DO:

            /* Verifica se fornecedor possui adiantamento, caso tenha desconsidera o titulo */
            FIND FIRST bf-pagamentos WHERE bf-pagamentos.cdn_fornecedor  = emsuni.fornecedor.cdn_fornecedor
                                       AND bf-pagamentos.cod_espec_docto = "AF"
                                       NO-ERROR.
            IF AVAIL bf-pagamentos THEN
                NEXT.
            ELSE DO:

                CREATE tt-pagamentos.
                ASSIGN tt-pagamentos.cod_empresa        = tit_ap.cod_empresa
                       tt-pagamentos.cod_estab          = tit_ap.cod_estab
                       tt-pagamentos.cod_tit_ap         = tit_ap.cod_tit_ap
                       tt-pagamentos.cod_espec_docto    = tit_ap.cod_espec_docto
                       tt-pagamentos.serie_tit          = tit_ap.cod_ser_docto
                       tt-pagamentos.cod_ser_docto      = tit_ap.cod_ser_docto
                       tt-pagamentos.parcela            = tit_ap.cod_parcela
                       tt-pagamentos.cod_parcela        = tit_ap.cod_parcela
                       tt-pagamentos.especie            = CAPS(tit_ap.cod_espec_docto)
                       tt-pagamentos.dt_liquida         = tit_ap.dat_liquidac_tit_ap
                       tt-pagamentos.valor_pagamento    = tit_ap.val_pagto_tit_ap
                       tt-pagamentos.valor_saldo        = tit_ap.val_sdo_tit_ap
                       tt-pagamentos.valor_original     = tit_ap.val_origin_tit_ap
                       tt-pagamentos.dt_vencimento      = tit_ap.dat_vencto_tit_ap
                       tt-pagamentos.cdn_fornecedor     = fornecedor.cdn_fornecedor
                       tt-pagamentos.nome_fornecedor    = fornecedor.nom_pessoa
                       tt-pagamentos.nome_abrev_fornec  = fornecedor.nom_abrev
                       tt-pagamentos.cod_grp_fornec     = fornecedor.cod_grp_fornec
                       tt-pagamentos.nome_grp_fornec    = IF AVAIL grp_fornec THEN grp_fornec.des_grp_fornec ELSE ""
                       tt-pagamentos.dat_emis_docto     = tit_ap.dat_emis_docto
                       tt-pagamentos.ind_origin_tit_ap  = tit_ap.ind_origin_tit_ap
                       tt-pagamentos.ind_trans_ap       = fn-free-accent(movto_tit_ap.ind_trans_ap)
                       tt-pagamentos.ind_trans_ap_abrev = fn-free-accent(movto_tit_ap.ind_trans_ap_abrev)
                       tt-pagamentos.dat_transacao      = movto_tit_ap.dat_transacao
                       tt-pagamentos.cod_portador       = tit_ap.cod_portador
                       tt-pagamentos.dat_prev_pagto     = tit_ap.dat_prev_pagto
                       tt-pagamentos.cod_indic_econ     = tit_ap.cod_indic_econ
                       tt-pagamentos.valor_multa        = tit_ap.val_multa_tit_ap
                       tt-pagamentos.valor_juros        = tit_ap.val_juros
                       tt-pagamentos.valor_cm           = tit_ap.val_cm_tit_ap
                       tt-pagamentos.valor_desconto     = tit_ap.val_desconto
                       tt-pagamentos.valor_abatimento   = tit_ap.val_abat_tit_ap
                       tt-pagamentos.cod_refer          = tit_ap.cod_refer
                       tt-pagamentos.cod_forma_pagto    = tit_ap.cod_forma_pagto
                       tt-pagamentos.cod_contrat_leas   = tit_ap.cod_contrat_leas
                       tt-pagamentos.dt_apuracao        = dtApuracao
                       tt-pagamentos.valor_original     = tt-pagamentos.valor_original - movto_tit_ap.val_desconto.

            /* Caso haja desconto na duplicata, subtrai do valor do titulo */
            

            END.
        END.
    END.
END.

/* Fase 3 - Lista todos os pagamentos extra fornecedor, onde a data da transacao esteja dentro do mes de apuracao, 
   considerando apenas fornecedores 1 e 3 */
FOR EACH movto_tit_ap NO-LOCK WHERE movto_tit_ap.cod_empresa        = "TOR"
                                AND movto_tit_ap.dat_transacao      <= dtFinal
                                AND movto_tit_ap.dat_transacao      >= dtInicial
                                AND movto_tit_ap.ind_trans_ap_abrev = "PGEF",
                                EACH emsuni.fornecedor WHERE emsuni.fornecedor.cdn_fornecedor = movto_tit_ap.cdn_fornecedor
                                                         AND (fornecedor.cod_grp_fornec = "1" OR fornecedor.cod_grp_fornec = "3") NO-LOCK:

    FIND FIRST grp_fornec WHERE grp_fornec.cod_grp_fornec = emsuni.fornecedor.cod_grp_fornec NO-LOCK NO-ERROR.

    CREATE tt-pagamentos.
    ASSIGN tt-pagamentos.cod_empresa        = movto_tit_ap.cod_empresa
           tt-pagamentos.cod_estab          = movto_tit_ap.cod_estab
           tt-pagamentos.cod_tit_ap         = movto_tit_ap.cod_tit_ap
           tt-pagamentos.cod_espec_docto    = movto_tit_ap.cod_espec_docto
           tt-pagamentos.valor_original     = movto_tit_ap.val_movto_ap
           tt-pagamentos.cdn_fornecedor     = fornecedor.cdn_fornecedor
           tt-pagamentos.nome_fornecedor    = fornecedor.nom_pessoa
           tt-pagamentos.nome_abrev_fornec  = fornecedor.nom_abrev
           tt-pagamentos.cod_grp_fornec     = fornecedor.cod_grp_fornec
           tt-pagamentos.nome_grp_fornec    = IF AVAIL grp_fornec THEN grp_fornec.des_grp_fornec ELSE ""
           tt-pagamentos.ind_origin_tit_ap  = movto_tit_ap.ind_origin_tit_ap
           tt-pagamentos.ind_trans_ap       = fn-free-accent(movto_tit_ap.ind_trans_ap)
           tt-pagamentos.ind_trans_ap_abrev = fn-free-accent(movto_tit_ap.ind_trans_ap_abrev)
           tt-pagamentos.dat_transacao      = movto_tit_ap.dat_transacao
           tt-pagamentos.cod_portador       = movto_tit_ap.cod_portador
           tt-pagamentos.valor_multa        = movto_tit_ap.val_multa_tit_ap
           tt-pagamentos.valor_juros        = movto_tit_ap.val_juros
           tt-pagamentos.valor_cm           = movto_tit_ap.val_cm_tit_ap
           tt-pagamentos.valor_desconto     = movto_tit_ap.val_desconto
           tt-pagamentos.valor_abatimento   = movto_tit_ap.val_abat_tit_ap
           tt-pagamentos.cod_refer          = movto_tit_ap.cod_refer
           tt-pagamentos.dt_apuracao        = dtApuracao.
    
END.

OUTPUT TO "c:\Temp\tit_pagos.csv".

PUT "COD EMPRESA"           ";"
    "ESTABELECIMENTO"       ";"
    "TITULO"                ";"
    "SERIE"                 ";"
    "PARCELA"               ";"
    "ESPECIE"               ";"
    "DATA PAGAMENTO"        ";"
    "VALOR PAGAMENTO"       ";"
    "SALDO"                 ";"
    "VALOR TITULO"          ";"
    "DATA VENCIMENTO"       ";"
    "COD FORNEC"            ";"
    "NOME FORNEC"           ";"
    "NOME ABREV FORNEC"     ";"
    "GRUPO FORNEC"          ";"
    "DESCR GRUPO FORNEC"    ";"
    "DATA EMISSAO"          ";"
    "ORIGEM TIT"            ";"
    "IND TRANS"             ";"
    "IND TRANS ABREV"       ";"
    "DT TRANSACAO"          ";"
    "PORTADOR"              ";"
    "DT PREV PAGTO"         ";"
    "VL ABATIMENTO"         ";"
    "MOEDA"                 SKIP.

FOR EACH tt-pagamentos NO-LOCK BY tt-pagamentos.cdn_fornecedor:

    PUT tt-pagamentos.cod_empresa           ";"
        tt-pagamentos.cod_estab             ";"
        tt-pagamentos.cod_tit_ap            ";"
        tt-pagamentos.cod_ser_docto         ";"
        tt-pagamentos.cod_parcela           ";"
        tt-pagamentos.cod_espec_docto       ";"
        tt-pagamentos.dt_liquida            ";"
        tt-pagamentos.valor_pagamento       ";"
        tt-pagamentos.valor_saldo           ";"
        tt-pagamentos.valor_original        ";"
        tt-pagamentos.dt_vencimento         ";"
        tt-pagamentos.cdn_fornecedor        ";"
        tt-pagamentos.nome_fornecedor       ";"
        tt-pagamentos.nome_abrev_fornec     ";"
        tt-pagamentos.cod_grp_fornec        ";"
        tt-pagamentos.nome_grp_fornec       ";"
        tt-pagamentos.dat_emis_docto        ";"
        tt-pagamentos.ind_origin_tit_ap     ";"
        tt-pagamentos.ind_trans_ap          ";"
        tt-pagamentos.ind_trans_ap_abrev    ";"
        tt-pagamentos.dat_transacao         ";"
        tt-pagamentos.cod_portador          ";"
        tt-pagamentos.dat_prev_pagto        ";"
        tt-pagamentos.cod_indic_econ        SKIP.

END.

OUTPUT CLOSE.
