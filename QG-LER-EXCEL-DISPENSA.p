DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-emitente      AS INTE
    FIELD nome-emitente     AS CHAR
    FIELD cgc               AS CHAR
    FIELD portador          AS CHAR
    FIELD carteira          AS CHAR
    FIELD dt-venc           AS DATE
    FIELD empresa           AS CHAR
    FIELD estabelec         AS CHAR
    FIELD especie           AS CHAR
    FIELD serie             AS CHAR
    FIELD nro-docto         AS CHAR
    FIELD parcela           AS CHAR    
    FIELD dt-emis           AS DATE
    FIELD vl-saldo          AS DECI.

DEFINE TEMP-TABLE tt_tit_acr 
    FIELD cod_estab             LIKE  tit_acr.cod_estab
    FIELD cod_espec_docto       LIKE  tit_acr.cod_espec_docto
    FIELD cod_ser_docto         LIKE  tit_acr.cod_ser_docto
    FIELD cod_tit_acr           LIKE  tit_acr.cod_tit_acr
    FIELD cod_parcela           LIKE  tit_acr.cod_parcela
    FIELD cdn_cliente           LIKE  tit_acr.cdn_cliente
    FIELD val_sdo_tit_acr       LIKE  tit_acr.val_sdo_tit_acr
    FIELD val_origin_tit_acr    LIKE  tit_acr.val_origin_tit_acr
    FIELD valor-planilha        AS DECI.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Temp\dispensa.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.cod-emitente
    tt-planilha.nome-emitente
    tt-planilha.cgc
    tt-planilha.portador
    tt-planilha.carteira
    tt-planilha.dt-venc
    tt-planilha.empresa
    tt-planilha.estabelec
    tt-planilha.especie
    tt-planilha.serie
    tt-planilha.nro-docto
    tt-planilha.parcela
    tt-planilha.dt-emis
    tt-planilha.vl-saldo.

END.
INPUT CLOSE.

OUTPUT TO "c:\temp\tit_acr.csv".

PUT "cod_estab"           ";"
    "cod_espec_docto"     ";"
    "cod_ser_docto"       ";"
    "cod_tit_acr"         ";"
    "cod_parcela"         ";"
    "val_sdo_tit_acr"     ";"
    "val_origin_tit_acr"  ";"
    "cdn_cliente"         ";"
    "valor_planilha"      SKIP.

