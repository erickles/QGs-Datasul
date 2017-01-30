    DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
    DEFINE BUFFER bf-aprov-pedido FOR es-aprov-pedido.
    DEFINE BUFFER bf-his-follow FOR es-his-follow.

    FOR EACH ws-p-venda WHERE ws-p-venda.cod-tipo-oper = 139 
                        AND YEAR(ws-p-venda.dt-impl) = YEAR(TODAY)
                        AND ws-p-venda.ind-sit-ped <> 17                      
                        NO-LOCK:        

        FIND FIRST es-his-follow WHERE es-his-follow.cod-usuario = "kprezend"
                                   AND es-his-follow.nr-pedcli   = ws-p-venda.nr-pedcli
                                   NO-LOCK NO-ERROR.

        IF AVAIL es-his-follow THEN DO:

            FIND FIRST bf-his-follow WHERE bf-his-follow.cod-usuario = "lsferrei"
                                      AND bf-his-follow.nr-pedcli   = ws-p-venda.nr-pedcli
                                      NO-LOCK NO-ERROR.

            IF NOT AVAIL bf-his-follow THEN DO:
                CREATE bf-his-follow.
                BUFFER-COPY es-his-follow EXCEPT es-his-follow.cod-usuario TO bf-his-follow.
                ASSIGN bf-his-follow.cod-usuario = "lsferrei".
            END.           

        END.
        /*
        FIND FIRST es-aprov-pedido WHERE es-aprov-pedido.nr-pedcli = ws-p-venda.nr-pedcli 
                                   AND es-aprov-pedido.cod-usuario = "kprezend"
                                   NO-LOCK NO-ERROR.
        IF AVAIL es-aprov-pedido THEN DO:
    
            CREATE bf-aprov-pedido.
            BUFFER-COPY es-aprov-pedido EXCEPT es-aprov-pedido.cod-usuario TO bf-aprov-pedido.
            ASSIGN bf-aprov-pedido.cod-usuario = "lsferrei".
    
        END.
        */

        iCont = iCont + 1.            

    END.

    MESSAGE iCont
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
