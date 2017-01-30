DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO.

{include/i-freeac.i}

/* O que tenho a pagar a partir no primeiro dia util apos 30/04 */
DEFINE VARIABLE mesApuracao     AS INTE         NO-UNDO.
DEFINE VARIABLE anoApuracao     AS INTE         NO-UNDO.
DEFINE VARIABLE dtLimite        AS DATE         NO-UNDO.
DEFINE VARIABLE dtLiquidacao    AS DATE         NO-UNDO.
DEFINE VARIABLE dtInicial       AS DATE         NO-UNDO.
DEFINE VARIABLE dtFinal         AS DATE         NO-UNDO.
DEFINE VARIABLE lDiaUtil        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE iFornecIni      AS INTEGER      NO-UNDO INITIAL 0.
DEFINE VARIABLE iFornecFim      AS INTEGER      NO-UNDO INITIAL 999999.

ASSIGN mesApuracao  = 06
       anoApuracao  = 2014
       dtInicial    = DATE("01/" + STRING(mesApuracao) + "/" + STRING(anoApuracao)).

IF mesApuracao = 12 THEN DO:
    ASSIGN dtFinal  = DATE("01/01" + "/" + STRING(anoApuracao + 1)) - 1
           dtLimite = DATE("01/01" + "/" + STRING(anoApuracao + 1)) - 1
           dtLiquidacao = DATE("01/01" + "/" + STRING(anoApuracao + 1)).
END.
ELSE DO:
    ASSIGN dtFinal      = DATE("01/" + STRING(mesApuracao + 1) + "/" + STRING(anoApuracao)) - 1
           dtLimite     = DATE("01/" + STRING(mesApuracao + 1) + "/" + STRING(anoApuracao)) - 1
           dtLiquidacao = DATE("01/" + STRING(mesApuracao + 1) + "/" + STRING(anoApuracao)).
END.

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
    FIELD dt_apuracao           AS DATE.

DEFINE BUFFER bf_tit_ap FOR tit_ap.
DEFINE BUFFER bf_movto_tit_ap   FOR movto_tit_ap.
DEFINE BUFFER bf2_movto_tit_ap   FOR movto_tit_ap.

/*
    Chave da tit_ap
    cod_estab
    cdn_fornecedor
    cod_espec_docto
    cod_ser_docto
    cod_tit_ap
    cod_parcela
*/

DO WHILE lDiaUtil = NO:

    IF WEEKDAY(dtLiquidacao) = 1 OR WEEKDAY(dtLiquidacao) = 7 THEN DO:
        dtLiquidacao = dtLiquidacao + 1.
    END.
    ELSE DO:
        FIND FIRST dia_calend_glob WHERE dia_calend_glob.dat_calend = dtLiquidacao NO-LOCK NO-ERROR.
        IF AVAIL dia_calend_glob THEN DO:
            IF dia_calend_glob.cod_clas_dia_calend = "util" THEN DO:
                ASSIGN lDiaUtil = YES.
            END.
            ELSE DO:
                dtLiquidacao = dtLiquidacao + 1.
            END.
        END.
    END.

END.

/*
ASSIGN iFornecIni = 220
       iFornecFim = 220.
*/

/*
dtInicial       01/06/2014
dtFinal         30/06/2014
dtLimite        30/06/2014
dtLiquidacao    01/06/2014
*/

/* Pega as duplicatas, da empresa TOR, emitidas ate o ultimo dia do mes
   com data de liquidacao inexistente ou maior/igual ao primeiro dia util 
   do mes seguinte, considerando apenas fornecedores do grupo 1 e 3, 
   considerando vencimento do primeiro dia util do mes de apuracao ate 31/12/9999 */
