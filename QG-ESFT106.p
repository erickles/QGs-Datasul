DEFINE TEMP-TABLE tt-es-ped-saldo LIKE es-ped-saldo.
DEFINE TEMP-TABLE tt-saldo-estoq LIKE saldo-estoq.
DEFINE TEMP-TABLE tt-alocacao
    FIELD cod-depos     LIKE saldo-estoq.cod-depos      
    FIELD cod-refer     LIKE saldo-estoq.cod-refer   
    FIELD lote          LIKE saldo-estoq.lote        
    FIELD dt-vali-lote  LIKE saldo-estoq.dt-vali-lote
    FIELD qtidade-atu   LIKE saldo-estoq.qtidade-atu 
    FIELD qt-aloc-ped   LIKE saldo-estoq.qt-aloc-ped 
    FIELD qt-alocada    LIKE saldo-estoq.qt-alocada  
    FIELD qt-aloc-prod  LIKE saldo-estoq.qt-aloc-prod
    FIELD saldo         LIKE saldo-estoq.qt-aloc-prod
    FIELD cod-estabel   LIKE es-ped-saldo.cod-estabel 
    FIELD it-codigo     LIKE es-ped-saldo.it-codigo   
    FIELD nr-embarque   LIKE es-ped-saldo.nr-embarque 
    FIELD cod-sit-aloc  LIKE es-ped-saldo.cod-sit-aloc
    FIELD qt-alocada-2  LIKE es-ped-saldo.qt-alocada  
    FIELD qt-embarcada  LIKE es-ped-saldo.qt-embarcada
    FIELD nr-pedcli     LIKE es-ped-saldo.nr-pedcli   
    FIELD nome-abrev    LIKE es-ped-saldo.nome-abrev
    FIELD dt-impl-ped   LIKE ws-p-venda.dt-impl.

DEFINE VARIABLE de-qtde-aloc     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dt-aux           AS DATE        NO-UNDO.

OUTPUT TO "c:\ESFT106.CSV".

PUT "Deposito"          ";"
    "Ref"               ";"
    "Lote"              ";"
    "Validade"          ";"
    "Qtde Atual"        ";"
    "Pedido"            ";"
    "Embarque"          ";"
    "Producao"          ";"
    "Disponivel"        ";"
    "Cod. Estab."       ";"
    "Cod. Item"         ";"
    "Embarque"          ";"
    "Sit.Aloc"          ";"
    "Qtde Alocada"      ";"
    "Qtde Embarcada"    ";"
    "Nr. Pedido"        ";"
    "Dt.Aloc.Ped"       SKIP.

