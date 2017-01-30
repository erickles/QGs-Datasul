DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FOR EACH es-repres-docum WHERE YEAR(es-repres-docum.dt-acum) > 2014
                           AND es-repres-docum.atualizado = NO
                           BREAK BY es-repres-docum.dt-acum DESC:

    DO iCont = 1 TO 5:
        
        IF SUBSTR(es-repres-docum.sc-codigo[iCont],5) = "0000" THEN DO:
            DISP iCont                      SKIP
                 es-repres-docum.dt-acum    SKIP
                 SUBSTR(es-repres-docum.sc-codigo[iCont],5).

        END.
            
        OVERLAY(es-repres-docum.sc-codigo[iCont],5) = "2601".

    END.

END.
