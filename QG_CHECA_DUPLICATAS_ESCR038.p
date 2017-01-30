DEFINE VARIABLE c-titulo-banco  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dData           AS DATE    FORMAT "99/99/9999"    NO-UNDO.

UPDATE dData.

FOR EACH es-fat-duplic NO-LOCK WHERE es-fat-duplic.data-geracao >= dData
                                 AND es-fat-duplic.data-geracao > 03/01/2013 BY es-fat-duplic.data-geracao:

    IF LOOKUP(STRING(es-fat-duplic.cod-portador),'111,112,410,411,23712,34110,39910') = 0 THEN NEXT.

    FIND FIRST tit_acr NO-LOCK WHERE tit_acr.cod_empresa     =  "TOR"
                                 AND tit_acr.cod_espec_docto = "DP"
                                 AND tit_acr.cod_estab       =  es-fat-duplic.cod-estabel
                                 AND tit_acr.cod_tit_acr     =  es-fat-duplic.nr-fatura
                                 AND tit_acr.cod_ser_docto   =  es-fat-duplic.serie
                                 AND tit_acr.cod_parcela     =  es-fat-duplic.parcela
                                 AND tit_acr.cod_port        =  STRING(es-fat-duplic.cod-portador) NO-ERROR.

    IF AVAIL tit_acr AND tit_acr.val_sdo_tit_acr <> tit_acr.val_origin_tit_acr THEN NEXT.

    FIND FIRST fat-duplic  NO-LOCK WHERE fat-duplic.cod-estabel =  es-fat-duplic.cod-estabel
                                     AND fat-duplic.nr-fatura   =  es-fat-duplic.nr-fatura
                                     AND fat-duplic.serie       =  es-fat-duplic.serie
                                     AND fat-duplic.parcela     =  es-fat-duplic.parcela NO-ERROR.

    IF es-fat-duplic.cod-portador = 111 THEN
        ASSIGN c-titulo-banco = SUBSTR(es-fat-duplic.titulo-banco,1,11) + SUBSTR(es-fat-duplic.titulo-banco,13,1).
    ELSE
        IF es-fat-duplic.cod-portador = 112 THEN
            ASSIGN c-titulo-banco = es-fat-duplic.titulo-banco.
        ELSE
            IF es-fat-duplic.cod-portador = 410 OR es-fat-duplic.cod-portador = 411 THEN
                ASSIGN c-titulo-banco = SUBSTR(es-fat-duplic.titulo-banco,1,7) + SUBSTR(es-fat-duplic.titulo-banco,9,1).
            ELSE
                IF es-fat-duplic.cod-portador = 23712 THEN
                    ASSIGN c-titulo-banco = SUBSTR(es-fat-duplic.titulo-banco,5,11) + SUBSTR(es-fat-duplic.titulo-banco,17,1).
                ELSE
                    IF es-fat-duplic.cod-portador = 34110 THEN
                        ASSIGN c-titulo-banco = SUBSTR(es-fat-duplic.titulo-banco,5,8).
                    ELSE
                        ASSIGN c-titulo-banco = SUBSTR(es-fat-duplic.titulo-banco,1,10) + SUBSTR(es-fat-duplic.titulo-banco,12,1).

    IF TRIM(c-titulo-banco) <> TRIM(fat-duplic.char-1) OR 
       /*TRIM(c-titulo-banco) <> tit_acr.cod_tit_acr_bco*/  THEN
        MESSAGE "Portador "         + STRING(es-fat-duplic.cod-portador)                    SKIP
                c-titulo-banco + " es-fat-duplic"                                           SKIP
                fat-duplic.char-1 + " fat-duplic"                                           SKIP
                IF AVAIL tit_acr THEN tit_acr.cod_tit_acr_bco ELSE " "   + " tit_acr"       SKIP
                "Estabelecimento "  + es-fat-duplic.cod-estabel                             SKIP
                "Nr Fatura "        + es-fat-duplic.nr-fatura                               SKIP
                "Serie "            + es-fat-duplic.serie                                   SKIP
                "Parcela "          + IF AVAIL tit_acr THEN tit_acr.cod_parcela ELSE " "    SKIP
                "Dt Geracao "       + STRING(es-fat-duplic.data-geracao)                    SKIP
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.
