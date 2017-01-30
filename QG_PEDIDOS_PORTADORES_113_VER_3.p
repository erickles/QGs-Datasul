DEFINE VARIABLE iCont   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFaixa  AS INTEGER     NO-UNDO.

{include/varsituac.i}

iFaixa = 500.

OUTPUT TO "c:\temp\clientes_port_check_boleto.csv".

PUT "cod-emitente"   ";"
    "grupo"          ";"
    "portador"       ";"
    "port-prefer"    SKIP.

/* Pego todos os cliente que sejam correio, que seja cliente ou ambos e que o portador seja diferente de 113 */
    FOR EACH emitente WHERE /*emitente.cod-gr-cli = 4*/
                        /*AND emitente.cod-emitente >= 100000
                        AND emitente.cod-emitente <= 199999*/
                        /*AND*/ (emitente.identific = 1 OR emitente.identific = 3)
                        AND (emitente.portador = 112 OR emitente.port-prefer = 112),
        EACH es-loc-entr WHERE es-loc-entr.nome-abrev = emitente.nome-abrev
                           AND es-loc-entr.boleto      = 1
                           AND es-loc-entr.cod-entrega = "Padrao" NO-LOCK BREAK BY emitente.cod-emitente:

    /*ASSIGN iFaixa = iFaixa - 1.*/
    
    /*IF emitente.portador = 39910 OR emitente.portador = 113 THEN DO:*/
        /*
        IF emitente.portador <> 34110 THEN
            ASSIGN emitente.portador    = 112.

        IF emitente.port-pref <> 34110 THEN
            ASSIGN emitente.port-pref    = 112.

        PUT emitente.cod-emitente   ";"
            emitente.cod-gr-cli     ";"
            emitente.portador       ";"
            emitente.port-prefer    SKIP.
        */
    /*END.*/
    
    /*
    IF emitente.port-prefer = 113 THEN DO:

        ASSIGN emitente.portador    = 112
               emitente.port-prefer = 112.

        PUT emitente.cod-emitente   ";"
            emitente.portador       ";"
            emitente.port-prefer    SKIP.

    END.
    */
    /*
    FIND FIRST es-motorista WHERE es-motorista.cgc = emitente.cgc NO-LOCK NO-ERROR.
    IF AVAIL es-motorista THEN
        PUT emitente.cod-emitente SKIP.
    */
    
    FOR EACH ws-p-venda WHERE ws-p-venda.nome-abrev = emitente.nome-abrev
                          AND ws-p-venda.ind-sit-ped < 17
                          AND (ws-p-venda.cod-tipo-oper = 1 OR ws-p-venda.cod-tipo-oper = 2):

        FIND FIRST es-embarque-pedido WHERE es-embarque-pedido.nr-pedcli  = ws-p-venda.nr-pedcli
                                        AND es-embarque-pedido.nome-abrev = ws-p-venda.nome-abrev
                                        NO-LOCK NO-ERROR.
        IF NOT AVAIL es-embarque-pedido THEN DO:

            FIND FIRST ped-venda WHERE ped-venda.nome-abrev     = ws-p-venda.nome-abrev
                               AND ped-venda.nr-pedcli      = ws-p-venda.nr-pedcli
                               AND ped-venda.cod-portador   <> 112
                               NO-ERROR.
            IF AVAIL ped-venda THEN DO:
                ped-venda.cod-portador = 112.
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

    IF iFaixa = 0 THEN
        LEAVE.
END.

OUTPUT CLOSE.
/*
MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
