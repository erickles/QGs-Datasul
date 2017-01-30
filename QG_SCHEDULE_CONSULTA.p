
FIND FIRST es-consulta WHERE es-consulta.nr-consulta = 68140 NO-LOCK NO-ERROR.
IF AVAIL es-consulta THEN DO:
    FOR EACH es-consulta-ped OF es-consulta NO-LOCK:
        CREATE es-schedule.
        ASSIGN es-schedule.id     = STRING(ROWID(es-consulta-ped))
               es-schedule.tabela = "es-consulta-ped"
               es-schedule.banco  = "mgtor".
    END.

    /* ESS - Criacao da es-schedule */
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(es-consulta))
           es-schedule.tabela = "es-consulta"
           es-schedule.banco  = "mgtor".

END.
