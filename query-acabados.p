define variable ord-saida as inte.
define variable l-ok      as logical.
define buffer bfmovto-estoq for movto-estoq.

output to "c:\itens_teste.txt".   
        
for each movto-estoq where movto-estoq.dt-trans     = 08/14/2009                   and
                           movto-estoq.cod-estabel  >= "19"                        and
                           movto-estoq.cod-estabel  <= "19"                        and
                           movto-estoq.it-codigo     = "13143049"                  and
                           (movto-estoq.esp-docto    = 28                          or
                           movto-estoq.esp-docto     = 31 )
                           no-lock:   
    message movto-estoq.nr-ord-produ view-as alert-box.        
    if movto-estoq.it-codigo begins "4" then put movto-estoq.it-codigo "" skip.
    else run pi-search(input  movto-estoq.nr-ord-produ,
                       output ord-saida,
                       output l-ok).   
      
    do while l-ok = no:
        run pi-search(input  ord-saida,
                      output ord-saida,
                      output l-ok).    
    end.    
     
end.

output close.

procedure pi-search.
    define input  parameter ordem         as inte.
    define output parameter ordem-saida   as inte.
    define output parameter l-oka         as logical.

    l-oka = yes.

    find first ord-prod where ord-prod.nr-ord-produ = ordem no-lock no-error.
    if avail ord-prod then do:
    
        if ord-prod.it-codigo begins "4" then 
            put movto-estoq.it-codigo
                " "
                ord-prod.it-codigo skip.
        else do:            
            find first bfmovto-estoq where bfmovto-estoq.it-codigo = ord-prod.it-codigo 
                                       and bfmovto-estoq.lote      = ord-prod.lote
                                       no-lock no-error.

            if avail bfmovto-estoq then do:            
                if bfmovto-estoq.item-pai begins "4" then do:
                    put movto-estoq.it-codigo
                        " "
                        bfmovto-estoq.item-pai
                        skip.
                end.

                if bfmovto-estoq.item-pai <> "4" then 
                    assign ord-saida = bfmovto-estoq.nr-ord-produ
                               l-oka = no.
            end.
        end.
    end.
end procedure.
