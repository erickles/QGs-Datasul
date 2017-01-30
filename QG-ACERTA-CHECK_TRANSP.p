FIND FIRST es-emit-fornec WHERE cod-emitente = 123273.
DISP SUBSTR(es-emit-fornec.char-1,31,1) SKIP
     SUBSTR(es-emit-fornec.char-1,32,1) SKIP
     SUBSTR(es-emit-fornec.char-1,33,10) FORMAT "X(12)" SKIP
     SUBSTR(es-emit-fornec.char-1,43,12) FORMAT "X(12)".

ASSIGN OVERLAY(es-emit-fornec.char-1,33,10) = "".
       