FOR EACH saldo-estoq NO-LOCK WHERE saldo-estoq.it-codigo = "40000060"
                               AND saldo-estoq.cod-estab = "19"
                               AND saldo-estoq.qtidade-atu > 0:

    FIND ITEM WHERE ITEM.it-codigo = saldo-estoq.it-codigo NO-LOCK NO-ERROR.
    
    CREATE tt-saldo-estoq.
        BUFFER-COPY saldo-estoq TO tt-saldo-estoq.

    /* Cria Alocacoes/Reservas */
    FOR EACH es-ped-saldo NO-LOCK WHERE es-ped-saldo.cod-estabel  = saldo-estoq.cod-estabel
                                    AND es-ped-saldo.cod-depos    = saldo-estoq.cod-depos
                                    AND es-ped-saldo.it-codigo    = saldo-estoq.it-codigo
                                    AND es-ped-saldo.cod-refer    = saldo-estoq.cod-refer
                                    AND es-ped-saldo.lote         = saldo-estoq.lote
                                    AND es-ped-saldo.cod-sit-aloc < 3:

        CREATE tt-es-ped-saldo.
        BUFFER-COPY es-ped-saldo TO tt-es-ped-saldo.

        /* Grava Numero do Embarque */
        FIND pre-fatur WHERE pre-fatur.nome-abrev = es-ped-saldo.nome-abrev 
                         AND pre-fatur.nr-pedcli  = es-ped-saldo.nr-pedcli  
                         NO-LOCK NO-ERROR.

        IF AVAIL pre-fatur THEN DO:
            ASSIGN tt-es-ped-saldo.nr-embarque = pre-fatur.nr-embarque.
        END.
        ELSE DO:

            FIND es-embarque-pedido WHERE es-embarque-pedido.nome-abrev = es-ped-saldo.nome-abrev 
                                      AND es-embarque-pedido.nr-pedcli  = es-ped-saldo.nr-pedcli 
                                      NO-LOCK NO-ERROR.

            IF AVAIL es-embarque-pedido THEN DO:
    
                FIND es-embarque WHERE es-embarque.nr-fila = es-embarque-pedido.nr-fila NO-LOCK NO-ERROR.
                IF AVAIL es-embarque THEN DO:
                    ASSIGN tt-es-ped-saldo.nr-embarque = IF es-embarque.nr-embarque > 0 THEN 
                           es-embarque.nr-embarque ELSE es-embarque.nr-fila.
                END.    
            END.        
        END.        
    END.       

    IF saldo-estoq.qt-alocada > 0 THEN DO:

        de-qtde-aloc = saldo-estoq.qt-alocada.
    
        blk_data:
        DO dt-aux = TODAY TO TODAY - 360 BY -1:
    
            FOR EACH it-pre-fat NO-LOCK WHERE it-pre-fat.it-codigo   = saldo-estoq.it-codigo
                                          AND it-pre-fat.dt-prev-fat = dt-aux:
    
                FIND pre-fatur OF it-pre-fat NO-LOCK NO-ERROR.
                IF pre-fatur.cod-sit-pre > 2 THEN NEXT.
    
                FIND embarque WHERE embarque.nr-embarque = pre-fatur.nr-embarque NO-LOCK NO-ERROR.
    
                IF embarque.cod-estabel <> saldo-estoq.cod-estabel THEN NEXT.
    
                FOR EACH it-dep-fat NO-LOCK WHERE it-dep-fat.nr-embarque  = it-pre-fat.nr-embarque
                                              AND it-dep-fat.nr-resumo    = it-pre-fat.nr-resumo
                                              AND it-dep-fat.nome-abrev   = it-pre-fat.nome-abrev
                                              AND it-dep-fat.nr-pedcli    = it-pre-fat.nr-pedcli
                                              AND it-dep-fat.cod-estabel  = pre-fatur.cod-estabel
                                              AND it-dep-fat.nr-sequencia = it-pre-fat.nr-sequencia
                                              AND it-dep-fat.it-codigo    = it-pre-fat.it-codigo
                                              AND it-dep-fat.cod-refer    = it-pre-fat.cod-refer
                                              AND it-dep-fat.nr-entrega   = it-pre-fat.nr-entrega
                                              AND it-dep-fat.cod-depos    = saldo-estoq.cod-depos
                                              AND it-dep-fat.cod-localiz  = saldo-estoq.cod-localiz
                                              AND it-dep-fat.nr-serlote   = saldo-estoq.lote:

                    CREATE tt-es-ped-saldo.
                    ASSIGN tt-es-ped-saldo.cod-estabel  = saldo-estoq.cod-estabel
                           tt-es-ped-saldo.cod-depos    = saldo-estoq.cod-depos
                           tt-es-ped-saldo.it-codigo    = saldo-estoq.it-codigo
                           tt-es-ped-saldo.cod-refer    = saldo-estoq.cod-refer
                           tt-es-ped-saldo.lote         = saldo-estoq.lote
                           tt-es-ped-saldo.nr-embarque  = embarque.nr-embarque
                           tt-es-ped-saldo.cod-sit-aloc = 3
                           tt-es-ped-saldo.qt-alocada   = 0
                           tt-es-ped-saldo.qt-embarcada = it-dep-fat.qt-alocada
                           tt-es-ped-saldo.nr-pedcli    = pre-fatur.nr-pedcli
                           tt-es-ped-saldo.nome-abrev   = pre-fatur.nome-abrev
                           de-qtde-aloc                 = de-qtde-aloc - it-dep-fat.qt-alocada.
    
                    IF de-qtde-aloc <= 0 THEN
                        LEAVE blk_data.
    
                END.
            END.
        END.
    END.
END.

