DEFINE BUFFER bf-movto-sintegra FOR movto-sintegra.

OUTPUT TO "C:\Clientes_semretorno_sintegra.csv".

PUT "Cliente" ";"
    "Pedido"  ";"
    "Data Ultima Consulta"
    SKIP.
    
FOR EACH ws-p-venda WHERE ws-p-venda.ind-sit-ped <> 17 
                      AND ws-p-venda.dt-impl > 06/01/2011 NO-LOCK:
    FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:        
        IF NOT CAN-FIND(LAST movto-sintegra WHERE movto-sintegra.cod-emitente  = emitente.cod-emitente 
                                              AND movto-sintegra.data-consulta = 09/30/2011
                                              AND movto-sintegra.uf = "MS") THEN DO: 
                                                                 
            /*IF CAN-FIND(LAST bf-movto-sintegra WHERE bf-movto-sintegra.cod-emitente  = emitente.cod-emitente) THEN*/

            FIND LAST bf-movto-sintegra WHERE bf-movto-sintegra.cod-emitente  = emitente.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL bf-movto-sintegra THEN
                PUT emitente.cod-emitente           ";"
                    ws-p-venda.nr-pedcli            ";"
                    bf-movto-sintegra.data-consulta ";"
                    SKIP.
            
            IF NOT AVAIL bf-movto-sintegra THEN
                PUT emitente.cod-emitente           ";"
                    ws-p-venda.nr-pedcli            ";"
                    "Sem Consulta Pre existente"    ";"
                    SKIP.
        END.                
    END.    
END.

OUTPUT CLOSE.
