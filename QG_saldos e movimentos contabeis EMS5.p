DEFINE TEMP-TABLE tt-saldos-contabeis
    FIELD cod_empresa       LIKE sdo_ctbl.cod_empresa
    FIELD cod_cta_ctbl      LIKE sdo_ctbl.cod_cta_ctbl
    FIELD des_tit_ctbl      LIKE cta_ctbl.des_tit_ctbl
    FIELD val_sdo_ctbl      LIKE sdo_ctbl.val_sdo_ctbl_fim
    FIELD deMovtoDB         LIKE sdo_ctbl.val_sdo_ctbl_fim
    FIELD deMovtoCR         LIKE sdo_ctbl.val_sdo_ctbl_fim
    FIELD val_sdo_ctbl_fim  AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99"
    FIELD dat_sdo_ctbl      LIKE sdo_ctbl.dat_sdo_ctbl.

DEFINE VARIABLE deVlrVendasMes      LIKE sdo_ctbl.val_sdo_ctbl_fim.
DEFINE VARIABLE deVlrVendasMesAnt   LIKE sdo_ctbl.val_sdo_ctbl_fim.
DEFINE VARIABLE deVlrContasRec      LIKE sdo_ctbl.val_sdo_ctbl_fim.

DEFINE VARIABLE deSaldo         LIKE sdo_ctbl.val_sdo_ctbl_fim.
DEFINE VARIABLE dePrimeiraFase  LIKE sdo_ctbl.val_sdo_ctbl_fim.
DEFINE VARIABLE deSegundaFase   LIKE sdo_ctbl.val_sdo_ctbl_fim.

DEFINE VARIABLE deDSO       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dtData      AS DATE     FORMAT "99/99/9999"   NO-UNDO.

UPDATE dtData LABEL "Data do mes para calculo".

/* Define o mˆs corrente */
DEFINE VARIABLE iMesCorrente AS INTEGER     NO-UNDO.
DEFINE VARIABLE iAnoCorrente AS INTEGER     NO-UNDO.

iMesCorrente = MONTH(dtData).
iAnoCorrente = YEAR(dtData).

/* Pega os valores do mes corrente */
RUN piValores(INPUT dtData,
              OUTPUT deVlrVendasMes,
              OUTPUT deVlrContasRec).

/* Calculo da primeira fase */
ASSIGN deSaldo = deVlrContasRec - deVlrVendasMes
       dePrimeiraFase = deSaldo.

IF deSaldo > 0 THEN DO:

    ASSIGN deDSO = 30.
    /* Fazer enquanto o resultado da primeira fase menos as vendas dos meses anteriores for maior que zero */
    DO WHILE deSaldo > 0:

        /* Caso o mˆs seja janeiro */
        IF iMesCorrente - 1 = 0 THEN
            ASSIGN iAnoCorrente = iAnoCorrente - 1
                   iMesCorrente = 12.
        ELSE
            ASSIGN iMesCorrente = iMesCorrente - 1.

        RUN piValores(INPUT DATE("01/" + STRING(iMesCorrente) + "/" + STRING(iAnoCorrente)),
                          OUTPUT deVlrVendasMesAnt,
                          OUTPUT deVlrContasRec).

        deSaldo = deSaldo - deVlrVendasMesAnt.

        IF deSaldo < 0 THEN
            ASSIGN deDSO = deDSO + (dePrimeiraFase / deVlrVendasMesAnt) * 30.
        ELSE
            ASSIGN deDSO = deDSO + 30.

    END.

END.

MESSAGE "DSO: " +   STRING(deDSO)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* Esta procedure retorna o valor das vendas e do 
   contas a receber de acordo com o mˆs e ano da 
   data passada como parametro */
