DEFINE VARIABLE deSaldoCredito AS DECIMAL     NO-UNDO.
DEFINE BUFFER bfped-venda FOR ped-venda.
DEFINE BUFFER bfemitente FOR emitente.
DEFINE BUFFER bfped-venda2 FOR ped-venda.
DEFINE VARIABLE deSaldoSusp AS DECIMAL     NO-UNDO.

FIND FIRST bfped-venda WHERE bfped-venda.nr-pedcli = "3076c0004" NO-LOCK NO-ERROR.

    IF AVAIL bfped-venda THEN DO:

        /*** Credito do Cliente ***/
        ASSIGN deSaldoCredito = 0.

        FOR FIRST bfemitente 
            FIELDS (bfemitente.dt-lim-cre 
                    bfemitente.lim-credito
                    bfemitente.dt-fim-cred
                    bfemitente.lim-adicional 
                    bfemitente.moeda-libcre)
            WHERE bfemitente.nome-abrev = bfped-venda.nome-abrev NO-LOCK:

            ASSIGN deSaldoCredito = (IF bfemitente.dt-lim-cre  >= TODAY THEN bfemitente.lim-credito ELSE 0)
                                  + (IF bfemitente.dt-fim-cred >= TODAY THEN bfemitente.lim-adicional ELSE 0).

                

        END.
        /***************************/
        
        /*** Verifica Pedidos Suspensos ***/
        ASSIGN deSaldoSusp = 0.
        FOR EACH bfped-venda2 NO-LOCK
            WHERE bfped-venda2.nome-abrev = bfped-venda.nome-abrev:

            IF ROWID(bfped-venda2) = ROWID(bfped-venda) THEN NEXT.

            IF bfped-venda2.cod-sit-ped = 5 THEN DO:
                ASSIGN deSaldoSusp = deSaldoSusp + bfped-venda2.vl-tot-ped.
            END.
        END.    
        /**********************************/

        /*** Devolve para a API o novo valor do saldo ***/
        ASSIGN deSaldoCredito = deSaldoCredito - deSaldoSusp.
        MESSAGE deSaldoCredito
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        /*
        CREATE b-tt-epc.
        ASSIGN b-tt-epc.cod-event     = p-ind-event
               b-tt-epc.cod-parameter = "credit-limit"
               b-tt-epc.val-parameter = STRING(deSaldoCredito).
        /*************************************************/
        */
    END.
