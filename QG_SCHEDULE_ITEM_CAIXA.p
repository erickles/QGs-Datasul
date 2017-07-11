
FIND FIRST ITEM-caixa WHERE ITEM-caixa.it-codigo = "59217765" NO-LOCK NO-ERROR.

/* ESS - Criacao da es-schedule */
CREATE es-schedule.
ASSIGN es-schedule.id     = STRING(ROWID(item-caixa))
       es-schedule.tabela = "item-caixa"
       es-schedule.banco  = "mgcad".
