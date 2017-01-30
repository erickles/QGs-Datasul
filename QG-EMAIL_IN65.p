DEFINE VARIABLE c-itens         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-destinatario  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-remetente     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-assunto       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-mensagem      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-copia         AS CHARACTER   NO-UNDO.

{includes/varsituac.i}

FIND FIRST ws-p-venda WHERE nr-pedcli = "IN-0001" NO-LOCK NO-ERROR.

IF ws-p-venda.ind-sit-ped = 05 OR
   ws-p-venda.ind-sit-ped = 09 OR
   ws-p-venda.ind-sit-ped = 12 THEN DO:        

        FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
            FIND FIRST ws-in65 WHERE ws-in65.it-codigo  = ws-p-item.it-codigo 
                                 AND ws-in65.nome-abrev = ws-p-item.nome-abrev
                                 AND ws-in65.nr-pedcli  = ws-p-item.nr-pedcli
                                 NO-LOCK NO-ERROR.

            IF AVAIL ws-in65 THEN DO:
                FIND FIRST ITEM WHERE ITEM.it-codigo = ws-p-item.it-codigo  NO-LOCK NO-ERROR.
                ASSIGN c-itens = ws-p-item.it-codigo + " - " + ITEM.desc-item + CHR(10) + 
                                 "Qtd: " + STRING(ws-p-item.qt-pedida,"->>>,>>>,>>9.9999") + CHR(10).
            END.
        END.                    

        FIND FIRST ws-in65 WHERE ws-in65.nr-pedcli  = ws-p-venda.nr-pedcli
                             AND ws-in65.nome-abrev = ws-p-venda.nome-abrev
                             NO-LOCK NO-ERROR.

        IF AVAIL ws-in65 THEN DO:

            FIND FIRST loc-entr WHERE loc-entr.cod-entrega = ws-p-venda.cod-entrega NO-LOCK NO-ERROR.
            FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev   NO-LOCK NO-ERROR.

            c-destinatario = "marcelo.goncalves@tortuga.com.br;juliano.lima@tortuga.com.br;marcelo.paulo@tortuga.com.br;
                              sergio.batista@tortuga.com.br;evaldo.rodrigues@tortuga.com.br;israel.moraes@tortuga.com.br;
                              rodrigo.garcia@tortuga.com.br;marcos.pereira@tortuga.com.br".

            IF ws-p-venda.ind-sit-ped = 12 THEN
                ASSIGN c-destinatario = c-destinatario + ";pcp.mairinque@tortuga.com.br".

            FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = ws-p-venda.user-impl NO-LOCK NO-ERROR.

            ASSIGN c-remetente    = IF AVAIL usuar_mestre THEN usuar_mestre.cod_e_mail_local ELSE "sac@tortuga.com.br"
                   /*c-destinatario = "erick.souza@tortuga.com.br"*/
                   c-assunto      = "Pedido com item IN65 liberado: " + ws-p-venda.nr-pedcli
                   c-mensagem     = "Prezados!" + CHR(10) + CHR(10) +
                                    "Foi liberado pelas †reas Comercial / Financeiro pedido que contem item IN65." + CHR(10) +
                                    "O mesmo j† encontra-se dispon°vel para Produá∆o. Favor atentar para Formaá∆o de carga / Faturamento assim que a receita original do veterin†rio estiver em m∆os da †rea PCP." + CHR(10) + CHR(10) +
                                    "Dados do Pedido: " + CHR(10) +
                                    "Cliente: " + STRING(emitente.cod-emitente) + " - " + STRING(emitente.nome-emit) +
                                    CHR(10) +
                                    "Dt. Implantacao Pedido: " + STRING(ws-p-venda.dt-implant) +
                                    CHR(10) +
                                    "Cidade de Entrega: " + loc-entr.cidade + "/" + loc-entr.estado +
                                    CHR(10) +
                                    "Nr. Pedido: " + ws-p-venda.nr-pedcli + CHR(10) +
                                    "Status do Pedido: " + cSituacao[ws-p-venda.ind-sit-ped] + CHR(10) +
                                    CHR(10) + CHR(10) +
                                    "Item(s):" + CHR(10) +
                                    c-itens
                   c-copia        = "".

            MESSAGE c-mensagem
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

/*             RUN esp\wsmail-sac2.p(c-remetente,    */
/*                                   c-destinatario, */
/*                                   c-assunto,      */
/*                                   c-mensagem,     */
/*                                   c-copia).       */
        END.
    END.
