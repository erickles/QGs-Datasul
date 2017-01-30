FOR EACH es-aprov-pedido NO-LOCK
       WHERE es-aprov-pedido.cod-usuario = "slcarraz"
         AND es-aprov-pedido.nr-pedcli = "3192216",
       FIRST ws-p-venda FIELDS(nome-abrev nr-pedcli ind-sit-ped      no-ab-reppri cod-estabel dt-entrega cod-tipo-oper tp-frete tp-carga 
                               dt-implant micro-reg seq-carga-compos cod-cond-pag log-conferido)
             WHERE ws-p-venda.nr-pedcli = es-aprov-pedido.nr-pedcli NO-LOCK:
       
/*         IF ptg-comercial  = NO AND es-aprov-pedido.ind-tp-follow = 1 THEN NEXT. */
/*         IF ptg-logistica  = NO AND es-aprov-pedido.ind-tp-follow = 2 THEN NEXT. */
/*         IF ptg-financeiro = NO AND es-aprov-pedido.ind-tp-follow = 3 THEN NEXT. */
/*         IF ptg-outros     = NO AND es-aprov-pedido.ind-tp-follow = 4 THEN NEXT. */
             
        FOR FIRST emitente FIELDS(nome-abrev cod-emitente) WHERE
                  emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK.
        END.

        FIND es-emitente-dis WHERE
             es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

        FOR FIRST ped-venda FIELDS(nome-abrev nr-pedcli tp-pedido vl-tot-ped) NO-LOCK
            WHERE ped-venda.nome-abrev = ws-p-venda.nome-abrev
              AND ped-venda.nr-pedcli  = ws-p-venda.nr-pedcli.
        END.

        
        IF RETURN-VALUE = 'NOK' THEN NEXT.
            
        /* Verifica se possui bloqueio sem acompanhamento */
        FOR EACH es-his-follow NO-LOCK 
           WHERE es-his-follow.nome-abrev = ws-p-venda.nome-abrev
             AND es-his-follow.nr-pedcli  = ws-p-venda.nr-pedcli,
           FIRST es-follow-up NO-LOCK 
             WHERE es-follow-up.cdn-follow-up = es-his-follow.cdn-follow-up
               AND es-follow-up.log-acomp     = FALSE
            BREAK BY es-his-follow.cdn-follow-up:
           IF LAST-OF(es-his-follow.cdn-follow-up) AND 
              NOT es-his-follow.log-encerra-follow THEN NEXT.
        END.

        FIND FIRST es-his-follow NO-LOCK
            WHERE  es-his-follow.nome-abrev    = es-aprov-pedido.nome-abrev 
              AND  es-his-follow.nr-pedcli     = es-aprov-pedido.nr-pedcli  
              AND  es-his-follow.cdn-follow-up = es-aprov-pedido.cdn-follow-up
              NO-ERROR.

/*         IF AVAIL es-his-follow THEN                                                                    */
/*            ASSIGN mot-bloq-cred = fn-motivo-bloq(INPUT SUBSTRING(es-his-follow.dsl-follow-up,27,100)). */
/*         ELSE                                                                                           */
/*            ASSIGN mot-bloq-cred = "".                                                                  */
        
        FIND LAST es-his-follow NO-LOCK
            WHERE es-his-follow.nome-abrev    = es-aprov-pedido.nome-abrev 
              AND es-his-follow.nr-pedcli     = es-aprov-pedido.nr-pedcli  
              AND es-his-follow.cdn-follow-up = es-aprov-pedido.cdn-follow-up
              NO-ERROR.

/*         IF ptg-ped-usuar = YES AND LOOKUP(es-aprov-pedido.cod-usuario,es-his-follow.usuarios) = 0 THEN NEXT. */
    
/*         IF ptg-ped-and   = NO                     AND        */
/*            es-his-follow.cod-usuario <> 'sistema' AND        */
/*            es-his-follow.cod-usuario <> ''        THEN NEXT. */
        
/*         IF ptg-ped-aber  = NO                     AND        */
/*           (es-his-follow.cod-usuario  = 'sistema' OR         */
/*            es-his-follow.cod-usuario  = '')       THEN NEXT. */

    MESSAGE "OK"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.
