OUTPUT TO "C:\temp\cobranca_sms.csv".

FOR EACH es-comunica-cliente-envio WHERE es-comunica-cliente-envio.tipo = "SMS_COBRANCA":

    PUT es-comunica-cliente-envio.texto-mensagem SKIP.
    /*DELETE es-comunica-cliente-envio.*/
END.
OUTPUT CLOSE.
