DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD nr-tab-finan      LIKE tab-finan-indice.nr-tab-finan
    FIELD num-seq           LIKE tab-finan-indice.num-seq
    FIELD tab-dia-fin       LIKE tab-finan-indice.tab-dia-fin
    FIELD tab-ind-fin       LIKE tab-finan-indice.tab-ind-fin.

EMPTY TEMP-TABLE tt-planilha.

DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTabela AS INTEGER     NO-UNDO.

iTabela = 761.

INPUT FROM "C:\Temp\tabelas.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:

    CREATE tt-planilha.
    iCont = iCont + 1.

    IF iCont = 13 THEN DO:
        iTabela = iTabela + 1.
        iCont = 1.
    END.

    ASSIGN tt-planilha.nr-tab-finan = iTabela
           tt-planilha.num-seq      = iCont.
    
   IMPORT DELIMITER ";"
    
    /*tt-planilha.num-seq*/
    tt-planilha.tab-dia-fin
    tt-planilha.tab-ind-fin.

END.
INPUT CLOSE.

/*OUTPUT TO "c:\temp\new.csv".*/

iCont = 0.
FOR EACH tt-planilha NO-LOCK:

    iCont = iCont + 1.

    
    CREATE tab-finan-indice.
    ASSIGN tab-finan-indice.nr-tab-finan = tt-planilha.nr-tab-finan
           tab-finan-indice.num-seq      = tt-planilha.num-seq
           tab-finan-indice.tab-dia-fin  = tt-planilha.tab-dia-fin
           tab-finan-indice.tab-ind-fin  = tt-planilha.tab-ind-fin.
    
    /*
    PUT tt-planilha.nr-tab-finan   ";"
        tt-planilha.num-seq        ";"
        tt-planilha.tab-dia-fin    ";"
        STRING(tt-planilha.tab-ind-fin,">9.99999")    SKIP.
    */
    IF iCont = 366 THEN
        LEAVE.
END.
/*OUTPUT CLOSE.*/
/*
FOR EACH tab-finan-indice WHERE tab-finan-indice.nr-tab-finan >= 761
                            AND tab-finan-indice.nr-tab-finan <= 791:
    DELETE tab-finan-indice.
END.
*/
