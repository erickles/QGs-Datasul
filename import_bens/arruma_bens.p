    
    {H:\import_bens\i-variaveis-bens.i}
    {include/i-freeac.i}

    DEFINE VARIABLE cInput          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iNroSequencial  AS INTEGER     NO-UNDO.

    /*cInput = "H:\import_bens\MQ_ADM.csv".*/
    /*cInput = "H:\import_bens\contabil.csv".*/
    cInput = "C:\Users\ess55813\Documents\GitHub\QGs-Datasul\import_bens\LAYOUT_DSM_CUIABA_FINAL_11_16_3.csv".

    /* 
        1 '1' '1312102x' 017848 0 'MESA DE CRISTAL' '017848' 1 'Quadrimestral' 01/08/1979 '01' '02004' '' '' '' '' 'BOM' '' '' 0 '01001' '' 31/12/2000 'MESA DE CRISTAL C/LATERAIS' '' '' ? ? 0 '' '' ? ? 0 '' '' ? ? 0 '' 0 0 ? ? '' '' ? 0 ? ? ''
        2 '1' '1312102x' 017848 1 'MESA DE CRISTAL' '017848' 1 'Quadrimestral' 01/08/1979 '01' '02004' '' '' '' '' 'BOM' '' '' 0 '01001' '' 31/12/2000 'MESA DE CRISTAL C/LATERAIS' '' '' ? ? 0 '' '' ? ? 0 '' '' ? ? 0 '' 0 0 ? ? '' '' ? 0 ? ? ''
    */

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
    
    FOR EACH tt-planilha:
                
        IF tt-planilha.col_1 BEGINS "B" THEN NEXT.

        FIND FIRST bem_pat WHERE bem_pat.cod_empresa     = "TOR"
                             AND bem_pat.cod_cta_pat     = tt-planilha.col_3
                             AND bem_pat.num_bem_pat     = INTE(tt-planilha.col_1)
                             AND bem_pat.num_seq_bem_pat = INTE(tt-planilha.col_2)
                             NO-LOCK NO-ERROR.

        iNroSequencial = iNroSequencial + 1.

        IF NOT AVAIL bem_pat THEN
            NEXT.
        
        CREATE tt-bens.
        ASSIGN tt-bens.iNrSeqItem                   = iNroSequencial
               tt-bens.ccEmpresa                    = "TOR"
               tt-bens.cContaPatr                   = TRIM(tt-planilha.col_3)
               tt-bens.iBemPatrimonial              = INTE(tt-planilha.col_1)
               tt-bens.iSeqBem                      = INTE(tt-planilha.col_2)
               tt-bens.cDescBemPatr                 = IF AVAIL bem_pat THEN bem_pat.des_bem_pat ELSE tt-planilha.col_4
               tt-bens.cNumPlaq                     = TRIM(tt-planilha.col_7)
               tt-bens.iQtBensRepres                = IF AVAIL bem_pat THEN bem_pat.qtd_bem_pat_represen ELSE 1
               tt-bens.cPeriodicidade               = ""
               tt-bens.dtDataAquisicao              = IF AVAIL bem_pat THEN bem_pat.dat_aquis_bem_pat ELSE DATE(tt-planilha.col_6)
               tt-bens.cEstabel                     = "18"
               tt-bens.lBemImportado                = YES
               tt-bens.lCreditaPis                  = YES
               tt-bens.lCreditaCofins               = YES
               tt-bens.iNroParcelasCredPisCofins    = 0
               tt-bens.iParcelasDescontadas         = 0
               tt-bens.lCreditaCsll                 = NO                 
               tt-bens.iExerciciosCreditoCsll       = 0
               tt-bens.cEspeciePatrim               = ''
               tt-bens.cMarca                       = IF AVAIL bem_pat THEN bem_pat.cod_marca ELSE TRIM(tt-planilha.col_12)
               tt-bens.cModelo                      = IF AVAIL bem_pat THEN bem_pat.cod_modelo ELSE TRIM(tt-planilha.col_13)
               tt-bens.cLocalizacao                 = IF AVAIL bem_pat THEN bem_pat.cod_localiz ELSE TRIM(tt-planilha.col_8)               
               tt-bens.dtUltimoInvent               = DATE(tt-planilha.col_6)
               tt-bens.cNarrativaBem                = TRIM(tt-planilha.col_5).

        ASSIGN tt-bens.cDescBemPatr = REPLACE(tt-bens.cDescBemPatr,'"','')
               tt-bens.cDescBemPatr = fn-free-accent(tt-bens.cDescBemPatr).

        ASSIGN tt-bens.cNarrativaBem = REPLACE(tt-bens.cNarrativaBem,'"','')
               tt-bens.cNarrativaBem = fn-free-accent(tt-bens.cNarrativaBem).


        ASSIGN tt-bens.cMarca = REPLACE(tt-bens.cMarca,'"','')
               tt-bens.cMarca = fn-free-accent(tt-bens.cMarca).

        ASSIGN tt-bens.cModelo = REPLACE(tt-bens.cModelo,'"','')
               tt-bens.cModelo = fn-free-accent(tt-bens.cModelo).

        ASSIGN tt-bens.cLocalizacao = REPLACE(tt-bens.cLocalizacao,'"','')
               tt-bens.cLocalizacao = fn-free-accent(tt-bens.cLocalizacao).

    END.

    MESSAGE "Tenho" iNroSequencial "bens"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

    /* Apos criadas as temp-tables, exporto para o arquivo */
    OUTPUT TO "C:\temp\bens.csv".

    FOR EACH tt-bens NO-LOCK WHERE tt-bens.cContaPatr <> "":

        PUT UNFORM
            tt-bens.iNrSeqItem                                  CHR(9)
            tt-bens.ccEmpresa                                   CHR(9)
            tt-bens.cContaPatr                                  CHR(9)
            tt-bens.iBemPatrimonial                             CHR(9)
            tt-bens.iSeqBem                                     CHR(9)
            tt-bens.cDescBemPatr                                SKIP.
    END.

    OUTPUT CLOSE.
