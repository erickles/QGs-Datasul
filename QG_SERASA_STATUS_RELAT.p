{include/i-freeac.i}

OUTPUT TO "C:\Temp\clientes_serasa.csv".

PUT "CODIGO;NOME CLIENTE;DATA;HORARIO;HISTORICO" SKIP.

DEFINE VARIABLE cHistorico AS CHARACTER   NO-UNDO.

FOR EACH es-serasastatus NO-LOCK /*WHERE es-serasastatus.cod-emitente >= 153999 AND es-serasastatus.cod-emitente <= 154010*/ :

    FIND FIRST emitente WHERE emitente.cod-emitente = es-serasastatus.cod-emitente NO-LOCK NO-ERROR.

    FIND LAST his-emit WHERE his-emit.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    IF AVAIL his-emit THEN DO:
        
        ASSIGN cHistorico = ""
               cHistorico = ENTRY(1,his-emit.historico,CHR(10))
               cHistorico = REPLACE(cHistorico,"*","")
               cHistorico = REPLACE(cHistorico,"#","")
               cHistorico = REPLACE(cHistorico,CHR(13),"").

        PUT UNFORM emitente.cod-emitente    ";"
                   emitente.nome-emit       ";"
                   his-emit.dt-his-emit     ";"
                   STRING(his-emit.horario)         ";"
                   cHistorico               SKIP.

    END.

END.

OUTPUT CLOSE.
