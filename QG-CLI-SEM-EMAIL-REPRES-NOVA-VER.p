FOR EACH pm-rep-param WHERE pm-rep-param.ind_situacao <> 4 
                        AND pm-rep-param.atualiza_sw
                        NO-LOCK:
    
    FOR EACH es-loc-entr NO-LOCK WHERE (es-loc-entr.cod-repres = pm-rep-param.cod-rep 
                                    OR LOOKUP(STRING(repres.cod-rep),es-loc-entr.char-1) > 0)
                                    AND es-loc-entr.ind-situacao
                                    BREAK BY es-loc-entr.nome-abrev:
        
        FIND FIRST loc-entr WHERE loc-entr.nome-abrev = es-loc-entr.nome-abrev NO-LOCK NO-ERROR.
        IF NOT AVAIL loc-entr THEN NEXT.
    
        IF FIRST-OF(es-loc-entr.nome-abrev) THEN DO:
    
            FOR EACH emitente NO-LOCK
               WHERE emitente.nome-abrev = es-loc-entr.nome-abrev
                 AND (emitente.identific = 1 OR emitente.identific = 3)
                 AND NOT emitente.nome-emit BEGINS "** Eliminado":

                FOR FIRST es-emitente-dis NO-LOCK
                    WHERE es-emitente-dis.cod-emitente = emitente.cod-emitente:

                    CREATE tt-cliente.
                    ASSIGN tt-cliente.cod-emitente = emitente.cod-emitente
                           tt-cliente.nome-abrev   = emitente.nome-abrev
                           tt-cliente.nome-matriz  = emitente.nome-matriz.  

                    /*KLEBER SOTTE - 17.06.2010*/
                    ASSIGN log-ativo             = TRUE
                           iTipoCliente          = 3
                           dtUltAvaliacaoCliente = DATE(SUBSTRING(es-emitente-dis.char-2,17,10)) 
                           NO-ERROR.

                    IF iTipoExportacao = 1 THEN DO: /*piExport*/
                        IF NOT VALID-HANDLE(hESPD063in) THEN RUN pdp/espd063in.p PERSISTENT SET hESPD063in.

                        SESSION:DATE-FORMAT="dmy".
                        IF VALID-HANDLE(hESPD063in) THEN DO:
                            RUN piClienteInativo IN hESPD063in (INPUT tt-cliente.nome-matriz,OUTPUT log-ativo).
                            IF dtUltAvaliacaoCliente = ? OR dtUltAvaliacaoCliente > (TODAY - 180) THEN
                                /*RUN piClienteTortuga IN hESPD063in (INPUT tt-cliente.nome-matriz,OUTPUT iTipoCliente).*/
                                RUN piClienteTortuga IN hESPD063in (INPUT tt-cliente.nome-abrev,OUTPUT iTipoCliente).
                        END.
                        SESSION:DATE-FORMAT="mdy".
                    END.

                    FIND tt-canal-venda WHERE
                         tt-canal-venda.cod-canal-venda = emitente.cod-canal-venda NO-ERROR.
                    IF NOT AVAIL tt-canal-venda THEN DO:
                        CREATE tt-canal-venda.
                        ASSIGN tt-canal-venda.cod-canal-venda = emitente.cod-canal-venda.
                    END.

                    IF SUBSTRING(es-emitente-dis.char-2,210,1) = "N" THEN log-ativo = FALSE.

                    OUTPUT STREAM s-saida TO VALUE(c-dir-export-rep + "\emitente.tdb") APPEND CONVERT TARGET "ISO8859-1".
                           PUT STREAM s-saida UNFORMATTED 
                                 {include/exp-emitente.i &ativo=log-ativo &empresa_cliente=es-emitente-dis.int-2}
                    OUTPUT STREAM s-saida CLOSE.
                    
                END.
            END.
        END.        
    END.


END.
