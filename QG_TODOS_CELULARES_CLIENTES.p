{include/i-freeac.i}

OUTPUT TO "c:\temp\celular_clientes.csv".

DEFINE VARIABLE cRetorno AS CHARACTER   NO-UNDO.

FOR EACH emitente NO-LOCK WHERE emitente.telefone[1] <> "":    
    
    ASSIGN cRetorno = REPLACE(emitente.telefone[1],"(","")
           cRetorno = REPLACE(cRetorno,")","")
           cRetorno = REPLACE(cRetorno,"}","")
           cRetorno = REPLACE(cRetorno,"\","")
           cRetorno = REPLACE(cRetorno,"/","")
           cRetorno = REPLACE(cRetorno," ","")
           cRetorno = REPLACE(cRetorno,"-","")
           cRetorno = REPLACE(cRetorno,".","")
           cRetorno = REPLACE(cRetorno,",","")
           cRetorno = REPLACE(cRetorno,";","")
           cRetorno = REPLACE(cRetorno,"#","")
           cRetorno = REPLACE(cRetorno,"*","")
           cRetorno = REPLACE(cRetorno,"+","")
           cRetorno = REPLACE(cRetorno,"-","")
           cRetorno = REPLACE(cRetorno,"&","")
           cRetorno = REPLACE(cRetorno,"%","")
           cRetorno = REPLACE(cRetorno,"$","")
           cRetorno = REPLACE(cRetorno,":","")
           cRetorno = "55" + cRetorno.

    ASSIGN cRetorno = fn-free-accent(cRetorno).

    ASSIGN cRetorno = REPLACE(cRetorno,"}","").

    ASSIGN cRetorno = CAPS(cRetorno).

    ASSIGN cRetorno = REPLACE(cRetorno,"A","")
           cRetorno = REPLACE(cRetorno,"B","")
           cRetorno = REPLACE(cRetorno,"C","")
           cRetorno = REPLACE(cRetorno,"D","")
           cRetorno = REPLACE(cRetorno,"E","")
           cRetorno = REPLACE(cRetorno,"F","")
           cRetorno = REPLACE(cRetorno,"G","")
           cRetorno = REPLACE(cRetorno,"H","")
           cRetorno = REPLACE(cRetorno,"I","")
           cRetorno = REPLACE(cRetorno,"J","")
           cRetorno = REPLACE(cRetorno,"K","")
           cRetorno = REPLACE(cRetorno,"L","")
           cRetorno = REPLACE(cRetorno,"M","")
           cRetorno = REPLACE(cRetorno,"N","")
           cRetorno = REPLACE(cRetorno,"O","")
           cRetorno = REPLACE(cRetorno,"P","")
           cRetorno = REPLACE(cRetorno,"Q","")
           cRetorno = REPLACE(cRetorno,"R","")
           cRetorno = REPLACE(cRetorno,"S","")
           cRetorno = REPLACE(cRetorno,"T","")
           cRetorno = REPLACE(cRetorno,"U","")
           cRetorno = REPLACE(cRetorno,"V","")
           cRetorno = REPLACE(cRetorno,"W","")
           cRetorno = REPLACE(cRetorno,"X","")
           cRetorno = REPLACE(cRetorno,"Y","")
           cRetorno = REPLACE(cRetorno,"Z","").

    IF LENGTH(cRetorno) < 10 THEN
        NEXT.

    PUT UNFORM cRetorno SKIP.    

END.

OUTPUT CLOSE.
