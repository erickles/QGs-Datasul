DEFINE VARIABLE cNomModelo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iLin               AS INTEGER     NO-UNDO.
DEFINE VARIABLE hAcomp             AS HANDLE      NO-UNDO.
DEFINE VARIABLE iCont              AS INTEGER     NO-UNDO.
DEFINE VARIABLE cCodCidade         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodEstado         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cList              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cNomAux            AS CHARACTER   NO-UNDO.

DEFINE VARIABLE regiaoini  AS CHAR NO-UNDO.
DEFINE VARIABLE regiaofim  AS CHAR NO-UNDO.
DEFINE VARIABLE microini   AS CHAR NO-UNDO.
DEFINE VARIABLE microfim   AS CHAR NO-UNDO.
DEFINE VARIABLE codrepini  AS INTE NO-UNDO.
DEFINE VARIABLE codrepfim  AS INTE NO-UNDO.
DEFINE VARIABLE c-estado   AS CHAR NO-UNDO.
DEFINE VARIABLE c-cidade   AS CHAR NO-UNDO.

ASSIGN c-estado = "SP".

DEFINE TEMP-TABLE ttRepres NO-UNDO
    FIELD cod-rep       LIKE repres.cod-rep
    FIELD nome-emp      LIKE repres.nome
    FIELD responsavel   LIKE cont-repres.nome
    FIELD nome-ab-reg   LIKE rep-micro.nome-ab-reg
    FIELD nome-mic-reg  LIKE rep-micro.nome-mic-reg
    FIELD cidade        LIKE loc-mr.cidade
    FIELD estado        LIKE loc-mr.estado
    FIELD telefone      LIKE repres.telefone
    FIELD gerencia      LIKE regiao.nome-regiao
    FIELD sede          AS CHARACTER
    FIELD cod-cidade    AS CHARACTER
    FIELD cod-estado    AS CHARACTER
    FIELD linha-produto AS CHARACTER
    FIELD atuacao       AS CHARACTER
    INDEX idxRep gerencia nome-ab-reg nome-mic-reg nome-emp.

DEFINE VARIABLE c-linha-produto AS CHARACTER EXTENT 4 INITIAL ["Nutri‡Æo","Sa£de","Nutri‡Æo/Sa£de","Mitsuisal"] NO-UNDO.

/*Recuperando os Representantes*/
FOR EACH regiao WHERE regiao.nome-ab-reg >= ""
                  AND regiao.nome-ab-reg <= "zzzzzzzzzzz" NO-LOCK,
                  EACH micro-reg OF regiao NO-LOCK WHERE micro-reg.nome-mic-reg >= ""
                                                     AND micro-reg.nome-mic-reg <= "zzzzzzzzzz"
                                                     AND ((micro-reg.nome-ab-reg >= "" 
                                                     AND micro-reg.nome-ab-reg <= "zzzzzzzzzz") OR micro-reg.nome-ab-reg = ""):
    
    bloco_principal:
    FOR EACH rep-micro NO-LOCK
        WHERE rep-micro.nome-mic-reg = micro-reg.nome-mic-reg,
        FIRST repres NO-LOCK WHERE repres.nome-abrev = rep-micro.nome-ab-rep
                               AND repres.cod-rep >= 0
                               AND repres.cod-rep <= 99999,
        FIRST es-repres-comis OF repres NO-LOCK
        WHERE (es-repres-comis.situacao = 1 OR es-repres-comis.situacao = 4)
          AND es-repres-comis.u-int-2   = 0
          AND es-repres-comis.log-1:
        
        IF CAN-find(FIRST ttRepres
                    WHERE ttRepres.nome-ab-reg = micro-reg.nome-ab-reg
                      AND ttRepres.nome-mic-reg = micro-reg.nome-mic-reg) THEN LEAVE bloco_principal.
        FIND FIRST cont-repres NO-LOCK WHERE cont-repres.cod-rep = repres.cod-rep NO-ERROR.

        IF CAN-FIND(FIRST loc-mr WHERE loc-mr.nome-ab-reg  = micro-reg.nome-ab-reg
                                   AND loc-mr.nome-mic-reg = micro-reg.nome-mic-reg) THEN DO:
            FOR EACH loc-mr NO-LOCK
                WHERE loc-mr.nome-ab-reg  = micro-reg.nome-ab-reg
                  AND loc-mr.nome-mic-reg = micro-reg.nome-mic-reg:

                ASSIGN cCodCidade = "" cCodEstado = "".
                FIND FIRST es-cidade NO-LOCK
                     WHERE es-cidade.cidade = loc-mr.cidade
                       AND es-cidade.estado = loc-mr.estado NO-ERROR.

                IF c-estado <> "" THEN DO:
                    IF c-cidade = "" AND loc-mr.estado <> c-estado THEN NEXT.
                    ELSE IF c-cidade <> "" AND (loc-mr.cidade <> c-cidade OR loc-mr.estado <> c-estado) THEN NEXT.
                END.

                IF AVAIL es-cidade THEN
                    ASSIGN cCodCidade = STRING(es-cidade.cod-cidade)
                           cCodEstado = SUBSTRING(STRING(es-cidade.cod-cidade),1,2).

                MESSAGE IF AVAIL regiao THEN regiao.nome-regiao ELSE ""                                                                                                             SKIP
                    IF AVAIL repres THEN repres.cod-rep ELSE 0                                                                                                                  SKIP
                    IF AVAIL cont-repres THEN cont-repres.nome ELSE ""                                                                                                          SKIP
                    micro-reg.desc-mic-reg                                                                                                                                      SKIP
                    IF AVAIL repres THEN repres.nome ELSE ""                                                                                                                    SKIP
                    micro-reg.nome-ab-reg                                                                                                                                       SKIP
                    micro-reg.nome-mic-reg                                                                                                                                      SKIP
                    IF AVAIL loc-mr THEN loc-mr.cidade ELSE ""                                                                                                                  SKIP
                    IF AVAIL loc-mr THEN loc-mr.estado ELSE ""                                                                                                                  SKIP
                    cCodCidade                                                                                                                                                  SKIP
                    cCodEstado                                                                                                                                                  SKIP
                    c-linha-produto[es-repres-comis.u-int-1]                                                                                                                    SKIP
                    IF AVAIL repres THEN repres.telefone[1] ELSE ""                                                                                                             SKIP
                    IF AVAIL repres THEN repres.telefone[2] ELSE ""                                                                                                             SKIP
                    SUBSTRING(es-repres-comis.u-char-2,1,26) + IF SUBSTRING(es-repres-comis.char-1,21,20) <> " " THEN " - " + SUBSTRING(es-repres-comis.char-1,21,20) ELSE ""   
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
        END.
        ELSE DO:
            ASSIGN cCodCidade = "" cCodEstado = "".
            MESSAGE IF AVAIL regiao THEN regiao.nome-regiao ELSE ""                                                                                                             SKIP
                    IF AVAIL repres THEN repres.cod-rep ELSE 0                                                                                                                  SKIP
                    IF AVAIL cont-repres THEN cont-repres.nome ELSE ""                                                                                                          SKIP
                    micro-reg.desc-mic-reg                                                                                                                                      SKIP
                    IF AVAIL repres THEN repres.nome ELSE ""                                                                                                                    SKIP
                    micro-reg.nome-ab-reg                                                                                                                                       SKIP
                    micro-reg.nome-mic-reg                                                                                                                                      SKIP
                    IF AVAIL loc-mr THEN loc-mr.cidade ELSE ""                                                                                                                  SKIP
                    IF AVAIL loc-mr THEN loc-mr.estado ELSE ""                                                                                                                  SKIP
                    cCodCidade                                                                                                                                                  SKIP
                    cCodEstado                                                                                                                                                  SKIP
                    c-linha-produto[es-repres-comis.u-int-1]                                                                                                                    SKIP
                    IF AVAIL repres THEN repres.telefone[1] ELSE ""                                                                                                             SKIP
                    IF AVAIL repres THEN repres.telefone[2] ELSE ""                                                                                                             SKIP
                    SUBSTRING(es-repres-comis.u-char-2,1,26) + IF SUBSTRING(es-repres-comis.char-1,21,20) <> " " THEN " - " + SUBSTRING(es-repres-comis.char-1,21,20) ELSE ""   
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.

