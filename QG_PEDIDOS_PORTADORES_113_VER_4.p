DEFINE VARIABLE iCont   AS INTEGER     NO-UNDO.

{include/varsituac.i}

DEFINE VARIABLE iChange AS LOGICAL     NO-UNDO INITIAL NO.

OUTPUT TO "c:\temp\clientes_port_check_boleto_113.csv".

PUT "cod-emitente"   ";"
    "grupo"          ";"
    "portador"       ";"
    "port-prefer"    ";"
    "identific"      SKIP.

/* Pego todos os cliente que sejam correio, que seja cliente ou ambos e que o portador seja diferente de 113 */
    FOR EACH emitente WHERE (emitente.identific = 1 OR emitente.identific = 3)
                        AND (emitente.cod-gr-cli <> 3 AND emitente.cod-gr-cli <> 9 AND emitente.cod-gr-cli <> 92)
                        AND (emitente.port-prefer <> 113 AND emitente.port-prefer <> 44010),
                        EACH es-loc-entr WHERE es-loc-entr.nome-abrev = emitente.nome-abrev
                                           AND es-loc-entr.boleto      = 2
                                           AND es-loc-entr.cod-entrega = "Padrao" NO-LOCK BREAK BY emitente.cod-emitente:
            
        PUT emitente.cod-emitente   ";"
            emitente.cod-gr-cli     ";"
            emitente.portador       ";"
            emitente.port-prefer    ";"
            emitente.identific      SKIP.
        
        IF iChange THEN DO:
            ASSIGN emitente.port-prefer = 113.
        END.

        FIND FIRST clien_financ WHERE clien_financ.cdn_cliente = emitente.cod-emitente NO-ERROR.
        
        IF iChange THEN DO:
            IF AVAIL clien_financ THEN
                clien_financ.cod_portad_prefer = "113".
        END.
        
        FOR EACH ws-p-venda WHERE ws-p-venda.nome-abrev = emitente.nome-abrev
                              AND ws-p-venda.ind-sit-ped < 17
                              AND (ws-p-venda.cod-tipo-oper = 1 OR ws-p-venda.cod-tipo-oper = 2):
    
            FIND FIRST es-embarque-pedido WHERE es-embarque-pedido.nr-pedcli  = ws-p-venda.nr-pedcli
                                            AND es-embarque-pedido.nome-abrev = ws-p-venda.nome-abrev
                                            NO-LOCK NO-ERROR.
            IF NOT AVAIL es-embarque-pedido THEN DO:
    
                FIND FIRST ped-venda WHERE ped-venda.nome-abrev     = ws-p-venda.nome-abrev
                                   AND ped-venda.nr-pedcli      = ws-p-venda.nr-pedcli
                                   AND ped-venda.cod-portador   <> 113
                                   NO-ERROR.
                IF AVAIL ped-venda THEN DO:

                    IF iChange THEN
                        ped-venda.cod-portador = 113.

                    PUT ws-p-venda.nr-pedcli SKIP.
                END.
    
            END.
    
        END.

    /*
    FIND LAST ws-p-venda WHERE ws-p-venda.nome-abrev = emitente.nome-abrev
                           AND ws-p-venda.ind-sit-ped < 17
                           AND (ws-p-venda.cod-tipo-oper = 1 OR ws-p-venda.cod-tipo-oper = 2) NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN DO:
    
        FIND FIRST ped-venda WHERE ped-venda.nome-abrev     = ws-p-venda.nome-abrev
                               AND ped-venda.nr-pedcli      = ws-p-venda.nr-pedcli
                               AND ped-venda.cod-portador   <> 113
                               NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            ped-venda.cod-portador = 113.
            PUT STRING(ws-p-venda.cod-estabel,"99") ";"
                ws-p-venda.nome-abrev               ";"
                ws-p-venda.nr-pedcli                ";"
                ped-venda.cod-portador              ";"
                ws-p-venda.dt-implant               SKIP.
        END.
    END.
    /*
    ELSE DO:
        /*
        ASSIGN emitente.portador    = 113
               emitente.port-prefer = 113.
        */

        PUT "" ";"
            emitente.nome-abrev     ";"
            ""                      ";"
            emitente.portador       ";"
            ""                      SKIP.

    END.
    */
        
    */  

END.

OUTPUT CLOSE.
/*
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
