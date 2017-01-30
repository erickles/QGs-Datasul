DEFINE VARIABLE lAtivo AS LOGICAL     NO-UNDO.

RUN piClienteInativo(INPUT 238905,
                     OUTPUT lAtivo).

MESSAGE lAtivo
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE piClienteInativo:

    DEFINE VARIABLE i-mesina    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-sit-ant   AS CHARACTER   NO-UNDO.

    DEFINE INPUT  PARAMETER pcNomeMatriz    AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pl-log-ativo    AS LOGICAL     NO-UNDO.
    
    DEFINE BUFFER b-emitente                FOR emitente.
    DEFINE BUFFER buffer-es-emitente-dis    FOR es-emitente-dis.
    DEFINE BUFFER b-nota-fiscal             FOR nota-fiscal.

    /* Verifica se o Cliente esta Inativo/Renovacao */
    FIND b-emitente WHERE b-emitente.nome-abrev = pcNomeMatriz NO-LOCK NO-ERROR.
    IF NOT AVAIL b-emitente THEN DO:
        MESSAGE "1"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "NOK":U.
    END.
    
    /* Renovacao apenas para os grupos 1 e 2 */
    IF b-emitente.cod-gr-cli > 2 THEN DO:
       pl-log-ativo = TRUE.
       MESSAGE "2"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN "OK":U.
    END.
    
    i-mesina = IF AVAIL b-emitente THEN b-emitente.nr-mesina ELSE 12.

    /*EGP5577-9 - Inativar clientes pessoa fisica do MT que sejam produtores rurais, contribuintes ICMS e que tiverem a inscri»’o estadual ISENTO*/
    IF TODAY >= 08/01/2013 THEN DO:
        
        FOR EACH b-emitente NO-LOCK WHERE b-emitente.nome-matriz            = pcNomeMatriz
                                      AND NOT b-emitente.nome-emit BEGINS   "** Eliminado"
                                      AND b-emitente.identific              <> 2 /* Fornecedor */
                                      AND b-emitente.natureza               = 1 /*pessoa fisica*/
                                      AND b-emitente.atividade              = "RURAL"
                                      AND b-emitente.contrib-icms           = YES
                                      AND b-emitente.estado                 = "MT"
                                      AND b-emitente.ins-estadual           = "ISENTO":
           
            FIND buffer-es-emitente-dis WHERE buffer-es-emitente-dis.cod-emitente = b-emitente.cod-emitente 
                                          AND buffer-es-emitente-dis.cod-CNAE = 141401 EXCLUSIVE-LOCK NO-ERROR.  
             IF AVAIL buffer-es-emitente-dis THEN DO:
                    MESSAGE "3"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    pl-log-ativo = FALSE.
                    RETURN "OK":U.
             END.
    
        END.
        
    END.
    /*FIM - EGP5577-9*/

    RELEASE buffer-es-emitente-dis.

    blk_cliente_inat:
    FOR EACH b-emitente NO-LOCK WHERE b-emitente.nome-matriz = pcNomeMatriz
                                AND NOT b-emitente.nome-emit BEGINS "** Eliminado"
                                AND b-emitente.identific  <> 2 /* Fornecedor */:

        /* Verifica Ultima Renovacao e se Pedido foi Aprovado se Renovacao */
        FIND buffer-es-emitente-dis WHERE buffer-es-emitente-dis.cod-emitente = b-emitente.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL buffer-es-emitente-dis THEN DO:
             
            c-sit-ant = SUBSTRING(buffer-es-emitente-dis.char-2,210,1).

            IF buffer-es-emitente-dis.dt-renov <> ? AND 
                buffer-es-emitente-dis.dt-renov  > (TODAY - (30 * i-mesina)) THEN DO:
                MESSAGE "4"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                pl-log-ativo = TRUE.
                LEAVE blk_cliente_inat.
            END.
            
            /** Considera nota apenas se nao esta pendente de atualizacao de ficha
             ** pois pedido pode ser aprovado sem a renovacao da ficha cadastral
             **/
            IF buffer-es-emitente-dis.pend-atualiz-ficha = FALSE THEN DO:
                FIND LAST b-nota-fiscal NO-LOCK WHERE b-nota-fiscal.nome-ab-cli = b-emitente.nome-abrev
                                                AND b-nota-fiscal.emite-duplic
                                                AND b-nota-fiscal.dt-emis-nota > (TODAY - (30 * i-mesina))
                                                AND b-nota-fiscal.dt-cancela   = ?
                                                NO-ERROR.
                IF AVAIL b-nota-fiscal THEN DO:
                    pl-log-ativo = TRUE.
                    MESSAGE "5"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    LEAVE blk_cliente_inat.
                END.                             
            END.
        END.
    END.
    
    /* Se Situacao Atual e Igual a Anterior nao Atualiza Tabela*/
    IF c-sit-ant = "S" AND pl-log-ativo     THEN DO:
        MESSAGE "6"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "OK":U.
    END.
        
    IF c-sit-ant = "N" AND NOT pl-log-ativo THEN DO:
        MESSAGE "7"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN "OK":U.
    END.
        
    /* Atualiza Es-Emitente-Dis - Performance Ped-Mobile */
    FOR EACH b-emitente NO-LOCK
       WHERE b-emitente.nome-matriz = pcNomeMatriz
         AND NOT b-emitente.nome-emit BEGINS "** Eliminado"
         AND b-emitente.identific  <> 2 /* Fornecedor */:

         /* Verifica Ultima Renovacao e se Pedido foi Aprovado se Renovacao */
         FIND buffer-es-emitente-dis WHERE buffer-es-emitente-dis.cod-emitente = b-emitente.cod-emitente EXCLUSIVE-LOCK NO-ERROR.  
         IF AVAIL buffer-es-emitente-dis THEN DO:
             OVERLAY(buffer-es-emitente-dis.char-2,210,1) = IF pl-log-ativo THEN "S" ELSE "N" NO-ERROR.
             VALIDATE buffer-es-emitente-dis.
         END.
         
         FIND CURRENT buffer-es-emitente-dis NO-LOCK NO-ERROR.

    END.


END PROCEDURE.