FOR EACH tt-planilha WHERE tt-planilha.vl-saldo < 50:
    
    ASSIGN tt-planilha.estabelec = IF LENGTH(TRIM(tt-planilha.estabelec)) = 1 THEN "0" + tt-planilha.estabelec ELSE tt-planilha.estabelec.

    FOR EACH tit_acr WHERE tit_acr.cod_estab          = tt-planilha.estabelec
                       AND tit_acr.cod_espec_docto    = "AV"
                       AND tit_acr.cod_ser_docto      = tt-planilha.serie
                       AND tit_acr.cod_tit_acr        = tt-planilha.nro-docto
                       AND tit_acr.cdn_cliente        = tt-planilha.cod-emitente
                       AND tit_acr.dat_emis_doc       = tt-planilha.dt-emis
                       NO-LOCK:
        
        IF tit_acr.val_origin_tit_acr = tt-planilha.vl-saldo AND 
           tit_acr.val_sdo_tit_acr > 0 THEN DO:

            CREATE tt_tit_acr.
            ASSIGN tt_tit_acr.cod_estab          = tit_acr.cod_estab
                   tt_tit_acr.cod_espec_docto    = tit_acr.cod_espec_docto
                   tt_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto
                   tt_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr
                   tt_tit_acr.cod_parcela        = tit_acr.cod_parcela
                   tt_tit_acr.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
                   tt_tit_acr.val_origin_tit_acr = tit_acr.val_origin_tit_acr
                   tt_tit_acr.cdn_cliente        = tit_acr.cdn_cliente
                   tt_tit_acr.valor-planilha     = tt-planilha.vl-saldo.
        END.

    END.
    
    FOR EACH tit_acr WHERE tit_acr.cod_estab          = tt-planilha.estabelec
                       AND tit_acr.cod_espec_docto    = "AV"
                       AND tit_acr.cod_ser_docto      = tt-planilha.serie
                       AND tit_acr.cod_tit_acr        = "0" + tt-planilha.nro-docto
                       AND tit_acr.cdn_cliente        = tt-planilha.cod-emitente
                       AND tit_acr.dat_emis_doc       = tt-planilha.dt-emis
                       NO-LOCK:

        IF tit_acr.val_origin_tit_acr = tt-planilha.vl-saldo AND 
           tit_acr.val_sdo_tit_acr > 0 THEN DO:

            CREATE tt_tit_acr.
            ASSIGN tt_tit_acr.cod_estab          = tit_acr.cod_estab
                   tt_tit_acr.cod_espec_docto    = tit_acr.cod_espec_docto
                   tt_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto
                   tt_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr
                   tt_tit_acr.cod_parcela        = tit_acr.cod_parcela
                   tt_tit_acr.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
                   tt_tit_acr.val_origin_tit_acr = tit_acr.val_origin_tit_acr
                   tt_tit_acr.cdn_cliente        = tit_acr.cdn_cliente
                   tt_tit_acr.valor-planilha     = tt-planilha.vl-saldo.
        END.

    END.
    
    FOR EACH tit_acr WHERE tit_acr.cod_estab          = tt-planilha.estabelec
                       AND tit_acr.cod_espec_docto    = "AV"
                       AND tit_acr.cod_ser_docto      = tt-planilha.serie
                       AND tit_acr.cod_tit_acr        = "00" + tt-planilha.nro-docto
                       AND tit_acr.cdn_cliente        = tt-planilha.cod-emitente
                       AND tit_acr.dat_emis_doc       = tt-planilha.dt-emis
                       NO-LOCK:

        IF tit_acr.val_origin_tit_acr = tt-planilha.vl-saldo AND 
           tit_acr.val_sdo_tit_acr > 0 THEN DO:

            CREATE tt_tit_acr.
            ASSIGN tt_tit_acr.cod_estab          = tit_acr.cod_estab
                   tt_tit_acr.cod_espec_docto    = tit_acr.cod_espec_docto
                   tt_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto
                   tt_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr
                   tt_tit_acr.cod_parcela        = tit_acr.cod_parcela
                   tt_tit_acr.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
                   tt_tit_acr.val_origin_tit_acr = tit_acr.val_origin_tit_acr
                   tt_tit_acr.cdn_cliente        = tit_acr.cdn_cliente
                   tt_tit_acr.valor-planilha     = tt-planilha.vl-saldo.
        END.

    END.

    FOR EACH tit_acr WHERE tit_acr.cod_estab          = tt-planilha.estabelec
                       AND tit_acr.cod_espec_docto    = "AV"
                       AND tit_acr.cod_ser_docto      = tt-planilha.serie
                       AND tit_acr.cod_tit_acr        = "000" + tt-planilha.nro-docto
                       AND tit_acr.cdn_cliente        = tt-planilha.cod-emitente
                       AND tit_acr.dat_emis_doc       = tt-planilha.dt-emis
                       NO-LOCK:

        IF tit_acr.val_origin_tit_acr = tt-planilha.vl-saldo AND 
           tit_acr.val_sdo_tit_acr > 0 THEN DO:

            CREATE tt_tit_acr.
            ASSIGN tt_tit_acr.cod_estab          = tit_acr.cod_estab
                   tt_tit_acr.cod_espec_docto    = tit_acr.cod_espec_docto
                   tt_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto
                   tt_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr
                   tt_tit_acr.cod_parcela        = tit_acr.cod_parcela
                   tt_tit_acr.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
                   tt_tit_acr.val_origin_tit_acr = tit_acr.val_origin_tit_acr
                   tt_tit_acr.cdn_cliente        = tit_acr.cdn_cliente
                   tt_tit_acr.valor-planilha     = tt-planilha.vl-saldo.
        END.

    END.
    
    FOR EACH tit_acr WHERE tit_acr.cod_estab          = tt-planilha.estabelec
                       AND tit_acr.cod_espec_docto    = "AV"
                       AND tit_acr.cod_ser_docto      = tt-planilha.serie
                       AND tit_acr.cod_tit_acr        = "0000" + tt-planilha.nro-docto
                       AND tit_acr.cdn_cliente        = tt-planilha.cod-emitente
                       AND tit_acr.dat_emis_doc       = tt-planilha.dt-emis
                       NO-LOCK:

        IF tit_acr.val_origin_tit_acr = tt-planilha.vl-saldo AND 
           tit_acr.val_sdo_tit_acr > 0 THEN DO:

            CREATE tt_tit_acr.
            ASSIGN tt_tit_acr.cod_estab          = tit_acr.cod_estab
                   tt_tit_acr.cod_espec_docto    = tit_acr.cod_espec_docto
                   tt_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto
                   tt_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr
                   tt_tit_acr.cod_parcela        = tit_acr.cod_parcela
                   tt_tit_acr.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
                   tt_tit_acr.val_origin_tit_acr = tit_acr.val_origin_tit_acr
                   tt_tit_acr.cdn_cliente        = tit_acr.cdn_cliente
                   tt_tit_acr.valor-planilha     = tt-planilha.vl-saldo.
        END.

    END.

    FOR EACH tit_acr WHERE tit_acr.cod_estab          = tt-planilha.estabelec
                       AND tit_acr.cod_espec_docto    = "AV"
                       AND tit_acr.cod_ser_docto      = tt-planilha.serie
                       AND tit_acr.cod_tit_acr        = "00000" + tt-planilha.nro-docto
                       AND tit_acr.cdn_cliente        = tt-planilha.cod-emitente
                       AND tit_acr.dat_emis_doc       = tt-planilha.dt-emis
                       NO-LOCK:

        IF tit_acr.val_origin_tit_acr = tt-planilha.vl-saldo AND 
           tit_acr.val_sdo_tit_acr > 0 THEN DO:

            CREATE tt_tit_acr.
            ASSIGN tt_tit_acr.cod_estab          = tit_acr.cod_estab
                   tt_tit_acr.cod_espec_docto    = tit_acr.cod_espec_docto
                   tt_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto
                   tt_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr
                   tt_tit_acr.cod_parcela        = tit_acr.cod_parcela
                   tt_tit_acr.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
                   tt_tit_acr.val_origin_tit_acr = tit_acr.val_origin_tit_acr
                   tt_tit_acr.cdn_cliente        = tit_acr.cdn_cliente
                   tt_tit_acr.valor-planilha     = tt-planilha.vl-saldo.
        END.

    END.
    
    FOR EACH tit_acr WHERE tit_acr.cod_estab          = tt-planilha.estabelec
                       AND tit_acr.cod_espec_docto    = "AV"
                       AND tit_acr.cod_ser_docto      = tt-planilha.serie
                       AND tit_acr.cod_tit_acr        = "000000" + tt-planilha.nro-docto
                       AND tit_acr.val_sdo_tit_acr    = tt-planilha.vl-saldo
                       AND tit_acr.cdn_cliente        = tt-planilha.cod-emitente
                       AND tit_acr.dat_emis_doc       = tt-planilha.dt-emis
                       NO-LOCK:

        IF tit_acr.val_origin_tit_acr = tt-planilha.vl-saldo AND 
           tit_acr.val_sdo_tit_acr > 0 THEN DO:

            CREATE tt_tit_acr.
            ASSIGN tt_tit_acr.cod_estab          = tit_acr.cod_estab
                   tt_tit_acr.cod_espec_docto    = tit_acr.cod_espec_docto
                   tt_tit_acr.cod_ser_docto      = tit_acr.cod_ser_docto
                   tt_tit_acr.cod_tit_acr        = tit_acr.cod_tit_acr
                   tt_tit_acr.cod_parcela        = tit_acr.cod_parcela
                   tt_tit_acr.val_sdo_tit_acr    = tit_acr.val_sdo_tit_acr
                   tt_tit_acr.val_origin_tit_acr = tit_acr.val_origin_tit_acr
                   tt_tit_acr.cdn_cliente        = tit_acr.cdn_cliente
                   tt_tit_acr.valor-planilha     = tt-planilha.vl-saldo.
        END.

    END.

