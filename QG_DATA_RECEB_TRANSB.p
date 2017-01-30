FIND FIRST es-nota-fiscal WHERE es-nota-fiscal.nr-nota-fis = "0020978"
                            AND es-nota-fiscal.cod-estabel = "12"
                            AND es-nota-fiscal.serie       = "4"
                            NO-LOCK NO-ERROR.
IF AVAIL es-nota-fiscal THEN DO:

    FIND FIRST nota-fiscal OF es-nota-fiscal
         WHERE nota-fiscal.dt-cancela = ? NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:

        FOR FIRST es-transbordo-ped NO-LOCK
            WHERE es-transbordo-ped.nr-pedcli   = nota-fiscal.nr-pedcli 
              AND es-transbordo-ped.nr-embarque = nota-fiscal.nr-embarque
              AND es-transbordo-ped.dt-entrega <> ?:
        END.
        IF NOT AVAIL es-transbordo-ped THEN DO:
           /* Nao tem data de entrega */
           FIND FIRST es-transbordo-ped NO-LOCK
                WHERE es-transbordo-ped.nr-pedcli   = nota-fiscal.nr-pedcli 
                  AND es-transbordo-ped.nr-embarque = nota-fiscal.nr-embarque NO-ERROR.
           IF AVAIL es-transbordo-ped THEN DO:
               /* Tem Transbordo */
               /*ASSIGN ttes-nota-fiscal.data-recebto = ?.*/
               MESSAGE "1 FAIL" 
                   VIEW-AS ALERT-BOX INFO BUTTONS OK.

               /* Trata Transbordo Antigo */
               FIND es-transbordo
                   WHERE es-transbordo.nr-sequencia = es-transbordo-ped.nr-sequencia
                     AND es-transbordo.nr-linha     = 0 NO-ERROR.
               IF AVAIL es-transbordo AND es-transbordo.dt-entrega <> ? THEN DO:
                  /*ASSIGN ttes-nota-fiscal.data-recebto = es-transbordo.dt-entrega.*/
                   ASSIGN es-transbordo.dt-entrega = 05/08/2012.
                   MESSAGE "2 " es-transbordo.dt-entrega
                           VIEW-AS ALERT-BOX INFO BUTTONS OK.
               END.

           END.

        END.
        ELSE DO:

            FOR FIRST es-transbordo-ped NO-LOCK
                WHERE es-transbordo-ped.nr-pedcli   = nota-fiscal.nr-pedcli 
                  AND es-transbordo-ped.nr-embarque = nota-fiscal.nr-embarque
                  AND es-transbordo-ped.dt-entrega  = ?:
            END.
            IF NOT AVAIL es-transbordo-ped THEN DO:
                /* Tem todas Entregas do pedido*/
                FOR EACH es-transbordo-ped NO-LOCK
                   WHERE es-transbordo-ped.nr-pedcli   = nota-fiscal.nr-pedcli 
                     AND es-transbordo-ped.nr-embarque = nota-fiscal.nr-embarque
                     AND es-transbordo-ped.dt-entrega <> ?
                     BY es-transbordo-ped.dt-entrega DESCENDING:                    
                  /*ASSIGN ttes-nota-fiscal.data-recebto = es-transbordo-ped.dt-entrega.*/
                    MESSAGE "3 " es-transbordo-ped.dt-entrega
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  LEAVE.   
                END.
            END.

        END.

    END.
END.
