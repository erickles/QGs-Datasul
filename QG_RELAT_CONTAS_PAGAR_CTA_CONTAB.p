DEFINE VARIABLE lDiaUtilVenc            AS LOGICAL     NO-UNDO INITIAL NO.
DEFINE VARIABLE dtVencimentoEfetivo     AS DATE        NO-UNDO.

DEFINE BUFFER bf_movto_tit_ap   FOR movto_tit_ap.
DEFINE BUFFER bf2_movto_tit_ap  FOR movto_tit_ap.

{include/i-freeac.i}

DEFINE TEMP-TABLE tt-saldo-pagar
    FIELD cod_empresa           AS CHAR
    FIELD cod_estab             AS CHAR
    FIELD cod_tit_ap            AS CHAR
    FIELD serie_tit             AS CHAR
    FIELD parcela               AS CHAR
    FIELD especie               AS CHAR
    FIELD dt_liquida            AS DATE FORMAT 99/99/9999
    FIELD valor_pagamento       AS DECI
    FIELD valor_saldo           AS DECI
    FIELD valor_original        AS DECI
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
    FIELD dt_apuracao           AS DATE
    FIELD cod_cta_ctbl          AS CHAR.

RUN piSaldoCtaPag(INPUT 9,
                  INPUT 2014).

OUTPUT TO "c:\relat_contas_pagar_contab.csv".

PUT "Codigo Empresa;"
    "Codigo Estab;"
    "Titulo;"
    "Serie;"
    "Parcela;"
    "Especie;"
    "dt_liquida;"
    "Valor pagamento;"
    "Valor saldo;"
    "Valor original;"
    "Data vencimento;"
    "Codigo fornecedor;"
    "Nome fornecedor;"
    "Nome abrev fornec;"
    "Codigo grupo fornec;"
    "Nome grupo fornec;"
    "Dt emis docto;"
    "ind_origin_tit_ap;"
    "ind_trans_ap;"
    "ind_trans_ap_abrev;"
    "Dt transacao;"
    "Cd portador;"
    "Dt PREV pagto;"
    "cod_indic_econ;"
    "dt_apuracao;" SKIP.

FOR EACH tt-saldo-pagar NO-LOCK:

    PUT cod_empresa         ";"
        cod_estab           ";"
        cod_tit_ap          ";"
        serie_tit           ";"
        parcela             ";"
        especie             ";"
        dt_liquida          ";"
        valor_pagamento     ";"
        valor_saldo         ";"
        valor_original      ";"
        dt_vencimento       ";"
        cdn_fornecedor      ";"
        nome_fornecedor     ";"
        nome_abrev_fornec   ";"
        cod_grp_fornec      ";"
        nome_grp_fornec     ";"
        dat_emis_docto      ";"
        ind_origin_tit_ap   ";"
        ind_trans_ap        ";"
        ind_trans_ap_abrev  ";"
        dat_transacao       ";"
        cod_portador        ";"
        dat_prev_pagto      ";"
        cod_indic_econ      ";"
        dt_apuracao         ";"
        cod_cta_ctbl        SKIP.

END.

OUTPUT CLOSE.

