PROCEDURE piClienteInativo:

    DEFINE VARIABLE i-mesina    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-sit-ant   AS CHARACTER   NO-UNDO.

    DEFINE INPUT  PARAMETER pcNomeMatriz    AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-log-ativo    AS LOGICAL     NO-UNDO.
    
    DEFINE BUFFER b-emitente        FOR emitente.
    DEFINE BUFFER b-es-emitente-dis FOR es-emitente-dis.
    DEFINE BUFFER b-nota-fiscal     FOR nota-fiscal.

    /* Verifica se o Cliente esta Inativo/Renovacao */
    FIND b-emitente WHERE b-emitente.nome-abrev = pcNomeMatriz NO-LOCK NO-ERROR.
    IF NOT AVAIL b-emitente THEN
       RETURN "NOK":U.

    /* Renovacao apenas para os grupos 1 e 2 */
    IF b-emitente.cod-gr-cli > 2 THEN DO:
       pl-log-ativo = TRUE.
       RETURN "OK":U.
    END.
    
    i-mesina = IF AVAIL b-emitente THEN b-emitente.nr-mesina ELSE 12.

    blk_cliente_inat:
    FOR EACH b-emitente NO-LOCK
       WHERE b-emitente.nome-matriz = pcNomeMatriz
         AND NOT b-emitente.nome-emit BEGINS "** Eliminado"
         AND b-emitente.identific  <> 2 /* Fornecedor */:

         /* Verifica Ultima Renovacao e se Pedido foi Aprovado se Renovacao */
         FIND b-es-emitente-dis 
            WHERE b-es-emitente-dis.cod-emitente = b-emitente.cod-emitente
            NO-LOCK NO-ERROR.  
         IF AVAIL b-es-emitente-dis THEN DO:
             
             c-sit-ant = SUBSTRING(b-es-emitente-dis.char-2,210,1).

             IF b-es-emitente-dis.dt-renov <> ? AND 
                b-es-emitente-dis.dt-renov  > (TODAY - (30 * i-mesina)) THEN DO:
                pl-log-ativo = TRUE.
                LEAVE blk_cliente_inat.
             END.
         
             /** Considera nota apenas se nao esta pendente de atualizacao de ficha
              ** pois pedido pode ser aprovado sem a renovacao da ficha cadastral
              **/
             IF b-es-emitente-dis.pend-atualiz-ficha = FALSE THEN DO:
                 FIND LAST b-nota-fiscal NO-LOCK
                     WHERE b-nota-fiscal.nome-ab-cli = b-emitente.nome-abrev
                       AND b-nota-fiscal.emite-duplic
                       AND b-nota-fiscal.dt-emis-nota > (TODAY - (30 * i-mesina))
                       AND b-nota-fiscal.dt-cancela   = ?
                       NO-ERROR.
                 IF AVAIL b-nota-fiscal THEN DO:
                    pl-log-ativo = TRUE.
                    LEAVE blk_cliente_inat.
                 END.
             END.
         END.

    END.

    /* Se Situacao Atual e Igual a Anterior nao Atualzia Tabela*/
    IF c-sit-ant = "S" AND pl-log-ativo     THEN RETURN "OK":U.
    IF c-sit-ant = "N" AND NOT pl-log-ativo THEN RETURN "OK":U.

    /* Atualiza Es-Emitente-Dis - Performance Ped-Mobile */
    FOR EACH b-emitente NO-LOCK
       WHERE b-emitente.nome-matriz = pcNomeMatriz
         AND NOT b-emitente.nome-emit BEGINS "** Eliminado"
         AND b-emitente.identific  <> 2 /* Fornecedor */:

         /* Verifica Ultima Renovacao e se Pedido foi Aprovado se Renovacao */
         FIND b-es-emitente-dis 
            WHERE b-es-emitente-dis.cod-emitente = b-emitente.cod-emitente
            EXCLUSIVE-LOCK NO-ERROR.  
         IF AVAIL b-es-emitente-dis THEN DO:
             OVERLAY(b-es-emitente-dis.char-2,210,1) = IF pl-log-ativo THEN "S" ELSE "N".
             VALIDATE b-es-emitente-dis.
         END.
         
         FIND CURRENT b-es-emitente-dis NO-LOCK NO-ERROR.

    END.

    RELEASE b-es-emitente-dis.
    
    RETURN "OK":U.

END PROCEDURE.
