DEFINE VARIABLE qtd-itens AS INTEGER     NO-UNDO.

IF TODAY >= 09/21/2010 AND TODAY <= 11/30/2010 THEN DO:
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = "0104-11" NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda             AND
       ws-p-venda.nr-consulta = 0   THEN DO:
        ASSIGN qtd-itens = 0.
        MESSAGE SUBSTR(ws-p-venda.char-1,501,12)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        FIND FIRST ws-p-item OF ws-p-venda WHERE ws-p-item.it-codigo = "40000564" NO-LOCK NO-ERROR.
        IF AVAIL ws-p-item THEN DO:        
            FOR EACH ws-p-item OF ws-p-venda:
                IF ws-p-item.it-codigo = "40002044" THEN DO:
                    qtd-itens = qtd-itens + 1.
                END.
    
                IF ws-p-item.it-codigo = "40008277" THEN DO:
                    qtd-itens = qtd-itens + ws-p-item.qt-pedida.
                END.
    
                IF ws-p-item.it-codigo = "40008290" THEN DO:
                    qtd-itens = qtd-itens + ws-p-item.qt-pedida.
                END.
    
                IF ws-p-item.it-codigo = "40012669" THEN DO:
                    qtd-itens = qtd-itens + ws-p-item.qt-pedida.
                END.            
        
            END.
        END.
        IF qtd-itens >= 120 THEN
            MESSAGE "Tormicina recebera desconto de 7%"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

        IF qtd-itens >= 80  AND
           qtd-itens < 120   THEN
            MESSAGE "Tormicina recebera desconto de 5%"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
        IF qtd-itens >= 40  AND
           qtd-itens < 80   THEN
            MESSAGE "Tormicina recebera desconto de 3%"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

    END.
END.
