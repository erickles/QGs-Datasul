DEF VAR numero AS INTEGER INIT 1 NO-UNDO.
DEF VAR xi AS INTEGER.
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DO iCont =  1 TO 5:

    DO ON ERROR UNDO, LEAVE:

        numero = INTEGER("a").

        /* S¢ exibe abaixo se n∆o ocorrer erro acima */

        MESSAGE "Sucesso de convers∆o!"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

        CATCH erro AS Progress.Lang.ProError: /* Executa somente quando ocorre erro Progress */
        
            /* S¢ entra nesse bloco se ocorrer erro */
            REPEAT xi = 1 TO erro:NumMessages:
                /*
                MESSAGE "C¢digo do Erro: " + STRING(erro:GetMessageNum(xi)) SKIP
                        "Mensagem: " + erro:GetMessage(xi)
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                */
            END.
        END CATCH.
        FINALLY: 
            /*
            MESSAGE "Executa Sempre!"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            */
        END FINALLY. 
    END.
END.
/*
DO ON ERROR UNDO, LEAVE:

   numero = INTEGER("a").
   /* S¢ exibe abaixo se n∆o ocorrer erro acima */
   MESSAGE "Sucesso de convers∆o!"
       VIEW-AS ALERT-BOX INFO BUTTONS OK.

   CATCH erro AS Progress.Lang.ProError: /* Executa somente quando ocorre erro Progress */
      /* S¢ entra nesse bloco se ocorrer erro */
      REPEAT xi = 1 TO erro:NumMessages:
          /*
          MESSAGE "C¢digo do Erro: " + STRING(erro:GetMessageNum(xi)) SKIP
                  "Mensagem: " + erro:GetMessage(xi)
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  */
      END.
   END CATCH.
   FINALLY: 
    /*
      MESSAGE "Executa Sempre!"
              VIEW-AS ALERT-BOX INFO BUTTONS OK.
              */
   END FINALLY. 
END.
*/
