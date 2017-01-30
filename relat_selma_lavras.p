output to "C:\temp\Relatorio_Lavras.CSV".

put "Estabelecimento Origem"
    ";"
    "Numero Pedido"
    ";"
    "Cliente"
    ";"
    "Codigo Item"
    ";"
    "Descricao Item"
    ";"
    "Estado Destino"
    skip.  

for each ws-p-venda where (ws-p-venda.ind-sit-ped = 01 or
                           ws-p-venda.ind-sit-ped = 03 or
                           ws-p-venda.ind-sit-ped = 05 or
                           ws-p-venda.ind-sit-ped = 09) and
                           ws-p-venda.cod-estabel = "44"
                          no-lock:

    find first loc-entr where loc-entr.nome-abrev = ws-p-venda.nome-abrev 
                          and loc-entr.cod-entrega = ws-p-venda.cod-entrega
                          no-lock.

    for each ws-p-item of ws-p-venda no-lock.
        find first item where item.it-codigo = ws-p-item.it-codigo no-lock no-error.
        if ws-p-item.it-codigo <> "38800512" and
           ws-p-item.it-codigo <> "39900654" and
           ws-p-item.it-codigo <> "39919020" and      
           ws-p-item.it-codigo <> "40000515" and       
           ws-p-item.it-codigo <> "40000655" and       
           ws-p-item.it-codigo <> "40019020" and
           ws-p-item.it-codigo <> "38800524" and      
           ws-p-item.it-codigo <> "39970139" and       
           ws-p-item.it-codigo <> "40000187" and       
           ws-p-item.it-codigo <> "40000424" and      
           ws-p-item.it-codigo <> "40000527" and     
           ws-p-item.it-codigo <> "40000667" and      
           ws-p-item.it-codigo <> "40019019" and        
           ws-p-item.it-codigo <> "50054752" and
           ws-p-item.it-codigo <> "38800056" and
           ws-p-item.it-codigo <> "39900058" and        
           ws-p-item.it-codigo <> "39900800" and        
           ws-p-item.it-codigo <> "39919092" and        
           ws-p-item.it-codigo <> "40000394" and        
           ws-p-item.it-codigo <> "40000680" and        
           ws-p-item.it-codigo <> "40000801" and        
           ws-p-item.it-codigo <> "40019093" and        
           ws-p-item.it-codigo <> "40033922" and        
           ws-p-item.it-codigo <> "40091739" and                
           ws-p-item.it-codigo <> "50000056" and        
           ws-p-item.it-codigo <> "50000068" and
           ws-p-item.it-codigo <> "38800081" and               
           ws-p-item.it-codigo <> "39900083" and             
           ws-p-item.it-codigo <> "39919109" and         
           ws-p-item.it-codigo <> "39970127" and         
           ws-p-item.it-codigo <> "40000400" and        
           ws-p-item.it-codigo <> "40000692" and        
           ws-p-item.it-codigo <> "40019100" and        
           ws-p-item.it-codigo <> "50000081" and   
           ws-p-item.it-codigo <> "38800202" and           
           ws-p-item.it-codigo <> "38800445" and        
           ws-p-item.it-codigo <> "39900708" and        
           ws-p-item.it-codigo <> "39919031" and        
           ws-p-item.it-codigo <> "40000205" and        
           ws-p-item.it-codigo <> "40000448" and        
           ws-p-item.it-codigo <> "40000709" and        
           ws-p-item.it-codigo <> "40005756" and        
           ws-p-item.it-codigo <> "40019032" and         
           ws-p-item.it-codigo <> "40033934"  then

            put ws-p-venda.cod-estabel
                ";"
                ws-p-venda.nr-pedcli 
                ";"
                ws-p-venda.nome-abrev
                ";"
                ws-p-item.it-codigo
                ";"
                item.descricao-1
                ";"
                loc-entr.estado
                skip.  
    end.

end.

for each ws-p-venda where (ws-p-venda.ind-sit-ped = 01 or
                           ws-p-venda.ind-sit-ped = 03 or
                           ws-p-venda.ind-sit-ped = 05 or
                           ws-p-venda.ind-sit-ped = 09) and
                           ws-p-venda.cod-estabel = "19"
                          no-lock:

    find first loc-entr where loc-entr.nome-abrev = ws-p-venda.nome-abrev 
                          and loc-entr.cod-entrega = ws-p-venda.cod-entrega
                          no-lock.

    if avail loc-entr and
             loc-entr.estado <> "MG" then next.

    for each ws-p-item of ws-p-venda no-lock.
        find first item where item.it-codigo = ws-p-item.it-codigo no-lock no-error.
        if ws-p-item.it-codigo <> "38800512" and
           ws-p-item.it-codigo <> "39900654" and
           ws-p-item.it-codigo <> "39919020" and      
           ws-p-item.it-codigo <> "40000515" and       
           ws-p-item.it-codigo <> "40000655" and       
           ws-p-item.it-codigo <> "40019020" and
           ws-p-item.it-codigo <> "38800524" and      
           ws-p-item.it-codigo <> "39970139" and       
           ws-p-item.it-codigo <> "40000187" and       
           ws-p-item.it-codigo <> "40000424" and      
           ws-p-item.it-codigo <> "40000527" and     
           ws-p-item.it-codigo <> "40000667" and      
           ws-p-item.it-codigo <> "40019019" and        
           ws-p-item.it-codigo <> "50054752" and
           ws-p-item.it-codigo <> "38800056" and
           ws-p-item.it-codigo <> "39900058" and        
           ws-p-item.it-codigo <> "39900800" and        
            ws-p-item.it-codigo <> "39919092" and        
            ws-p-item.it-codigo <> "40000394" and        
            ws-p-item.it-codigo <> "40000680" and        
            ws-p-item.it-codigo <> "40000801" and        
            ws-p-item.it-codigo <> "40019093" and        
            ws-p-item.it-codigo <> "40033922" and        
            ws-p-item.it-codigo <> "40091739" and                
            ws-p-item.it-codigo <> "50000056" and        
            ws-p-item.it-codigo <> "50000068" and
            ws-p-item.it-codigo <> "38800081" and               
            ws-p-item.it-codigo <> "39900083" and             
            ws-p-item.it-codigo <> "39919109" and         
            ws-p-item.it-codigo <> "39970127" and         
            ws-p-item.it-codigo <> "40000400" and        
            ws-p-item.it-codigo <> "40000692" and        
            ws-p-item.it-codigo <> "40019100" and        
            ws-p-item.it-codigo <> "50000081" and   
            ws-p-item.it-codigo <> "38800202" and           
            ws-p-item.it-codigo <> "38800445" and        
            ws-p-item.it-codigo <> "39900708" and        
            ws-p-item.it-codigo <> "39919031" and        
            ws-p-item.it-codigo <> "40000205" and        
            ws-p-item.it-codigo <> "40000448" and        
            ws-p-item.it-codigo <> "40000709" and        
            ws-p-item.it-codigo <> "40005756" and        
            ws-p-item.it-codigo <> "40019032" and         
            ws-p-item.it-codigo <> "40033934"  then

            put ws-p-venda.cod-estabel
                ";"
                ws-p-venda.nr-pedcli 
                ";"
                ws-p-venda.nome-abrev
                ";"
                ws-p-item.it-codigo
                ";"
                item.descricao-1
                ";"
                loc-entr.estado
                skip.  
    end.

end.

output close.
