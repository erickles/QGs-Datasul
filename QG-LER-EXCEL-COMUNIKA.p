DEFINE VARIABLE idx         AS INTEGER     NO-UNDO.
DEFINE VARIABLE contador    AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD dataenvio         AS CHAR FORMAT "X(30)"
    FIELD remetente         AS CHAR FORMAT "X(30)"
    FIELD destinatario      AS CHAR FORMAT "X(30)"
    FIELD idmsg             AS CHAR FORMAT "X(30)"
    FIELD operador          AS CHAR FORMAT "X(30)"
    FIELD estatus           AS CHAR FORMAT "X(30)"
    FIELD explain           AS CHAR FORMAT "X(30)"
    FIELD conteudo          AS CHAR FORMAT "X(100)"
    FIELD usuario           AS CHAR FORMAT "X(30)"
    FIELD cod-emitente      AS INTE
    FIELD nome-emitente     AS CHAR FORMAT "X(80)"
    FIELD celular           AS CHAR FORMAT "X(20)"
    FIELD nr-pedcli         LIKE ws-p-venda.nr-pedcli
    FIELD sucesso           LIKE es-comunica-cliente-envio.sucesso-envio
    FIELD log-envio         LIKE es-comunica-cliente-envio.log-envio
    FIELD dt-implant        LIKE ws-p-venda.dt-implant.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Junho_Comunika_2013.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";" 
    tt-planilha.dataenvio   
    tt-planilha.remetente   
    tt-planilha.destinatario
    tt-planilha.idmsg       
    tt-planilha.operador    
    tt-planilha.estatus
    tt-planilha.explain     
    tt-planilha.conteudo
    tt-planilha.usuario.
END.
INPUT CLOSE.

FOR EACH tt-planilha WHERE tt-planilha.conteudo <> "":

    /* Acha o pedido */
    idx = INDEX(tt-planilha.conteudo,", vlr").
    IF idx > 0 THEN DO:

        OVERLAY(tt-planilha.conteudo,idx,LENGTH(tt-planilha.conteudo)) = "".

        idx = INDEX(tt-planilha.conteudo,"seu ped ").
        OVERLAY(tt-planilha.conteudo,1,idx) = "".

        tt-planilha.conteudo = REPLACE(tt-planilha.conteudo,"eu ped","").
        ASSIGN tt-planilha.nr-pedcli = TRIM(tt-planilha.conteudo).

        /* Traz o sucesso de envio e o log */
        FIND FIRST es-comunica-cliente-envio WHERE es-comunica-cliente-envio.nr-pedcli = tt-planilha.nr-pedcli
                                                AND es-comunica-cliente-envio.tipo = "SMS"
                                                NO-LOCK NO-ERROR.

        IF AVAIL es-comunica-cliente-envio THEN DO:
            ASSIGN tt-planilha.sucesso   = es-comunica-cliente-envio.sucesso-envio
                    tt-planilha.log-envio = es-comunica-cliente-envio.log-envio.
        END.

        FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = tt-planilha.nr-pedcli NO-LOCK NO-ERROR.
        IF AVAIL ws-p-venda THEN DO:
            ASSIGN tt-planilha.dt-implant = ws-p-venda.dt-implant.
            FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN
                ASSIGN tt-planilha.cod-emitente     = emitente.cod-emitente
                        tt-planilha.nome-emitente    = emitente.nome-emit
                        tt-planilha.celular          = emitente.telefone[1].
        END.

    END.           
        
END.

OUTPUT TO "C:\Relatorio_SMS_JUNHO_2013.CSV".

PUT "Nr Pedido"         ";"
    "Cod Cliente"       ";"
    "Nome Cliente"      ";"
    "Celular"           ";"
    "Data\Hora Envio"   ";"
    "Data Impl Pedido"  ";"
    "Remetente"         ";"
    "Destinatario"      ";"
    "Operador"          ";"
    "Staus"             ";"
    "Usuario"           ";"
    "Sucesso Envio"     ";"
    "LOG Envio"         SKIP.

FOR EACH tt-planilha NO-LOCK WHERE tt-planilha.nr-pedcli <> "" BY tt-planilha.dataenvio:

    PUT tt-planilha.nr-pedcli                   ";"
        tt-planilha.cod-emitente                ";"
        tt-planilha.nome-emitente               ";"
        tt-planilha.celular                     ";"
        tt-planilha.dataenvio                   ";"
        tt-planilha.dt-implant                  ";"
        tt-planilha.destinatario                ";"
        tt-planilha.operador                    ";"
        tt-planilha.estatus                     ";"
        tt-planilha.usuario                     ";"
        tt-planilha.sucesso                     ";"
        tt-planilha.log-envio FORMAT "X(200)"   SKIP.
        
END.

OUTPUT CLOSE.
