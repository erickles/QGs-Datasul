{include/i-buffer.i}
/*{include/i-es-permis.i}*/

DEFINE VARIABLE GA-logRepres    AS LOGICAL     NO-UNDO INITIAL "YES".
DEFINE VARIABLE GA-ind-tp-usuar AS INTEGER     NO-UNDO INITIAL 4.
DEFINE VARIABLE GA-Nome-Rep     AS CHARACTER   NO-UNDO INITIAL "1254".
DEFINE VARIABLE GA-UsuarioID    AS CHARACTER   NO-UNDO INITIAL "repres".
DEFINE VARIABLE GA-logRegiao    AS LOGICAL     NO-UNDO INITIAL YES.
DEFINE VARIABLE GA-logGrpEstoq  AS LOGICAL     NO-UNDO INITIAL YES.
DEFINE VARIABLE GA-logFamilia   AS LOGICAL     NO-UNDO INITIAL YES.
DEFINE VARIABLE GA-logItem      AS LOGICAL     NO-UNDO INITIAL YES.
DEFINE VARIABLE GA-Linha-Repres AS LOGICAL     NO-UNDO INITIAL YES.

FOR EACH tit_acr WHERE tit_acr.cod_estab        = "22"
                   AND tit_acr.cod_espec_docto  = "DP"
                   AND tit_acr.cod_ser_docto    = "2"
                   AND tit_acr.cod_tit_acr      = "0077181"
                   NO-LOCK.

    /*
    DISP tit_acr.cod_ser_docto  
         tit_acr.cod_estab      
         tit_acr.cod_espec_docto
         tit_acr.cod_tit_acr    
         tit_acr.cod_parcela.
    */

    RUN GatilhoTituloACR(rowid(tit_acr)).

    IF RETURN-VALUE = "NOK":U THEN
        MESSAGE "nok"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

PROCEDURE GatilhoTituloACR:

    /* Definicao de Buffer de Acesso */
    DEFINE BUFFER GA-titulo           FOR tit_acr.
    DEFINE BUFFER GA-fat-duplic       FOR fat-duplic.
    DEFINE BUFFER GA-nota-fiscal2     FOR nota-fiscal.  
    DEFINE BUFFER GA-ws-p-venda2      FOR ws-p-venda.
    
    DEFINE INPUT  PARAMETER prRowIdTitulo    AS ROWID       NO-UNDO.
    /*
    IF NOT GA-logRepres   AND 
       NOT GA-logRegiao   AND 
       NOT GA-logGrpEstoq AND   
       NOT GA-logFamilia  AND 
       NOT GA-logItem     THEN RETURN "OK":U.
    */     
    FIND FIRST GA-titulo WHERE ROWID(GA-titulo) = prRowIdTitulo NO-LOCK NO-ERROR.
    IF NOT AVAIL GA-titulo THEN RETURN "OK":U.
    
    FIND GA-fat-duplic
        WHERE GA-fat-duplic.cod-estabel  = GA-titulo.cod_estab 
          AND GA-fat-duplic.serie        = GA-titulo.cod_ser_docto
          AND GA-fat-duplic.nr-fatura    = GA-titulo.cod_tit_acr
          AND GA-fat-duplic.ind-fat-nota = 1 /* Fatura */
          AND GA-fat-duplic.flag-atualiz = TRUE 
          AND GA-fat-duplic.parcela      = GA-titulo.cod_parcela     
          NO-LOCK NO-ERROR.

   IF NOT AVAIL GA-fat-duplic THEN DO:
       
      /* Verificar se titulo jka e do represetante */
      /*IF LOOKUP(STRING(GA-titulo.cdn_repres),GA-lista-codrep) > 0 OR */
         /*LOOKUP(STRING(GA-titulo.cdn_repres),v-lista)         > 0 THEN.*/
      /*ELSE RETURN "NOK":U.*/
      
   END.
   ELSE DO:
       
       FIND GA-nota-fiscal2 
           WHERE GA-nota-fiscal2.cod-estabel = GA-fat-duplic.cod-estabel
             AND GA-nota-fiscal2.serie       = GA-fat-duplic.serie
             AND GA-nota-fiscal2.nr-fatura   = GA-fat-duplic.nr-fatura 
             NO-LOCK NO-ERROR.
       IF NOT AVAIL GA-nota-fiscal2 THEN RETURN "NOK":U.

       RUN GatilhoNotaFiscal IN TARGET-PROCEDURE (INPUT ROWID(GA-nota-fiscal2)).
       IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
       
       IF GA-nota-fiscal2.nr-pedcli <> "" THEN DO: /* N’o valida notas que n’o possui pedido */
         FIND GA-ws-p-venda2 
             WHERE GA-ws-p-venda2.nr-pedcli = GA-nota-fiscal2.nr-pedcli
             NO-LOCK NO-ERROR.
         IF NOT AVAIL GA-ws-p-venda2 THEN RETURN "NOK":U.
         RUN GatilhoPedidoVenda IN TARGET-PROCEDURE (INPUT ROWID(GA-ws-p-venda2)).
         IF RETURN-VALUE = "NOK":U THEN RETURN "NOK":U.
       END.

   END.
   
   RETURN "OK":U.

