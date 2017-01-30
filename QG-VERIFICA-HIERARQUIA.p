DEFINE VARIABLE v-lista             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-lista2            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-lista-linharep    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-cod-rep           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-cont1             AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-cont2             AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-es-repres-comis    LIKE es-repres-comis.
DEFINE TEMP-TABLE tt-rep-micro          LIKE rep-micro.

UPDATE c-cod-rep.

RUN HierarquiaRepres.

OUTPUT TO "c:\teste.txt".

MESSAGE v-lista
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

PUT UNFORMATTED(v-lista).

OUTPUT CLOSE.


PROCEDURE HierarquiaRepres:

    FIND FIRST ws-sessao WHERE ws-sessao.codigo = INTE(c-cod-rep) NO-LOCK NO-ERROR. 
  
    ASSIGN v-lista          = c-cod-rep
           v-lista2         = ""
           v-lista-linharep = "".
  
    /* Cria Tabelas de Apoio */
    EMPTY TEMP-TABLE tt-es-repres-comis NO-ERROR.
    FOR EACH es-repres-comis NO-LOCK: 
        CREATE tt-es-repres-comis.
        BUFFER-COPY es-repres-comis TO tt-es-repres-comis.
    END.

    EMPTY TEMP-TABLE tt-rep-micro NO-ERROR.
    FOR EACH rep-micro NO-LOCK: 
        CREATE tt-rep-micro.
        BUFFER-COPY rep-micro TO tt-rep-micro.
    END.
  
    /* MVR - Verifica linhas de produto para os codigos do representante */
    RUN pi-check-linha-repres (INPUT c-cod-rep).

    /* Lista de Subordinados do PedWeb */
    DO i-cont2 = 1 TO NUM-ENTRIES(v-lista):
        FIND ws-repres WHERE ws-repres.cod-rep = INT(ENTRY(i-cont2,v-lista)) NO-LOCK NO-ERROR.
        IF AVAIL ws-repres AND ws-repres.subordinado <> "" THEN DO:
            DO i-cont1 = 1 TO NUM-ENTRIES(ws-repres.subordinado):
                if lookup(trim(entry(i-cont1,ws-repres.subordinado)),v-lista) = 0 THEN
                    assign v-lista = v-lista + "," + TRIM(ENTRY(i-cont1,ws-repres.subordinado)).
            end.
        end.   
    end.

    /* MVR - Verifica se e Representante */
    IF ws-sessao.tipo = "REP" THEN DO:
        FIND tt-es-repres-comis WHERE tt-es-repres-comis.cod-rep = ws-sessao.codigo NO-LOCK NO-ERROR.
        IF AVAIL tt-es-repres-comis THEN DO:
            /* MVR - Verifica se e Gerente - Valida ESPD007 apenas se for Gerente - Nao le mais ESPD007 */
            /*IF LOOKUP(tt-es-repres-comis.u-char-2,"GERENTE")> 0 THEN DO:
                RUN pi-check-super.
            END.*/
            MESSAGE tt-es-repres-comis.cod-rep SKIP
                    tt-es-repres-comis.u-char-2 SKIP
                    STRING(INDEX(tt-es-repres-comis.u-char-2,"SUPERVISOR") > 0)
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            /* Verifica se e Supervisor ou Gerente */
            IF INDEX(tt-es-repres-comis.u-char-2,"GERENTE")    > 0 OR
                INDEX(tt-es-repres-comis.u-char-2,"SUPERVISOR") > 0 THEN DO:
                
                /* MVR - Possibilita Visualizar os representantes de acordo com o RepMicro (Gerente e Supervisor ) */
                RUN pi-check-repmicro (INPUT ws-sessao.codigo).
            END.
        END.
    END.
    ELSE DO:
        RUN pi-check-super.
    END.
  
    /* MVR - Possibilita Visualizar Todos os Codigos do Representante */
    RUN pi-check-unificado.
  
    /* Atualiza Lista de Apelidos dos Representantes */
    do i-cont2 = 1 to num-entries(v-lista) :
        find first repres where repres.cod-rep = int(entry(i-cont2,v-lista)) no-lock no-error. 
        if avail repres then 
            if v-lista2 = " " then
                v-lista2 = repres.nome-abrev.
            else
                v-lista2 = v-lista2 + "," + trim(repres.nome-abrev).    
    end.
  
end procedure.

