DEF VAR v_mem   AS MEMPTR       NO-UNDO.
DEF VAR v_dados AS CHARACTER    NO-UNDO.
DEF VAR v_cont  AS INTEGER      NO-UNDO.

FILE-INFO:FILE-NAME = 'C:\pedidos_guy.txt'.

SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

INPUT FROM VALUE(FILE-INFO:FILE-NAME).
    IMPORT v_mem.
INPUT CLOSE.

v_dados = GET-STRING(v_mem,1).

SET-SIZE(v_mem)= 0.

OUTPUT TO "c:\pedidos_guy_2.csv".

PUT "PEDIDO GUY;NOME ABREV PEDIDO;PEDIDO REAL;NOME ABREV CLIENTE; DT IMPLANT;CONT" SKIP.

DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):
    
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ENTRY(v_cont, v_dados, CHR(10)) NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN DO:

        FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.

        PUT UNFORMATTED 
            REPLACE(ENTRY(v_cont, v_dados, CHR(10)),CHR(10),"") ";"            
            REPLACE(TRIM(ws-p-venda.nome-abrev),CHR(10),"")     ";"            
            REPLACE(TRIM(ws-p-venda.nr-pedcli),CHR(10),"")      ";"
            IF AVAIL emitente THEN emitente.nome-abrev ELSE ""  ";"
            ws-p-venda.dt-implant                               ";"
            "1"
            SKIP.
    END.
END.
OUTPUT CLOSE.                 
