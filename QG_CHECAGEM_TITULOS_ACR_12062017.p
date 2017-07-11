OUTPUT TO "C:\Temp\titulos_pagos_12062017.csv".

PUT "EMPRESA;CLIENTE;ESTABELECIMENTO;TITULO;ESPECIE;SERIE;PARCELA;PORTADOR;TITULO BANCO;DATA GERACAO;DATA EMISSAO;SALDO;VALOR ORIGINAL;DIFERENCA" SKIP.

FOR EACH tit_acr WHERE tit_acr.dat_emis_docto >= 06/12/2017 
                   AND tit_acr.cod_espec_docto = "DP"
                   AND (tit_acr.cod_portador = "112" OR tit_acr.cod_portador = "34110")
                   NO-LOCK:

    FIND FIRST es-fat-duplic NO-LOCK WHERE es-fat-duplic.cod-estabel = tit_acr.cod_estab
                                       AND es-fat-duplic.serie       = tit_acr.cod_ser_docto
                                       AND es-fat-duplic.nr-fatura   = tit_acr.cod_tit_acr
                                       AND es-fat-duplic.parcela     = tit_acr.cod_parcela
                                       NO-ERROR.
    
    PUT UNFORM  tit_acr.cod_empresa                                                                     ";"
                tit_acr.cdn_cliente                                                                     ";"
                tit_acr.cod_estab                                                                       ";"
                tit_acr.cod_tit_acr                                                                     ";"
                tit_acr.cod_espec_docto                                                                 ";"
                tit_acr.cod_ser_docto                                                                   ";"
                tit_acr.cod_parcela                                                                     ";"
                tit_acr.cod_portador                                                                    ";"
                IF AVAIL es-fat-duplic THEN "'" + STRING(es-fat-duplic.titulo-banco) ELSE ""                  ";"
                IF AVAIL es-fat-duplic THEN STRING(es-fat-duplic.data-geracao) ELSE ""                  ";"
                tit_acr.dat_emis_docto                                                                  ";"
                tit_acr.val_sdo_tit_acr                                                                 ";"
                tit_acr.val_origin_tit_acr                                                              ";"
                tit_acr.val_sdo_tit_acr > 0 AND tit_acr.val_sdo_tit_acr < tit_acr.val_origin_tit_acr    SKIP.

END.

OUTPUT CLOSE.