FOR EACH tit_ap NO-LOCK WHERE (tit_ap.cod_espec_docto        = "DP" OR tit_ap.cod_espec_docto = "FF")
                          AND CAPS(tit_ap.cod_empresa)      = "TOR"
                          AND tit_ap.dat_emis_docto         <= dtLimite
                          AND (tit_ap.dat_liquidac_tit_ap    >= dtLiquidacao OR tit_ap.dat_liquidac_tit_ap = ?)
                          AND tit_ap.dat_vencto_tit_ap      <= 12/31/9999
                          AND tit_ap.dat_vencto_tit_ap      >= dtInicial,
                          EACH emsuni.fornecedor OF tit_ap WHERE (emsuni.fornecedor.cod_grp_fornec = "1" OR emsuni.fornecedor.cod_grp_fornec = "3")
                                                              AND emsuni.fornecedor.cdn_fornecedor >= iFornecIni
                                                              AND emsuni.fornecedor.cdn_fornecedor <= iFornecFim
                                                              NO-LOCK:
    
    FIND FIRST movto_tit_ap OF tit_ap WHERE movto_tit_ap.ind_trans_ap_abrev = "IMPL" 
                                         OR movto_tit_ap.ind_trans_ap_abrev = "SBND"
                                         NO-LOCK NO-ERROR.
    
    IF AVAIL movto_tit_ap AND movto_tit_ap.dat_transacao <= dtLimite THEN DO:
        
        FIND FIRST grp_fornec WHERE grp_fornec.cod_grp_fornec = emsuni.fornecedor.cod_grp_fornec NO-LOCK NO-ERROR.
        
        /* Verifica se titulo com baixa possui estorno, caso tenha, ignora registro*/
        FIND LAST bf_movto_tit_ap OF tit_ap WHERE bf_movto_tit_ap.ind_trans_ap_abrev = "BXA"
                                              AND bf_movto_tit_ap.dat_transacao      <= dtLiquidacao
                                              NO-LOCK NO-ERROR.

        FIND LAST bf2_movto_tit_ap OF tit_ap WHERE bf2_movto_tit_ap.ind_trans_ap_abrev = "EBXA" 
                                               AND bf2_movto_tit_ap.dat_transacao      <= dtLiquidacao
                                               NO-LOCK NO-ERROR.

        IF AVAIL bf_movto_tit_ap AND AVAIL bf2_movto_tit_ap AND bf2_movto_tit_ap.dat_transacao > bf_movto_tit_ap.dat_transacao THEN NEXT.
        /* Verifica se titulo com baixa possui estorno, caso tenha, ignora registro */

        /*IF AVAIL bf_movto_tit_ap AND bf_movto_tit_ap.dat_transacao < dtLiquidacao THEN NEXT.*/

        CREATE tt-saldo-pagar.
        ASSIGN tt-saldo-pagar.cod_empresa           = tit_ap.cod_empresa
               tt-saldo-pagar.cod_estab             = tit_ap.cod_estab
               tt-saldo-pagar.cod_tit_ap            = tit_ap.cod_tit_ap
               tt-saldo-pagar.serie_tit             = tit_ap.cod_ser_docto
               tt-saldo-pagar.parcela               = tit_ap.cod_parcela
               tt-saldo-pagar.especie               = CAPS(tit_ap.cod_espec_docto)
               tt-saldo-pagar.dt_liquida            = tit_ap.dat_liquidac_tit_ap
               tt-saldo-pagar.valor_pagamento       = tit_ap.val_pagto_tit_ap
               tt-saldo-pagar.valor_saldo           = tit_ap.val_sdo_tit_ap
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
               tt-saldo-pagar.dt_apuracao           = dtLiquidacao.

    END.

END.

OUTPUT TO "c:\Temp\tit_aberto.csv".

PUT "COD EMPRESA"       ";"
    "ESTABELECIMENTO"   ";"
    "TITULO"            ";"
    "SERIE"             ";"
    "PARCELA"           ";"
    "ESPECIE"           ";"
    "DATA PAGAMENTO"    ";"
    "VALOR PAGAMENTO"   ";"
    "SALDO"             ";"
    "VALOR TITULO"      ";"
    "DATA VENCIMENTO"   ";"
    "COD FORNEC"        ";"
    "NOME FORNEC"       ";"
    "NOME ABREV FORNEC" ";"
    "GRUPO FORNEC"      ";"
    "NOME GRUPO FORNEC" ";"
    "DATA EMISSAO"      ";"
    "ORIGEM TIT"        ";"
    "IND TRANS"         ";"
    "IND TRANS ABREV"   ";"
    "DT TRANSACAO"      ";"
    "COD PORTADOR"      ";"
    "DT PREV PAGTO"     ";"
    "MOEDA"             ";"
    "DT APURACAO"       SKIP.

FOR EACH tt-saldo-pagar NO-LOCK:

    PUT tt-saldo-pagar.cod_empresa          ";"
        tt-saldo-pagar.cod_estab            ";"
        tt-saldo-pagar.cod_tit_ap           ";"
        tt-saldo-pagar.serie_tit            ";"
        tt-saldo-pagar.parcela              ";"
        tt-saldo-pagar.especie              ";"
        tt-saldo-pagar.dt_liquida           ";"
        tt-saldo-pagar.valor_pagamento      ";"
        tt-saldo-pagar.valor_saldo          ";"
        tt-saldo-pagar.valor_original       ";"
        tt-saldo-pagar.dt_vencimento        ";"
        tt-saldo-pagar.cdn_fornecedor       ";"
        tt-saldo-pagar.nome_fornecedor      ";"
        tt-saldo-pagar.nome_abrev_fornec    ";"
        tt-saldo-pagar.cod_grp_fornec       ";"
        tt-saldo-pagar.nome_grp_fornec      ";"
        tt-saldo-pagar.dat_emis_docto       ";"
        tt-saldo-pagar.ind_origin_tit_ap    ";"
        tt-saldo-pagar.ind_trans_ap         ";"
        tt-saldo-pagar.ind_trans_ap_abrev   ";"
        tt-saldo-pagar.dat_transacao        ";"
        tt-saldo-pagar.cod_portador         ";"
        tt-saldo-pagar.dat_prev_pagto       ";"
        tt-saldo-pagar.cod_indic_econ       ";"
        tt-saldo-pagar.dt_apuracao          SKIP.

END.

OUTPUT CLOSE.
