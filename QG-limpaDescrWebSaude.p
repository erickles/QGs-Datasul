
DEFINE VARIABLE i-linha-produto AS INTEGER     NO-UNDO.

OUTPUT TO "c:\temp\itemSaude.txt".

PUT UNFORMATTED                 
    "Item;"  
    "Descricao;"  
    "Ge;"  
    "Familia;"  
    "DescWeb"  SKIP.

FOR EACH ITEM,
   FIRST es-item 
   WHERE es-item.it-codigo = ITEM.it-codigo
     AND es-item.desc-item-web <> "":

    RUN piClassificaProduto (INPUT ITEM.it-codigo,
                             OUTPUT i-linha-produto).

    IF i-linha-produto <> 2 THEN NEXT.

    PUT UNFORMATTED
        es-item.it-codigo      ";"
        item.desc-item         ";"
        ITEM.ge-codigo         ";"
        ITEM.fm-cod-com        ";"
        es-item.desc-item-web  SKIP. 
    ASSIGN es-item.desc-item-web = "".
END.

OUTPUT CLOSE.

PROCEDURE piClassificaProduto:

    DEFINE INPUT  PARAMETER pcItCodigo    AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER piLinhaProd   AS INTEGER     NO-UNDO.

    DEFINE BUFFER b-item FOR ITEM.

    FOR FIRST b-ITEM FIELDS(it-codigo ge-codigo fm-cod-com) NO-LOCK
        WHERE b-ITEM.it-codigo = pcItCodigo:
    END.
    IF AVAIL b-ITEM THEN DO:

       CASE b-ITEM.ge-codigo:

           WHEN 44 /* Nutricao   */ THEN
               piLinhaProd = 1. 
               
           WHEN 04 /* Saude      */ THEN 
               piLinhaProd = 2. 

           WHEN 42 /* Saude      */ THEN 
               piLinhaProd = 2. 
                                 
          WHEN 43 /* Mitsuisal  */ THEN
               piLinhaProd = 3. 

           WHEN 05 /*            */ THEN DO:

               IF b-ITEM.fm-cod-com = "MATPRIMA" THEN 
                  piLinhaProd = 1. /* Nutricao */

               ELSE IF b-ITEM.fm-cod-com = "AMICI" THEN 
                       piLinhaProd = 2. /* Saude */

                    ELSE IF b-ITEM.it-codigo = "50063042" /* Lacthor */ THEN
                            piLinhaProd = 1. /* Nutricao */

           END.

       END CASE.

    END.

END PROCEDURE.