END.

FOR EACH ttRepres:
    MESSAGE ttRepres.gerencia       SKIP
            ttRepres.cod-rep        SKIP
            ttRepres.responsavel    SKIP
            ttRepres.sede           SKIP
            ttRepres.nome-emp       SKIP
            ttRepres.nome-ab-reg    SKIP
            ttRepres.nome-mic-reg   SKIP
            ttRepres.cidade         SKIP
            ttRepres.estado         SKIP
            ttRepres.cod-cidade     SKIP
            ttRepres.cod-estado     SKIP
            ttRepres.linha-produto  SKIP
            ttRepres.telefone[1]    SKIP
            ttRepres.telefone[2]    SKIP
            ttRepres.atuacao        
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

PROCEDURE pi-cria-tt:
    CREATE ttRepres.
    ASSIGN ttRepres.gerencia      = IF AVAIL regiao THEN regiao.nome-regiao ELSE ""
           ttRepres.cod-rep       = IF AVAIL repres THEN repres.cod-rep ELSE 0
           ttRepres.responsavel   = IF AVAIL cont-repres THEN cont-repres.nome ELSE ""
           ttRepres.sede          = micro-reg.desc-mic-reg
           ttRepres.nome-emp      = IF AVAIL repres THEN repres.nome ELSE ""
           ttRepres.nome-ab-reg   = micro-reg.nome-ab-reg 
           ttRepres.nome-mic-reg  = micro-reg.nome-mic-reg
           ttRepres.cidade        = IF AVAIL loc-mr THEN loc-mr.cidade ELSE ""
           ttRepres.estado        = IF AVAIL loc-mr THEN loc-mr.estado ELSE ""
           ttRepres.cod-cidade    = cCodCidade
           ttRepres.cod-estado    = cCodEstado
           ttRepres.linha-produto = c-linha-produto[es-repres-comis.u-int-1] 
           ttRepres.telefone[1]   = IF AVAIL repres THEN repres.telefone[1] ELSE ""
           ttRepres.telefone[2]   = IF AVAIL repres THEN repres.telefone[2] ELSE ""
           ttRepres.atuacao       = SUBSTRING(es-repres-comis.u-char-2,1,26) + IF SUBSTRING(es-repres-comis.char-1,21,20) <> " " THEN " - " + SUBSTRING(es-repres-comis.char-1,21,20) ELSE "".
END PROCEDURE.
