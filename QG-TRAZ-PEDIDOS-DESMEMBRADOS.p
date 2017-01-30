DEFINE VARIABLE numero-pedido AS CHAR NO-UNDO FORMAT "X(15)".
DEFINE VARIABLE nr-ped        AS CHAR NO-UNDO FORMAT "X(15)".

DEFINE BUFFER bf-p-venda FOR ws-p-venda.
DEFINE BUFFER bf2-p-venda FOR ws-p-venda.

DEFINE TEMP-TABLE tt-pedidos
    FIELD nr-pedido     AS CHAR FORMAT "X(12)"
    FIELD nome-abrev    AS CHAR FORMAT "X(12)".

UPDATE numero-pedido.
    
IF INDEX(numero-pedido,"/") > 0 THEN
    nr-ped = SUBSTR(numero-pedido,1,inte(INDEX(numero-pedido,"/") - 1)).
ELSE 
    nr-ped = numero-pedido.

FOR EACH ws-p-venda WHERE ws-p-venda.nr-pedcli = nr-ped.

    CREATE tt-pedidos.
    ASSIGN tt-pedidos.nr-pedido     = ws-p-venda.nr-pedcli
           tt-pedidos.nome-abrev    = .

    FOR EACH bf-p-venda WHERE bf-p-venda.nr-pedrep  = ws-p-venda.nr-pedcli 
                          AND bf-p-venda.nr-pedcli  BEGINS nr-ped
/*                           AND bf-p-venda.nome-abrev = ws-p-venda.nome-abrev */
                          NO-LOCK.
        
        CREATE tt-pedidos.
        ASSIGN tt-pedidos.nr-pedido = bf-p-venda.nr-pedcli.

        FOR EACH bf2-p-venda WHERE bf2-p-venda.nr-pedrep  = bf-p-venda.nr-pedcli 
                               AND bf2-p-venda.nr-pedcli  BEGINS nr-ped
/*                                AND bf2-p-venda.nome-abrev = bf-p-venda.nome-abrev */
                               NO-LOCK.
        
            CREATE tt-pedidos.
            ASSIGN tt-pedidos.nr-pedido = bf2-p-venda.nr-pedcli.
          
        END.
          
    END.
END.

FOR EACH tt-pedidos.
    DISP tt-pedidos.nr-pedido.
END.
