DEFINE VARIABLE dataMes AS DATE     FORMAT "99/99/9999"   NO-UNDO.
DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO.
/*
OUTPUT TO "c:\titulos_vencidos.csv".

PUT "COD CLIENTE;
    COD EMPRESA;
    COD ESPEC DOCTO;
    COD ESTAB;
    COD TITI ACR;
    COD SER DOCTO;
    COD REFER;
    COD TIT ACR BCO;
    DAT LIQUID TIT ACR;
    DAT EMIS DOCTO;
    DAT VENC;
    VALOR LIQ;
    VALOR SALDO" SKIP.


FOR EACH tit_acr WHERE tit_acr.cod_empresa           = "TOR"
                   AND tit_acr.dat_vencto_tit_acr    < TODAY - 5
                   AND tit_acr.dat_vencto_tit_acr   <= 04/30/2014
                   AND tit_acr.dat_vencto_tit_acr   >= 04/01/2014
                   AND tit_acr.cod_espec_docto      <> "DN"
                   NO-LOCK:

    IF tit_acr.val_sdo_tit_acr <= 0 THEN NEXT.

    PUT tit_acr.cdn_cliente             ";"
        tit_acr.cod_empresa             ";"
        tit_acr.cod_espec_docto         ";"
        tit_acr.cod_estab               ";"
        tit_acr.cod_tit_acr             ";"
        tit_acr.cod_ser_docto           ";"
        tit_acr.cod_refer               ";"
        tit_acr.cod_tit_acr_bco         ";"
        tit_acr.dat_liquidac_tit_acr    ";"
        tit_acr.dat_emis_docto          ";"
        tit_acr.dat_vencto_tit_acr      ";"
        tit_acr.val_liq_tit_acr         ";"
        tit_acr.val_sdo_tit_acr         SKIP.

    ASSIGN deValor = deValor + tit_acr.val_sdo_tit_acr.

END.

OUTPUT CLOSE.
*/
OUTPUT TO "c:\titulos_a_vencer.csv".

PUT "COD CLIENTE;
    COD EMPRESA;
    COD ESPEC DOCTO;
    COD ESTAB;
    COD TITI ACR;
    COD SER DOCTO;
    COD REFER;
    COD TIT ACR BCO;
    DAT LIQUID TIT ACR;
    DAT EMIS DOCTO;
    DAT VENC;
    VALOR LIQ;
    VALOR SALDO;
    COD SITUACAO;
    SITUACAO" SKIP.


FOR EACH tit_acr WHERE tit_acr.cod_empresa           = "TOR"
                   AND tit_acr.dat_vencto_tit_acr   <= 04/30/2014
                   /*AND tit_acr.dat_vencto_tit_acr   >= 04/01/2014*/
                   /*AND tit_acr.cod_espec_docto      <> "DN"*/
                   NO-LOCK:

    IF tit_acr.val_sdo_tit_acr <= 0 THEN NEXT.

    PUT tit_acr.cdn_cliente             ";"
        tit_acr.cod_empresa             ";"
        tit_acr.cod_espec_docto         ";"
        tit_acr.cod_estab               ";"
        tit_acr.cod_tit_acr             ";"
        tit_acr.cod_ser_docto           ";"
        tit_acr.cod_refer               ";"
        tit_acr.cod_tit_acr_bco         ";"
        tit_acr.dat_liquidac_tit_acr    ";"
        tit_acr.dat_emis_docto          ";"
        tit_acr.dat_vencto_tit_acr      ";"
        tit_acr.val_liq_tit_acr         ";"
        tit_acr.val_sdo_tit_acr         ";"
        INTE(tit_acr.ind_sit_tit_acr)   ";"
        tit_acr.ind_sit_tit_acr         SKIP.

    /*ASSIGN deValor = deValor + tit_acr.val_sdo_tit_acr.*/

END.

OUTPUT CLOSE.

/*
FOR EACH tit_acr WHERE tit_acr.dat_vencto_tit_acr < TODAY - 5
                   AND tit_acr.val_sdo_tit_acr > 0
                   NO-LOCK:

    deValor = deValor + /*tit_acr.val_liq_tit_acr.*/ tit_acr.val_origin_tit_acr.

END.

MESSAGE deValor
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
/*
FOR EACH nota-fiscal WHERE MONTH(nota-fiscal.dt-emis)   = 04
                       AND YEAR(nota-fiscal.dt-emis)    = 2014
                       AND nota-fiscal.emite-duplic     = YES
                       AND nota-fiscal.dt-canc = ?
                       NO-LOCK:

    deValor = deValor + nota-fiscal.vl-tot-nota.

END.

MESSAGE deValor / 2.2
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