END PROCEDURE.

PROCEDURE GatilhoNotaFiscal:

    /* Definicao de Buffer de Acesso */
    DEFINE BUFFER GA-es-usuario-ger   FOR es-usuario-ger.
    DEFINE BUFFER GA-es-usuar-ge      FOR es-usuar-ge.
    DEFINE BUFFER GA-es-usuar-fam-com FOR es-usuar-fam-com.
    DEFINE BUFFER GA-item             FOR ITEM.
    DEFINE BUFFER GA-it-nota-fisc     FOR it-nota-fisc.
    DEFINE BUFFER GA-es-repres-comis  FOR es-repres-comis.
    DEFINE BUFFER GA-rep-micro        FOR rep-micro.
    DEFINE BUFFER GA-repres           FOR repres.
    DEFINE BUFFER GA-nota-fiscal      FOR nota-fiscal.  
    DEFINE BUFFER GA-ws-p-venda       FOR ws-p-venda.
    DEFINE BUFFER GA-es-usuar-item    FOR es-usuar-item.
    
    DEFINE INPUT  PARAMETER prRowIdNotaFiscal AS ROWID       NO-UNDO.

    FIND FIRST GA-nota-fiscal WHERE ROWID(GA-nota-fiscal) = prRowIdNotaFiscal NO-LOCK NO-ERROR.
    IF NOT AVAIL GA-nota-fiscal THEN RETURN "OK":U.
        
    
    /* Verifica se Usuario tem Acesso a Regiao do Pedido */
    IF GA-logRepres THEN DO:
        
        
       /* Se o pedido e do proprio codigo de repres ja libera o acesso */
       IF GA-ind-tp-usuar = 4 /* Repres */ THEN DO:
          /*IF LOOKUP(GA-nota-fiscal.no-ab-reppri,GA-lista-nomrep) = 0 THEN RETURN "NOK":U.
          ELSE RETURN "OK":U.*/
       END.
       ELSE DO:

          /* Supervisor nao tem aceso a nota sem pedido devido a MicroRegiao */
          IF GA-nota-fiscal.nr-pedcli <> "" THEN DO:
              /* Valida Relacionamento com Regiao e MicroRegiao - Supervisor */
              FOR FIRST GA-ws-p-venda NO-LOCK
                  WHERE GA-ws-p-venda.nr-pedcli = GA-nota-fiscal.nr-pedcli.
              END.
              IF NOT AVAIL GA-ws-p-venda THEN RETURN "NOK":U.
              IF NOT CAN-FIND(FIRST GA-rep-micro WHERE GA-rep-micro.nome-ab-rep  = GA-Nome-Rep 
                                                   AND GA-rep-micro.nome-ab-reg  = GA-ws-p-venda.nome-ab-reg
                                                   AND GA-rep-micro.nome-mic-reg = GA-ws-p-venda.micro-reg NO-LOCK) THEN DO:
                 IF NOT CAN-FIND(FIRST GA-es-usuario-ger WHERE GA-es-usuario-ger.cod_usuario = GA-UsuarioID 
                                                           AND GA-es-usuario-ger.nome-ab-reg = GA-ws-p-venda.nome-ab-reg NO-LOCK) THEN
                    RETURN "NOK":U.
              END.                       
          END.
          ELSE DO:
              IF NOT CAN-FIND(FIRST GA-es-usuario-ger WHERE GA-es-usuario-ger.cod_usuario = GA-UsuarioID 
                                                        AND GA-es-usuario-ger.nome-ab-reg = GA-nota-fiscal.nome-ab-reg NO-LOCK) THEN
                 RETURN "NOK":U.
          END.

       END.

    END.
    ELSE DO: 

       IF GA-ind-tp-usuar = 2 /* Gerente */ THEN DO:
          /* Valida Relacionamento com Regiao e MicroRegiao - Supervisor */
          IF GA-nota-fiscal.nr-pedcli <> "" THEN DO:
              FOR FIRST GA-ws-p-venda NO-LOCK
                  WHERE GA-ws-p-venda.nr-pedcli = GA-nota-fiscal.nr-pedcli.
              END.
              IF NOT AVAIL GA-ws-p-venda THEN RETURN "NOK":U.
              IF NOT CAN-FIND(FIRST GA-rep-micro WHERE GA-rep-micro.nome-ab-rep  = GA-Nome-Rep 
                                                   AND GA-rep-micro.nome-ab-reg  = GA-ws-p-venda.nome-ab-reg NO-LOCK) THEN DO:
                 IF NOT CAN-FIND(FIRST GA-es-usuario-ger WHERE GA-es-usuario-ger.cod_usuario = GA-UsuarioID 
                                                           AND GA-es-usuario-ger.nome-ab-reg = GA-ws-p-venda.nome-ab-reg NO-LOCK) THEN
                    RETURN "NOK":U.
              END.                      
          END.
          ELSE DO:
              IF NOT CAN-FIND(FIRST GA-rep-micro WHERE GA-rep-micro.nome-ab-rep  = GA-Nome-Rep 
                                                   AND GA-rep-micro.nome-ab-reg  = GA-nota-fiscal.nome-ab-reg NO-LOCK) THEN DO:
                 IF NOT CAN-FIND(FIRST GA-es-usuario-ger WHERE GA-es-usuario-ger.cod_usuario = GA-UsuarioID 
                                                           AND GA-es-usuario-ger.nome-ab-reg = GA-nota-fiscal.nome-ab-reg NO-LOCK) THEN
                    RETURN "NOK":U.
              END.
          END.
       END.
       ELSE DO:
           IF GA-logRegiao THEN DO:
              IF GA-nota-fiscal.nr-pedcli <> "" THEN DO:
                  FOR FIRST GA-ws-p-venda NO-LOCK
                      WHERE GA-ws-p-venda.nr-pedcli = GA-nota-fiscal.nr-pedcli.
                  END.
                  IF NOT AVAIL GA-ws-p-venda THEN RETURN "NOK":U.
                  IF NOT CAN-FIND(FIRST GA-es-usuario-ger WHERE GA-es-usuario-ger.cod_usuario = GA-UsuarioID 
                                                            AND GA-es-usuario-ger.nome-ab-reg = GA-ws-p-venda.nome-ab-reg NO-LOCK) THEN
                     RETURN "NOK":U.
              END.
              ELSE DO:
                 IF NOT CAN-FIND(FIRST GA-es-usuario-ger WHERE GA-es-usuario-ger.cod_usuario = GA-UsuarioID 
                                                           AND GA-es-usuario-ger.nome-ab-reg = GA-nota-fiscal.nome-ab-reg NO-LOCK) THEN
                    RETURN "NOK":U.
              END.
           END.
       END.
         
    END.
        
    /* Se tem acesso a tudo nao verifica item */
    IF NOT GA-logGrpEstoq AND NOT GA-logFamilia AND NOT GA-logItem /*AND GA-log-mitsuisal AND GA-log-tortuga*/ THEN DO:

        IF GA-Linha-Repres <> "" THEN DO:
           /* Verifica se Linha do repres do pedido pertente a linha do repres logado */
           FIND GA-repres WHERE
                GA-repres.nome-abrev = GA-nota-fiscal.no-ab-reppri NO-LOCK NO-ERROR.
           IF AVAIL GA-Repres THEN DO:
              FIND GA-es-repres-comis 
                   WHERE GA-es-repres-comis.cod-rep = GA-repres.cod-rep NO-LOCK NO-ERROR.
              IF NOT AVAIL GA-es-repres-comis THEN RETURN "NOK":U.
              IF AVAIL GA-es-repres-comis AND LOOKUP(STRING(GA-es-repres-comis.u-int-1),GA-Linha-Repres) = 0 THEN DO:
                 /* Representante e Nucricao e Saude */
                 IF GA-es-repres-comis.u-int-1 = 3 THEN DO:
                    IF LOOKUP('1',GA-Linha-Repres) = 0 AND LOOKUP('2',GA-Linha-Repres) = 0 THEN RETURN "NOK":U.        
                 END.
                 ELSE RETURN "NOK":U.        
              END.
           END.
        END.

        IF GA-Linha-Repres <> "" THEN DO:
           FOR FIRST GA-it-nota-fisc OF GA-nota-fiscal NO-LOCK:
              RUN piClassificaProduto (INPUT GA-it-nota-fisc.it-codigo, OUTPUT GA-Linha-Item).
              IF LOOKUP(STRING(GA-Linha-Item),GA-Linha-Repres) = 0 AND GA-Linha-Item <> 9 THEN RETURN "NOK":U.                  
           END.
        END.
        RETURN "OK":U.
    END.

    /* Se nao tem item, nao valida acesso ao item */
    IF NOT CAN-FIND(FIRST GA-it-nota-fisc OF GA-nota-fiscal NO-LOCK) THEN RETURN "OK":U.

    FOR EACH GA-it-nota-fisc OF GA-nota-fiscal NO-LOCK,
       FIRST GA-item  
       WHERE GA-item.it-codigo = GA-it-nota-fisc.it-codigo NO-LOCK
       BREAK BY GA-item.ge-codigo
             BY GA-item.fm-cod-com:

       IF GA-logItem THEN DO:
           
          /* Verifica se tem acesso ao item */
          IF CAN-FIND(FIRST GA-es-usuar-item WHERE GA-es-usuar-item.cod-usuario = GA-UsuarioID 
                                               AND GA-es-usuar-item.it-codigo   = GA-item.it-codigo 
                                               AND GA-es-usuar-item.ind-tipo    = 1 NO-LOCK) THEN RETURN "OK":U.

          /* Verifica se nao tem acesso ao item */
          IF CAN-FIND(FIRST GA-es-usuar-item WHERE GA-es-usuar-item.cod-usuario = GA-UsuarioID 
                                               AND GA-es-usuar-item.it-codigo   = GA-item.it-codigo 
                                               AND GA-es-usuar-item.ind-tipo    = 2 NO-LOCK) THEN NEXT.

          /* Se Tem Acesso a um determinado item tem que ter restricao por familia a grupo de estoque */
          IF GA-logValItem AND NOT GA-logGrpEstoq AND NOT GA-logFamilia THEN NEXT.

       END.
       
       IF FIRST-OF(GA-item.fm-cod-com) THEN DO:

           /* Verifica se Usuario tem Acesso a Regiao do Pedido */
           IF GA-logGrpEstoq THEN 
              IF NOT CAN-FIND(FIRST GA-es-usuar-ge WHERE GA-es-usuar-ge.cod_usuario = GA-UsuarioID 
                                                     AND GA-es-usuar-ge.ge-codigo   = GA-item.ge-codigo NO-LOCK) THEN NEXT.

           /* Verifica se Usuario tem Acesso a Regiao do Pedido */
           IF GA-logFamilia THEN
              IF NOT CAN-FIND(FIRST GA-es-usuar-fam-com WHERE GA-es-usuar-fam-com.cod_usuario = GA-UsuarioID 
                                                          AND GA-es-usuar-fam-com.fm-cod-com  = GA-item.fm-cod-com NO-LOCK) THEN NEXT.

           /* Garante Restricao Tortuga / Mitsuisal 
           IF NOT Ga-Log-Mitsuisal AND Ga-item.ge-codigo  = 43 THEN RETURN "NOK":U.
           IF NOT Ga-Log-tortuga   AND (Ga-item.ge-codigo <> 43 /*AND GA-item.it-codigo <> "40008277" /* ABATHOR */ 
                                                                AND GA-item.it-codigo <> "40008290" /* Altec */*/ ) THEN RETURN "NOK":U.*/

           /* Se tem accesso a um item tem acesso ao pedido */
           RETURN "OK":U.
       
       END.
       
    END.
    /* Se nao achou item valido usuario nao tem acesso */
    RETURN "NOK":U.
    
END PROCEDURE.
