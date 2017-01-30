
FIND FIRST ITEM WHERE ITEM.it-codigo = "44095387" NO-LOCK NO-ERROR.

/* ESS - Criacao da es-schedule */
CREATE es-schedule.
ASSIGN es-schedule.id     = STRING(ROWID(ITEM))
       es-schedule.tabela = "item"
       es-schedule.banco  = "ems2cad".
