DEFINE VARIABLE de-vProd-tot                  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vNF                        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vDesc-tot                  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vProd                      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vUnCom                     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vUnTrib                    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vDesc                      AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vDescCom                   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-desc                    AS DECIMAL     NO-UNDO. 
DEFINE VARIABLE de-arredondar                 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vlProdTotal                AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-total                   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-Diferenca-vProd            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vProd-acumula              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-perc-icms-item             AS DECIMAL     NO-UNDO.
                                              
DEFINE VARIABLE de-tot-desc-icm-item          AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-des-comerc                 AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-aliquota-icms              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-vl-unit                    AS DECIMAL     NO-UNDO.
DEFINE VARIABLE de-tot-desc-icm               AS DECIMAL     NO-UNDO.

FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis = "0295863"
                         AND nota-fiscal.serie = "4"
                         AND nota-fiscal.cod-estabel = "19"
                         NO-LOCK NO-ERROR.
FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK WHERE it-nota-fisc.it-codigo = "50050205":

    ASSIGN de-vDescCom = 0
           de-vProd    = 0
           de-vDesc    = 0
           de-vUnCom   = 0
           de-vUnTrib  = 0.

    MESSAGE "1"                                     SKIP    
            "de-vUnTrib   " + STRING(de-vUnTrib)    SKIP
            "de-vUnCom    " + STRING(de-vUnCom)     SKIP
            "de-vProd     " + STRING(de-vProd)      SKIP
            "de-vProd-tot " + STRING(de-vProd-tot)  SKIP
            "it-nota-fisc.vl-ipi-it " + STRING(it-nota-fisc.vl-ipi-it)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

    ASSIGN de-vDescCom   = ROUND(it-nota-fisc.vl-merc-ori * (1 - (it-nota-fisc.per-des-item / 100)),2) /*Valor Tabela + Encargos - Descontos Comerciais do item*/
           de-vDesc      = ROUND((de-vDescCom * (it-nota-fisc.per-des-icms  / 100)),2)                    /*Desconto de icms do item*/
           de-vProd      = ROUND(it-nota-fisc.vl-tot-item + de-vDesc,2)                                   /*Valor liquido do item + Desc ICMS*/
           de-vUnCom     = ROUND((de-vProd / it-nota-fisc.qt-faturada[1]),7)                              /*Valor unitario do item - Desc ICMS - Desc Comercial*/
           de-vUnTrib    = ROUND((de-vProd / it-nota-fisc.qt-faturada[1]),7)                              /*Valor unitario do item - Desc ICMS - Desc Comercial*/
           de-vProd-tot  = ROUND(de-vProd-tot + de-vProd,2)                                                  /*Total Bruto NF (acumulador) = (Valor liquido do item + Desc ICMS)*/
           de-vDesc-tot  = ROUND(de-vDesc-tot + de-vDesc,2)                                                  /*Total de Descontos da NF*/
           de-vNF        = ROUND(de-vNF + it-nota-fisc.vl-tot-item,2).                                    /*Valor lðquido da NF-e*/

    MESSAGE "2"                                     SKIP    
            "de-vUnTrib   " + STRING(de-vUnTrib)    SKIP
            "de-vUnCom    " + STRING(de-vUnCom)     SKIP
            "de-vProd     " + STRING(de-vProd)      SKIP
            "de-vProd-tot " + STRING(de-vProd-tot)  SKIP
            "it-nota-fisc.vl-ipi-it " + STRING(it-nota-fisc.vl-ipi-it)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    /*KSR - 16/01/2014 - Substitui‡Æo Tribut ria*/
    IF it-nota-fisc.vl-icmsub-it > 0 THEN DO:
        ASSIGN de-vUnTrib   = de-vUnTrib   - it-nota-fisc.vl-icmsub-it
               de-vUnCom    = de-vUnCom    - it-nota-fisc.vl-icmsub-it
               de-vProd     = de-vProd     - it-nota-fisc.vl-icmsub-it
               de-vProd-tot = de-vProd-tot - it-nota-fisc.vl-icmsub-it.
    END.
    /*KSR - 16/01/2014 - Substitui‡Æo Tribut ria*/

    MESSAGE "3"                                     SKIP    
            "de-vUnTrib   " + STRING(de-vUnTrib)    SKIP
            "de-vUnCom    " + STRING(de-vUnCom)     SKIP
            "de-vProd     " + STRING(de-vProd)      SKIP
            "de-vProd-tot " + STRING(de-vProd-tot)  SKIP
            "it-nota-fisc.vl-ipi-it " + STRING(it-nota-fisc.vl-ipi-it)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

    /*KSR - 27/02/2014 - IPI*/
    IF it-nota-fisc.vl-ipi-it > 0 THEN DO:
        ASSIGN /*de-vUnTrib   = de-vUnTrib   - it-nota-fisc.vl-ipi-it
               de-vUnCom    = de-vUnCom    - it-nota-fisc.vl-ipi-it
               */
               
               de-vUnTrib   = de-vUnTrib   - ROUND((it-nota-fisc.vl-ipi-it / it-nota-fisc.qt-faturada[1]),7)
               de-vUnCom    = de-vUnCom    - ROUND((it-nota-fisc.vl-ipi-it / it-nota-fisc.qt-faturada[1]),7)
               
               de-vProd     = de-vProd     - it-nota-fisc.vl-ipi-it
               de-vProd-tot = de-vProd-tot - it-nota-fisc.vl-ipi-it.
    END.

    MESSAGE "4"                                                                                 SKIP
            "de-vUnTrib             " + STRING(de-vUnTrib)                                      SKIP
            "de-vUnCom              " + STRING(de-vUnCom)                                       SKIP
            "de-vProd               " + STRING(de-vProd)                                        SKIP
            "de-vProd-tot           " + STRING(de-vProd-tot)                                    SKIP
            "it-nota-fisc.vl-ipi-it " + STRING(it-nota-fisc.vl-ipi-it)                          SKIP
            STRING((de-vUnCom * it-nota-fisc.qt-faturada[1]) + it-nota-fisc.vl-ipi-it)          SKIP
            STRING(((de-vUnCom * it-nota-fisc.qt-faturada[1]) + it-nota-fisc.vl-ipi-it) / 2)    SKIP
            de-vProd <> (((de-vUnCom * it-nota-fisc.qt-faturada[1])))                           SKIP
            it-nota-fisc.vl-tot-item
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
