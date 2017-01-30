def var v_num_vers_integr_api as integer   format ">>>>,>>9" no-undo.
def var v_cod_empresa         as character format "x(03)"    no-undo.
def var v_cod_empresa_ext     as character format "x(03)"    no-undo.
def var v_cod_estab           as character format "x(03)"    no-undo.
def var v_cod_estab_ext       as character format "x(08)"    no-undo.
def var v_num_dias_max_atr    as integer   format ">>>9"     no-undo.
def var v_num_dias_max_atr_ad as integer   format ">>>9"     no-undo.

define temp-table tt-emitente no-undo
    field cod-emitente      as integer   format ">>>>>>9" 
    field nome-abrev        as character format "x(12)" 
    field nr-mesina         as integer   format ">9"
    field cod-gr-cli        as integer   format ">9"
    field nr-peratr         as integer   format ">9"
    /* ****    Atributos utilizados na integra‡Æo com o EMS 5.0     *****/
    field nr-cheque-devol   as integer   format ">>9"                 /* N£mero de Cheques Devolvidos */
    field qtd-dias          as integer   format ">>9"
    field vl-max-devol      as decimal   format ">>>,>>>,>>9.99"      /* Valor M ximo do Total de Cheques Devolvidos */
    field identific         as integer   format ">9"
    field moeda-credito     as integer   format ">9"
    field de-saldo-cr       as decimal   format "->>>,>>>,>>>,>>9.99" /* Saldo em Aberto (Saldo Total - Antecipa‡Æo) ACR */
    field de-saldo-ap       as decimal   format "->>>,>>>,>>>,>>9.99" /* Saldo em Aberto (Saldo Total - Antecipa‡Æo) APB */
    field de-tot-tit-atr-cr as decimal   format ">>>,>>>,>>>,>>9.99"
    field de-tot-ad-cr      as decimal   format ">>>,>>>,>>>,>>9.99"  /* Total de Aviso de D‚bito ACR */
    field de-cr-ant-aberto  as decimal   format ">>>,>>>,>>>,>>9.99"  /* Total de Antecipa‡äes em Aberto ACR */
    field de-ap-ant-aberto  as decimal   format ">>>,>>>,>>>,>>9.99"  /* Total de Antecipa‡äes em Aberto APB */
    field de-tot-tit-atr-ap as decimal   format ">>>,>>>,>>>,>>9.99"  /* Saldo de t¡tulos a pagar em atraso */
    field de-ap-ant-sem-safra as decimal format ">>>,>>>,>>>,>>9.99"  /* Saldo de antecipa‡äes que nÆo possuem c¢digo de safra */
    index cod-emitente is primary cod-emitente.

def temp-table tt-emitente-safra no-undo
    field cod-emitente                 as integer   format ">>>>>>>>9"          /* C¢digo do emitente */
    field cod-safra                    as character format "9999/9999"          /* C¢digo da safra */
    field de-tit-abe-nao-venc-safra-cr as decimal   format ">>>,>>>,>>>,>>9.99" /* Saldo de t¡tulos a receber nÆo vencidos */
    field de-tit-abe-nao-venc-safra-ap as decimal   format ">>>,>>>,>>>,>>9.99" /* Saldo de t¡tulos a pagar nÆo vencidos */
    field de-ap-ant-safra              as decimal   format ">>>,>>>,>>>,>>9.99" /* Saldo das antecipa‡äes */
    index cod-emitente-safra is primary cod-emitente
                                        cod-safra.

def temp-table tt-erros-analise-credito no-undo
    field cod-emitente      as integer   format ">>>>>>9" 
    field cod-mensagem      as integer   format ">>>>,>>9"
    field des-msg           as character format "x(50)"   
    field help-msg          as character format "x(50)".

def temp-table tt_tit_acr_analise_credito no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa‡Æo T¡tulo" column-label "Situa‡Æo T¡tulo"
    field tta_log_tit_acr_estordo          as logical format "Sim/NÆo" initial no label "Estornado" column-label "Estornado"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_origin_tit_acr           as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Original T¡tulo" column-label "Vl Original T¡tulo"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field ttv_rec_tit_acr                  as recid format ">>>>>>9"
    field ttv_cod_indic_movto              as character format "x(1)" label "Indic Movto" column-label "Indic Movto"
    field ttv_val_sdo_tit_analis_cr        as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Vl An lise Cr‚dito" column-label "Vl An lise Cr‚dito"
    index tt_chave                        
          tta_cod_empresa                  ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    index tt_tipo_espec                   
          tta_ind_tip_espec_docto          ascending.

