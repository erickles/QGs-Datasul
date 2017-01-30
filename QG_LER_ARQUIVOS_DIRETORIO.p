DEF VAR vArq AS CHAR EXTENT 3.
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

INPUT from OS-DIR("H:\Arquivos 1_4_2013").
    REPEAT:
      IMPORT vArq.

      IF vArq[3] = "F" THEN DO:
          DISP "Nome:" vArq[1] FORMAT "X(40)" 
               "Path:" vArq[2] 
               "Tipo:" vArq[3].
          iCont = iCont + 1.
      END.
          
   END.
INPUT CLOSE.
