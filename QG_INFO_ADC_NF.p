DEFINE VARIABLE h-axsep027                   AS HANDLE      NO-UNDO.

{ftp/ft0518f.i5} /* ttDanfe, ttDanfeItem */
{adapters/xml/ep2/axsep027.i} /*Temp-Tables da NF-e, ttNFe, ttIde, ttDet, etc. | 3.10*/

/*Temp-Table com todos os campos que sÊo impressos no DANFE, referente ao ICMS*/
DEFINE TEMP-TABLE ttICMSDanfe NO-UNDO  
    FIELD orig           AS CHARACTER INITIAL ?                                         /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importa¯Êo direta 2 - Estrangeira - Adquirida no mercado interno */
    FIELD CST            AS CHARACTER INITIAL ?                                         /*Tribut¯Êo pelo ICMS 00 - Tributada integralmente*/
    FIELD vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS*/ 
    FIELD vICMS          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS*/       
    FIELD pICMS          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Alðquota do ICMS*/    
    FIELD vBCST          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ICMS ST*/ 
    FIELD vICMSST        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do ICMS ST*/ 
    /*Chave EMS*/
    FIELD CodEstabelNF   AS CHARACTER INITIAL ?
    FIELD SerieNF        AS CHARACTER INITIAL ?
    FIELD NrNotaFisNF    AS CHARACTER INITIAL ?
    FIELD ItCodigoNF     AS CHARACTER INITIAL ?
    FIELD NrSeqFatNF     AS INTEGER   INITIAL ?
    INDEX ch-ttICMSDanfe CodEstabelNF SerieNF NrNotaFisNF NrSeqFatNF ItCodigoNF.

FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis = "0110483"
                         AND nota-fiscal.cod-estabel = "05"
                         AND nota-fiscal.serie       = "1"
                         NO-LOCK NO-ERROR.
    
