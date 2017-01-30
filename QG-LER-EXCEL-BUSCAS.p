DEFINE VARIABLE idx         AS INTEGER     NO-UNDO.
DEFINE VARIABLE contador    AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD nrbusca           AS INTE.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Buscas.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";" 
    tt-planilha.nrbusca.
END.
INPUT CLOSE.

FOR EACH tt-planilha:

    FOR EACH es-busca-preco WHERE es-busca-preco.nr-busca = tt-planilha.nrbusca:
        ASSIGN es-busca-preco.data-2 = 12/31/2012.
    END.
    
END.
