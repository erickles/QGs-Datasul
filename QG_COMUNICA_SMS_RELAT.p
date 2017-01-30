DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE cRetorno    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lMessageSent AS LOGICAL     NO-UNDO.

OUTPUT TO "C:\Temp\comunica_012017.csv".

PUT "data-envio"    ";" 
    "hora-envio"    ";" 
    "destino"       ";"
    "log-envio"     ";" 
    "nome-abrev"    ";" 
    "nr-pedcli"     ";"
    "STATUS"        ";"
    "cod-emitente"  ";"
    "celular"       ";"
    "fixo"          ";"
    "sucesso-envio" ";" 
    "tipo"          ";" 
    "atividade"     SKIP.

lMessageSent = YES.

FOR EACH es-comunica-cliente-envio WHERE es-comunica-cliente-envio.data-envio >= 12/01/2016
                                     AND es-comunica-cliente-envio.data-envio <= 12/31/2016
                                     AND (es-comunica-cliente-envio.tipo = "SMS" OR es-comunica-cliente-envio.tipo = "SMS_COBRANCA")
                                     NO-LOCK:

    IF NOT lMessageSent AND es-comunica-cliente-envio.log-envio = "MessageSent" THEN NEXT.
    
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = es-comunica-cliente-envio.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN
        FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
    /*
    IF AVAIL ws-p-venda THEN DO:
    */
        /*
        FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
        */                
            PUT UNFORM es-comunica-cliente-envio.data-envio                             ";"
                       STRING(es-comunica-cliente-envio.hora-envio,"HH:MM:SS")          ";"
                       TRIM(es-comunica-cliente-envio.destino)                          ";"
                       es-comunica-cliente-envio.log-envio                              ";"
                       es-comunica-cliente-envio.nome-abrev                             ";"
                       es-comunica-cliente-envio.nr-pedcli                              ";"
                       IF AVAIL ws-p-venda THEN STRING(ws-p-venda.ind-sit-ped) ELSE ""  ";"
                       IF AVAIL emitente THEN emitente.cod-emitente ELSE 0              ";"
                       IF AVAIL emitente THEN emitente.telefone[1] ELSE ""              ";"
                       IF AVAIL emitente THEN emitente.telefone[2] ELSE ""              ";"
                       es-comunica-cliente-envio.sucesso-envio                          ";"
                       es-comunica-cliente-envio.tipo                                   ";"
                       es-comunica-cliente-envio.atividade                              SKIP.

        /*END.*/

    /*END.*/
    /*
    ASSIGN es-comunica-cliente-envio.data-envio = ?
             es-comunica-cliente-envio.log-envio  = "".
    */
END.

OUTPUT CLOSE.