PROCEDURE pi-check-linha-repres:

     DEFINE INPUT  PARAMETER piCodRep    AS INTEGER     NO-UNDO.

     DEFINE VARIABLE i-cod-emitente      AS INTEGER     NO-UNDO.

     /* MVR - Compoe Linhas do Repres */
     FIND tt-es-repres-comis WHERE
          tt-es-repres-comis.cod-rep = piCodRep NO-LOCK NO-ERROR.
     IF AVAIL tt-es-repres-comis THEN DO:

       IF tt-es-repres-comis.cod-emitente <> 0 THEN DO:
          ASSIGN i-cod-emitente = tt-es-repres-comis.cod-emitente.
          FOR EACH tt-es-repres-comis NO-LOCK 
             WHERE tt-es-repres-comis.cod-emitente = i-cod-emitente,
             FIRST repres NO-LOCK
             WHERE repres.cod-rep = tt-es-repres-comis.cod-rep:
             IF LOOKUP(STRING(tt-es-repres-comis.u-int-1),v-lista-linharep) = 0 THEN
                ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN STRING(tt-es-repres-comis.u-int-1)
                                           ELSE v-lista-linharep + "," + STRING(tt-es-repres-comis.u-int-1).                 
          END.
       END.
       ELSE DO:
          IF LOOKUP(STRING(tt-es-repres-comis.u-int-1),v-lista-linharep) = 0 THEN
             ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN STRING(tt-es-repres-comis.u-int-1)
                                       ELSE v-lista-linharep + "," + STRING(tt-es-repres-comis.u-int-1).              
       END.
           
     END.

     /* Grava Linhas Qdo representante e Nutricao e Saude */
     IF LOOKUP('3',v-lista-linharep) > 0 THEN DO:
         IF LOOKUP("1",v-lista-linharep) = 0 THEN ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN "1" ELSE v-lista-linharep + "," + "1".
         IF LOOKUP("2",v-lista-linharep) = 0 THEN ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN "2" ELSE v-lista-linharep + "," + "2".
     END.

     /* Se Nutricao ou Saude tambem enxerga representantes Nutricao e Saude */
     IF LOOKUP('1',v-lista-linharep) > 0 OR LOOKUP('2',v-lista-linharep) > 0 THEN DO:
        ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN "1" ELSE v-lista-linharep + "," + "3".
     END.

END PROCEDURE.

