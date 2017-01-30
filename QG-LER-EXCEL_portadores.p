DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD nome-emitente     LIKE emitente.nome-emit.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\clientes_ports.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.cod-emitente
    tt-planilha.nome-emitente.

END.
INPUT CLOSE.

OUTPUT TO "c:\pedidos.csv".

FOR EACH tt-planilha:
    
    FIND FIRST emitente WHERE emitente.cod-emitente = tt-planilha.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:
        FOR EACH ws-p-venda WHERE ws-p-venda.nome-abrev  = emitente.nome-abrev
                              AND ws-p-venda.ind-sit-ped <= 12
                              NO-LOCK:

            FIND FIRST ped-venda WHERE ped-venda.nr-pedcli  = ws-p-venda.nr-pedcli
                                   AND ped-venda.nome-abrev = ws-p-venda.nome-abrev
                                   NO-LOCK NO-ERROR.
            IF AVAIL ped-venda THEN
                PUT emitente.cod-emitente ";"
                    ws-p-venda.nr-pedcli  ";"
                    ped-venda.cod-portador  SKIP.
        END.
    END.

END.

OUTPUT CLOSE.
