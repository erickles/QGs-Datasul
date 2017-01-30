DEFINE VARIABLE cCelular AS CHARACTER   NO-UNDO FORMAT "X(15)".

OUTPUT TO "C:\Temp\titulos_a_vencer_2_dias.csv".

PUT "Empresa;Cliente;Celular;Repres;Estab;Especie;Parcela;Portador;Serie;Nr titulo;Dt emissao;Dt venc;Vlr Saldo;Vlr Original" SKIP.

FOR EACH tit_acr WHERE tit_acr.cod_empresa        = "TOR"
                   AND tit_acr.cod_espec_docto    = "DP"
                   AND tit_acr.dat_vencto_tit_acr = TODAY + 2
                   /*AND tit_acr.dat_vencto_origin_tit_acr = TODAY + 2*/
                   AND tit_acr.val_sdo_tit_acr > 0
                   NO-LOCK:

    ASSIGN cCelular = "".

    FIND FIRST emitente WHERE emitente.cod-emitente = tit_acr.cdn_cliente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN 
        ASSIGN cCelular = STRING(emitente.telefone[1],"X(15)").
            
    PUT tit_acr.cod_empresa         ";"
        tit_acr.cdn_cliente         ";"
        cCelular                    ";"
        tit_acr.cdn_repres          ";"
        tit_acr.cod_estab           ";"
        tit_acr.cod_espec_docto     ";"
        tit_acr.cod_parcela         ";"
        tit_acr.cod_portador        ";"
        tit_acr.cod_ser_docto       ";"
        tit_acr.cod_tit_acr         ";"
        tit_acr.dat_emis_docto      ";"
        tit_acr.dat_vencto_tit_acr  ";"
        tit_acr.val_sdo_tit_acr     ";"
        tit_acr.val_origin_tit_acr  SKIP.
END.

OUTPUT CLOSE.
