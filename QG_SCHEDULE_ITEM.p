
FIND FIRST ITEM WHERE ITEM.it-codigo = "59217765" NO-LOCK NO-ERROR.

/* ESS - Criacao da es-schedule */
CREATE es-schedule.
ASSIGN es-schedule.id     = STRING(ROWID(ITEM))
       es-schedule.tabela = "item"
       es-schedule.banco  = "mgcad".

FIND FIRST ITEM-caixa WHERE ITEM-caixa.it-codigo = "59217765" NO-LOCK NO-ERROR.

/* ESS - Criacao da es-schedule */
CREATE es-schedule.
ASSIGN es-schedule.id     = STRING(ROWID(item-caixa))
       es-schedule.tabela = "item-caixa"
       es-schedule.banco  = "mgcad".

FIND FIRST es-item WHERE es-item.it-codigo = "59217765" NO-LOCK NO-ERROR.

/* ESS - Criacao da es-schedule */
CREATE es-schedule.
ASSIGN es-schedule.id     = STRING(ROWID(es-item))
       es-schedule.tabela = "es-item"
       es-schedule.banco  = "mgtor".

