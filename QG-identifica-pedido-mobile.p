DEFINE VARIABLE codigo-repres   AS INTEGER     NO-UNDO FORMAT "9999".
DEFINE VARIABLE numero-pedido   AS CHARACTER   NO-UNDO FORMAT "X(12)".
DEFINE VARIABLE c-resto-pedido  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE idx             AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-nr-pedido     AS LOGICAL     NO-UNDO.

UPDATE codigo-repres
       numero-pedido.

FIND FIRST pm-rep-param WHERE pm-rep-param.cod_rep = codigo-repres NO-LOCK NO-ERROR.
IF AVAIL pm-rep-param THEN DO:
    /* Primeiro verifica se representante utiliza o PedMobile */
    IF pm-rep-param.ind_situacao <> 4 AND
       (pm-rep-param.nr_ultimo_pedido <> "" OR pm-rep-param.nr_ultimo_pedido <> ?) THEN DO:
        /* Verifica se representante eh Mitsuisal */
        FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = codigo-repres NO-LOCK NO-ERROR.
        IF AVAIL es-repres-comis            AND 
            es-repres-comis.u-int-1 <> 4    THEN DO:
            /* Trata o numero do pedido, dependendo do codigo do representante(numero de digitos) */            
            CASE LENGTH(STRING(codigo-repres)):
                WHEN 2 THEN DO:
                    IF SUBSTRING(numero-pedido,1,3) = STRING(codigo-repres) + "-" THEN DO:
                        c-resto-pedido = REPLACE(numero-pedido,STRING(codigo-repres) + "-","").
                        DO idx = 1 TO LENGTH(STRING(c-resto-pedido)):
                            /* Se encontra letra */
                            IF LOOKUP(SUBSTRING(c-resto-pedido,idx,1),"0,1,2,3,4,5,6,7,8,9") = 0 THEN
                                ASSIGN l-nr-pedido = YES.
                        END.
                        IF l-nr-pedido THEN
                            MESSAGE "Numero de pedido liberado" 
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        ELSE
                            MESSAGE "Numero do pedido exclusivo para uso no PedMobile!" SKIP
                                    "Utilize uma letra para diferenciar o numero do pedido (Ex: " + numero-pedido + "A)."
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    END.
                END.
                WHEN 3 THEN DO:
                    IF SUBSTRING(numero-pedido,1,4) = STRING(codigo-repres) + "-" THEN DO:
                        c-resto-pedido = REPLACE(numero-pedido,STRING(codigo-repres) + "-","").
                        DO idx = 1 TO LENGTH(STRING(c-resto-pedido)):
                            IF LOOKUP(SUBSTRING(c-resto-pedido,idx,1),"0,1,2,3,4,5,6,7,8,9") = 0 THEN
                                ASSIGN l-nr-pedido = YES.                            
                        END.
                        IF l-nr-pedido THEN
                            MESSAGE "Numero de pedido liberado" 
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        ELSE
                            MESSAGE "Numero do pedido exclusivo para uso no PedMobile!" SKIP
                                    "Utilize uma letra para diferenciar o numero do pedido (Ex: " + numero-pedido + "A)."
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    END.
                END.
                WHEN 4 THEN DO:                    
                    IF SUBSTRING(numero-pedido,1,5) = STRING(codigo-repres) + "-" THEN DO:                        
                        c-resto-pedido = REPLACE(numero-pedido,STRING(codigo-repres) + "-","").
                        DO idx = 1 TO LENGTH(STRING(c-resto-pedido)):
                            IF LOOKUP(SUBSTRING(c-resto-pedido,idx,1),"0,1,2,3,4,5,6,7,8,9") = 0 THEN
                                ASSIGN l-nr-pedido = YES.                            
                        END.
                        IF l-nr-pedido THEN
                            MESSAGE "Numero de pedido liberado" 
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        ELSE
                            MESSAGE "Numero do pedido exclusivo para uso no PedMobile!" SKIP
                                    "Utilize uma letra para diferenciar o numero do pedido (Ex: " + numero-pedido + "A)."
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    END.
                END.
            END CASE.            
        END.        
    END.
END.
