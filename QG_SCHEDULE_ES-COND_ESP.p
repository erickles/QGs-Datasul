
FIND FIRST pm-rep-param WHERE pm-rep-param.cod_rep = 3000 NO-LOCK NO-ERROR.

/* ESS - Criacao da es-schedule */
CREATE es-schedule.
ASSIGN es-schedule.id     = STRING(ROWID(pm-rep-param))
       es-schedule.tabela = "pm-rep-param"
       es-schedule.banco  = "mgtor".
