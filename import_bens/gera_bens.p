    
    {H:\import_bens\i-variaveis-bens.i}    

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

        CREATE tt-bens.
        ASSIGN tt-bens.iNrSeqItem                   = iNroSequencial
               tt-bens.ccEmpresa                    = "TOR"
               tt-bens.cContaPatr                   = TRIM(tt-planilha.col_3)
               tt-bens.iBemPatrimonial              = INTE(tt-planilha.col_1)
               tt-bens.iSeqBem                      = INTE(tt-planilha.col_2)
               tt-bens.cDescBemPatr                 = IF AVAIL bem_pat THEN bem_pat.des_bem_pat ELSE tt-planilha.col_4
               tt-bens.cNumPlaq                     = TRIM(tt-planilha.col_7)
               tt-bens.iQtBensRepres                = 0
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
               tt-bens.cMarca                       = TRIM(tt-planilha.col_10)
               tt-bens.cModelo                      = TRIM(tt-planilha.col_11)
               tt-bens.cLicencaUso                  = ''
               tt-bens.cEspecifTecnica              = ''
               tt-bens.cEstadoFisico                = ''
               tt-bens.cArrendador                  = ''
               tt-bens.cContratoLeasing             = ''
               tt-bens.iFornecedor                  = 0
               tt-bens.cLocalizacao                 = TRIM(tt-planilha.col_8)
               tt-bens.cResponsavel                 = ''
               tt-bens.dtUltimoInvent               = DATE(tt-planilha.col_6)
               tt-bens.cNarrativaBem                = TRIM(tt-planilha.col_5)
               tt-bens.cSeguradora                  = ''
               tt-bens.cApoliceSeguro               = ''
               tt-bens.dtInicValidApol              = ?
               tt-bens.dtFimValidApol               = ?
               tt-bens.dePremioSeguro               = 0
               tt-bens.cSeguradora_1                = ''
               tt-bens.cApoliceSeguro_1             = ''
               tt-bens.dtInicioValidApolice_1       = ?
               tt-bens.dtFimValidApolice_1          = ?
               tt-bens.dePremioSeguro_1             = 0
               tt-bens.cSeguradora_2                = ''
               tt-bens.cApoliceSeguro_2             = ''
               tt-bens.dtInicioValidApolice_2       = ?
               tt-bens.dtFimValidApolice_2          = ?
               tt-bens.dePremioSeguro_2             = 0
               tt-bens.cDoctoEntrada                = ''
               tt-bens.iNumeroItem                  = 0
               tt-bens.iPessoaGarantia              = 0
               tt-bens.dtInicioGarantia             = ?
               tt-bens.dtFimGarantia                = ?
               tt-bens.cGrupoCalculo                = ''
               tt-bens.dtDataMovimento              = ?
               tt-bens.dePercBaixado                = 0
               tt-bens.dtInicioCalculoDpr           = ?
               tt-bens.dtDataCalculo                = ?
               tt-bens.cSerieNota                   = ''
               tt-bens.deValorCreditoPis            = 0
               tt-bens.deValorCreditoCofins         = 0.
        
    END.

    /* Apos criadas as temp-tables, exporto para o arquivo */
    OUTPUT TO "C:\temp\bens.dat".

    FOR EACH tt-bens NO-LOCK WHERE tt-bens.cContaPatr <> "":

        PUT UNFORM
                tt-bens.iNrSeqItem                  ' '
            "'" tt-bens.ccEmpresa                  "'" ' '
            "'" tt-bens.cContaPatr                 "'" ' '
                tt-bens.iBemPatrimonial             ' '
                tt-bens.iSeqBem                     ' '
            "'" tt-bens.cDescBemPatr               "'" ' '
            "'" tt-bens.cNumPlaq                   "'" ' '
                tt-bens.iQtBensRepres               ' '
            "'" tt-bens.cPeriodicidade             "'" ' '
                tt-bens.dtDataAquisicao             ' '
            "'" tt-bens.cEstabel                   "'" ' '
            "'" tt-bens.cEspeciePatrim             "'" ' '
            "'" tt-bens.cMarca                     "'" ' '
            "'" tt-bens.cModelo                    "'" ' '
            "'" tt-bens.cLicencaUso                "'" ' '
            "'" tt-bens.cEspecifTecnica            "'" ' '
            "'" tt-bens.cEstadoFisico              "'" ' '
            "'" tt-bens.cArrendador                "'" ' '
            "'" tt-bens.cContratoLeasing           "'" ' '
                tt-bens.iFornecedor                 ' '
            "'" tt-bens.cLocalizacao               "'" ' '
            "'" tt-bens.cResponsavel               "'" ' '
                tt-bens.dtUltimoInvent              ' '
            "'" tt-bens.cNarrativaBem              "'" ' '
            "'" tt-bens.cSeguradora                "'" ' '
            "'" tt-bens.cApoliceSeguro             "'" ' '
                tt-bens.dtInicValidApol             ' '
                tt-bens.dtFimValidApol              ' '
                tt-bens.dePremioSeguro              ' '
            "'" tt-bens.cSeguradora_1              "'" ' '
            "'" tt-bens.cApoliceSeguro_1           "'" ' '
                tt-bens.dtInicioValidApolice_1      ' '
                tt-bens.dtFimValidApolice_1         ' '
                tt-bens.dePremioSeguro_1            ' '
            "'" tt-bens.cSeguradora_2              "'" ' '
            "'" tt-bens.cApoliceSeguro_2           "'" ' '
                tt-bens.dtInicioValidApolice_2      ' '
                tt-bens.dtFimValidApolice_2         ' '
                tt-bens.dePremioSeguro_2            ' '
            "'" tt-bens.cDoctoEntrada              "'" ' '
                tt-bens.iNumeroItem                 ' '
                tt-bens.iPessoaGarantia             ' '
                tt-bens.dtInicioGarantia            ' '
                tt-bens.dtFimGarantia               ' '
            "'" tt-bens.cTermoGarantia             "'" ' '
            "'" tt-bens.cGrupoCalculo              "'" ' '
                tt-bens.dtDataMovimento             ' '
                tt-bens.dePercBaixado               ' '
                tt-bens.dtInicioCalculoDpr          ' '
                tt-bens.dtDataCalculo               ' '
            "'" tt-bens.cSerieNota                 "'" ' '
                tt-bens.lBemImportado               ' '
                tt-bens.lCreditaPis                 ' '
                tt-bens.lCreditaCofins              ' '
                tt-bens.iNroParcelasCredPisCofins   ' '
                tt-bens.iParcelasDescontadas        ' '
                tt-bens.deValorCreditoPis           ' '
                tt-bens.deValorCreditoCofins        ' '
                tt-bens.lCreditaCsll                ' '
                tt-bens.iExerciciosCreditoCsll      ' '
                tt-bens.deValorBasePis              ' '
                tt-bens.deValorBaseCofins
                SKIP.
    END.

    OUTPUT CLOSE.