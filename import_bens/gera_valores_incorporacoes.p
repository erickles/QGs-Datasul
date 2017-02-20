    
    {C:\Users\ess55813\Documents\GitHub\QGs-Datasul\import_bens\i-variaveis-valores-e-incorporacoes.i}

    DEFINE VARIABLE cInput          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iNroSequencial  AS INTEGER     NO-UNDO.
    
    /*1 0 'FISCAL' 'CORRENTE  ' 1,0000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0*/

    /*cInput = "H:\import_bens\MQ_ADM.csv".*/
    /*cInput = "H:\import_bens\contabil.csv".*/
    cInput = "C:\Users\ess55813\Documents\GitHub\QGs-Datasul\import_bens\LAYOUT_DSM_CUIABA_FINAL_11_16_3.csv".

    DEFINE TEMP-TABLE tt-planilha NO-UNDO
        FIELD col_1     AS CHAR
        FIELD col_2     AS CHAR
        FIELD col_3     AS CHAR
        FIELD col_4     AS CHAR
        FIELD col_5     AS CHAR
        FIELD col_6     AS CHAR
        FIELD col_7     AS CHAR
        FIELD col_8     AS CHAR
        FIELD col_9     AS CHAR
        FIELD col_10    AS CHAR
        FIELD col_11    AS CHAR
        FIELD col_12    AS CHAR
        FIELD col_13    AS CHAR
        FIELD col_14    AS CHAR
        FIELD col_15    AS CHAR
        FIELD col_16    AS CHAR
        FIELD col_17    AS CHAR
        FIELD col_18    AS CHAR
        FIELD col_19    AS CHAR
        FIELD col_20    AS CHAR
        FIELD col_21    AS CHAR
        FIELD col_22    AS CHAR
        FIELD col_23    AS CHAR
        FIELD col_24    AS CHAR
        FIELD col_25    AS CHAR.

    EMPTY TEMP-TABLE tt-planilha.

    INPUT FROM VALUE(cInput) CONVERT TARGET "ibm850".

    REPEAT ON ERROR UNDO, NEXT:
        CREATE tt-planilha.
        IMPORT DELIMITER ";"
            tt-planilha.col_1 
            tt-planilha.col_2 
            tt-planilha.col_3 
            tt-planilha.col_4 
            tt-planilha.col_5 
            tt-planilha.col_6 
            tt-planilha.col_7 
            tt-planilha.col_8 
            tt-planilha.col_9 
            tt-planilha.col_10
            tt-planilha.col_11
            tt-planilha.col_12
            tt-planilha.col_13
            tt-planilha.col_14
            tt-planilha.col_15
            tt-planilha.col_16
            tt-planilha.col_17
            tt-planilha.col_18
            tt-planilha.col_19
            tt-planilha.col_20
            tt-planilha.col_21
            tt-planilha.col_22
            tt-planilha.col_23
            tt-planilha.col_24
            tt-planilha.col_25.
    END.

    INPUT CLOSE.
    
    FOR EACH tt-planilha WHERE tt-planilha.col_1 <> "":
                
        IF tt-planilha.col_1 BEGINS "B" THEN NEXT.

        FIND FIRST bem_pat WHERE bem_pat.cod_empresa     = "TOR"
                             AND bem_pat.cod_cta_pat     = tt-planilha.col_3
                             AND bem_pat.num_bem_pat     = INTE(tt-planilha.col_1)
                             AND bem_pat.num_seq_bem_pat = INTE(tt-planilha.col_2)
                             NO-LOCK NO-ERROR.

        iNroSequencial = iNroSequencial + 1.

        CREATE tt-val-incorp.
        ASSIGN tt-val-incorp.iNrSeqItem             = iNroSequencial
               tt-val-incorp.cCenarioContabil       = 'FISCAL'
               tt-val-incorp.cFinalidade            = 'CORRENTE'
               tt-val-incorp.deValorOriginal        = IF AVAIL bem_pat THEN bem_pat.val_original ELSE 0
               tt-val-incorp.iSeqIncorp             = IF AVAIL bem_pat THEN num_seq_bem_pat ELSE 0
               tt-val-incorp.deCorrecaoMonetaria    = 0
               tt-val-incorp.deDprValorOriginal     = 0
               tt-val-incorp.deDprCorrecMonet       = 0
               tt-val-incorp.deCorrecMonetDpr       = 0
               tt-val-incorp.deDeprecIncentiv       = 0
               tt-val-incorp.deDprIncentivCM        = 0
               tt-val-incorp.deCMDprIncentivada     = 0
               tt-val-incorp.deAmortizacaoVO        = 0
               tt-val-incorp.deAmortizacaoCM        = 0
               tt-val-incorp.deCMAmortizacao        = 0
               tt-val-incorp.deAmortizacaoIncent    = 0
               tt-val-incorp.deAmortizacaoIncentCM  = 0
               tt-val-incorp.deCMAmortIncentivada   = 0
               tt-val-incorp.dePercentualDpr        = 0
               tt-val-incorp.dePercDprIncentivada   = 0
               tt-val-incorp.dePercDprReducaoSaldo  = 0
               tt-val-incorp.deQuantVidaUtil        = 0.

    END.

    /* Apos criadas as temp-tables, exporto para o arquivo */
    OUTPUT TO "C:\temp\valores.dat".

    FOR EACH tt-val-incorp NO-LOCK WHERE tt-val-incorp.cCenarioContabil <> '':
            
        PUT UNFORM
            tt-val-incorp.iNrSeqItem                            " "
            tt-val-incorp.iSeqIncorp                            " "
            '"' tt-val-incorp.cCenarioContabil '"'              " "
            '"' tt-val-incorp.cFinalidade      '"'              " "
            STRING(tt-val-incorp.deValorOriginal,"->>>>9.9999") " "
            tt-val-incorp.deCorrecaoMonetaria                   " "
            tt-val-incorp.deDprValorOriginal                    " "
            tt-val-incorp.deDprCorrecMonet                      " "
            tt-val-incorp.deCorrecMonetDpr                      " "
            tt-val-incorp.deDeprecIncentiv                      " "
            tt-val-incorp.deDprIncentivCM                       " "
            tt-val-incorp.deCMDprIncentivada                    " "
            tt-val-incorp.deAmortizacaoVO                       " "
            tt-val-incorp.deAmortizacaoCM                       " "
            tt-val-incorp.deCMAmortizacao                       " "
            tt-val-incorp.deAmortizacaoIncent                   " "
            tt-val-incorp.deAmortizacaoIncentCM                 " "
            tt-val-incorp.deCMAmortIncentivada                  " "
            tt-val-incorp.dePercentualDpr                       " "
            tt-val-incorp.dePercDprIncentivada                  " "
            tt-val-incorp.dePercDprReducaoSaldo                 " "
            tt-val-incorp.deQuantVidaUtil                       CHR(10).

    END.

    OUTPUT CLOSE.
