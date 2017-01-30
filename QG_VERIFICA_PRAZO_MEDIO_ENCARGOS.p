DEFINE VARIABLE dt-parcela-ini  AS DATE         NO-UNDO.
DEFINE VARIABLE dt-parcela-fim  AS DATE         NO-UNDO.
DEFINE VARIABLE nr-pedido       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE de-encargo      AS DECIMAL      NO-UNDO.
DEFINE VARIABLE idx             AS INTEGER      NO-UNDO.
DEFINE VARIABLE prazo-medio     AS INTEGER     NO-UNDO.

UPDATE nr-pedido.

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = nr-pedido NO-LOCK NO-ERROR.

IF AVAIL ws-p-venda THEN DO:

    FIND FIRST ws-cond-ped OF ws-p-venda WHERE ws-cond-ped.nr-pedcli = ws-p-venda.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-cond-ped THEN DO:
        IF ws-cond-ped.nr-dias-venc <> 0 THEN DO:
            FOR EACH ws-cond-ped OF ws-p-venda WHERE ws-cond-ped.nr-pedcli = ws-p-venda.nr-pedcli
                            NO-LOCK BY ws-cond-ped.nr-dias-venc DESC:

                MESSAGE "Pedido tem prazo medio de " + STRING(ws-cond-ped.nr-dias-venc) + " dias."  SKIP
                        "Encargo original: " + STRING(ws-p-venda.dec-2) + "%"                       SKIP
                        "Encargo aplicado: " + STRING(ws-p-venda.nr-tab-finan - 900) + "," + STRING(ws-p-venda.nr-ind-finan - 1) + "%"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                IF  ws-cond-ped.nr-dias-venc > 120                      AND
                    DEC(STRING(ws-p-venda.nr-tab-finan - 900) + "." +
                        STRING(ws-p-venda.nr-ind-finan - 1)) < 2.4      AND
                    ws-p-venda.nr-consulta = 0                          THEN DO:

                    MESSAGE "Pedidos com prazo meio acima de 120 dias sem consulta, os encargos permitidos sÆo apenas a partir de 2,4%"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.

                END.

                LEAVE.
        
            END.
        END.
        ELSE DO:
            FOR EACH ws-cond-ped OF ws-p-venda WHERE ws-cond-ped.nr-pedcli = ws-p-venda.nr-pedcli
                            NO-LOCK BREAK BY ws-cond-ped.nr-pedcli:

                IF FIRST-OF(ws-cond-ped.nr-pedcli) THEN
                    ASSIGN dt-parcela-ini = ws-cond-ped.data-pagto.

                IF LAST-OF(ws-cond-ped.nr-pedcli) THEN DO:

                    ASSIGN dt-parcela-fim = ws-cond-ped.data-pagto.

                    MESSAGE "Pedido tem prazo medio de " + STRING(dt-parcela-fim - dt-parcela-ini) + " dias."   SKIP
                            "Encargo original: " + STRING(ws-p-venda.dec-2) + "%"                               SKIP
                            "Encargo aplicado: " + STRING(ws-p-venda.nr-tab-finan - 900) + "," + STRING(ws-p-venda.nr-ind-finan - 1) + "%"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.

                    IF  (dt-parcela-fim - dt-parcela-ini) > 120             AND
                        DEC(STRING(ws-p-venda.nr-tab-finan - 900) + "." +
                            STRING(ws-p-venda.nr-ind-finan - 1)) < 2.4      AND
                        ws-p-venda.nr-consulta = 0                          THEN DO:
                        MESSAGE "Pedidos com prazo meio acima de 120 dias sem consulta, os encargos permitidos sÆo apenas a partir de 2,4%"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    END.
                END.                                                    
        
            END.            
        END.
    END.
    ELSE DO:
        FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = ws-p-venda.cod-cond-pag NO-LOCK NO-ERROR.
        IF AVAIL cond-pagto THEN DO:

            FIND FIRST tab-finan WHERE tab-finan.nr-tab-finan = cond-pagto.nr-tab-finan NO-LOCK NO-ERROR.
            ASSIGN de-encargo = tab-finan.tab-ind-fin[cond-pagto.nr-ind-finan].

            DO idx = 1 TO 12:
                IF cond-pagto.prazos[idx] <> 0 THEN
                    ASSIGN prazo-medio = cond-pagto.prazos[idx].
            END.

            MESSAGE "Pedido tem prazo medio de " + STRING(prazo-medio) + " dias."   SKIP
                    "Encargo: " + STRING(de-encargo) + "%"                          SKIP                    
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

            IF prazo-medio > 120    AND
               de-encargo < 2.4     AND 
               ws-p-venda.nr-consulta = 0 THEN DO:
                MESSAGE "Pedidos com prazo meio acima de 120 dias sem consulta, os encargos permitidos sÆo apenas a partir de 2,4%"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
                                  
        END.

    END.
END.
