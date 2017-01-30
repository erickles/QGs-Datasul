DEFINE VARIABLE c-it-codigo LIKE ITEM.it-codigo  NO-UNDO.

DEF BUFFER b-movto-estoq FOR movto-estoq.

FOR EACH movto-estoq
    WHERE movto-estoq.it-codigo = "11002050"
    AND   movto-estoq.dt-trans  >= 09/01/2009
    AND   (movto-estoq.esp-docto    = 28  OR
           movto-estoq.esp-docto     = 31 )
    NO-LOCK :


    RUN pi-ordem(INPUT movto-estoq.nr-ord-prod,
                 OUTPUT c-it-codigo).

    DISP c-it-codigo.

END.


PROCEDURE pi-ordem:

    DEFINE INPUT  PARAMETER i-ordem   AS INTE.
    DEFINE OUTPUT PARAMETER c-item    AS CHAR.

    /*
    MESSAGE "Numero Ordem : " i-ordem SKIP
            "Codigo Item  : " c-it-codigo
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */

    FIND FIRST ord-prod
        WHERE ord-prod.nr-ord-prod = i-ordem NO-LOCK NO-ERROR.


    IF AVAIL ord-prod THEN DO:

        IF SUBSTRING(ord-prod.it-codigo,1,1) <> "4" THEN DO:

/*             MESSAGE "Existe Ordem de Produ‡Æo" SKIP  */
/*                     ord-prod.nr-ord-prod SKIP        */
/*                     ord-prod.it-codigo SKIP          */
/*                     ord-prod.lote                    */
/*                 VIEW-AS ALERT-BOX INFO BUTTONS OK.   */

            ASSIGN c-item = ord-prod.it-codigo.
            /*
            MESSAGE "C-ITEM : " c-item
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            */
            
            FOR EACH  b-movto-estoq
                WHERE b-movto-estoq.it-codigo = ord-prod.it-codigo
                AND   b-movto-estoq.lote      = ord-prod.lote 
                AND   (b-movto-estoq.esp-docto    = 28  OR
                       b-movto-estoq.esp-docto    = 31 )  
                NO-LOCK:
                /*
                MESSAGE "Movimento Estoque" SKIP
                        b-movto-estoq.it-codigo SKIP      
                        STRING(b-movto-estoq.esp-docto) SKIP
                        b-movto-estoq.nr-ord-prod
                    VIEW-AS ALERT-BOX INFO BUTTONS OK. 
                */
                RUN pi-ordem(INPUT b-movto-estoq.nr-ord-prod,
                             OUTPUT c-item).

            END.
        END.
        ELSE DO:
            ASSIGN c-item = ord-prod.it-codigo.
            /*
            MESSAGE "Item acabado" SKIP
                    ord-prod.nr-ord-prod SKIP
                    ord-prod.it-codigo SKIP
                    ord-prod.lote SKIP
                    "c-item : " c-item
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
           */

        END.
    END.
END PROCEDURE.
