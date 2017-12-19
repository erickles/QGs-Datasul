DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

OUTPUT TO "C:\Temp\DNI.csv".

PUT "EMPRESA;ESTAB;ESPECIE;TITULO;CLIENTE;PARCELA;PORTADOR;SERIE;EMISSAO;VALOR" SKIP.

FOR EACH tit_acr WHERE tit_acr.cod_empresa          = "TOR"
                   /*AND tit_acr.val_origin_tit_acr = tit_acr.val_sdo_tit_acr*/
                   AND tit_acr.val_origin_tit_acr   = 1740.95
                   AND tit_acr.cod_espec_docto      = "DP"
                   AND YEAR(tit_acr.dat_emis_docto) >= 2017
                   /*AND tit_acr.cod_portador = "112"*/
                   NO-LOCK:
    
    PUT tit_acr.cod_empresa         ";"
        tit_acr.cod_estab           ";"
        tit_acr.cod_espec_docto     ";"
        "'" + tit_acr.cod_tit_acr         ";"
        tit_acr.cdn_cliente         ";"                
        "'" + tit_acr.cod_parcela         ";"
        tit_acr.cod_portador        ";"
        tit_acr.cod_ser_docto       ";"
        tit_acr.dat_emis_docto      ";"
        tit_acr.val_origin_tit_acr  SKIP.

    iCont = iCont + 1.

END.

OUTPUT CLOSE.

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