RUN adapters/xml/ep2/axsep027.p PERSISTENT SET h-axsep027.
RUN pi-seta-nota-fiscal    IN h-axsep027 (INPUT ROWID(nota-fiscal)).
RUN pi-prepara-dados       IN h-axsep027.
RUN pi-devolve-temp-tables IN h-axsep027 (OUTPUT  TABLE ttAdi         ,
                                          OUTPUT  TABLE ttArma        ,
                                          OUTPUT  TABLE ttAutXML      ,
                                          OUTPUT  TABLE ttAvulsa      ,
                                          OUTPUT  TABLE ttCobr        ,
                                          OUTPUT  TABLE ttCOFINSAliq  ,
                                          OUTPUT  TABLE ttCOFINSNT    ,
                                          OUTPUT  TABLE ttCOFINSOutr  ,
                                          OUTPUT  TABLE ttCOFINSQtde  ,
                                          OUTPUT  TABLE ttCOFINSST    ,
                                          OUTPUT  TABLE ttICMSUFDest  ,
                                          OUTPUT  TABLE ttComb        ,
                                          OUTPUT  TABLE ttCompra      ,
                                          OUTPUT  TABLE ttDest        ,
                                          OUTPUT  TABLE ttDet         ,
                                          OUTPUT  TABLE ttDetExport   ,
                                          OUTPUT  TABLE ttDI          ,
                                          OUTPUT  TABLE ttDup         ,
                                          OUTPUT  TABLE ttEmit        ,
                                          OUTPUT  TABLE ttEntrega     ,
                                          OUTPUT  TABLE ttExporta     ,
                                          OUTPUT  TABLE ttICMS00      ,
                                          OUTPUT  TABLE ttICMS10      ,
                                          OUTPUT  TABLE ttICMS20      ,
                                          OUTPUT  TABLE ttICMS30      ,
                                          OUTPUT  TABLE ttICMS40      ,
                                          OUTPUT  TABLE ttICMS51      ,
                                          OUTPUT  TABLE ttICMS60      ,
                                          OUTPUT  TABLE ttICMS70      ,
                                          OUTPUT  TABLE ttICMS90      ,
                                          OUTPUT  TABLE ttICMSTot     ,
                                          OUTPUT  TABLE ttIde         ,
                                          OUTPUT  TABLE ttII          ,
                                          OUTPUT  TABLE ttImpostoDevol,
                                          OUTPUT  TABLE ttInfAdic     ,
                                          OUTPUT  TABLE ttIPI         ,
                                          OUTPUT  TABLE ttISSQN       ,
                                          OUTPUT  TABLE ttISSQNtot    ,
                                          OUTPUT  TABLE ttLacres      ,
                                          OUTPUT  TABLE ttMed         ,
                                          OUTPUT  TABLE ttNFe         ,
                                          OUTPUT  TABLE ttrefNF       ,
                                          OUTPUT  TABLE ttObsCont     ,
                                          OUTPUT  TABLE ttObsFisco    ,
                                          OUTPUT  TABLE ttPISAliq     ,
                                          OUTPUT  TABLE ttPISNT       ,
                                          OUTPUT  TABLE ttPISOutr     ,
                                          OUTPUT  TABLE ttPISQtde     ,
                                          OUTPUT  TABLE ttPISST       ,
                                          OUTPUT  TABLE ttProcRef     ,
                                          OUTPUT  TABLE ttReboque     ,
                                          OUTPUT  TABLE ttRetirada    ,
                                          OUTPUT  TABLE ttRetTrib     ,
                                          OUTPUT  TABLE ttTransp      ,
                                          OUTPUT  TABLE ttVeic        ,
                                          OUTPUT  TABLE ttVol         ,
                                          OUTPUT  TABLE ttrefNFP      ,
                                          OUTPUT  TABLE ttrefCTe      ,
                                          OUTPUT  TABLE ttrefECF      ,
                                          OUTPUT  TABLE ttICMSPart    ,
                                          OUTPUT  TABLE ttICMSST      ,
                                          OUTPUT  TABLE ttICMSSN101   ,
                                          OUTPUT  TABLE ttICMSSN102   ,
                                          OUTPUT  TABLE ttICMSSN201   ,
                                          OUTPUT  TABLE ttICMSSN202   ,
                                          OUTPUT  TABLE ttICMSSN500   ,
                                          OUTPUT  TABLE ttICMSSN900   ,
                                          OUTPUT  TABLE ttCana        ,
                                          OUTPUT  TABLE ttForDia      ,
                                          OUTPUT  TABLE ttDeduc       ).

    IF  VALID-HANDLE(h-axsep027) THEN DO:
        DELETE PROCEDURE h-axsep027.
        ASSIGN h-axsep027 = ?.
    END.
    /*
    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:

        FOR FIRST ttICMS20
            WHERE ttICMS20.CodEstabelNF = it-nota-fisc.cod-estabel
              AND ttICMS20.SerieNF      = it-nota-fisc.serie
              AND ttICMS20.NrNotaFisNF  = it-nota-fisc.nr-nota-fis
              AND ttICMS20.NrSeqFatNF   = it-nota-fisc.nr-seq-fat
              AND ttICMS20.itcodigonf   = it-nota-fisc.it-codigo:

            MESSAGE ttICMS20.itcodigonf SKIP
                    ttICMS20.vICMSDeson SKIP
                    "20"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

            /*d-icms-deson = d-icms-deson + ttICMS20.vICMSDeson.*/
        END.
        FOR FIRST ttICMS30
            WHERE ttICMS30.CodEstabelNF = it-nota-fisc.cod-estabel
              AND ttICMS30.SerieNF      = it-nota-fisc.serie      
              AND ttICMS30.NrNotaFisNF  = it-nota-fisc.nr-nota-fis
              AND ttICMS30.NrSeqFatNF   = it-nota-fisc.nr-seq-fat 
              AND ttICMS30.itcodigonf   = it-nota-fisc.it-codigo:
            /*d-icms-deson = d-icms-deson + ttICMS30.vICMSDeson.*/

            MESSAGE ttICMS20.itcodigonf SKIP
                    ttICMS20.vICMSDeson SKIP
                    "30"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

        END.
        FOR FIRST ttICMS40
            WHERE ttICMS40.CodEstabelNF = it-nota-fisc.cod-estabel
              AND ttICMS40.SerieNF      = it-nota-fisc.serie      
              AND ttICMS40.NrNotaFisNF  = it-nota-fisc.nr-nota-fis
              AND ttICMS40.NrSeqFatNF   = it-nota-fisc.nr-seq-fat 
              AND ttICMS40.itcodigonf   = it-nota-fisc.it-codigo:
            /*d-icms-deson = d-icms-deson + ttICMS40.vICMSDeson.*/

            MESSAGE ttICMS20.itcodigonf SKIP
                    ttICMS20.vICMSDeson SKIP
                    "40"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

        END.
        FOR FIRST ttICMS70
            WHERE ttICMS70.CodEstabelNF = it-nota-fisc.cod-estabel
              AND ttICMS70.SerieNF      = it-nota-fisc.serie
              AND ttICMS70.NrNotaFisNF  = it-nota-fisc.nr-nota-fis
              AND ttICMS70.NrSeqFatNF   = it-nota-fisc.nr-seq-fat 
              AND ttICMS70.itcodigonf   = it-nota-fisc.it-codigo:
            /*d-icms-deson = d-icms-deson + ttICMS70.vICMSDeson.*/

            MESSAGE ttICMS20.itcodigonf SKIP
                    ttICMS20.vICMSDeson SKIP
                    "70"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

        END.
        FOR FIRST ttICMS90
            WHERE ttICMS90.CodEstabelNF = it-nota-fisc.cod-estabel
              AND ttICMS90.SerieNF      = it-nota-fisc.serie
              AND ttICMS90.NrNotaFisNF  = it-nota-fisc.nr-nota-fis
              AND ttICMS90.NrSeqFatNF   = it-nota-fisc.nr-seq-fat 
              AND ttICMS90.itcodigonf   = it-nota-fisc.it-codigo:
            /*d-icms-deson = d-icms-deson + ttICMS90.vICMSDeson.*/

            MESSAGE ttICMS20.itcodigonf SKIP
                    ttICMS20.vICMSDeson SKIP
                    "90"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

        END.

    */
    FOR EACH item-nf-adc WHERE item-nf-adc.cod-estab = it-nota-fisc.cod-estabel
                           AND item-nf-adc.cod-serie = it-nota-fisc.serie
                           AND item-nf-adc.cod-nota-fisc = it-nota-fisc.nr-nota-fis
                           AND item-nf-adc.cdn-emitente = nota-fiscal.cod-emitente
                           AND item-nf-adc.cod-natur-operac = it-nota-fisc.nat-operacao
                           AND item-nf-adc.idi-tip-dado = 24
                           AND item-nf-adc.num-seq = it-nota-fisc.nr-seq-fat
                           AND item-nf-adc.num-seq-item-nf = it-nota-fisc.nr-seq-fat
                           AND item-nf-adc.cod-item = it-nota-fisc.it-codigo:
        
        DISP item-nf-adc.val-livre-1        /* vBCUFDest    */
             item-nf-adc.val-livre-2        /* pFCPUFDest   */
             item-nf-adc.val-livre-3        /* Valor ICMS Partilha UF Destino   */
             item-nf-adc.val-livre-4        /* Valor ICMS Partilha UF Remetente */
             DEC(item-nf-adc.cod-livre-1)
             DEC(item-nf-adc.cod-livre-2)
             item-nf-adc.num-livre-1
             DEC(item-nf-adc.cod-livre-4)
             WITH 1 COL.

    END.
    

END.


/*  Valor do ICMS desonerado R$ 3.976,53 (vICMSDeson). |
    Valor ICMS Partilha UF Destino: 810,91 |
    Valor ICMS Partilha UF Remetente: 1.216,35 */
