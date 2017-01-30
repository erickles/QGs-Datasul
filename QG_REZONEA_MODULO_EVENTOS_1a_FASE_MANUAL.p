DEFINE BUFFER bf-ev-permissao           FOR es-ev-permissao.
DEFINE BUFFER bf-ev-unid-tp-ev-hist     FOR es-ev-unid-tp-ev-hist.
DEFINE BUFFER bf-ev-unid-tp-ev          FOR es-ev-unid-tp-ev.
DEFINE BUFFER bf-ev-unid-vendas         FOR es-ev-unid-vendas.
DEFINE BUFFER bf-ev-unid-vendas-hist    FOR es-ev-unid-vendas-hist.
DEFINE BUFFER bf-ev-regiao-unid         FOR es-ev-regiao-unid.
DEFINE BUFFER bf-ft-gerencias           FOR es-ft-gerencias.

DEFINE VARIABLE cMicroAntiga    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cMicroNova      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRegiaoAntiga   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRegiaoNova     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cGerenciaNova   AS CHARACTER   NO-UNDO FORMAT "X(40)".

UPDATE cMicroAntiga
       cMicroNova
       cRegiaoAntiga
       cRegiaoNova  
       cGerenciaNova.
   
/* Regiao antiga */
FOR EACH es-eventos WHERE TRIM(es-eventos.nome-mic-reg) = TRIM(cMicroAntiga).
    ASSIGN es-eventos.nome-mic-reg  = cMicroNova
           es-eventos.nome-ab-reg   = cRegiaoNova
           es-eventos.unidade-venda = cGerenciaNova.
END.

/*
FOR EACH es-eventos WHERE TRIM(es-eventos.nome-ab-reg) = TRIM(cRegiaoAntiga).
    ASSIGN es-eventos.nome-ab-reg   = cRegiaoNova
           es-eventos.unidade-venda = cGerenciaNova.
END.
*/
FOR EACH es-ev-regiao-unid WHERE TRIM(es-ev-regiao-unid.nome-ab-reg) = TRIM(cRegiaoAntiga):
    FIND FIRST bf-ev-regiao-unid WHERE bf-ev-regiao-unid.unidade-vendas = cGerenciaNova
                                   AND bf-ev-regiao-unid.nome-ab-reg    = cRegiaoNova
                                   NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-ev-regiao-unid THEN
        ASSIGN es-ev-regiao-unid.nome-ab-reg    = cRegiaoNova
               es-ev-regiao-unid.unidade-venda  = cGerenciaNova.
END.

FOR EACH es-ft-gerencias WHERE TRIM(es-ft-gerencias.nome-ab-reg) = TRIM(cRegiaoAntiga).
    FIND FIRST bf-ft-gerencias WHERE bf-ft-gerencias.nome-ab-reg = cRegiaoNova NO-LOCK NO-ERROR.
    IF NOT AVAIL bf-ft-gerencias THEN
        ASSIGN es-ft-gerencias.nome-ab-reg      = cRegiaoNova
               es-ft-gerencias.unidade-venda    = cGerenciaNova.
END.