PROCEDURE pi-check-unificado:

    DEFINE VARIABLE piCodEmitente AS INTEGER     NO-UNDO.

    DO i-cont2 = 1 TO NUM-ENTRIES(v-lista):
       FIND FIRST tt-es-repres-comis 
            WHERE tt-es-repres-comis.cod-rep = INT(ENTRY(i-cont2,v-lista)) NO-LOCK NO-ERROR. 
       IF AVAIL tt-es-repres-comis AND tt-es-repres-comis.cod-emitente > 0 THEN DO:
          piCodEmitente = tt-es-repres-comis.cod-emitente.
          FOR EACH tt-es-repres-comis NO-LOCK 
             WHERE tt-es-repres-comis.cod-emitente = piCodEmitente:
             /* Verifica se repres e da mesma linha do principal */
             IF LOOKUP(STRING(tt-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                IF LOOKUP(STRING(tt-es-repres-comis.cod-rep),v-lista) = 0 THEN
                   v-lista = IF v-lista = '' THEN STRING(tt-es-repres-comis.cod-rep)
                             ELSE v-lista + "," + STRING(tt-es-repres-comis.cod-rep).
             END.
          END.
       END.

    END.

END PROCEDURE.

PROCEDURE pi-check-repmicro:

    DEFINE INPUT  PARAMETER pi-cod-rep AS INTEGER     NO-UNDO.

    DEFINE VARIABLE piCodEmitente AS INTEGER     NO-UNDO.

    DEFINE BUFFER b-repres          FOR repres.
    DEFINE BUFFER b-rep-micro       FOR tt-rep-micro.
    DEFINE BUFFER b-es-repres-comis FOR tt-es-repres-comis.

    FIND tt-es-repres-comis WHERE 
         tt-es-repres-comis.cod-rep = pi-cod-rep NO-LOCK NO-ERROR.
    IF AVAIL tt-es-repres-comis THEN DO:
      /* Verifica se e Unificado - nao precisa ver todos os codigos - Regioes serao relacionadas ao codigo principal */
      /*IF tt-es-repres-comis.cod-emitente > 0 THEN DO:
          piCodEmitente = tt-es-repres-comis.cod-emitente.
          FOR EACH tt-es-repres-comis NO-LOCK 
             WHERE tt-es-repres-comis.cod-emitente = piCodEmitente,
             FIRST repres WHERE
                   repres.cod-rep = tt-es-repres-comis.cod-rep NO-LOCK,
              EACH tt-rep-micro NO-LOCK 
                   WHERE tt-rep-micro.nome-ab-rep = repres.nome-abrev:
                /* Se gerente le todos representantes da regiao relacionada */
                IF LOOKUP(tt-es-repres-comis.u-char-2,"GERENTE") > 0 THEN DO:
                    FOR EACH b-rep-micro NO-LOCK 
                       WHERE b-rep-micro.nome-ab-reg = tt-rep-micro.nome-ab-reg
                       BREAK BY b-rep-micro.nome-ab-rep:
                        IF FIRST-OF(b-rep-micro.nome-ab-rep) THEN DO:
                            FIND FIRST b-repres WHERE 
                                       b-repres.nome-abrev = b-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                            IF AVAIL b-repres THEN DO:
                                FIND b-es-repres-comis 
                                    WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                                IF AVAIL b-es-repres-comis THEN DO:
                                    /* Verifica se repres e da mesma linha do principal */
                                    IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                                       IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                                          ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                                    END.
                                END.
                            END.
                        END.                                        
                    END.                        
                END.
                ELSE DO:
                    /* Se supervisor le todas da RepMicro */
                    FOR EACH b-rep-micro NO-LOCK 
                       WHERE b-rep-micro.nome-ab-reg  = tt-rep-micro.nome-ab-reg
                         AND b-rep-micro.nome-mic-reg = tt-rep-micro.nome-mic-reg
                       BREAK BY b-rep-micro.nome-ab-rep:
                        IF FIRST-OF(b-rep-micro.nome-ab-rep) THEN  DO:
                            FIND FIRST b-repres WHERE 
                                       b-repres.nome-abrev = b-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                            IF AVAIL b-repres THEN DO:
                                FIND b-es-repres-comis 
                                    WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                                IF AVAIL b-es-repres-comis THEN DO:
                                    /* Verifica se repres e da mesma linha do principal */
                                    IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                                       IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                                          ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                                    END.
                                END.
                            END.
                        END.                                        
                    END.
                END.                 
          END.
      END.
      ELSE DO:*/
          FOR FIRST repres WHERE
                    repres.cod-rep = tt-es-repres-comis.cod-rep NO-LOCK,
               EACH tt-rep-micro NO-LOCK 
                    WHERE tt-rep-micro.nome-ab-rep = repres.nome-abrev:
                /* Se gerente le todos representantes da regiao relacionada */
                IF LOOKUP(tt-es-repres-comis.u-char-2,"GERENTE") > 0 THEN DO:
                    FOR EACH b-rep-micro NO-LOCK 
                       WHERE b-rep-micro.nome-ab-reg = tt-rep-micro.nome-ab-reg
                       BREAK BY b-rep-micro.nome-ab-rep:
                        IF FIRST-OF(b-rep-micro.nome-ab-rep) THEN DO:
                            FIND FIRST b-repres WHERE 
                                       b-repres.nome-abrev = b-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                            IF AVAIL b-repres THEN DO:
                                FIND b-es-repres-comis 
                                    WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                                IF AVAIL b-es-repres-comis THEN DO:
                                    /* Verifica se repres e da mesma linha do principal */
                                    IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                                       IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                                          ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                                    END.
                                END.
                            END.
                        END.                                        
                    END.                        
                END.
                ELSE DO:
                    /* Se supervisor le todas da RepMicro */
                    FOR EACH b-rep-micro NO-LOCK 
                       WHERE b-rep-micro.nome-ab-reg  = tt-rep-micro.nome-ab-reg
                         AND b-rep-micro.nome-mic-reg = tt-rep-micro.nome-mic-reg
                       BREAK BY b-rep-micro.nome-ab-rep:
                        IF FIRST-OF(b-rep-micro.nome-ab-rep) THEN  DO:
                            FIND FIRST b-repres WHERE 
                                       b-repres.nome-abrev = b-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                            IF AVAIL b-repres THEN DO:
                                FIND b-es-repres-comis 
                                    WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                                IF AVAIL b-es-repres-comis THEN DO:
                                    /* Verifica se repres e da mesma linha do principal */
                                    IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                                       IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                                          ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                                    END.
                                END.
                            END.
                        END.                                        
                    END.
                END.                
          END.
      /*END.*/

    END.

    /* Verifica Acesso as Regioes - Gerente e Supervisor */
    FOR EACH es-usuario-ger NO-LOCK WHERE es-usuario-ger.cod_usuario = ws-sessao.usuario:
        FOR EACH tt-rep-micro NO-LOCK WHERE tt-rep-micro.nome-ab-reg = es-usuario-ger.nome-ab-reg
                                BREAK BY tt-rep-micro.nome-ab-rep
                                      BY tt-rep-micro.nome-ab-reg:
            IF FIRST-OF(tt-rep-micro.nome-ab-rep) THEN  DO:
                FIND FIRST b-repres WHERE 
                           b-repres.nome-abrev = tt-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                IF AVAIL b-repres THEN DO:
                    FIND b-es-repres-comis 
                        WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                    IF AVAIL b-es-repres-comis THEN DO:
                        /* Verifica se repres e da mesma linha do principal */
                        IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                           IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                              ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                        END.
                    END.
                END.
            END.            
        END.
    END.
    
END PROCEDURE.
