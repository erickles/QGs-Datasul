DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE cRetorno    AS CHARACTER   NO-UNDO.

/*OUTPUT TO "C:\Temp\comunica.csv".*/

FOR EACH es-comunica-cliente-envio WHERE es-comunica-cliente-envio.data-envio >= 02/01/2016
                                     AND es-comunica-cliente-envio.tipo       = "EMAIL"
                                     AND es-comunica-cliente-envio.destino    = "erick.souza@tortuga.com.br":

    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = es-comunica-cliente-envio.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN DO:

        FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:

            ASSIGN es-comunica-cliente-envio.destino = emitente.e-mail.
            /*PUT cRetorno SKIP.*/

        END.

    END.
    
END.
/*OUTPUT CLOSE.*/
