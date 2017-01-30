{include/i-buffer.i}

DEFINE VARIABLE cRetorno        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCont           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iContador       AS INTEGER     NO-UNDO.

DEFINE VARIABLE cCodigoBarras   AS CHARACTER   NO-UNDO EXTENT 5.
DEFINE VARIABLE deValor         AS DECI        NO-UNDO EXTENT 5.
DEFINE VARIABLE iFornec         AS INTE        NO-UNDO EXTENT 5.

DEFINE VARIABLE cCodigoBoleto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cCodigoBarra    AS CHARACTER   NO-UNDO.

ASSIGN cCodigoBarras[1] = "00190000090108849300000496097189163160000050000"
       cCodigoBarras[2] = "00190000090108849300000496100181263160000050000"
       cCodigoBarras[3] = "00190000090108849300000496098187163160000025000"
       cCodigoBarras[4] = "00190000090108849300000496505181463160000025000"
       cCodigoBarras[5] = "00190000090255468600200000724187563160000179330".

ASSIGN deValor[1] = 500
       deValor[2] = 500
       deValor[3] = 250
       deValor[4] = 250
       deValor[5] = 1793.30.

ASSIGN iFornec[1] = 113302
       iFornec[2] = 113302
       iFornec[3] = 113302
       iFornec[4] = 113302
       iFornec[5] = 227503.


DO iCont = 1 TO 5:

    cRetorno = "".

    RUN pi_retorna_cod_barra_leitora(INPUT cCodigoBarras[iCont], OUTPUT cCodigoBoleto).
    
    FIND FIRST emsuni.fornecedor WHERE emsuni.fornecedor.cdn_fornecedor = iFornec[iCont] NO-LOCK NO-ERROR.
    IF AVAIL emsuni.fornecedor THEN DO:

        iContador = 0.

        FOR EACH item_bord_ap WHERE item_bord_ap.cdn_fornecedor    = emsuni.fornecedor.cdn_fornecedor
                                AND item_bord_ap.dat_vencto_tit_ap = 01/22/2015
                                AND item_bord_ap.val_pagto         = deValor[iCont]
                                NO-LOCK:
            iContador = iContador + 1.
        END.

        /* Caso haja mais de um titulo do mesmo fornecedor, mesmo vencimento e mesmo valor
           checa pelo codigo de barras */
        IF iContador > 1 THEN DO:

            FOR EACH antecip_pef_pend WHERE antecip_pef_pend.cod_empresa        = "TOR"
                                        AND antecip_pef_pend.cdn_fornecedor     = emsuni.fornecedor.cdn_fornecedor
                                        AND antecip_pef_pend .dat_vencto_tit_ap = 01/22/2015
                                        AND antecip_pef_pend.val_tit_ap         = deValor[iCont]
                                        NO-LOCK:

                FOR EACH item_bord_ap WHERE item_bord_ap.cod_refer_antecip_pef = antecip_pef_pend.cod_refer
                                        AND item_bord_ap.cdn_fornecedor        = antecip_pef_pend.cdn_fornecedor
                                        NO-LOCK:

                    RUN pi_retorna_cod_barra_leitora(INPUT antecip_pef_pend.cb4_tit_ap_bco_cobdor,OUTPUT cCodigoBarra).

                    IF cCodigoBarra = cCodigoBoleto THEN DO:
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
        ELSE DO:
            FIND FIRST tit_ap WHERE tit_ap.cdn_fornecedor     = emsuni.fornecedor.cdn_fornecedor
                                AND tit_ap.dat_vencto_tit_ap  = 01/22/2015
                                AND tit_ap.val_sdo_tit_ap     = deValor[iCont]
                                NO-LOCK NO-ERROR.
            IF AVAIL tit_ap THEN DO:
                FIND FIRST item_bord_ap OF tit_ap NO-LOCK.
                IF AVAIL item_bord_ap THEN DO:
                    FIND FIRST item_bord_ap_agrup OF item_bord_ap NO-LOCK NO-ERROR.
                    IF AVAIL item_bord_ap_agrup THEN
                        cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "Y" + ";".
                    ELSE
                        cRetorno = item_bord_ap.cod_estab_bord + ";" + STRING(item_bord_ap.num_id_item_bord_ap) + ";" + "N" + ";".
                END.
                ELSE
                    cRetorno = "".
            END.
            ELSE
                cRetorno = "".
        END.
    END.

    MESSAGE cRetorno
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

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