/* Traz o saldo do contas a pagar referente a uma determinada data */
PROCEDURE piSaldoCtaPag:
    
    DEFINE INPUT PARAMETER mesApuracao AS INTE NO-UNDO.
    DEFINE INPUT PARAMETER anoApuracao AS INTE NO-UNDO.

    /* O que tenho a pagar a partir no primeiro dia util apos 30/04 */
    DEFINE VARIABLE dtLimite    AS DATE         NO-UNDO.

    /* dtLiquida: primeiro dia util do mes seguinte */
    DEFINE VARIABLE dtLiquida   AS DATE         NO-UNDO.

    /* dtVencimento: Ultima data valida para vencimento */
    DEFINE VARIABLE dtVencimento AS DATE        NO-UNDO.

    /* dtInicial: primeiro dia do mes de apuracao */
    DEFINE VARIABLE dtInicial   AS DATE         NO-UNDO.

    /* dtInicial: ultimo dia do mes de apuracao */
    DEFINE VARIABLE dtFinal     AS DATE         NO-UNDO.
    DEFINE VARIABLE lDiaUtil    AS LOGICAL      NO-UNDO.

    /* Variavel para acumulo das baixas por titulo */
    DEFINE VARIABLE deValorAbatimento AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE lAberto AS LOGICAL     NO-UNDO.

    ASSIGN dtInicial = DATE("01/" + STRING(mesApuracao) + "/" + STRING(anoApuracao)).

    IF mesApuracao = 12 THEN DO:
        ASSIGN dtFinal      = DATE("01/01" + "/" + STRING(anoApuracao + 1)) - 1
               dtLimite     = DATE("01/01" + "/" + STRING(anoApuracao + 1)) - 1
               dtLiquida    = DATE("01/01" + "/" + STRING(anoApuracao + 1))
               dtVencimento = DATE("01/01" + "/" + STRING(anoApuracao + 1)).
    END.
    ELSE DO:
        ASSIGN dtFinal      = DATE("01/" + STRING(mesApuracao + 1) + "/" + STRING(anoApuracao)) - 1
               dtLimite     = DATE("01/" + STRING(mesApuracao + 1) + "/" + STRING(anoApuracao)) - 1
               dtLiquida    = DATE("01/" + STRING(mesApuracao + 1) + "/" + STRING(anoApuracao))
               dtVencimento = DATE("01/" + STRING(mesApuracao + 1) + "/" + STRING(anoApuracao)).
    END.
    
    DO WHILE lDiaUtil = NO:
        
        IF WEEKDAY(dtLiquida) = 1 OR WEEKDAY(dtLiquida) = 7 THEN DO:
            dtLiquida = dtLiquida + 1.
        END.
        ELSE DO:
            FIND FIRST dia_calend_glob WHERE dia_calend_glob.dat_calend = dtLiquida NO-LOCK NO-ERROR.
            IF AVAIL dia_calend_glob THEN DO:
                IF dia_calend_glob.cod_clas_dia_calend = "util" THEN DO:
                    ASSIGN lDiaUtil = YES.
                END.
                ELSE DO:
                    dtLiquida = dtLiquida + 1.
                END.
            END.
        END.
    END.

    ASSIGN lDiaUtil = NO.
    
    /* Pega as duplicatas, da empresa TOR, emitidas ate o ultimo dia do mes
    com data de liquidacao inexistente ou maior/igual ao primeiro dia util
    do mes seguinte, considerando apenas fornecedores do grupo 1 e 3,
    considerando vencimento do primeiro dia util do mes de apuracao ate 31/12/9999 */
    FOR EACH tit_ap NO-LOCK WHERE (tit_ap.cod_espec_docto   = "DP" OR tit_ap.cod_espec_docto = "FF")
                              AND CAPS(tit_ap.cod_empresa)  = "TOR"
                              AND tit_ap.dat_vencto_tit_ap  >= dtVencimento,
                              EACH emsuni.fornecedor OF tit_ap NO-LOCK BY tit_ap.dat_vencto_tit_ap:
        
        ASSIGN lDiaUtilVenc         = NO
               dtVencimentoEfetivo  = tit_ap.dat_vencto_tit_ap.
        
        RELEASE dia_calend_glob.
        /*
        FIND FIRST tt-digita NO-LOCK NO-ERROR.
        IF AVAIL tt-digita THEN DO:
            FIND FIRST tt-digita WHERE STRING(tt-digita.cod-grupo-fornec) = emsuni.fornecedor.cod_grp_fornec NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-digita THEN NEXT.
        END.
        */
        ASSIGN deValorAbatimento = 0.
               lAberto           = YES.

        FIND FIRST movto_tit_ap OF tit_ap WHERE (movto_tit_ap.ind_trans_ap_abrev = "IMPL" OR movto_tit_ap.ind_trans_ap_abrev = "SBND")
                                            AND movto_tit_ap.dat_transacao <= dtFinal
                                            NO-LOCK NO-ERROR.
            
        IF AVAIL movto_tit_ap THEN DO:

            FOR EACH bf_movto_tit_ap OF tit_ap WHERE (bf_movto_tit_ap.ind_trans_ap_abrev = "BXA" OR bf_movto_tit_ap.ind_trans_ap_abrev = "BXSB")
                                                 AND bf_movto_tit_ap.dat_transacao      < dtVencimento
                                                 NO-LOCK BY bf_movto_tit_ap.dat_transacao:

                FIND LAST bf2_movto_tit_ap OF tit_ap WHERE bf2_movto_tit_ap.ind_trans_ap_abrev = "EBXA"
                                                       AND bf2_movto_tit_ap.dat_transacao      >= bf_movto_tit_ap.dat_transacao
                                                       AND bf2_movto_tit_ap.dat_transacao      < dtLiquida
                                                       AND bf2_movto_tit_ap.val_movto_ap       = bf_movto_tit_ap.val_movto_ap
                                                       NO-LOCK NO-ERROR.
                IF AVAIL bf2_movto_tit_ap THEN
                    lAberto = YES.
                ELSE DO:
                    ASSIGN deValorAbatimento = deValorAbatimento + bf_movto_tit_ap.val_movto_ap
                           lAberto = NO.
                END.
            END.
            RELEASE bf2_movto_tit_ap.
            
            IF deValorAbatimento = tit_ap.val_origin_tit_ap  AND NOT lAberto THEN NEXT.

            CREATE tt-saldo-pagar.
            ASSIGN tt-saldo-pagar.cod_empresa           = tit_ap.cod_empresa
                   tt-saldo-pagar.cod_estab             = tit_ap.cod_estab
                   tt-saldo-pagar.cod_tit_ap            = tit_ap.cod_tit_ap
                   tt-saldo-pagar.serie_tit             = tit_ap.cod_ser_docto
                   tt-saldo-pagar.parcela               = tit_ap.cod_parcela
                   tt-saldo-pagar.especie               = CAPS(tit_ap.cod_espec_docto)
                   tt-saldo-pagar.dt_liquida            = tit_ap.dat_liquidac_tit_ap
                   tt-saldo-pagar.valor_pagamento       = tit_ap.val_pagto_tit_ap
                   tt-saldo-pagar.valor_saldo           = IF deValorAbatimento > 0 AND deValorAbatimento < tit_ap.val_origin_tit_ap THEN tit_ap.val_origin_tit_ap - deValorAbatimento ELSE tit_ap.val_origin_tit_ap
                   tt-saldo-pagar.valor_original        = tit_ap.val_origin_tit_ap
                   tt-saldo-pagar.dt_vencimento         = tit_ap.dat_vencto_tit_ap
                   tt-saldo-pagar.cdn_fornecedor        = fornecedor.cdn_fornecedor
                   tt-saldo-pagar.nome_fornecedor       = fornecedor.nom_pessoa
                   tt-saldo-pagar.nome_abrev_fornec     = fornecedor.nom_abrev
                   tt-saldo-pagar.cod_grp_fornec        = fornecedor.cod_grp_fornec
                   tt-saldo-pagar.nome_grp_fornec       = IF AVAIL grp_fornec THEN grp_fornec.des_grp_fornec ELSE ""
                   tt-saldo-pagar.dat_emis_docto        = tit_ap.dat_emis_docto
                   tt-saldo-pagar.ind_origin_tit_ap     = tit_ap.ind_origin_tit_ap
                   tt-saldo-pagar.ind_trans_ap          = fn-free-accent(movto_tit_ap.ind_trans_ap)
                   tt-saldo-pagar.ind_trans_ap_abrev    = fn-free-accent(movto_tit_ap.ind_trans_ap_abrev)
                   tt-saldo-pagar.dat_transacao         = movto_tit_ap.dat_transacao
                   tt-saldo-pagar.cod_portador          = tit_ap.cod_portador
                   tt-saldo-pagar.dat_prev_pagto        = tit_ap.dat_prev_pagto
                   tt-saldo-pagar.cod_indic_econ        = tit_ap.cod_indic_econ
                   tt-saldo-pagar.dt_apuracao           = dtInicial.

        END.
        
    END.

END PROCEDURE.
