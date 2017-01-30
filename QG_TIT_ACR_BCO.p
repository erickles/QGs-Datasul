DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE BUFFER bfinstruc_bcia FOR instruc_bcia.

OUTPUT TO "c:\temp\titulos_acr.csv".

PUT "ID Titulo;"
    "Valor movto;"
    "Cod Cliente;"
    "Cod empresa;"
    "Cod estab;"
    "portador;"
    "Dt geracao movto;"
    "Boleto;"
    "Instrucao 1;"
    "Instrucao 2"
    SKIP.

FOR EACH movto_ocor_bcia WHERE movto_ocor_bcia.dat_movto_ocor_bcia >= 07/01/2015
                           AND movto_ocor_bcia.dat_movto_ocor_bcia <= 08/31/2015
                           AND movto_ocor_bcia.cod_empresa = "TOR"
                           AND (movto_ocor_bcia.cod_portador = "23712"  OR
                                movto_ocor_bcia.cod_portador = "39910"  OR
                                movto_ocor_bcia.cod_portador = "112"    OR
                                movto_ocor_bcia.cod_portador = "34110")
                           AND movto_ocor_bcia.log_confir_movto_envdo_bco
                           NO-LOCK:
    
    FIND FIRST es-emitente-dis WHERE es-emitente-dis.cod-emitente = movto_ocor_bcia.cdn_cliente NO-LOCK NO-ERROR.
    IF AVAIL es-emitente-dis THEN DO:

        iCont = iCont + 1.

        FIND FIRST instruc_bcia WHERE instruc_bcia.cod_instruc_bcia = movto_ocor_bcia.cod_instruc_bcia_1_acr NO-LOCK NO-ERROR.
        FIND FIRST bfinstruc_bcia WHERE bfinstruc_bcia.cod_instruc_bcia = movto_ocor_bcia.cod_instruc_bcia_2_acr NO-LOCK NO-ERROR.
                                
        PUT UNFORM movto_ocor_bcia.num_id_tit_acr                                   ";"
                   movto_ocor_bcia.val_movto_ocor_bcia                              ";"
                   movto_ocor_bcia.cdn_cliente                                      ";"
                   movto_ocor_bcia.cod_empresa                                      ";"
                   movto_ocor_bcia.cod_estab                                        ";"
                   movto_ocor_bcia.cod_portador                                     ";"
                   movto_ocor_bcia.dat_gerac_movto_ocor_bcia                        ";"
                   IF es-emitente-dis.boleto = 1 THEN "Acompanha NF" ELSE "Correio" ";"
                   IF AVAIL instruc_bcia THEN instruc_bcia.des_instruc_bcia ELSE ""              ";"
                   IF AVAIL bfinstruc_bcia THEN bfinstruc_bcia.des_instruc_bcia ELSE ""            SKIP.

    END.

END.
    
OUTPUT CLOSE.