def temp-table tt_tit_ap_analise_credito no-undo
    field tta_cod_empresa           as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab             as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor        as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_ser_docto         as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_espec_docto       as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_tit_ap            as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela           as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_vencto_tit_ap     as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_emis_docto        as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_ind_tip_espec_docto   as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
    field tta_ind_sit_tit_ap        as character format "X(13)" label "Situa‡Æo" column-label "Situa‡Æo"
    field tta_log_tit_ap_estordo    as logical format "Sim/NÆo" initial no label "Estornado" column-label "Estornado"
    field tta_cod_indic_econ        as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_origin_tit_ap     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Original" column-label "Valor Original"
    field tta_val_sdo_tit_ap        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_rec_tit_ap            as recid format ">>>>>>9" initial ?
    field ttv_cod_indic_movto       as character format "x(1)" label "Indic Movto" column-label "Indic Movto"
    field ttv_val_sdo_tit_analis_cr as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Vl An lise Cr‚dito" column-label "Vl An lise Cr‚dito"
    index tt_chave                  
          tta_cod_empresa           ascending
          tta_cod_estab             ascending
          tta_cdn_fornecedor        ascending
          tta_cod_ser_docto         ascending
          tta_cod_espec_docto       ascending
          tta_cod_tit_ap            ascending
          tta_cod_parcela           ascending
    index tt_tipo_espec             
          tta_ind_tip_espec_docto   ascending.


ASSIGN v_num_vers_integr_api    = 1
       v_cod_empresa            = "TOR"
       v_cod_empresa_ext        = ?
       v_cod_estab              = ?
       v_cod_estab_ext          = ?
       v_num_dias_max_atr       = 120
       v_num_dias_max_atr_ad    = 120.

CREATE tt-emitente.
ASSIGN tt-emitente.cod-emitente = 267189.

CREATE tt_tit_acr_analise_credito.
ASSIGN tt_tit_acr_analise_credito.tta_cod_empresa = "TOR".

CREATE tt_tit_aP_analise_credito.

CREATE tt-emitente-safra.

CREATE tt-erros-analise-credito.

RUN prgfin/acr/acr777zd.py (INPUT v_num_vers_integr_api,
                            INPUT v_cod_empresa,
                            INPUT v_cod_empresa_ext,
                            INPUT v_cod_estab,
                            INPUT v_cod_estab_ext,
                            INPUT v_num_dias_max_atr,
                            INPUT v_num_dias_max_atr_ad,
                            INPUT YES, /* v_log_valid_cheq */
                            INPUT NO,  /* v_log_retorna_dados */
                            INPUT-OUTPUT TABLE tt_tit_acr_analise_credito,
                            INPUT-OUTPUT TABLE tt_tit_aP_analise_credito,
                            INPUT-OUTPUT TABLE tt-emitente,
                            INPUT-OUTPUT TABLE tt-emitente-safra,
                            INPUT-OUTPUT TABLE tt-erros-analise-credito).

FOR EACH tt_tit_acr_analise_credito NO-LOCK:

    DISPLAY tt_tit_acr_analise_credito.tta_cod_empresa
            tt_tit_acr_analise_credito.tta_cod_estab            
            tt_tit_acr_analise_credito.tta_cdn_cliente          
            tt_tit_acr_analise_credito.tta_cod_ser_docto        
            tt_tit_acr_analise_credito.tta_cod_espec_docto      
            tt_tit_acr_analise_credito.tta_cod_tit_acr          
            tt_tit_acr_analise_credito.tta_cod_parcela          
            tt_tit_acr_analise_credito.tta_dat_vencto_tit_acr   
            tt_tit_acr_analise_credito.tta_dat_emis_docto       
            tt_tit_acr_analise_credito.tta_ind_tip_espec_docto  
            tt_tit_acr_analise_credito.tta_ind_sit_tit_acr      
            tt_tit_acr_analise_credito.tta_log_tit_acr_estordo  
            tt_tit_acr_analise_credito.tta_cod_indic_econ       
            tt_tit_acr_analise_credito.tta_val_origin_tit_acr   
            tt_tit_acr_analise_credito.tta_val_sdo_tit_acr      
            tt_tit_acr_analise_credito.ttv_rec_tit_acr          
            tt_tit_acr_analise_credito.ttv_cod_indic_movto      
            tt_tit_acr_analise_credito.ttv_val_sdo_tit_analis_cr
            WITH 1 COL.
END.

FOR EACH tt_tit_aP_analise_credito NO-LOCK:
    DISP "tt_tit_aP_analise_credito".
END.
FIND FIRST tt-erros-analise-credito NO-LOCK NO-ERROR.
IF AVAIL tt-erros-analise-credito THEN
    DISP "tt-erros-analise-credito".
