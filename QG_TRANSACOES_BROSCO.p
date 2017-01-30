{include/i-freeac.i}

OUTPUT TO "C:\tmp\transacoes_brosco.csv".

PUT "Usuario;"
    "Data movto;"
    "Cod empresa;"
    "Especie docto;"
    "Cod Estab;"
    "Tipo transacao;"
    "Cod cliente;"
    "Parcela;"
    "Serie;"
    "Nr titulo;"
    "Valor movto"
    SKIP.

FOR EACH movto_tit_acr WHERE movto_tit_acr.cod_usuario = "ambrosco"
                         AND movto_tit_acr.dat_gerac_movto >= 01/01/2013
                         AND movto_tit_acr.dat_gerac_movto <= 10/31/2014
                         NO-LOCK,
                         EACH tit_acr OF movto_tit_acr NO-LOCK:

    PUT UNFORM
        movto_tit_acr.cod_usuario                   ";"
        movto_tit_acr.dat_gerac_movto               ";"
        movto_tit_acr.cod_empresa                   ";"
        movto_tit_acr.cod_espec_docto               ";"
        movto_tit_acr.cod_estab                     ";"
        fn-free-accent(movto_tit_acr.ind_trans_acr) ";"
        tit_acr.cdn_cliente                         ";"
        tit_acr.cod_parcela                         ";"
        tit_acr.cod_ser_docto                       ";"
        tit_acr.cod_tit_acr                         ";"
        movto_tit_acr.val_movto_tit_acr             SKIP.

END.

OUTPUT CLOSE.
