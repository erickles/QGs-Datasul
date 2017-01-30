DEFINE VARIABLE c-path              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-path-corpo-email  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-linha             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-email             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cParamSaida         AS CHARACTER NO-UNDO FORMAT "x(50)" EXTENT 5.
DEFINE VARIABLE iAmbiente           AS INTEGER     NO-UNDO INITIAL 2.

{include/i-freeac.i}

FOR EACH ws-p-venda WHERE ws-p-venda.nr-pedcli = "9512c0008"
                       NO-LOCK:

    ASSIGN c-path = SEARCH("esp/doc/pedido_venda_cliente_tortuga.html").
    
    IF c-path = ? THEN
        RETURN "NOK".
    
    ASSIGN c-path-corpo-email = SEARCH("esp/doc/pedido_venda_corpo_email_tortuga.html").
    
    IF c-path-corpo-email = ? THEN
        RETURN "NOK".
    
    INPUT FROM VALUE(c-path) NO-CONVERT.
    REPEAT:
        IMPORT UNFORMATTED c-linha.
        ASSIGN c-email = fn-free-accent(c-email) + CHR(10) + fn-free-accent(c-linha).
    END.
    INPUT CLOSE.
    
    RUN pi-SubstParamPedido.
    IF RETURN-VALUE = "NOK" THEN DO:
        RETURN "NOK".
    END.
    /**/
    
    OUTPUT TO VALUE (SESSION:TEMP-DIRECTORY + "PEDIDO_VENDA_" + REPLACE(ws-p-venda.nr-pedcli,"/","-") + ".html") NO-CONVERT.
    PUT UNFORMATTED
        c-email.
    OUTPUT CLOSE.

END.

