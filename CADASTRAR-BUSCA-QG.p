DEF VAR seq-busca AS INTEGER NO-UNDO.


FIND LAST es-busca-natureza-frete NO-ERROR.
    IF AVAIL es-busca-natureza-frete THEN
    ASSIGN seq-busca = es-busca-natureza-frete.seq-busca + 1.

/*     ASSIGN seq-busca = seq-busca + 1. */


/*DISP seq-busca natoper-nota cod-estabel natoper-frete natoper-fretesimples natoper-freteorigemUF natoper-freteDifUF. */


    FIND FIRST es-busca-natureza-frete WHERE es-busca-natureza-frete.natoper-nota = "5999SD" NO-ERROR.
    IF NOT AVAIL es-busca-natureza-frete THEN DO:

        CREATE es-busca-natureza-frete.
        ASSIGN es-busca-natureza-frete.seq-busca = seq-busca
               es-busca-natureza-frete.natoper-nota = "5999SD".

    END.

    FIND FIRST es-busca-natureza-frete WHERE es-busca-natureza-frete.natoper-nota = "5999SD" NO-ERROR.
    IF AVAIL es-busca-natureza-frete THEN DO:

        FIND FIRST es-busca-natureza-frete-movto WHERE es-busca-natureza-frete-movto.seq-busca = es-busca-natureza-frete.seq-busca
                                                   AND es-busca-natureza-frete-movto.cod-estabel = "19" NO-ERROR.
            IF NOT AVAIL es-busca-natureza-frete-movto THEN DO:

                CREATE es-busca-natureza-frete-movto.
                ASSIGN es-busca-natureza-frete-movto.seq-busca =  es-busca-natureza-frete.seq-busca
                       es-busca-natureza-frete-movto.cod-estabel = "19"
                       es-busca-natureza-frete-movto.natoper-frete = "13520D"
                       es-busca-natureza-frete-movto.natoper-frete-simples = "13520D"
                       es-busca-natureza-frete-movto.natoper-frete-origemUF = "2621UW"
                       es-busca-natureza-frete-movto.natoper-frete-diferUF = "23520D" .
            END.
            
/*             UPDATE es-busca-natureza-frete-movto.natoper-frete          */
/*                    es-busca-natureza-frete-movto.natoper-frete-simples  */
/*                    es-busca-natureza-frete-movto.natoper-frete-origemUF */
/*                    es-busca-natureza-frete-movto.natoper-frete-diferUF. */

            
    END.
