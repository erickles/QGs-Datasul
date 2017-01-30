FOR EACH loc-mr WHERE loc-mr.nome-ab-reg  = "MARANHAO 01"
                  AND loc-mr.nome-mic-reg = "MA0102"
                  NO-LOCK:

    FOR EACH loc-entr NO-LOCK WHERE loc-entr.cidade = loc-mr.cidade  
                                AND loc-entr.estado = loc-mr.estado 
                                AND loc-entr.pais   = loc-mr.pais:

        FOR EACH ws-p-venda NO-LOCK WHERE ws-p-venda.nome-abrev = loc-entr.nome-abrev
                                      AND ws-p-venda.cod-entrega = loc-entr.cod-entrega
                                      AND ws-p-venda.nome-ab-reg = "MARANHAO 01"
                                      AND ws-p-venda.micro-reg   = "MA0102":
            
            FIND ped-venda NO-LOCK WHERE ped-venda.nome-abrev = ws-p-venda.nome-abrev
                                     AND ped-venda.nr-pedcli  = ws-p-venda.nr-pedcli NO-ERROR.
        
            IF AVAIL ped-venda THEN DO:
                /* FBL - 10/04/04 */
                IF ped-venda.cidade <>  loc-mr.cidade THEN 
                    MESSAGE "Pedido " + ws-p-venda.nr-pedcli + " deu NEXT na cidade"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.

                IF ped-venda.estado <>  loc-mr.estado THEN
                    MESSAGE "Pedido " + ws-p-venda.nr-pedcli + " deu NEXT no estado"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.

                IF ped-venda.pais   <>  loc-mr.pais   THEN
                    MESSAGE "Pedido " + ws-p-venda.nr-pedcli + " deu NEXT no pais"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    
            END.

        END.

    END.

END.