PROCEDURE piValores:

    DEFINE INPUT PARAMETER dtData AS DATE NO-UNDO.
    DEFINE OUTPUT PARAMETER deValorVendas           LIKE sdo_ctbl.val_sdo_ctbl_fim.
    DEFINE OUTPUT PARAMETER deValorContasReceber    LIKE sdo_ctbl.val_sdo_ctbl_fim.

    DEFINE VARIABLE deMovtoDB           AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE deMovtoCR           AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE deVlrSdoCtb         AS DECIMAL  NO-UNDO.
    DEFINE VARIABLE deValorProvDevDuv   LIKE sdo_ctbl.val_sdo_ctbl_fim.
    DEFINE VARIABLE deRecOperLiq        LIKE sdo_ctbl.val_sdo_ctbl_fim.
    DEFINE VARIABLE deExpProdDNP        LIKE sdo_ctbl.val_sdo_ctbl_fim.
    DEFINE VARIABLE deContasRec         LIKE sdo_ctbl.val_sdo_ctbl_fim.
    DEFINE VARIABLE deVlrCliDSM         LIKE sdo_ctbl.val_sdo_ctbl_fim.

    EMPTY TEMP-TABLE tt-saldos-contabeis.
    
    FOR EACH sdo_ctbl NO-LOCK WHERE sdo_ctbl.cod_empresa            = "TOR"
                                AND sdo_ctbl.cod_finalid_econ       = "Corrente"
                                AND sdo_ctbl.cod_plano_cta_ctbl     = "TORT2006"
                                AND sdo_ctbl.cod_cenar_ctbl         = "FISCAL"
                                AND YEAR(sdo_ctbl.dat_sdo_ctbl)     = YEAR(dtData)
                                AND MONTH(sdo_ctbl.dat_sdo_ctbl)    = MONTH(dtData),
                                FIRST cta_ctbl OF sdo_ctbl NO-LOCK
                                BREAK BY sdo_ctbl.cod_cta_ctbl:
        
        IF LOOKUP(sdo_ctbl.cod_unid_negoc,"80,81,82,83,EMS") > 0 THEN NEXT.
        
        ASSIGN deMovtoDB   = deMovtoDB   + sdo_ctbl.val_sdo_ctbl_db
               deMovtoCR   = deMovtoCR   + sdo_ctbl.val_sdo_ctbl_cr
               deVlrSdoCtb = deVlrSdoCtb + sdo_ctbl.val_sdo_ctbl_fim.

        IF LAST-OF(sdo_ctbl.cod_cta_ctbl) THEN DO:
            
            CREATE tt-saldos-contabeis.
            ASSIGN tt-saldos-contabeis.cod_empresa      = sdo_ctbl.cod_empresa
                   tt-saldos-contabeis.cod_cta_ctbl     = sdo_ctbl.cod_cta_ctbl
                   tt-saldos-contabeis.des_tit_ctbl     = cta_ctbl.des_tit_ctbl
                   tt-saldos-contabeis.val_sdo_ctbl     = deVlrSdoCtb
                   tt-saldos-contabeis.deMovtoDB        = deMovtoDB
                   tt-saldos-contabeis.deMovtoCR        = deMovtoCR
                   tt-saldos-contabeis.val_sdo_ctbl_fim = deVlrSdoCtb
                   tt-saldos-contabeis.dat_sdo_ctbl     = sdo_ctbl.dat_sdo_ctbl.

            ASSIGN deMovtoDB    = 0
                   deMovtoCR    = 0
                   deVlrSdoCtb  = 0.
        END.

    END.

    OUTPUT TO "c:\DSO.csv".

    PUT "cod_empresa"       ";"
        "cod_cta_ctbl"      ";"
        "des_tit_ctbl"      ";"
        "val_sdo_ctbl"      ";"
        "deMovtoDB"         ";"
        "deMovtoCR"         ";"
        "val_sdo_ctbl_fim"  ";"
        "dat_sdo_ctbl"      SKIP.

    FOR EACH tt-saldos-contabeis NO-LOCK:
    
        /* Provisao devedores duvidosos */
        IF  INTE(tt-saldos-contabeis.cod_cta_ctbl) >= 1128000   AND
            INTE(tt-saldos-contabeis.cod_cta_ctbl) <= 1128999   AND
            INTE(tt-saldos-contabeis.cod_cta_ctbl) <> 1128001   THEN DO:
            
            ASSIGN deValorProvDevDuv = deValorProvDevDuv + tt-saldos-contabeis.val_sdo_ctbl.
        END.

        IF deValorProvDevDuv < 0 THEN
            deValorProvDevDuv = deValorProvDevDuv * - 1.
    
        /* Exportacao Produtos DNP */
        IF INTE(tt-saldos-contabeis.cod_cta_ctbl) = 3110205 THEN
            ASSIGN deExpProdDNP = deExpProdDNP + tt-saldos-contabeis.deMovtoCR - tt-saldos-contabeis.deMovtoDB.

        IF deExpProdDNP < 0 THEN
            deExpProdDNP = deExpProdDNP * - 1.

        /* Receita Operacional Liquida */
        IF tt-saldos-contabeis.cod_cta_ctbl BEGINS "31" THEN
            ASSIGN deRecOperLiq = deRecOperLiq + tt-saldos-contabeis.deMovtoCR - tt-saldos-contabeis.deMovtoDB.
                                         
        IF deRecOperLiq < 0 THEN
            deRecOperLiq = deRecOperLiq * - 1.
    
        /* Clientes Grupo DSM */
        /*
        IF INTE(tt-saldos-contabeis.cod_cta_ctbl) >= 1120300   AND
           INTE(tt-saldos-contabeis.cod_cta_ctbl) <= 1120399   THEN DO:
        */
        IF tt-saldos-contabeis.cod_cta_ctbl BEGINS "11203" THEN DO:
            ASSIGN deVlrCliDSM = deVlrCliDSM + tt-saldos-contabeis.val_sdo_ctbl.
        END.

        IF deVlrCliDSM < 0 THEN
            deVlrCliDSM = deVlrCliDSM * - 1.
    
        /* Contas a receber */
        IF INTE(tt-saldos-contabeis.cod_cta_ctbl) >= 1120000   AND
            INTE(tt-saldos-contabeis.cod_cta_ctbl) <= 1129999   THEN
            ASSIGN deContasRec = deContasRec + tt-saldos-contabeis.val_sdo_ctbl.

        IF deContasRec < 0 THEN
            deContasRec = deContasRec * - 1.

        PUT tt-saldos-contabeis.cod_empresa         ";"
            tt-saldos-contabeis.cod_cta_ctbl        ";"
            tt-saldos-contabeis.des_tit_ctbl        ";"
            tt-saldos-contabeis.val_sdo_ctbl        ";"
            tt-saldos-contabeis.deMovtoDB           ";"
            tt-saldos-contabeis.deMovtoCR           ";"
            tt-saldos-contabeis.val_sdo_ctbl_fim    ";"
            tt-saldos-contabeis.dat_sdo_ctbl        SKIP.
        
    END.
    
    OUTPUT CLOSE.
    
    MESSAGE "Mes " + STRING(MONTH(dtData))                              SKIP
            "Provisao devedores duvidosos " + STRING(deValorProvDevDuv) SKIP
            "Exportacao Produtos DNP "      + STRING(deExpProdDNP)      SKIP
            "Receita Operacional Liquida "  + STRING(deRecOperLiq)      SKIP
            "Clientes Grupo DSM "           + STRING(deVlrCliDSM)       SKIP
            "Contas a receber "             + STRING(deContasRec)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    ASSIGN deValorVendas = deRecOperLiq - deExpProdDNP
           deValorContasReceber = deContasRec - deVlrCliDSM /*+ deValorProvDevDuv*/ .

END PROCEDURE.
