{include/i-buffer.i}

DEFINE VARIABLE cRetorno        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodigoBarra    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCont           AS INTEGER     NO-UNDO.

DEFINE VARIABLE v_mem           AS MEMPTR       NO-UNDO.
DEFINE VARIABLE v_dados         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE v_cont          AS INTEGER      NO-UNDO.

DEFINE VARIABLE cContent        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iContagem       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNumeroBoletos  AS INTEGER     NO-UNDO.
DEFINE VARIABLE cPassos         AS CHARACTER   NO-UNDO.

FILE-INFO:FILE-NAME = "H:\ESCRITURAL\TOR\PAG\HSBC\RET\FCP13282.DAT".

SET-SIZE(v_mem)= FILE-INFO:FILE-SIZE.

INPUT FROM VALUE(FILE-INFO:FILE-NAME).
    IMPORT v_mem.
INPUT CLOSE.

v_dados = GET-STRING(v_mem,1).

SET-SIZE(v_mem)= 0.

DO v_cont= 1 TO NUM-ENTRIES(v_dados,CHR(10)):

    cContent = ENTRY(v_cont, v_dados, CHR(10)).
    
    IF SUBSTRING(cContent,14,1) = "J" THEN DO:
        /*
        MESSAGE "Boleto"                                            SKIP
                "CNPJ"          TRIM(SUBSTRING(cContent,183,20))    SKIP
                "Vencimento "   DATE(SUBSTRING(cContent,92,8))      SKIP
                "Cod Barra"     TRIM(SUBSTRING(cContent,18,44))     SKIP
                DECI( SUBSTRING(cContent,155,11) + "," + SUBSTRING(cContent,166,2))
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        */
        ASSIGN cRetorno     = ""
               cCodigoBarra = ""
               cPassos      = "".

        iNumeroBoletos = iNumeroBoletos + 1.

        FIND FIRST pessoa_jurid WHERE pessoa_jurid.cod_id_feder = TRIM(SUBSTRING(cContent,183,20)) NO-LOCK NO-ERROR.
        IF AVAIL pessoa_jurid THEN DO:
            FIND FIRST emsuni.fornecedor WHERE emsuni.fornecedor.num_pessoa = pessoa_jurid.num_pessoa_jurid NO-LOCK NO-ERROR.
            IF AVAIL emsuni.fornecedor THEN DO:
                
                iCont = 0.

                FOR EACH item_bord_ap WHERE item_bord_ap.cdn_fornecedor    = emsuni.fornecedor.cdn_fornecedor
                                        AND item_bord_ap.dat_vencto_tit_ap = DATE(SUBSTRING(cContent,92,8))
                                        AND item_bord_ap.val_pagto         = DECI( SUBSTRING(cContent,155,11) + "," + SUBSTRING(cContent,166,2))
                                        NO-LOCK:
                    iCont = iCont + 1.
                END.
                
                /* Caso haja mais de um titulo do mesmo fornecedor, mesmo vencimento e mesmo valor
                   checa pelo codigo de barras, considerando sempre o bordero nao estornado */
                IF iCont > 1 THEN DO:
                    
                    cPassos = cPassos + "A".
                    ASSIGN iContagem = iCont.
        
                    FOR EACH antecip_pef_pend WHERE antecip_pef_pend.cod_empresa        = "TOR"
                                                AND antecip_pef_pend.cdn_fornecedor     = emsuni.fornecedor.cdn_fornecedor
                                                AND antecip_pef_pend.dat_vencto_tit_ap  = DATE(SUBSTRING(cContent,92,8))
                                                AND antecip_pef_pend.val_tit_ap         = DECI( SUBSTRING(cContent,155,11) + "," + SUBSTRING(cContent,166,2))
                                                NO-LOCK:
        
                        FOR EACH item_bord_ap WHERE item_bord_ap.cod_refer_antecip_pef = antecip_pef_pend.cod_refer
                                                AND item_bord_ap.cdn_fornecedor        = antecip_pef_pend.cdn_fornecedor
                                                NO-LOCK:
                            
                            RUN pi_retorna_cod_barra_leitora(INPUT antecip_pef_pend.cb4_tit_ap_bco_cobdor, OUTPUT cCodigoBarra).
                            cPassos = cPassos + "B".
                            IF  cCodigoBarra = TRIM(SUBSTRING(cContent,18,44))  AND
                                TRIM(SUBSTRING(cContent,18,44)) <> "0000000000" THEN DO:
                                
                                cPassos = cPassos + "C".
                                /* Consistir para que ate o ultimo registro de item de bordero, considere o bordero "Enviado ao banco */
                                FIND FIRST bord_ap OF item_bord_ap NO-LOCK NO-ERROR.
                                IF AVAIL bord_ap THEN DO:
                                    cPassos = cPassos + "D".
                                    iContagem = iContagem - 1.
        
                                    IF iContagem > 0 THEN DO:
                                        cPassos = cPassos + "E".
                                        IF bord_ap.ind_sit_bord_ap <> "Enviado ao Banco" THEN
                                            NEXT.
                                    END.
                                    
                                END.
        
                                FIND FIRST item_bord_ap_agrup OF item_bord_ap NO-LOCK NO-ERROR.
                                IF AVAIL item_bord_ap_agrup THEN
                                    cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "Y" + ";".
                                ELSE
                                    cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "N" + ";".
                                LEAVE.
                            END.
                            ELSE
                                cRetorno = "".
        
                            IF cRetorno <> "" THEN
                                LEAVE.
                        END.
        
                        IF cRetorno <> "" THEN
                            LEAVE.
                    END.
        
                    IF cRetorno = "" THEN DO:
        
                        ASSIGN iContagem = iCont.
        
                        FOR EACH tit_ap WHERE tit_ap.cdn_fornecedor     = emsuni.fornecedor.cdn_fornecedor
                                          AND tit_ap.dat_vencto_tit_ap  = DATE(SUBSTRING(cContent,92,8))
                                          AND tit_ap.val_origin_tit_ap  = DECI( SUBSTRING(cContent,155,11) + "," + SUBSTRING(cContent,166,2))
                                          NO-LOCK:
        
                            RUN pi_retorna_cod_barra_leitora(INPUT tit_ap.cb4_tit_ap_bco_cobdor,OUTPUT cCodigoBarra).
                            cPassos = cPassos + "F".
                            IF cCodigoBarra = TRIM(SUBSTRING(cContent,18,44))  AND
                               TRIM(SUBSTRING(cContent,18,44)) <> "0000000000" THEN DO:
                                cPassos = cPassos + "G".
                                FOR EACH item_bord_ap OF tit_ap NO-LOCK:
        
                                    /* Consistir para que ate o ultimo registro de item de bordero, considere o bordero "Enviado ao banco */
                                    FIND FIRST bord_ap OF item_bord_ap NO-LOCK NO-ERROR.
                                    IF AVAIL bord_ap THEN DO:
                                        cPassos = cPassos + "H".
                                        iContagem = iContagem - 1.
        
                                        IF iContagem > 0 THEN DO:
                                            cPassos = cPassos + "I".
                                            IF bord_ap.ind_sit_bord_ap <> "Enviado ao Banco" THEN
                                                NEXT.
                                        END.
        
                                    END.
        
                                    FIND FIRST item_bord_ap_agrup OF item_bord_ap NO-LOCK NO-ERROR.
                                    IF AVAIL item_bord_ap_agrup THEN
                                        cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "Y" + ";".
                                    ELSE
                                        cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "N" + ";".
                                END.
                            END.
                        END.
                    END.
                END.
                ELSE DO:
                    /* Caso seja o unico titulo do bordero com o valor, data de vencimento e fornecedor */
                    FIND FIRST tit_ap WHERE tit_ap.cdn_fornecedor     = emsuni.fornecedor.cdn_fornecedor
                                        AND tit_ap.dat_vencto_tit_ap  = DATE(SUBSTRING(cContent,92,8))
                                        AND tit_ap.val_origin_tit_ap  = DECI( SUBSTRING(cContent,155,11) + "," + SUBSTRING(cContent,166,2))
                                        NO-LOCK NO-ERROR.
                    IF AVAIL tit_ap THEN DO:
                        
                        cPassos = cPassos + "J".
                        
                        FOR EACH item_bord_ap OF tit_ap NO-LOCK BREAK BY item_bord_ap.num_bord_ap:
        
                            /* Consistir para que ate o ultimo registro de item de bordero, considere o bordero "Enviado ao banco */
                            FIND FIRST bord_ap OF item_bord_ap NO-LOCK NO-ERROR.
                            IF AVAIL bord_ap THEN DO:
                                cPassos = cPassos + "K".
                                IF NOT LAST-OF(item_bord_ap.num_bord_ap) THEN DO:
        
                                    IF bord_ap.ind_sit_bord_ap <> "Enviado ao Banco" THEN
                                        NEXT.
                                END.
        
                            END.
                            cPassos = cPassos + "L".
                            FIND FIRST item_bord_ap_agrup OF item_bord_ap NO-LOCK NO-ERROR.
                            IF AVAIL item_bord_ap_agrup THEN
                                cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "Y" + ";".
                            ELSE
                                cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "N" + ";".
                        END.
                    END.
                    ELSE DO:
                        
                        /* Caso nao haja titulo, sera uma antecipacao (apenas uma) */
                        FOR EACH antecip_pef_pend WHERE antecip_pef_pend.cod_empresa        = "TOR"
                                                    AND antecip_pef_pend.cdn_fornecedor     = emsuni.fornecedor.cdn_fornecedor
                                                    AND antecip_pef_pend .dat_vencto_tit_ap = DATE(SUBSTRING(cContent,92,8))
                                                    AND antecip_pef_pend.val_tit_ap         = DECI( SUBSTRING(cContent,155,11) + "," + SUBSTRING(cContent,166,2))
                                                    NO-LOCK:
                            
                            FOR EACH item_bord_ap WHERE item_bord_ap.cod_refer_antecip_pef = antecip_pef_pend.cod_refer
                                                    AND item_bord_ap.cdn_fornecedor        = antecip_pef_pend.cdn_fornecedor
                                                    NO-LOCK:
        
                                RUN pi_retorna_cod_barra_leitora(INPUT antecip_pef_pend.cb4_tit_ap_bco_cobdor,OUTPUT cCodigoBarra).
        
                                IF cCodigoBarra = TRIM(SUBSTRING(cContent,18,44)) THEN DO:
                                    cPassos = cPassos + "M".
                                    FIND FIRST item_bord_ap_agrup OF item_bord_ap NO-LOCK NO-ERROR.
                                    IF AVAIL item_bord_ap_agrup THEN
                                        cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "Y" + ";".
                                    ELSE
                                        cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "N" + ";".
                                    LEAVE.
                                END.
                                ELSE
                                    cRetorno = "".
        
                                IF cRetorno <> "" THEN
                                    LEAVE.
                            END.
        
                            IF cRetorno <> "" THEN
                                LEAVE.
                        END.
                    END.
                END.
            END.
            
            MESSAGE cRetorno    SKIP
                    cPassos
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            
        END.
    END.
    /*
    IF iNumeroBoletos = 1 THEN
        LEAVE.
    */
