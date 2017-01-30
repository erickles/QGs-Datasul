{include/i-buffer.i}
DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD nome-emitente     AS CHAR FORMAT "X(50)"
    FIELD emp               AS INTEGER
    FIELD cod-estab         LIKE estabel.cod-estab
    FIELD esp               AS CHAR FORMAT "X(3)"
    FIELD docto             AS CHAR FORMAT "X(8)"
    FIELD nr-pedcli         LIKE ws-p-venda.nr-pedcli
    FIELD parcela           AS CHAR FORMAT "X(6)"
    FIELD port              AS CHAR FORMAT "X(10)"
    FIELD dt-emis           AS CHAR FORMAT "X(10)"
    FIELD dt-venc           AS CHAR FORMAT "X(10)"
    FIELD saldo             AS DECI
    FIELD dias              AS INTE
    FIELD cod-rep           AS CHAR
    FIELD envio-sms         AS CHAR
    FIELD telefone          AS CHAR FORMAT "X(15)"
    FIELD envio-email       AS CHAR
    FIELD email             AS CHAR FORMAT "X(50)".

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\COBRANCA.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.cod-emitente
    tt-planilha.nome-emitente
    tt-planilha.emp
    tt-planilha.cod-estab
    tt-planilha.esp
    tt-planilha.docto
    tt-planilha.nr-pedcli
    tt-planilha.parcela
    tt-planilha.port
    tt-planilha.dt-emis
    tt-planilha.dt-venc
    tt-planilha.saldo
    tt-planilha.dias
    tt-planilha.cod-rep.

END.
INPUT CLOSE.

OUTPUT TO "c:\COBRANCA_VENCIDOS.CSV".

PUT "Cliente;"
    "Razao Social;"
    "Emp;"
    "Est;"
    "Esp;"
    "Docto;"
    "Pedido;"
    "/Parcela;"
    "Port-M;"
    "Dt.Emissao;"
    "Dt.Vencto;"
    "Saldo(R$);"
    "Dias;"
    "Representante;" 
    "Sucesso no envio SMS;" 
    "No Celular;"
    "Sucesso no envio EMAIL;" 
    "Email destino" SKIP.

FOR EACH tt-planilha WHERE tt-planilha.cod-emitente <> 0:

    FIND FIRST es-comunica-cliente-envio WHERE es-comunica-cliente-envio.nr-pedcli = tt-planilha.nr-pedcli
                                           AND es-comunica-cliente-envio.tipo = "SMS" 
                                           NO-LOCK NO-ERROR.

    IF AVAIL es-comunica-cliente-envio THEN DO:
        IF es-comunica-cliente-envio.sucesso-envio THEN
            ASSIGN tt-planilha.envio-sms  = "Sim"
                   tt-planilha.telefone   = es-comunica-cliente-envio.destino.
        ELSE
            ASSIGN tt-planilha.envio-sms  = "Nao"
                   tt-planilha.telefone   = es-comunica-cliente-envio.destino.
    END.

    FIND FIRST es-comunica-cliente-envio WHERE es-comunica-cliente-envio.nr-pedcli = tt-planilha.nr-pedcli
                                           AND es-comunica-cliente-envio.tipo = "EMAIL" 
                                           NO-LOCK NO-ERROR.

    IF AVAIL es-comunica-cliente-envio THEN DO:
        IF es-comunica-cliente-envio.sucesso-envio THEN
            ASSIGN tt-planilha.envio-email  = "Sim"
                   tt-planilha.email   = es-comunica-cliente-envio.destino.
        ELSE
            ASSIGN tt-planilha.envio-email  = "Nao"
                   tt-planilha.email   = es-comunica-cliente-envio.destino.
    END.

    PUT tt-planilha.cod-emitente   ";"
        tt-planilha.nome-emitente  ";"
        tt-planilha.emp            ";"
        tt-planilha.cod-estab      ";"
        tt-planilha.esp            ";"
        tt-planilha.docto          ";"
        tt-planilha.nr-pedcli      ";"
        tt-planilha.parcela        ";"
        tt-planilha.port           ";"
        tt-planilha.dt-emis        ";"
        tt-planilha.dt-venc        ";"
        tt-planilha.saldo          ";"
        "- " + STRING(tt-planilha.dias)           ";"
        tt-planilha.cod-rep        ";"
        tt-planilha.envio-sms      ";"
        tt-planilha.telefone       ";"
        tt-planilha.envio-email    ";"
        tt-planilha.email           SKIP.
END.

OUTPUT CLOSE.
