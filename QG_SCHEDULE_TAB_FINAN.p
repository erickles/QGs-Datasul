
FOR EACH tab-finan NO-LOCK WHERE tab-finan.dt-fim-val >= TODAY:
    
    FOR EACH tab-finan-indice WHERE tab-finan-indice.nr-tab-finan = tab-finan.nr-tab-finan NO-LOCK:

        IF tab-finan-indice.nr-tab-finan = 763 THEN
       
        CREATE es-schedule.
        ASSIGN es-schedule.id     = STRING(ROWID(tab-finan-indice))
               es-schedule.tabela = "tab-finan-indice"
               es-schedule.banco  = "mgcad".

    END.

    /* ESS - Criacao da es-schedule */
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(tab-finan))
           es-schedule.tabela = "tab-finan"
           es-schedule.banco  = "mgcad".

END.

/*
FOR EACH es-schedule WHERE es-schedule.tabela = "tab-finan" NO-LOCK:
    MESSAGE "OK"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
*/
