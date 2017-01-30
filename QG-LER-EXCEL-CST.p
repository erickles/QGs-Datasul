DEFINE VARIABLE idx         AS INTEGER     NO-UNDO.
DEFINE VARIABLE contador    AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-estab     AS CHAR FORMAT "99"
    FIELD serie         AS CHAR
    FIELD seq           AS INTE
    FIELD doc           AS CHAR
    FIELD cliente       AS INTE
    FIELD produto       AS CHAR FORMAT "9999999"
    FIELD cfop          AS CHAR
    FIELD natur         AS CHAR
    FIELD valor         AS DECI
    FIELD pis_antes     AS CHAR
    FIELD pis_depois    AS CHAR
    FIELD cofins_antes  AS CHAR
    FIELD cofins_depois AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Temp\carimbar16082016.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";" 
    tt-planilha.cod-estab    
    tt-planilha.serie        
    tt-planilha.seq          
    tt-planilha.doc          
    tt-planilha.cliente      
    tt-planilha.produto      
    tt-planilha.cfop         
    tt-planilha.natur        
    tt-planilha.valor        
    tt-planilha.pis_antes    
    tt-planilha.pis_depois   
    tt-planilha.cofins_antes 
    tt-planilha.cofins_depois.
END.
INPUT CLOSE.

DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE cEstab AS CHARACTER   NO-UNDO.

FOR EACH tt-planilha WHERE tt-planilha.cod-estab <> "":
    /*
    DISP tt-planilha.doc        
         tt-planilha.cod-estab  
         tt-planilha.serie      
         tt-planilha.produto    
         tt-planilha.seq WITH 1 COL.
    */    

    IF LENGTH(tt-planilha.cod-estab) = 1 THEN 
        cEstab = ("0" + tt-planilha.cod-estab).
    ELSE 
        cEstab = tt-planilha.cod-estab.

    FIND FIRST it-nota-fisc WHERE it-nota-fisc.nr-nota-fis = "0" + TRIM(tt-planilha.doc)
                              AND it-nota-fisc.cod-estabel = cEstab
                              AND it-nota-fisc.serie       = TRIM(tt-planilha.serie)
                              AND it-nota-fisc.it-codigo   = TRIM(tt-planilha.produto)
                              AND it-nota-fisc.nr-seq-fat  = tt-planilha.seq 
                              NO-ERROR.
    
    IF AVAIL it-nota-fisc THEN DO:
        
        ASSIGN it-nota-fisc.cod-sit-tributar-pis    = "01"
               it-nota-fisc.cod-sit-tributar-cofins = "01".

    END.
        iCont = iCont + 1.
END.

MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
