/* Deleta */
FOR EACH es-ev-permissao:
    DELETE es-ev-permissao.
END.

FOR EACH es-ev-ocorrencias:
    DELETE es-ev-ocorrencias.
END.


FOR EACH es-ev-regiao-unid:
    DELETE es-ev-regiao-unid.
END.


FOR EACH es-eventos:
    DELETE es-eventos.
END.


FOR EACH es-ft-gerencias:
    DELETE es-ft-gerencias.
END.


FOR EACH es-ev-unid-tp-ev-hist:
    DELETE es-ev-unid-tp-ev-hist.
END.


FOR EACH es-ev-unid-tp-ev:
    DELETE es-ev-unid-tp-ev.
END.


FOR EACH es-ev-unid-vendas:
    DELETE es-ev-unid-vendas.
END.

FOR EACH es-ev-unid-vendas-hist:
    DELETE es-ev-unid-vendas-hist.
END.

/* Traz de volta */
INPUT FROM C:\es-ev-permissao.d.
REPEAT:
    CREATE es-ev-permissao.
    IMPORT es-ev-permissao.
END.

INPUT FROM C:\es-ev-regiao-unid.d.
REPEAT:
    CREATE es-ev-regiao-unid.
    IMPORT es-ev-regiao-unid.
END.


INPUT FROM C:\es-eventos.d.
REPEAT:
    CREATE es-eventos.
    IMPORT es-eventos.
END.


INPUT FROM C:\es-ev-ocorrencias.d.
REPEAT:
    CREATE es-ev-ocorrencias.
    IMPORT es-ev-ocorrencias.
END.


INPUT FROM C:\es-ft-gerencias.d.
REPEAT:
    CREATE es-ft-gerencias.
    IMPORT es-ft-gerencias.
END.

INPUT FROM C:\es-ev-unid-tp-ev-hist.d.
REPEAT:
    CREATE es-ev-unid-tp-ev-hist.
    IMPORT es-ev-unid-tp-ev-hist.
END.


INPUT FROM C:\es-ev-unid-tp-ev.d.
REPEAT:
    CREATE es-ev-unid-tp-ev.
    IMPORT es-ev-unid-tp-ev.
END.


INPUT FROM C:\es-ev-unid-vendas.d.
REPEAT:
    CREATE es-ev-unid-vendas.
    IMPORT es-ev-unid-vendas.
END.


INPUT FROM C:\es-ev-unid-vendas-hist.d.
REPEAT:
    CREATE es-ev-unid-vendas-hist.
    IMPORT es-ev-unid-vendas-hist.
END.