END.

MESSAGE iNumeroBoletos
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE pi_retorna_cod_barra_leitora:

    /************************ Parameter Definition Begin ************************/

    DEFINE INPUT PARAM p_cod_barra_2
        AS CHARACTER
        FORMAT "99999.999999"
        NO-UNDO.

    DEFINE OUTPUT PARAM p_cod_barra
        AS CHARACTER
        FORMAT "X(44)"
        NO-UNDO.

    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    DEFINE VARIABLE v_num_tam_format
        AS INTEGER
        FORMAT ">>9":U
        NO-UNDO.

    DEFINE VARIABLE v_val_tit_barra
        AS DECIMAL
        FORMAT "->>,>>>,>>>,>>9.99":U
        DECIMALS 2
        NO-UNDO.

    /************************** Variable Definition End *************************/

    ASSIGN v_val_tit_barra = 0.

    &if DEFINED(BF_FIN_ALTER_CODIGO_BARRA) &then
        ASSIGN v_num_tam_format = 14.
    &else
        FIND histor_exec_especial NO-LOCK
             WHERE histor_exec_especial.cod_modul_dtsul = 'UFN'
               AND histor_exec_especial.cod_prog_dtsul  = 'SPP_alter_codigo_barra'
             NO-ERROR.
        IF AVAIL histor_exec_especial THEN
            ASSIGN v_num_tam_format = 14.
        ELSE ASSIGN v_num_tam_format = 12.
    &endif

    ASSIGN v_val_tit_barra  = DECI(SUBSTRING(p_cod_barra_2, 38, 10))
           p_cod_barra      = SUBSTRING(p_cod_barra_2,01,03)        +
                              SUBSTRING(p_cod_barra_2, 04,01)       +
                              SUBSTRING(p_cod_barra_2, 33,01)       +
                              SUBSTRING(p_cod_barra_2, 34,04)       +
                              STRING(v_val_tit_barra,"9999999999")  +
                              SUBSTRING(p_cod_barra_2, 05,05)       +
                              SUBSTRING(p_cod_barra_2, 11,10)       +
                              SUBSTRING(p_cod_barra_2, 22,10).

END PROCEDURE. /* pi_retorna_cod_barra_leitora */
