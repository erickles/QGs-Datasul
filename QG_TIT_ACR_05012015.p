OUTPUT TO "c:\temp\tit_acr.csv".

PUT "COD CLIENTE"   ";"
    "COD REPRES"    ";"
    "ESPECIE"       ";"
    "ESTAB"         ";"
    "PARCELA"       ";"
    "SERIE"         ";"
    "TITULO"        ";"
    "DT GER MOV"    ";"
    "HR GER MOV"    ";"
    "DT LIQ MOV"    ";"
    "VALOR"         SKIP.

FOR EACH movto_tit_acr WHERE movto_tit_acr.ind_trans_acr_abrev = "LIQ" 
                         AND movto_tit_acr.dat_liquidac_tit_acr >= 12/01/2015
                         AND movto_tit_acr.dat_liquidac_tit_acr <= 12/18/2015

                         AND movto_tit_acr.dat_gerac_movto >= 12/19/2015 
                         AND movto_tit_acr.dat_gerac_movto <= 12/31/2015
                         
                         NO-LOCK:
    
    FIND FIRST tit_acr OF movto_tit_acr NO-LOCK NO-ERROR.
    /*
    IF tit_acr.dat_liquidac_tit_acr >= 12/19/2015 AND tit_acr.dat_liquidac_tit_acr <= 12/31/2015 THEN
    */

    FIND FIRST es-movto-comis WHERE es-movto-comis.cod-estabel = tit_acr.cod_estab                                
                                AND es-movto-comis.esp-docto   = tit_acr.cod_espec_docto
                                AND es-movto-comis.nro-docto   = tit_acr.cod_tit_acr
                                AND es-movto-comis.parcela     = tit_acr.cod_parcela
                                AND es-movto-comis.serie       = tit_acr.cod_ser_docto
                                AND es-movto-comis.tp-movto    = 201
                                AND es-movto-comis.cod-rep     = tit_acr.cdn_repres
                                AND es-movto-comis.dt-today    = movto_tit_acr.dat_gerac_movto
                                AND es-movto-comis.ep-codigo   = 1
                                NO-LOCK NO-ERROR.

    PUT tit_acr.cdn_cliente                                         ";"
        tit_acr.cdn_repres                                          ";"
        tit_acr.cod_espec_docto                                     ";"
        tit_acr.cod_estab                                           ";"
        tit_acr.cod_parcela                                         ";"
        tit_acr.cod_ser_docto                                       ";"
        tit_acr.cod_tit_acr                                         ";"
        movto_tit_acr.dat_gerac_movto                               ";"
        movto_tit_acr.hra_gerac_movto                               ";"
        movto_tit_acr.dat_liquidac_tit_acr                          ";"
        IF AVAIL es-movto-comis THEN es-movto-comis.valor ELSE 0    SKIP.
END.
OUTPUT CLOSE.
