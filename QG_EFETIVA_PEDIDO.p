DEFINE VARIABLE r-rowid                 AS ROWID.
DEFINE VARIABLE h_espd1999ef            AS HANDLE   NO-UNDO.
DEFINE VARIABLE h_espd1999b             AS HANDLE   NO-UNDO.
DEFINE VARIABLE h_espd1999fi            AS HANDLE   NO-UNDO.
DEFINE VARIABLE h_espd1015u             AS HANDLE   NO-UNDO.

DEFINE VARIABLE c-nr-pedcli AS CHARACTER FORMAT "X(12)" LABEL "Informe o numero do pedido" NO-UNDO.

/* Implantacao de Pedidos No EMS204 ( 2 - Efetivado ) */
IF NOT VALID-HANDLE(h_espd1999ef) OR 
    h_espd1999ef:TYPE      <> "PROCEDURE":U OR 
    h_espd1999ef:FILE-NAME <> "esp/espd1999ef.p":U THEN 
    RUN esp/espd1999ef.p PERSISTENT SET h_espd1999ef.

/* Valida Regras Comerciais ( 4 - Implatado EMS ) */
IF NOT VALID-HANDLE(h_espd1999b) OR 
    h_espd1999b:TYPE      <> "PROCEDURE":U OR 
    h_espd1999b:FILE-NAME <> "esp/espd1999b.p":U THEN 
    RUN esp/espd1999b.p PERSISTENT SET h_espd1999b.

/* Valida Regras Comerciais ( 8 - Implatado EMS ) */
IF NOT VALID-HANDLE(h_espd1999fi) OR 
    h_espd1999fi:TYPE      <> "PROCEDURE":U OR 
    h_espd1999fi:FILE-NAME <> "esp/espd1999fi.p":U THEN 
    RUN esp/espd1999fi.p PERSISTENT SET h_espd1999fi.

/* Aprovacao de Pedidos */
IF NOT VALID-HANDLE(h_espd1015u) OR
    h_espd1015u:TYPE <> "PROCEDURE":U OR
    h_espd1015u:FILE-NAME <> "esp\espd1015u.p":U THEN DO:
    RUN esp\espd1015u.p PERSISTENT SET h_espd1015u.
END.

UPDATE c-nr-pedcli.

FIND FIRST ws-p-venda WHERE nr-pedcli = c-nr-pedcli.

ASSIGN ws-p-venda.ind-sit-ped = 18.

RUN pi-EfetivaPedido(ROWID(ws-p-venda)).

PROCEDURE pi-EfetivaPedido:

    DEFINE INPUT  PARAMETER pr-rowid AS ROWID      NO-UNDO.
    
    DO TRANS:
       FIND ws-p-venda WHERE ROWID(ws-p-venda) = pr-rowid EXCLUSIVE-LOCK NO-ERROR.
       ASSIGN ws-p-venda.nome-prog   = 'CLIENT'
              ws-p-venda.ind-sit-ped = 2 /* Implantado */.
    END.

    FIND CURRENT ws-p-venda NO-ERROR.
    
    /* Inicia Criacao do Pedido de Venda */
    IF VALID-HANDLE(h_espd1999ef) THEN DO:
        
        /*RUN pi-acompanhar IN h-acomp (INPUT "Atualizando pedido !!!").*/
        RUN efetivaPedido IN h_espd1999ef (INPUT pr-rowid).       
        
        IF ws-p-venda.ind-sit-ped < 4 THEN DO:
            
            ASSIGN ws-p-venda.nome-prog   = 'CLIENT'
                   ws-p-venda.ind-sit-ped = 2 /* Implantado */.

            RUN efetivaPedido IN h_espd1999ef (INPUT pr-rowid).       
            
        END.

    END.
    
    blk_aprova:
    DO TRANSACTION ON ERROR UNDO, LEAVE
                   ON STOP  UNDO, LEAVE:
        
        Atualiza:
        REPEAT:
            
            FIND ws-p-venda WHERE 
                 ROWID(ws-p-venda) = pr-rowid EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAIL ws-p-venda THEN LEAVE.            
            
            CASE ws-p-venda.ind-sit-ped :
                
                WHEN 4 THEN DO:
                    
                    ASSIGN ws-p-venda.nome-prog   = 'CLIENT'.
                    
                    IF VALID-HANDLE(h_espd1999b) THEN DO:
                       RUN validaRegraComercial IN h_espd1999b (INPUT pr-rowid).
                    END.   
    
                END.
                
                WHEN 8 THEN DO:
                    
                    ASSIGN ws-p-venda.nome-prog   = 'CLIENT'.
                    /*RUN pi-acompanhar IN h-acomp (INPUT "Inciando validacoes Financeiras : " + ws-p-venda.nr-pedcli + " !!!").*/
                    IF VALID-HANDLE(h_espd1999fi) THEN DO:
                       /* Verifica Pedidos Liberados Comercialmente ( 8 - Liberados Comercial ) */
                       RUN validaRegraFinanceira IN h_espd1999fi (INPUT pr-rowid).                   
                    END.    
    
                END.
                
                WHEN 10 THEN DO:
                    
                    ASSIGN ws-p-venda.nome-prog   = 'CLIENT'.                    
                    IF VALID-HANDLE(h_espd1999fi) THEN DO:
                       RUN aprovaFinanceiro IN h_espd1999fi (INPUT pr-rowid).      
                    END.
                END.
    
                OTHERWISE DO:
                    LEAVE atualiza.
                END.
    
            END CASE.
        
        END.

        /*RUN pi-acompanhar IN h-acomp (INPUT "Finalizando Atualizacao : " + ws-p-venda.nr-pedcli + "  !!!").*/
        
        FIND ws-p-venda WHERE ROWID(ws-p-venda) = pr-rowid EXCLUSIVE-LOCK NO-ERROR.
        ASSIGN ws-p-venda.nome-prog = ''.
        
        IF ws-p-venda.ind-sit-ped = 2  OR 
           ws-p-venda.ind-sit-ped = 4  OR
           ws-p-venda.ind-sit-ped = 8  OR
           ws-p-venda.ind-sit-ped = 10 THEN DO:
          
           ws-p-venda.ind-sit-ped = 18. /*  Manutencao */
    
           MESSAGE "Pedido de venda " + ws-p-venda.nr-pedcli + " nao foi processado por completo."      SKIP
                   "Pedido de venda " + ws-p-venda.nr-pedcli + " ficara com o status de em Manutencao"  SKIP 
                   "e devera ser efetivado para seguir fluxo normal."
                   VIEW-AS ALERT-BOX.

           RETURN NO-APPLY.

        END.
        
        IF ws-p-venda.ind-sit-ped = 5 OR
           ws-p-venda.ind-sit-ped = 9 THEN DO:
    
           IF NOT CAN-FIND(FIRST es-aprov-pedido OF ws-p-venda) THEN DO:
    
             ws-p-venda.ind-sit-ped = 18. /*  Manutencao */
    
             MESSAGE "Pedido de venda " + ws-p-venda.nr-pedcli + " nao foi processado por completo."     SKIP
                     "Pedido de venda " + ws-p-venda.nr-pedcli + " ficara com o status de em Manutencao" SKIP 
                     "e devera ser efetivado para seguir fluxo normal."
                     VIEW-AS ALERT-BOX.
             RETURN NO-APPLY.
           END.
    
         END.
     
    END.

    RETURN "OK":U.

END PROCEDURE.
