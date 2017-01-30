DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

OUTPUT TO "C:\Temp\titulos_vencidos_boletos.csv".

PUT UNFORM "ESTAB;EMPRESA;SERIE;TITULO;CLIENTE" SKIP.

FOR EACH es-fat-duplic WHERE es-fat-duplic.data-geracao >= 11/28/2016
                         AND es-fat-duplic.cod-portador <> 113
                         NO-LOCK:
    
    
    /*iCont = iCont + 1.*/
    
    FIND FIRST tit_acr WHERE tit_acr.cod_estab      = es-fat-duplic.cod-estabel
                         AND tit_acr.cod_empresa    = "TOR"
                         AND tit_acr.cod_ser_docto  = es-fat-duplic.serie
                         AND tit_acr.cod_tit_acr    = es-fat-duplic.nr-fatura
                         AND tit_acr.dat_vencto_tit_acr < TODAY
                         AND tit_acr.val_sdo_tit_acr > 0
                         NO-LOCK NO-ERROR.

    IF AVAIL tit_acr THEN DO:

        iCont = iCont + 1.
        
        PUT UNFORM tit_acr.cod_estab        ";"
                   tit_acr.cod_empresa      ";"
                   tit_acr.cod_ser_docto    ";"
                   tit_acr.cod_tit_acr      ";"
                   tit_acr.cdn_cliente      SKIP.

    END.    
    
END.
OUTPUT CLOSE.
MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
