{include/i-freeac.i}
DEFINE VARIABLE atuacao         AS CHARACTER   NO-UNDO  FORMAT "X(15)".
DEFINE VARIABLE c-gerente       AS CHARACTER   NO-UNDO  FORMAT "X(30)".
DEFINE VARIABLE c-supervisor    AS CHARACTER   NO-UNDO  FORMAT "X(30)".

DEFINE BUFFER supervisor        FOR repres.
DEFINE BUFFER gerente           FOR repres.
DEFINE BUFFER supervisor-comis  FOR es-repres-comis.
DEFINE BUFFER gerente-comis     FOR es-repres-comis.

DEFINE VARIABLE c-status AS CHARACTER EXTENT 5 INITIAL ["ATIVO","ATIVO UNIFICADO","SUSPENSO FINANCEIRO","SUSPENSO COMERCIAL","DISTRATADO"] NO-UNDO.

OUTPUT TO "C:\Nomenclatura.txt".

FOR EACH repres WHERE repres.cod-rep = 1459 NO-LOCK,
    EACH rep-micro WHERE rep-micro.nome-ab-rep = repres.nome-abrev,
    FIRST micro-reg WHERE micro-reg.nome-mic-reg = rep-micro.nome-mic-reg,
    FIRST loc-mr WHERE loc-mr.nome-ab-reg  = micro-reg.nome-ab-reg 
                   AND loc-mr.nome-mic-reg = micro-reg.nome-mic-reg,
                    FIRST es-repres-comis WHERE es-repres-comis.cod-rep = repres.cod-rep:

    FIND FIRST cont-repres WHERE cont-repres.cod-rep = repres.cod-rep NO-LOCK NO-ERROR.

    FOR EACH supervisor-comis WHERE TRIM(supervisor-comis.u-char-2) = "SUPERVISOR",
        EACH supervisor WHERE supervisor.nome-ab-reg = micro-reg.nome-ab-reg
                          AND supervisor.cod-rep = supervisor-comis.cod-rep 
                          AND supervisor-comis.situacao = 1    NO-LOCK:

            ASSIGN c-supervisor = STRING(STRING(supervisor.cod-rep) + " - " + supervisor.nome).
    END.

    FOR EACH gerente-comis WHERE TRIM(gerente-comis.u-char-2) = "GERENTE",
        EACH gerente WHERE gerente.nome-ab-reg = micro-reg.nome-ab-reg
                       AND gerente.cod-rep = gerente-comis.cod-rep 
                       AND gerente-comis.situacao = 1 NO-LOCK:

            ASSIGN c-gerente = STRING(STRING(gerente.cod-rep) + " - " + gerente.nome).
    END.
    
    PUT repres.cod-rep                                                                                          "   "
        micro-reg.nome-ab-reg                                                                                   "   "
        rep-micro.nome-mic-reg                                                                                  "   "
        repres.nome                                                                                             "   "
        cont-repres.nome                                                                                        "   "
        micro-reg.desc-mic-reg                                                                                  "   " 
        STRING(TRIM(es-repres-comis.char-1 + " - " + fn-free-accent(es-repres-comis.u-char-2))) FORMAT "X(40)"  "   "
        loc-mr.cidade                                                                                           "   "
        loc-mr.estado                                                                                           "   "
        c-supervisor                                                                                            "   "
        c-gerente                                                                                               "   "
        c-status[es-repres-comis.situacao]                                                                      "   "    
        SKIP.
END.

OUTPUT CLOSE.
