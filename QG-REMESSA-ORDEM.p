DEFINE TEMP-TABLE tt-cfop NO-UNDO
    FIELD r-rowid-item    AS ROWID
    FIELD r-rowid-cfop    AS ROWID
    FIELD pontos          AS INTEGER.

FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis    =   "0055226"
                         AND nota-fiscal.serie          =   "1"
                         AND nota-fiscal.cod-estabel    =   "05"
                         NO-LOCK NO-ERROR.

FIND FIRST es-cfop WHERE es-cfop.nat-operacao-interna = nota-fiscal.nat-operacao
                     AND (es-cfop.cod-tipo-oper = "9" OR es-cfop.cod-tipo-oper = "46")
                    NO-LOCK NO-ERROR.

IF AVAIL es-cfop AND (TRIM(es-cfop.cod-tipo-oper) = "9" OR TRIM(es-cfop.cod-tipo-oper) = "46" ) THEN DO:
    
    RUN esp\espd107.p(INPUT ROWID(nota-fiscal), OUTPUT TABLE tt-cfop).

    FOR EACH tt-cfop NO-LOCK BREAK BY tt-cfop.pontos DESCENDING:
        
        /* Pegara sempre o registro de maior pontuacao */
        IF FIRST-OF(tt-cfop.pontos) THEN DO:

            FIND FIRST es-cfop WHERE ROWID(es-cfop) = tt-cfop.r-rowid-cfop NO-LOCK NO-ERROR.
            IF AVAIL es-cfop THEN DO:

                FIND FIRST mensagem WHERE mensagem.cod-mensagem = es-cfop.cod-mensagem-interna NO-LOCK NO-ERROR.
                IF AVAIL mensagem THEN DO:
                    IF SUBSTRING(nota-fiscal.char-2,132,1) = "" THEN DO:
                        
                        MESSAGE mensagem.texto-mensag
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.

                        /*
                        ASSIGN  nota-fiscal.observ-nota  =   nota-fiscal.observ-nota   +
                                                             CHR(13)                   +
                                                             mensagem.texto-mensag
                                OVERLAY(nota-fiscal.char-2,132,1)    = "S".
                        */
                        LEAVE.
                    END.
                END.
            END.    
        END.

        IF AVAIL tt-cfop THEN LEAVE.

    END.

END.
