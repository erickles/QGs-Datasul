/* Campanha Adeus Parasitas */
  IF TODAY >= 09/21/2010 AND TODAY <= 11/30/2010    AND
     AVAIL ws-p-venda                               THEN DO:
        
        /* Primeiro, verifica se ha a Tormicina no pedido "B" */
        FIND FIRST ws-p-item OF ws-p-venda WHERE ws-p-item.it-codigo = "40000564" NO-LOCK NO-ERROR.
    
        /* Se nao acha, calcula tudo no pedido informado ... */
        IF NOT AVAIL ws-p-item THEN DO:
            
            IF ws-p-venda.nr-consulta = 0   THEN DO:

                FIND FIRST bf-p-venda WHERE bf-p-venda.nr-pedcli = ws-p-venda.nr-pedcli NO-ERROR.
                IF AVAIL bf-p-venda THEN
                    ASSIGN bf-p-venda.cod-cond-pag          = 752
                           bf-p-venda.int-1                 = 50020
                           OVERLAY(bf-p-venda.char-1,500,1) = "S"
                           bf-p-venda.tp-carga              = 2.
    
                ASSIGN qtd-itens = 0.
                
                FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
                    IF ws-p-item.it-codigo = "40002044" THEN DO:
                        qtd-itens = qtd-itens + ws-p-item.qt-pedida.
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
        END.
    
        /* Se acha, calcula tudo no proprio pedido... */
        IF AVAIL ws-p-item THEN DO:
            
            FIND FIRST bf-p-venda WHERE bf-p-venda.nr-pedcli = ws-p-venda.nr-pedcli NO-ERROR.
            IF AVAIL bf-p-venda THEN ASSIGN OVERLAY(bf-p-venda.char-1,500,1)    = "S".
        
            IF ws-p-venda.nr-consulta = 0   THEN DO:

                ASSIGN qtd-itens = 0.

                FIND FIRST bf-p-venda WHERE bf-p-venda.nr-pedcli = SUBSTRING(ws-p-venda.char-1,501,12) NO-ERROR.
                IF AVAIL bf-p-venda THEN DO:
                    
                    FOR EACH ws-p-item OF bf-p-venda NO-LOCK:
                        IF ws-p-item.it-codigo = "40002044" THEN DO:
                            qtd-itens = qtd-itens + ws-p-item.qt-pedida.
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
                ELSE DO:
                    
                    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
                        IF ws-p-item.it-codigo = "40002044" THEN DO:
                            qtd-itens = qtd-itens + ws-p-item.qt-pedida.
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
            END.            
        END.

        /* Faz as valida‡äes de desconto... */
        IF qtd-itens >= 120 THEN DO:
            FIND FIRST bf-p-item OF ws-p-venda WHERE bf-p-item.it-codigo = "40000564" NO-LOCK NO-ERROR.
            IF AVAIL bf-p-item THEN DO:
            
                FIND FIRST ws-p-desc OF bf-p-item WHERE ws-p-desc.cod-regra-comerc = "ADICIONAL" NO-ERROR.
                IF AVAIL ws-p-desc THEN DO:                    
                        ASSIGN  ws-p-desc.desc-aplicado = 7
                                ws-p-desc.desc-sugerido = 7.

                        FIND FIRST bf-p-venda WHERE bf-p-venda.nr-pedcli = ws-p-venda.nr-pedcli NO-ERROR.
                        IF AVAIL bf-p-venda THEN 
                            ASSIGN bf-p-venda.int-1     = 50020
                                   bf-p-venda.tp-carga  = 2.                    
                END.
                        
            END.
        END.
        
        IF qtd-itens >= 80  AND
            qtd-itens < 120   THEN DO:
        
            FIND FIRST bf-p-item OF ws-p-venda WHERE bf-p-item.it-codigo = "40000564" NO-LOCK NO-ERROR.
            IF AVAIL bf-p-item THEN DO:
            
                FIND FIRST ws-p-desc OF bf-p-item WHERE ws-p-desc.cod-regra-comerc = "ADICIONAL" NO-ERROR.
                IF AVAIL ws-p-desc THEN DO:                    
                    
                    ASSIGN  ws-p-desc.desc-aplicado = 5
                            ws-p-desc.desc-sugerido = 5.

                    FIND FIRST bf-p-venda WHERE bf-p-venda.nr-pedcli = ws-p-venda.nr-pedcli NO-ERROR.
                    IF AVAIL bf-p-venda THEN 
                        ASSIGN bf-p-venda.int-1     = 50020
                               bf-p-venda.tp-carga  = 2.                    
                END.                        
            END.            
        END.            
        
        IF qtd-itens >= 40  AND
            qtd-itens < 80   THEN DO:
        
            FIND FIRST ws-p-desc OF ws-p-item WHERE ws-p-desc.cod-regra-comerc = "ADICIONAL" NO-ERROR.
            IF AVAIL ws-p-desc THEN DO:                
                
                ASSIGN  ws-p-desc.desc-aplicado = 3
                        ws-p-desc.desc-sugerido = 3.

                FIND FIRST bf-p-venda WHERE bf-p-venda.nr-pedcli = ws-p-venda.nr-pedcli NO-ERROR.
                IF AVAIL bf-p-venda THEN 
                    ASSIGN bf-p-venda.int-1     = 50020
                           bf-p-venda.tp-carga  = 2.                
            END.               
        END.
        /* ... */
    END.