PROCEDURE pi-SubstParamPedido:


    /*------------------------------------------------------------------------------
      Purpose:     
      Parameters:  <none>
      Notes:       
    ------------------------------------------------------------------------------*/
    DEFINE VARIABLE iQtdItens           AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE iItemCodigo         AS INTEGER      EXTENT 40   NO-UNDO.
    DEFINE VARIABLE cItemDescricao      AS CHARACTER    EXTENT 40   NO-UNDO.
    DEFINE VARIABLE cItemUnidade        AS CHARACTER    EXTENT 40   NO-UNDO.
    DEFINE VARIABLE iQtdadePedida       AS INTEGER      EXTENT 40   NO-UNDO.
    DEFINE VARIABLE iQtdadeEmbalagem    AS INTEGER      EXTENT 40   NO-UNDO.
    DEFINE VARIABLE dcPrecoLiquido      AS DECIMAL      FORMAT ">,>>>,>>>,>>9.99" EXTENT 40 NO-UNDO.
    DEFINE VARIABLE dcValorTotalPedido  AS DECIMAL      FORMAT ">,>>>,>>>,>>9.99" NO-UNDO.
    DEFINE VARIABLE iContador           AS INTEGER      NO-UNDO.
    DEFINE VARIABLE cLocalAssinatura    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cdesc-cond-pag      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cDataHorario        AS CHARACTER    NO-UNDO.

    cLocalAssinatura = "".

    CASE iAmbiente:
        WHEN 1 THEN /*PRODU€ÇO*/
        DO:
            IF AVAIL ws-p-venda THEN DO:

                FIND FIRST ws-p-import WHERE ws-p-import.nr-pedcli = ws-p-venda.nr-pedcli NO-LOCK NO-ERROR.

                IF ws-p-venda.log-5 THEN DO:
                    /*pedido implatado via PedMobile*/
                    IF AVAIL ws-p-import THEN
                        ASSIGN cLocalAssinatura = "http://www.tortuga.com.br/pedmobile_PRO/assinaturas/" + ws-p-venda.nr-pedcli + ".png".
                    ELSE
                        ASSIGN cLocalAssinatura = "http://www.tortuga.com.br/pedmobile_PRO/assinaturas/" + ws-p-venda.nr-pedcli + ".gif".
                END.                
                ELSE DO:
                    IF AVAIL ws-p-import THEN
                        ASSIGN cLocalAssinatura = "http://www.tortuga.com.br/pedmobile_PRO/assinaturas/assinatura_branco.png".
                    ELSE
                        ASSIGN cLocalAssinatura = "http://www.tortuga.com.br/pedmobile_PRO/assinaturas/assinatura_branco.gif".
                END.                
            END.
        END.
        OTHERWISE  /*OUTRO*/
        DO:
            IF AVAIL ws-p-venda THEN DO:

                FIND FIRST ws-p-import WHERE ws-p-import.nr-pedcli = ws-p-venda.nr-pedcli NO-LOCK NO-ERROR.

                IF ws-p-venda.log-5 THEN DO:
                    /*pedido implantado via PedMobile*/
                    IF AVAIL ws-p-import THEN
                        ASSIGN cLocalAssinatura = "http://www.tortuga.com.br/pedmobile_DES/assinaturas/" + ws-p-venda.nr-pedcli + ".png".
                    ELSE
                        ASSIGN cLocalAssinatura = "http://www.tortuga.com.br/pedmobile_DES/assinaturas/" + ws-p-venda.nr-pedcli + ".gif".
                END.
                ELSE DO:
                    IF AVAIL ws-p-import THEN
                        ASSIGN cLocalAssinatura = "http://www.tortuga.com.br/pedmobile_DES/assinaturas/assinatura_branco.png".
                    ELSE
                        ASSIGN cLocalAssinatura = "http://www.tortuga.com.br/pedmobile_DES/assinaturas/assinatura_branco.gif".
                END.
            END.        
        END.
    END CASE.

    /**/
    IF AVAIL ws-p-venda THEN DO:
        FIND FIRST ped-venda
             WHERE ped-venda.nr-pedcli  = ws-p-venda.nr-pedcli
               AND ped-venda.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
        IF NOT AVAIL ped-venda THEN DO:
            RETURN "NOK".
        END.

        FIND FIRST loc-entr
             WHERE loc-entr.nome-abrev  = ws-p-venda.nome-abrev
               AND loc-entr.cod-entrega = ws-p-venda.cod-entrega NO-LOCK NO-ERROR.
        IF NOT AVAIL loc-entr THEN DO:
            RETURN "NOK".
        END.

        FIND FIRST es-loc-entr
             WHERE es-loc-entr.nome-abrev  = loc-entr.nome-abrev
               AND es-loc-entr.cod-entrega = loc-entr.cod-entrega NO-LOCK NO-ERROR.
        IF NOT AVAIL es-loc-entr THEN DO:
            RETURN "NOK".
        END.

        FIND FIRST repres
             WHERE repres.nome-abrev = ws-p-venda.no-ab-reppri NO-LOCK NO-ERROR.
        IF NOT AVAIL repres THEN DO:
            RETURN "NOK".
        END.        

        /*condicao de pagamento*/
        cdesc-cond-pag = "".
        FIND FIRST cond-pagto
             WHERE cond-pagto.cod-cond-pag = ws-p-venda.cod-cond-pag NO-LOCK NO-ERROR.
        IF ws-p-venda.cod-cond-pag = 0 THEN /*condi‡Æo especial de pagamento*/
            RUN pdp/espd088.p (INPUT ws-p-venda.nome-abrev,
                               INPUT ws-p-venda.nr-pedcli,
                               OUTPUT cdesc-cond-pag).
        ELSE
            ASSIGN cdesc-cond-pag = cond-pagto.descricao.
        /**/

        FIND FIRST emitente
             WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
        IF NOT AVAIL emitente THEN DO:
            RETURN "NOK".
        END.        

        ASSIGN iQtdItens          = 0
               dcValorTotalPedido = 0.

        FOR EACH ped-item 
           WHERE ped-item.nome-abrev = ws-p-venda.nome-abrev
             AND ped-item.nr-pedcli  = ws-p-venda.nr-pedcli NO-LOCK
            ,
            FIRST ITEM 
            WHERE ITEM.it-codigo = ped-item.it-codigo NO-LOCK:

            ASSIGN iQtdItens                   = iQtdItens + 1
                   iItemCodigo[iQtdItens]      = INT(ped-item.it-codigo)
                   cItemDescricao[iQtdItens]   = ITEM.desc-item
                   cItemUnidade[iQtdItens]     = ITEM.un
                   iQtdadePedida[iQtdItens]    = INT(ped-item.qt-pedida)
                   iQtdadeEmbalagem[iQtdItens] = INT(ITEM.lote-mulven)
                   dcPrecoLiquido[iQtdItens]   = DEC(ped-item.vl-tot-it)
                   dcValorTotalPedido          = DEC(dcValorTotalPedido + ped-item.vl-tot-it).
        END.
    END.
    ELSE DO:
        RETURN "NOK".
    END.
    /**/

    cDataHorario = STRING(ws-p-venda.dt-implant,"99/99/99") + 
                   " as " + 
                   SUBSTRING(STRING(ws-p-venda.hr-implant,"hh:mm"),1,INDEX(STRING(ws-p-venda.hr-implant,"hh:mm"),":") - 1) + "h" + 
                   SUBSTRING(STRING(ws-p-venda.hr-implant,"hh:mm"),INDEX(STRING(ws-p-venda.hr-implant,"hh:mm"),":") + 1,2) + "m".

    c-email = REPLACE(c-email, 
                      "cNumeroPedido", 
                      TRIM(STRING(ws-p-venda.nr-pedcli))).
    c-email = REPLACE(c-email,
                      "cCliente",
                      fn-free-accent(TRIM(STRING(emitente.nome-abrev))) + " - " + fn-free-accent(TRIM(STRING(emitente.nome-emit)))).
    c-email = REPLACE(c-email,
                      "cTelCelular",
                      fn-free-accent(TRIM(STRING(emitente.telefone[1])))).
    c-email = REPLACE(c-email,
                      "cTelFixo",
                      fn-free-accent(TRIM(STRING(emitente.telefone[2])))).
    c-email = REPLACE(c-email,
                      "cEmail",
                      fn-free-accent(TRIM(STRING(emitente.e-mail)))).
    c-email = REPLACE(c-email,
                      "cSituacaoPedido",
                      TRIM(STRING(cParamSaida[3]))).
    c-email = REPLACE(c-email,
                      "cDataImplantacao",
                      cDataHorario).
    c-email = REPLACE(c-email,
                      "cPropriedade",
                      fn-free-accent(TRIM(STRING(es-loc-entr.nome-fazenda))) + " - " + fn-free-accent(TRIM(STRING(es-loc-entr.cidade))) + "/" + TRIM(STRING(es-loc-entr.estado))).
    c-email = REPLACE(c-email,
                      "cEnderecoCobranca",
                      fn-free-accent(TRIM(STRING(es-loc-entr.endereco-cob))) + " - " + fn-free-accent(TRIM(STRING(es-loc-entr.cidade-cob))) + "/" + TRIM(STRING(es-loc-entr.estado-cob))).
    c-email = REPLACE(c-email,
                      "cNomeRepresentante",
                      fn-free-accent(STRING(STRING(repres.nome)))).
    c-email = REPLACE(c-email,
                      "cCondicaoPagto",
                      fn-free-accent(TRIM(STRING(cdesc-cond-pag)))).
    c-email = REPLACE(c-email,
                      "cRoteiro",
                      fn-free-accent(TRIM(STRING(es-loc-entr.roteiro)))).
    c-email = REPLACE(c-email, /*Valor total do pedido*/
                      "cValorTotal",
                      "R$ " + STRING(dcValorTotalPedido,">,>>>,>>>,>>9.99")).
    c-email = REPLACE(c-email, /*Assinatura do cliente; somente de pedidos enviados via PedMobile*/
                      "cLocalAssinatura",
                      cLocalAssinatura).


    DO iContador = 1 TO 40:
        ASSIGN
            c-email = REPLACE(c-email, /*Codigo do Item*/
                              "cItemCodigo[" + STRING(iContador) + "]",
                              IF STRING(iItemCodigo[iContador]) = "0" THEN "" ELSE STRING(iItemCodigo[iContador]))

            c-email = REPLACE(c-email, /*Descricao do Item*/
                              "cItemDescricao[" + STRING(iContador) + "]",
                              STRING(cItemDescricao[iContador]))

            c-email = REPLACE(c-email, /*Unidade do Item*/
                              "cItemUnidade[" + STRING(iContador) + "]",
                              STRING(cItemUnidade[iContador]))

            c-email = REPLACE(c-email, /*Qtdade pedida do Item*/
                              "cQtdadePedida[" + STRING(iContador) + "]",
                              IF STRING(iQtdadePedida[iContador]) = "0" THEN "" ELSE STRING(iQtdadePedida[iContador]))

            c-email = REPLACE(c-email, /*Preco liquido do item*/
                              "cPrecoLiquido[" + STRING(iContador) + "]",
                              IF STRING(dcPrecoLiquido[iContador]) = "0" THEN "" ELSE "R$ " + STRING(dcPrecoLiquido[iContador],">,>>>,>>>,>>9.99")).

    END.

END PROCEDURE.
