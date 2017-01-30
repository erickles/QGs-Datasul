
FOR EACH emitente NO-LOCK WHERE emitente.cod-emitente = 289496:

    /* ESS - Criacao da es-schedule */
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(emitente))
           es-schedule.tabela = "emitente"
           es-schedule.banco  = "mgcad".
    
    FIND FIRST es-emitente-dis WHERE es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(es-emitente-dis))
           es-schedule.tabela = "es-emitente-dis"
           es-schedule.banco  = "mgtor".
    
    FIND FIRST loc-entr WHERE loc-entr.nome-abrev = emitente.nome-abrev NO-LOCK NO-ERROR.
    
    /* ESS - Criacao da es-schedule */
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(loc-entr))
           es-schedule.tabela = "loc-entr"
           es-schedule.banco  = "mgcad".
    
    FIND FIRST es-loc-entr WHERE es-loc-entr.nome-abrev = emitente.nome-abrev NO-LOCK NO-ERROR.
    
    /* ESS - Criacao da es-schedule */
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(es-loc-entr))
           es-schedule.tabela = "es-loc-entr"
           es-schedule.banco  = "mgtor".
    
    /* ESS - Criacao da es-schedule */
    FOR EACH es-loc-entr-rep WHERE es-loc-entr-rep.nome-abrev = emitente.nome-abrev NO-LOCK:
    
        CREATE es-schedule.
        ASSIGN es-schedule.id     = STRING(ROWID(es-loc-entr-rep))
               es-schedule.tabela = "es-loc-entr-rep"
               es-schedule.banco  = "mgtor".
    
    END.

END.