FOR EACH tt-saldo-estoq NO-LOCK
    ,EACH tt-es-ped-saldo NO-LOCK WHERE tt-es-ped-saldo.cod-estabel  = tt-saldo-estoq.cod-estabel
                                    AND tt-es-ped-saldo.cod-depos    = tt-saldo-estoq.cod-depos
                                    AND tt-es-ped-saldo.it-codigo    = tt-saldo-estoq.it-codigo
                                    AND tt-es-ped-saldo.cod-refer    = tt-saldo-estoq.cod-refer
                                    AND tt-es-ped-saldo.lote         = tt-saldo-estoq.lote:

    CREATE tt-alocacao.
    ASSIGN tt-alocacao.cod-depos    = tt-saldo-estoq.cod-depos      
           tt-alocacao.cod-refer    = tt-saldo-estoq.cod-refer   
           tt-alocacao.lote         = tt-saldo-estoq.lote        
           tt-alocacao.dt-vali-lote = tt-saldo-estoq.dt-vali-lote
           tt-alocacao.qtidade-atu  = tt-saldo-estoq.qtidade-atu 
           tt-alocacao.qt-aloc-ped  = tt-saldo-estoq.qt-aloc-ped 
           tt-alocacao.qt-alocada   = tt-saldo-estoq.qt-alocada  
           tt-alocacao.qt-aloc-prod = tt-saldo-estoq.qt-aloc-prod
           tt-alocacao.saldo        = (tt-saldo-estoq.qtidade-atu  - tt-saldo-estoq.qt-aloc-ped  - tt-saldo-estoq.qt-aloc-prod - tt-saldo-estoq.qt-alocada)
           tt-alocacao.cod-estabel  = tt-es-ped-saldo.cod-estabel 
           tt-alocacao.it-codigo    = tt-es-ped-saldo.it-codigo   
           tt-alocacao.nr-embarque  = tt-es-ped-saldo.nr-embarque 
           tt-alocacao.cod-sit-aloc = tt-es-ped-saldo.cod-sit-aloc
           tt-alocacao.qt-alocada-2 = tt-es-ped-saldo.qt-alocada  
           tt-alocacao.qt-embarcada = tt-es-ped-saldo.qt-embarcada
           tt-alocacao.nr-pedcli    = tt-es-ped-saldo.nr-pedcli   
           tt-alocacao.nome-abrev   = tt-es-ped-saldo.nome-abrev.

    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = tt-alocacao.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN
        ASSIGN tt-alocacao.dt-impl-ped  = ws-p-venda.dt-impl.

END.

FOR EACH tt-saldo-estoq NO-LOCK:
    FIND FIRST tt-alocacao WHERE tt-saldo-estoq.cod-estabel = tt-alocacao.cod-estabel
                             AND tt-saldo-estoq.cod-depos   = tt-alocacao.cod-depos  
                             AND tt-saldo-estoq.it-codigo   = tt-alocacao.it-codigo  
                             AND tt-saldo-estoq.cod-refer   = tt-alocacao.cod-refer  
                             AND tt-saldo-estoq.lote        = tt-alocacao.lote
                             NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-alocacao THEN DO:
        CREATE tt-alocacao.
        ASSIGN tt-alocacao.cod-depos    = tt-saldo-estoq.cod-depos      
               tt-alocacao.cod-refer    = tt-saldo-estoq.cod-refer   
               tt-alocacao.lote         = tt-saldo-estoq.lote        
               tt-alocacao.dt-vali-lote = tt-saldo-estoq.dt-vali-lote
               tt-alocacao.qtidade-atu  = tt-saldo-estoq.qtidade-atu 
               tt-alocacao.qt-aloc-ped  = tt-saldo-estoq.qt-aloc-ped 
               tt-alocacao.qt-alocada   = tt-saldo-estoq.qt-alocada  
               tt-alocacao.qt-aloc-prod = tt-saldo-estoq.qt-aloc-prod
               tt-alocacao.saldo        = (tt-saldo-estoq.qtidade-atu  - tt-saldo-estoq.qt-aloc-ped  - tt-saldo-estoq.qt-aloc-prod - tt-saldo-estoq.qt-alocada)
               tt-alocacao.cod-estabel  = ""
               tt-alocacao.it-codigo    = ""
               tt-alocacao.nr-embarque  = 0
               tt-alocacao.cod-sit-aloc = 0
               tt-alocacao.qt-alocada-2 = 0
               tt-alocacao.qt-embarcada = 0
               tt-alocacao.nr-pedcli    = ""
               tt-alocacao.nome-abrev   = ""
               tt-alocacao.dt-impl-ped  = ?.
    END.
END.

FOR EACH tt-alocacao NO-LOCK:
    PUT tt-alocacao.cod-depos       ";"   
        tt-alocacao.cod-refer       ";"
        tt-alocacao.lote            ";"
        tt-alocacao.dt-vali-lote    ";"
        tt-alocacao.qtidade-atu     ";"
        tt-alocacao.qt-aloc-ped     ";"
        tt-alocacao.qt-alocada      ";"
        tt-alocacao.qt-aloc-prod    ";"
        tt-alocacao.saldo           ";"
        tt-alocacao.cod-estabel     ";"
        tt-alocacao.it-codigo       ";"
        tt-alocacao.nr-embarque     ";"
        tt-alocacao.cod-sit-aloc    ";"
        tt-alocacao.qt-alocada-2    ";"
        tt-alocacao.qt-embarcada    ";"
        tt-alocacao.nr-pedcli       ";"
        tt-alocacao.dt-impl-ped     SKIP.
END.

OUTPUT CLOSE.
