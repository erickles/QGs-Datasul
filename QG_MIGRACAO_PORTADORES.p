DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE iContPedidos AS INTEGER     NO-UNDO.

DEFINE BUFFER bf-emitente FOR emitente.

OUTPUT TO "C:\temp\migracao_portadores.csv".

PUT "nome-matriz"   ";"
    "cod-emitente"  ";"
    "port-pref"     ";"
    "mod-pref"      ";"
    "portador"      ";"
    "modalidade"    ";"
    "estado"        ";"
    "Qtd pedidos"   SKIP.

FOR EACH emitente WHERE emitente.estado <> "EX"
                    AND emitente.nome-abre = emitente.nome-matriz
                    AND emitente.port-pref = 112
                    NO-LOCK:
    iCont = iCont + 1.

    FOR EACH bf-emitente WHERE bf-emitente.nome-abrev = emitente.nome-matriz:
        
        iContPedidos = 0.        

        /* Ajustando pedidos */
        FOR EACH ws-p-venda WHERE ws-p-venda.nome-abrev = bf-emitente.nome-abrev 
                              AND ws-p-venda.ind-sit-ped < 17
                              AND (ws-p-venda.cod-tipo-oper = 1 OR ws-p-venda.cod-tipo-oper = 2)
                              NO-LOCK:

            FIND FIRST es-embarque-pedido WHERE es-embarque-pedido.nr-pedcli  = ws-p-venda.nr-pedcli
                                            AND es-embarque-pedido.nome-abrev = ws-p-venda.nome-abrev
                                            NO-LOCK NO-ERROR.
            IF NOT AVAIL es-embarque-pedido THEN DO:
    
                FIND FIRST ped-venda WHERE ped-venda.nome-abrev     = ws-p-venda.nome-abrev
                                       AND ped-venda.nr-pedcli      = ws-p-venda.nr-pedcli
                                       AND ped-venda.cod-portador   = 112
                                       NO-ERROR.
                IF AVAIL ped-venda THEN DO:
                    ped-venda.cod-portador = 34110.
                END.
    
            END.

            iContPedidos = iContPedidos + 1.
        END.

        PUT bf-emitente.nome-matriz     ";"
            bf-emitente.cod-emitente    ";"
            bf-emitente.port-pref       ";"
            bf-emitente.mod-pref        ";"
            bf-emitente.portador        ";"
            bf-emitente.modalidade      ";"
            bf-emitente.estado          ";"
            iContPedidos                SKIP.

        /* Por fim, o cliente */
        
        ASSIGN bf-emitente.port-pref  = 34110
               bf-emitente.mod-pref   = 1
               bf-emitente.portador   = 34110
               bf-emitente.modalidade = 1.
               
        FIND FIRST clien_financ WHERE clien_financ.cdn_cliente = emitente.cod-emitente NO-ERROR.
        IF AVAIL clien_financ THEN
            clien_financ.cod_portad_prefer = "34110".
                    
                       
    END.

    IF iCont = 7828 THEN
        LEAVE.

END.

OUTPUT CLOSE.

MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
