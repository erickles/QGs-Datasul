DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
/*DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO FORMAT ">>,>>>,>>>,>>9.99".*/

OUTPUT TO "c:\temp\pedidos_mob.csv".

DEFINE TEMP-TABLE tt-planilha
    FIELD nr-nota-fis   AS CHAR    
    FIELD cod-estabel   AS CHAR
    FIELD serie         AS CHAR
    FIELD dt-emis       AS DATE
    FIELD cancelada     AS LOGICAL.

PUT "Nota"          ";"
    "Estab"         ";"
    "Serie"         ";"
    "Dt. Emis"      ";"
    "Cancelada?"    SKIP.

FOR EACH nota-fiscal WHERE /*nota-fiscal.cod-estabel = "22"
                       AND*/ /*nota-fiscal.emite-duplic = YES
                       AND*/ nota-fiscal.dt-emis >= 02/28/2017
                       AND nota-fiscal.dt-emis <= 02/28/2017
                       /*AND nota-fiscal.dt-canc = ?*/
                       NO-LOCK:
        
    CREATE tt-planilha.
    ASSIGN tt-planilha.nr-nota-fis  = nota-fiscal.nr-nota-fis
           tt-planilha.cod-estabel  = nota-fiscal.cod-estabel
           tt-planilha.serie        = nota-fiscal.serie
           tt-planilha.dt-emis      = nota-fiscal.dt-emis
           tt-planilha.cancelada    = IF nota-fiscal.dt-canc = ? THEN NO ELSE YES.
END.

FOR EACH tt-planilha NO-LOCK:
    
    PUT tt-planilha.nr-nota-fis   ";"
        tt-planilha.cod-estabel   ";"
        tt-planilha.serie         ";"
        tt-planilha.dt-emis       ";"
        tt-planilha.cancelada     SKIP.

END.

OUTPUT CLOSE.
