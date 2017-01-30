DEFINE VARIABLE nr-pedido AS CHARACTER   NO-UNDO INITIAL "BR1003690410".
    
FOR EACH ws-p-venda WHERE nr-pedcli = nr-pedido:
    FOR EACH ws-p-item OF ws-p-venda:
        FOR EACH ws-p-desc OF ws-p-item:
            DELETE ws-p-desc.
        END.
        DELETE ws-p-item.
    END.
    DELETE ws-p-venda.
END.

FOR EACH ped-venda WHERE nr-pedcli = nr-pedido:
    FOR EACH ped-item OF ped-venda:
        
        DELETE ped-item.
    END.
    DELETE ped-venda.
END.
