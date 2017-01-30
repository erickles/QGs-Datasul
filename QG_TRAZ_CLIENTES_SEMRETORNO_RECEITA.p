DEFINE BUFFER bf-movto-receita FOR movto-receita.

OUTPUT TO "C:\Clientes_semretorno_receita.csv".

PUT "Cliente" ";"
    "Pedido"  ";"
    "Data Ultima Consulta"
    SKIP.
    
FOR EACH ws-p-venda WHERE ws-p-venda.dt-impl = 09/16/2011 
                      AND ws-p-venda.ind-sit-ped <> 17
                      NO-LOCK:
    FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:        
        IF NOT CAN-FIND(LAST movto-receita WHERE movto-receita.cod-emitente  = emitente.cod-emitente 
                                             AND movto-receita.data-pesquisa = 09/16/2011) THEN DO:

            /*IF CAN-FIND(LAST bf-movto-receita WHERE bf-movto-receita.cod-emitente  = emitente.cod-emitente) THEN*/

            FIND LAST bf-movto-receita WHERE bf-movto-receita.cod-emitente  = emitente.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL bf-movto-receita THEN
                PUT emitente.cod-emitente       ";"
                    ws-p-venda.nr-pedcli        ";"
                    bf-movto-receita.data-pesquisa ";"
                    SKIP.
            
            ELSE
                PUT emitente.cod-emitente           ";"
                    ws-p-venda.nr-pedcli            ";"
                    "Sem Consulta Pre existente"    ";"
                    SKIP.
        END.                
    END.    
END.

OUTPUT CLOSE.
