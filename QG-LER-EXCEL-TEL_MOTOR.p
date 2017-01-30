DEFINE VARIABLE idx         AS INTEGER     NO-UNDO.
DEFINE VARIABLE contador    AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cgc           AS CHAR
    FIELD telefone      AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\motoristas.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";" 
    tt-planilha.cgc
    tt-planilha.telefone.
END.
INPUT CLOSE.

FOR EACH tt-planilha:

    ASSIGN tt-planilha.telefone = REPLACE(tt-planilha.telefone," ","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"a","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"b","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"c","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"d","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"e","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"f","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"g","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"h","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"i","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"j","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"k","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"l","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"m","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"n","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"o","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"p","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"q","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"r","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"s","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"t","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"u","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"v","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"w","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"X","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"Y","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"z","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"\","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"/","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"-","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,".","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"_","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"(","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,")","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"*","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"#","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"!","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,",","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"}","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"[","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"]","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"'","")
           tt-planilha.telefone = REPLACE(tt-planilha.telefone,"|","").
    
END.

FOR EACH tt-planilha:

    DISP tt-planilha.cgc     
         tt-planilha.telefone FORMAT "X(10)".
END.
