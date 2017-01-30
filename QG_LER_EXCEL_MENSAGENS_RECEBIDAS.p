DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD nome-usuario  AS CHAR FORMAT "X(12)"
    FIELD remetente     AS CHAR FORMAT "X(12)"
    FIELD mensagem      AS CHAR FORMAT "X(60)"
    FIELD data-hora     AS CHAR FORMAT "X(20)"
    FIELD lida          AS CHAR FORMAT "X(3)".

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Exemplo_msg.xlsx" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.nome-usuario
    tt-planilha.remetente
    tt-planilha.mensagem
    tt-planilha.data-hora
    tt-planilha.lida.

END.
INPUT CLOSE.

FOR EACH tt-planilha:
    
    DISP tt-planilha.nome-usuario   SKIP
         tt-planilha.remetente      SKIP
         tt-planilha.mensagem       SKIP
         tt-planilha.data-hora      SKIP
         tt-planilha.lida           WITH 1 COL.
END.
