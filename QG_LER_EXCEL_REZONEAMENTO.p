DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD regiao-antiga     AS CHAR FORMAT "X(50)"
    FIELD regiao-nova       AS CHAR FORMAT "X(50)"
    FIELD micro-antiga      AS CHAR FORMAT "X(50)"
    FIELD micro-nova        AS CHAR FORMAT "X(50)"
    FIELD gerencia-antiga   AS CHAR FORMAT "X(50)"
    FIELD gerencia-nova     AS CHAR FORMAT "X(50)".

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\lista_rezoneamento.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";" 
    tt-planilha.regiao-antiga  
    tt-planilha.regiao-nova    
    tt-planilha.micro-antiga   
    tt-planilha.micro-nova     
    tt-planilha.gerencia-antiga
    tt-planilha.gerencia-nova.
END.

INPUT CLOSE.

OUTPUT TO "c:\lista_rezo.csv".
PUT "Regiao Antiga;Regiao Nova;Gerencia Antiga;Gerencia Nova" SKIP.

FOR EACH tt-planilha:
    
    PUT tt-planilha.regiao-antiga   ";"
        tt-planilha.regiao-nova     ";"
        tt-planilha.gerencia-antiga ";"
        tt-planilha.gerencia-nova   SKIP.
END.

OUTPUT CLOSE.
