DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE cRetorno    AS CHARACTER   NO-UNDO.

OUTPUT TO "C:\Temp\comunica_customer.csv".

PUT "data-envio"    ";" 
    "hora-envio"    ";" 
    "log-envio"     ";" 
    "nome-abrev"    ";" 
    "nr-pedcli"     ";" 
    "sucesso-envio" ";" 
    "tipo"          ";"
    "destino"       ";"
    "atividade"     SKIP.

FOR EACH es-comunica-cliente-envio WHERE /*es-comunica-cliente-envio.data-envio >= 07/01/2016
                                     AND es-comunica-cliente-envio.data-envio <= 07/31/2016
                                     AND*/ es-comunica-cliente-envio.nome-abrev = "217987"
                                     AND (es-comunica-cliente-envio.tipo = "SMS" OR es-comunica-cliente-envio.tipo = "SMS_COBRANCA"):

    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = es-comunica-cliente-envio.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN DO:

        FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
                        
            PUT UNFORM es-comunica-cliente-envio.data-envio                     ";"
                       string(es-comunica-cliente-envio.hora-envio,"HH:MM:SS")  ";"
                       es-comunica-cliente-envio.log-envio                      ";"
                       es-comunica-cliente-envio.nome-abrev                     ";"
                       es-comunica-cliente-envio.nr-pedcli                      ";"
                       es-comunica-cliente-envio.sucesso-envio                  ";"
                       es-comunica-cliente-envio.tipo                           ";"
                       "'" + es-comunica-cliente-envio.destino                  ";"
                       TRIM(REPLACE(es-comunica-cliente-envio.texto-mensagem,CHR(10),""))           ";"
                       es-comunica-cliente-envio.atividade                      SKIP.

        END.

    END.
    
END.

OUTPUT CLOSE.
