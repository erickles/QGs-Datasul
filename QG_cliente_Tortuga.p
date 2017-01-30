PROCEDURE piClienteTortuga:

    DEFINE VARIABLE i-mesina        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dt-base         AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-classif      AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-tortuga      AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-mitsuisal    AS DATE        NO-UNDO.
    DEFINE VARIABLE dt-saude        AS DATE        NO-UNDO.
    DEFINE VARIABLE log-tortuga     AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE log-mitsuisal   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE log-saude       AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE i-linha-produto AS INTEGER     NO-UNDO.
    
    DEFINE INPUT  PARAMETER pcNomeMatriz    AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER piTipoCliente   AS INTEGER     NO-UNDO.
    
    DEFINE BUFFER b2-emitente       FOR emitente.
    DEFINE BUFFER b-emitente        FOR emitente.
    DEFINE BUFFER b-es-emitente-dis FOR es-emitente-dis.
    DEFINE BUFFER b-nota-fiscal     FOR nota-fiscal.

    /* Verifica se o Cliente esta Inativo/Renovacao */
    FIND b2-emitente WHERE b2-emitente.nome-abrev = pcNomeMatriz NO-LOCK NO-ERROR.
    IF NOT AVAIL b2-emitente THEN
        RETURN "NOK":U.

    FIND b-es-emitente-dis WHERE b-es-emitente-dis.cod-emitente = b2-emitente.cod-emitente NO-LOCK NO-ERROR.  
    IF NOT AVAIL b-es-emitente-dis THEN
       RETURN "NOK":U.

    ASSIGN piTipoCliente  = b-es-emitente-dis.int-2
           i-mesina       = 6  /* 6 meses */
           dt-base        = (TODAY - (30 * i-mesina))
           dt-tortuga     = dt-base
           dt-mitsuisal   = dt-base
           dt-classif     = IF DATE(SUBSTRING(b-es-emitente-dis.char-2,17,10)) = ? THEN dt-base
                            ELSE DATE(SUBSTRING(b-es-emitente-dis.char-2,17,10))
                            NO-ERROR.

    /* Se ultima reclassificacao e inferior a 6 mese entao nao reclassifica */
    /* N’o reclassifica clientes marcados como ambos manualmente */
    IF NOT (SUBSTRING(b-es-emitente-dis.char-2,28,7) <> "Sistema" AND b-es-emitente-dis.int-2 = 3) /* <SD-1585> */ AND (dt-classif < dt-base OR b-es-emitente-dis.int-2 = 0) THEN DO:

        blk_cliente_tortuga:
        FOR EACH b-emitente NO-LOCK
           WHERE b-emitente.nome-matriz = b2-emitente.nome-matriz
             AND NOT b-emitente.nome-emit BEGINS "** Eliminado"
             AND b-emitente.identific  <> 2 /* Fornecedor */:
    
             /* Verifica se Utiliza Conceito de Matriz */
             IF NOT logMatriz AND b-emitente.nome-abrev <> b2-emitente.nome-abrev THEN NEXT.

             FIND b-es-emitente-dis WHERE b-es-emitente-dis.cod-emitente = b-emitente.cod-emitente NO-LOCK NO-ERROR.  
             IF AVAIL b-es-emitente-dis THEN DO:
                 
                 FOR EACH b-nota-fiscal NO-LOCK
                    WHERE b-nota-fiscal.nome-ab-cli  = b-emitente.nome-abrev  
                      AND b-nota-fiscal.emite-duplic  
                      AND b-nota-fiscal.dt-emis-nota >= dt-base
                      AND b-nota-fiscal.dt-cancela   = ?,
                    FIRST it-nota-fisc OF b-nota-fiscal NO-LOCK:
    
                    /* Classifica Produto Como: 0 - Diversos; 1 - Nutricao; 2 - Saude; 3 - Mitsuisal */
                    RUN piClassificaProduto (INPUT  it-nota-fisc.it-codigo,
                                             OUTPUT i-linha-produto).

                    CASE i-linha-produto:

                        WHEN 1 /* TORTUGA   */ THEN DO:
                            ASSIGN log-tortuga = TRUE.
                            /** Nao considera as notas fiscais emitidas nos ultimos 15 dias 
                             ** devido ao cancelamento de nota fiscal
                             **/
                            IF b-nota-fiscal.dt-emis < (TODAY - 15) THEN
                               dt-tortuga  = IF dt-tortuga < b-nota-fiscal.dt-emis-nota THEN b-nota-fiscal.dt-emis-nota ELSE dt-tortuga.
                        END.

                        WHEN 2 /* SAUDE     */ THEN DO:
                            ASSIGN log-saude = TRUE.
                            /** Nao considera as notas fiscais emitidas nos ultimos 15 dias 
                             ** devido ao cancelamento de nota fiscal
                             **/
                            IF b-nota-fiscal.dt-emis < (TODAY - 15) THEN
                               dt-saude  = IF dt-saude < b-nota-fiscal.dt-emis-nota THEN b-nota-fiscal.dt-emis-nota ELSE dt-saude.
                        END.

                        WHEN 3 /* MITSUISAL */ THEN DO:
                            ASSIGN log-mitsuisal = TRUE.
                            /** Nao considera as notas fiscais emitidas nos ultimos 15 dias 
                             ** devido ao cancelamento de nota fiscal
                             **/
                            IF b-nota-fiscal.dt-emis < (TODAY - 15) THEN
                               dt-mitsuisal  = IF dt-mitsuisal < b-nota-fiscal.dt-emis-nota THEN b-nota-fiscal.dt-emis-nota ELSE dt-mitsuisal.
                        END.

                    END CASE.                                        

                 END.             
    
             END.
    
        END.
        
        ASSIGN dt-base       = IF dt-tortuga > dt-mitsuisal THEN dt-mitsuisal ELSE dt-tortuga
               dt-base       = IF dt-base    > dt-saude     THEN dt-saude     ELSE dt-base
               piTipoCliente = IF piTipoCliente = 1 /*Tor*/ AND log-tortuga THEN 1 /* Se era Tortuga e tem compra Tortuga, entao continua Tortuga */
                               ELSE IF piTipoCliente = 2 /*Mit*/ AND log-mitsuisal THEN 2 /* Se era Mit e tem compra Mit, entao continua Mit */ 
                                    ELSE IF (log-tortuga OR log-saude) AND log-mitsuisal THEN 3 /* Ambos */
                                         ELSE IF log-mitsuisal AND NOT log-saude AND NOT log-tortuga THEN 2 /* Mitsuisal */
                                              ELSE IF log-tortuga THEN 1 /* Tortuga */
                                                   ELSE 3 /* Ambos */ 
                               NO-ERROR.     
       
        /* Atualiza Reclassificacao */
        FOR EACH b-emitente NO-LOCK
           WHERE b-emitente.nome-matriz = b2-emitente.nome-matriz
             AND NOT b-emitente.nome-emit BEGINS "** Eliminado"
             AND b-emitente.identific  <> 2 /* Fornecedor */:
    
           /* Verifica se Utiliza Conceito de Matriz */
           IF NOT logMatriz AND b-emitente.nome-abrev <> b2-emitente.nome-abrev THEN NEXT.

           FIND b-es-emitente-dis 
                WHERE b-es-emitente-dis.cod-emitente = b-emitente.cod-emitente
                EXCLUSIVE-LOCK NO-ERROR.  
           IF AVAIL b-es-emitente-dis THEN DO:
              
                 ASSIGN b-es-emitente-dis.int-2                 = piTipoCliente
                        OVERLAY(b-es-emitente-dis.char-2,17,10) = IF piTipoCliente = 1 /*TOR*/ THEN STRING(dt-tortuga,"99/99/9999")
                                                                  ELSE IF piTipoCliente = 2 /*MIT*/ THEN STRING(dt-mitsuisal,"99/99/9999")
                                                                       ELSE STRING(dt-base,"99/99/9999")
                        OVERLAY(b-es-emitente-dis.char-2,28,12) = "Sistema     "
                        OVERLAY(b-es-emitente-dis.char-2,41,8)  = STRING(TIME,"99999999")
                        NO-ERROR.
              /*END.*/
              
              VALIDATE b-es-emitente-dis.

              FIND CURRENT b-es-emitente-dis NO-LOCK NO-ERROR.

           END.

        END.

        RELEASE b-es-emitente-dis NO-ERROR. 
        
    END.         
    
    RETURN "OK":U.

END PROCEDURE.
