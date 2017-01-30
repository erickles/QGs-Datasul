/* Dados representante */
FOR EACH pm-rep-param WHERE ind_situacao = 1 NO-LOCK:

    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(pm-rep-param))
           es-schedule.tabela = "pm-rep-param"
           es-schedule.banco  = "mgtor".

    FIND FIRST repres WHERE repres.cod-rep = pm-rep-param.cod_rep NO-LOCK NO-ERROR.
    IF AVAIL repres THEN DO:
        CREATE es-schedule.
        ASSIGN es-schedule.id     = STRING(ROWID(repres))
               es-schedule.tabela = "repres"
               es-schedule.banco  = "mgcad".

        FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = repres.cod-rep NO-LOCK NO-ERROR.
        IF AVAIL es-repres-comis THEN DO:
            CREATE es-schedule.
            ASSIGN es-schedule.id     = STRING(ROWID(es-repres-comis))
                   es-schedule.tabela = "es-repres-comis"
                   es-schedule.banco  = "mgtor".
        END.

        FOR EACH rep-micro NO-LOCK WHERE rep-micro.nome-ab-rep = repres.nome-abrev:
            CREATE es-schedule.
            ASSIGN es-schedule.id     = STRING(ROWID(rep-micro))
                   es-schedule.tabela = "rep-micro"
                   es-schedule.banco  = "mgcad".
        END.

        FOR EACH es-comissao NO-LOCK WHERE es-comissao.cod-rep = repres.cod-rep:
            CREATE es-schedule.
            ASSIGN es-schedule.id     = STRING(ROWID(es-comissao))
                   es-schedule.tabela = "es-comissao"
                   es-schedule.banco  = "mgtor".
        END.

    END.


    FIND FIRST ws-repres NO-LOCK WHERE ws-repres.cod-rep = pm-rep-param.cod_rep NO-ERROR.
    IF AVAIL ws-repres THEN DO:
        CREATE es-schedule.
        ASSIGN es-schedule.id     = STRING(ROWID(ws-repres))
               es-schedule.tabela = "ws-repres"
               es-schedule.banco  = "mgtor".
    END.
END.

FOR EACH es-busca-estabel NO-LOCK:
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(es-busca-estabel))
           es-schedule.tabela = "es-busca-estabel"
           es-schedule.banco  = "mgtor".
END.

FOR EACH es-tab-preco-repres NO-LOCK:
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(es-tab-preco-repres))
           es-schedule.tabela = "es-tab-preco-repres"
           es-schedule.banco  = "mgtor".
END.

FOR EACH es-busca-preco NO-LOCK:
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(es-busca-preco))
           es-schedule.tabela = "es-busca-preco"
           es-schedule.banco  = "mgtor".
END.

FOR EACH es-cfop NO-LOCK WHERE es-cfop.cod-tipo-oper = "1":
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(es-cfop))
           es-schedule.tabela = "es-cfop"
           es-schedule.banco  = "mgtor".
END.

FOR EACH es-concorrente NO-LOCK:
    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(es-concorrente))
           es-schedule.tabela = "es-concorrente"
           es-schedule.banco  = "mgtor".
END.

FOR EACH cond-pagto NO-LOCK WHERE cond-pagto.cod-cond-pag > 499  /* Restringe Condicoes Venda */
                              AND cond-pagto.cod-cond-pag < 1000,
                              FIRST es-cond-pagto OF cond-pagto NO-LOCK
                              WHERE es-cond-pagto.log-1 = TRUE /* Liberada para Web*/ :

    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(cond-pagto))
           es-schedule.tabela = "cond-pagto"
           es-schedule.banco  = "mgcad".

    CREATE es-schedule.
    ASSIGN es-schedule.id     = STRING(ROWID(es-cond-pagto))
           es-schedule.tabela = "es-cond-pagto"
           es-schedule.banco  = "mgtor".

END.
