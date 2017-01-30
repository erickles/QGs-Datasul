for each movto-estoq no-lock.

    find first item where item.it-codigo = movto-estoq.it-codigo no-lock no-error.
    find first estabelec where estabelec.cod-estabel = movto-estoq.cod-estabel no-lock no-error.

    disp movto-estoq.it-codigo 
        item.descricao-1 
        string(movto-estoq.cod-estabel + " - " + estabelec.cidade) 
        dt-trans 
        /*esp-docto*/ 
        movto-estoq.quantidade
        movto-estoq.valor-mat-m[1] 
        movto-estoq.lote 
        movto-estoq.valor-mob-m[1] 
        movto-estoq.valor-mob-o[1] 
        movto-estoq.valor-mob-p[1] 
        movto-estoq.valor-ggf-m[1] 
        movto-estoq.valor-ggf-o[1] 
        movto-estoq.valor-ggf-p[1]
        movto-estoq.valor-mob-m[3]
        movto-estoq.valor-mob-o[3]
        movto-estoq.valor-mob-p[3]
        movto-estoq.valor-ggf-m[3]
        movto-estoq.valor-ggf-o[3]
        movto-estoq.valor-ggf-p[3]
        movto-estoq.referencia 
        movto-estoq.serie-docto 
        movto-estoq.nro-docto 
        movto-estoq.conta-contabil
        with 1 col.

