DEFINE VARIABLE soma AS DECIMAL     NO-UNDO.


FOR EACH saldo-estoq WHERE it-codigo    = "40007042" 
                       AND qtidade-atu  > 0
                       AND cod-estabel = "01"
                       AND saldo-estoq.dt-vali-lote >= TODAY
                       AND saldo-estoq.cod-dep = "EXP".

    DISP saldo-estoq.cod-dep.

    soma = soma + saldo-estoq.qtidade-atu - saldo-estoq.qt-aloc-ped - saldo-estoq.qt-aloc-prod - saldo-estoq.qt-alocada.
    
END.

MESSAGE soma
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