END.

FOR EACH tt_tit_acr NO-LOCK:
    PUT TRIM(tt_tit_acr.cod_estab)      ";"
        tt_tit_acr.cod_espec_docto      ";"
        tt_tit_acr.cod_ser_docto        ";"
        tt_tit_acr.cod_tit_acr          ";"
        tt_tit_acr.cod_parcela          ";"
        tt_tit_acr.val_sdo_tit_acr      ";"
        tt_tit_acr.val_origin_tit_acr   ";"
        tt_tit_acr.cdn_cliente          ";"
        tt_tit_acr.valor-planilha       SKIP.
END.

OUTPUT CLOSE.

OUTPUT TO "c:\Temp\planilha.csv".

FOR EACH tt-planilha NO-LOCK:
    PUT tt-planilha.cod-emitente    ";"
        tt-planilha.nome-emitente   ";"
        tt-planilha.cgc             ";"
        tt-planilha.portador        ";"
        tt-planilha.carteira        ";"
        tt-planilha.dt-venc         ";"
        tt-planilha.empresa         ";"
        tt-planilha.estabelec       ";"
        tt-planilha.especie         ";"
        tt-planilha.serie           ";"
        tt-planilha.nro-docto       ";"
        tt-planilha.parcela         ";"
        tt-planilha.dt-emis         ";"
        tt-planilha.vl-saldo        SKIP.
END.

OUTPUT CLOSE.
