DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE cRetorno    AS CHARACTER   NO-UNDO.

/*OUTPUT TO "C:\Temp\comunica.csv".*/

FOR EACH es-comunica-cliente-envio WHERE es-comunica-cliente-envio.data-envio >= 06/01/2016
                                     AND es-comunica-cliente-envio.tipo       = "SMS"
                                     AND es-comunica-cliente-envio.destino    = "5511999999999":

    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = es-comunica-cliente-envio.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN DO:

        FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            

            ASSIGN cRetorno = REPLACE(emitente.telefone[1],"(","")
                   cRetorno = REPLACE(cRetorno,")","")
                   cRetorno = REPLACE(cRetorno," ","")
                   cRetorno = REPLACE(cRetorno,"-","")
                   cRetorno = REPLACE(cRetorno,".","")
                   cRetorno = REPLACE(cRetorno,",","")
                   cRetorno = REPLACE(cRetorno,";","")
                   cRetorno = REPLACE(cRetorno,"#","")
                   cRetorno = REPLACE(cRetorno,":","")
                   cRetorno = "55" + cRetorno.

            ASSIGN es-comunica-cliente-envio.destino = cRetorno.
            /*PUT cRetorno SKIP.*/

        END.

    END.
    
END.
/*OUTPUT CLOSE.*/
