DEFINE VARIABLE cNrDocto     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDtLote      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDtLancto    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cVlrLnc      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cEntryDate   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCpuTm       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cTCode       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cUserName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lLocalizado  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cNumeroLote  AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-acomp      AS HANDLE    NO-UNDO.

DEFINE VARIABLE cNomeArquivo AS CHARACTER   NO-UNDO.
run utp/ut-acomp.p persistent set h-acomp.

DEFINE TEMP-TABLE ttResultado
    FIELD cNrDocto            AS CHARACTER    
    FIELD cDtLote             AS CHARACTER     
    FIELD cDtLancto           AS CHARACTER  
    FIELD cVlrLnc             AS CHARACTER     
    FIELD cEntryDate          AS CHARACTER  
    FIELD cCpuTm              AS CHARACTER       
    FIELD cTCode              AS CHARACTER      
    FIELD cUserName           AS CHARACTER   
    FIELD lLocalizado         AS LOGICAL
    FIELD NrLoteDatasul       AS CHARACTER
    FIELD num_Lancto_Contabil AS CHARACTER
    INDEX idxNrDocto  IS PRIMARY cNrDocto ASCENDING
    . 
EMPTY TEMP-TABLE ttResultado.

DEFINE TEMP-TABLE ttItem_Lancto_Ctbl
    FIELD LoteContabil           AS CHARACTER    
    FIELD num_Lancto_Contabil    AS CHARACTER     
    FIELD des_histor_lancto_ctbl AS CHARACTER  
    INDEX idxHistorico IS PRIMARY des_histor_lancto_ctbl ASCENDING
    .
EMPTY TEMP-TABLE ttItem_Lancto_Ctbl.

run pi-inicializar in h-acomp(input RETURN-VALUE).

FOR EACH lote_ctbl NO-LOCK
   WHERE lote_ctbl.des_lote_ctbl = "DSM Tort.Integr.Cont."
     AND lote_ctbl.dat_lote_ctbl > 10/01/2015
    ,
    EACH item_lancto_ctbl OF lote_ctbl NO-LOCK
    BREAK BY SUBSTRING(item_lancto_ctbl.des_histor_lancto_ctbl,1,18)
    :

    RUN pi-acompanhar IN h-acomp (INPUT "Criando ¡ndice - Lote Cont bil: " + STRING(lote_ctbl.num_lote_ctbl)).

    IF LAST-OF(SUBSTRING(item_lancto_ctbl.des_histor_lancto_ctbl,1,18)) THEN DO:
        
        CREATE ttItem_Lancto_Ctbl.
        ASSIGN ttItem_Lancto_Ctbl.LoteContabil           = STRING(lote_ctbl.num_lote_ctbl)
               ttItem_Lancto_Ctbl.num_Lancto_Contabil    = STRING(item_lancto_ctbl.num_lancto_ctbl)
               ttItem_Lancto_Ctbl.des_histor_lancto_ctbl = SUBSTRING(item_lancto_ctbl.des_histor_lancto_ctbl,1,18)
               .
    END.

END.
    

INPUT FROM "c:\temp\contabil\ArquivoFinalCSV.csv".

REPEAT:

    ASSIGN 
        cNrDocto   = ""
        cDtLote    = ""  
        cDtLancto  = "" 
        cEntryDate = ""
        cCpuTm     = ""   
        cTCode     = ""    
        cUserName  = ""
        .

    IMPORT DELIMITER ";"
        cNrDocto
        cDtLote
        cDtLancto
        cEntryDate
        cCpuTm
        cTCode
        cUserName
        .

    /*tira duplicidade*/
    FIND FIRST ttResultado
         WHERE ttResultado.cNrDocto = cNrDocto
         NO-LOCK NO-ERROR.
    IF AVAIL ttResultado THEN NEXT.
    /*tira duplicidade*/


    IF LENGTH(cNrDocto) < 18 THEN
        cNrDocto = FILL("0",18 - LENGTH(cNrDocto)) + cNrDocto.

    FIND FIRST ttItem_Lancto_Ctbl NO-LOCK
         WHERE ttItem_Lancto_Ctbl.des_histor_lancto_ctbl = cNrDocto NO-ERROR.
    
    RUN pi-acompanhar IN h-acomp (INPUT "Localizando Docto: " + cNrDocto).


    IF NOT AVAIL ttItem_Lancto_Ctbl THEN DO: /*apenas gera Log dos documentos cont beis nÆo localizados*/
        
        CREATE ttResultado.
        ASSIGN                     
            ttResultado.cNrDocto            = cNrDocto
            ttResultado.cDtLote             = cDtLote
            ttResultado.cDtLancto           = cDtLancto
            ttResultado.cEntryDate          = cEntryDate
            ttResultado.cCpuTm              = cCpuTm
            ttResultado.cTCode              = cTCode
            ttResultado.cUserName           = cUserName
            ttResultado.lLocalizado         = AVAIL ttItem_Lancto_Ctbl
            ttResultado.NrLoteDatasul       = IF AVAIL ttItem_Lancto_Ctbl THEN ttItem_Lancto_Ctbl.LoteContabil        ELSE ""
            ttResultado.num_Lancto_Contabil = IF AVAIL ttItem_Lancto_Ctbl THEN ttItem_Lancto_Ctbl.num_Lancto_Contabil ELSE ""
            .

    END.

        /*
        blk_For:
    FOR EACH lote_ctbl NO-LOCK
       WHERE lote_ctbl.des_lote_ctbl = "DSM Tort.Integr.Cont."
         AND lote_ctbl.dat_lote_ctbl > 01/10/2015
        :

        RUN pi-acompanhar IN h-acomp (INPUT "Localizando Docto: " + cNrDocto).

        FIND FIRST item_lancto_ctbl OF lote_ctbl
             WHERE SUBSTRING(item_lancto_ctbl.des_histor_lancto_ctbl,1,18) = cNrDocto
             NO-LOCK NO-ERROR.

        IF AVAIL item_lancto_ctbl THEN DO:
            lLocalizado = YES.
            cNumeroLote = STRING(lote_ctbl.num_lote_ctbl).
            LEAVE blk_For.
        END.

    END.
    */
    
END.


OUTPUT TO "c:\temp\contabil\ArquivoFinalCSV_Resultado.csv".
PUT
    "cNrDocto;"   
    "cDtLote;"    
    "cDtLancto;"  
    "cEntryDate;" 
    "cCpuTm;"     
    "cTCode;"     
    "cUserName;"  
    "lLocalizado;"
    "NrLoteDatasul;"
    "NrLanctoDatasul"
    SKIP
    .

FOR EACH ttResultado
    :

    RUN pi-acompanhar IN h-acomp (INPUT "Gerando planilha - Docto: " + ttResultado.cNrDocto).

    PUT UNFORMATTED
        "'" ttResultado.cNrDocto      ";"  
        "'" ttResultado.cDtLote       ";" 
        "'" ttResultado.cDtLancto     ";"
        "'" ttResultado.cEntryDate    ";"
        "'" ttResultado.cCpuTm        ";"
        "'" ttResultado.cTCode        ";"
        "'" ttResultado.cUserName     ";"
        "'" ttResultado.lLocalizado   ";"
        "'" ttResultado.NrLoteDatasul ";"
        "'" ttResultado.num_Lancto_Contabil
        SKIP.

END.
OUTPUT CLOSE.

run pi-finalizar in h-acomp.


