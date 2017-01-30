FOR EACH estabelec WHERE estabelec.estado = "MG",
                    EACH es-busca-preco WHERE estabelec.estado = es-busca-preco.uf-destino
                                          AND es-busca-preco.nr-tabpre BEGINS "TRA"
                                          AND es-busca-preco.cod-estabel = estabelec.cod-estabel
                                          AND es-busca-preco.cod-tipo-oper = 7:

    IF AVAIL es-busca-preco THEN DO:

        FIND FIRST preco-item WHERE preco-item.it-codigo = "40004697"
                                AND preco-item.nr-tabpre = es-busca-preco.nr-tabpre
                                NO-LOCK NO-ERROR.

        IF AVAIL preco-item THEN
            MESSAGE preco-item.preco-venda
                    preco-item.nr-tabpre
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.            

    END.        
END.
