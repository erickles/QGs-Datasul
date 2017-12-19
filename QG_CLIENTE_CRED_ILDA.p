DEFINE VARIABLE cOutput AS CHARACTER   NO-UNDO.

cOutput = "C:\Temp\clientes_credito" + SUBSTRING(STRING(TODAY, "99999999"),5,4) + 
                                        SUBSTRING(STRING(TODAY, "99999999"),3,2) +
                                        SUBSTRING(STRING(TODAY, "99999999"),1,2) + "-" +
                                        SUBSTRING(STRING(TIME, "HH:MM:SS"),1,2) +
                                        SUBSTRING(STRING(TIME, "HH:MM:SS"),4,2) +
                                        SUBSTRING(STRING(TIME, "HH:MM:SS"),7,2) + ".csv".

OUTPUT TO VALUE(cOutput).

PUT "CODIGO;NOME CLIENTE;MEDIA ATRASO;LIMITE CRED;DT CADASTRO;DATA HISTORICO;DATA LIM CREDITO;HISTORICO" SKIP.

DEFINE VARIABLE deMedia     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE cHistorico  AS CHARACTER   NO-UNDO.

FOR EACH emitente WHERE (emitente.identific = 1 OR emitente.identific = 3)                    
                    NO-LOCK:

    ASSIGN cHistorico = "".

    /*
    FIND FIRST es-serasastatus WHERE es-serasastatus.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL es-serasastatus THEN DO:
    */        
        FIND LAST his-emit WHERE his-emit.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL his-emit THEN
            ASSIGN cHistorico = ""
                   cHistorico = ENTRY(1,his-emit.historico,CHR(10))
                   cHistorico = REPLACE(cHistorico,"*","")
                   cHistorico = REPLACE(cHistorico,"#","")
                   cHistorico = REPLACE(cHistorico,CHR(13),"").

        deMedia = 0.

        RUN pi-estatistica(INPUT emitente.cod-emitente, 
                           OUTPUT deMedia).
    
        PUT  UNFORM
                 emitente.cod-emitente                              ";"
                 emitente.nome-emit                                 ";"
                 deMedia                                            ";"
                 emitente.lim-cred                                  ";"
                 emitente.data-implant                              ";"
                 IF AVAIL his-emit THEN his-emit.dt-his-emit ELSE ? ";"
                 emitente.dt-lim-cred                               ";"
                 cHistorico                                         SKIP.

    /*
    END.
    */
END.

OUTPUT CLOSE.

PROCEDURE pi-estatistica:
    
    DEFINE INPUT PARAMETER iCodEmitente AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER deMedia     AS DECIMAL NO-UNDO.
    
    DEFINE BUFFER bf2-emitente FOR emitente.
    DEFINE BUFFER bf-emitente FOR emitente.

    /* Variaveis novas para busca da estatistica */
    DEFINE VARIABLE iMes    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iAno    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE idx     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iMeses  AS INTEGER     NO-UNDO INITIAL 12.

    DEFINE VARIABLE deVendasAcumuladas  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deValorSaldo        AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deVendasPeriodo     AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE dePrazoMedio            AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deAtrasoMedio           AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deValPrazRecebtoTot     AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deValPrazRecebtoTotTot  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deValRecebtoTot         AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE deValRecebtoTotTot      AS DECIMAL     NO-UNDO.

    FIND FIRST bf2-emitente WHERE bf2-emitente.cod-emitente = iCodEmitente NO-LOCK NO-ERROR.

    /* Novo calculo */
    ASSIGN iMes = MONTH(TODAY)
           iAno = YEAR(TODAY).
    
    DO idx = 1 TO iMeses:
/*         FOR EACH bf-emitente WHERE bf-emitente.nome-matriz = bf2-emitente.nome-matriz NO-LOCK: */
        FOR EACH bf-emitente WHERE bf-emitente.cod-emitente = bf2-emitente.cod-emitente NO-LOCK:
    
            FIND FIRST estatis_clien WHERE estatis_clien.cdn_clien                  = bf-emitente.cod-emitente
                                       AND estatis_clien.cod_empresa                = "TOR"
                                       AND MONTH(estatis_clien.dat_estatis_clien)   = iMes
                                       AND YEAR(estatis_clien.dat_estatis_clien)    = iAno
                                       NO-LOCK NO-ERROR.

            IF AVAIL estatis_clien THEN DO:
        
                ASSIGN deVendasAcumuladas       = deVendasAcumuladas + estatis_clien.val_vendas
                       deValorSaldo             = deValorSaldo + val_sdo_clien
                       deValPrazRecebtoTot      = deValPrazRecebtoTot    + estatis_clien.val_praz_recebto
                       deValPrazRecebtoTotTot   = deValPrazRecebtoTotTot + estatis_clien.val_tot_praz_recebto
                       deValRecebtoTot          = deValRecebtoTot        + estatis_clien.val_recebto
                       deValRecebtoTotTot       = deValRecebtoTotTot     + estatis_clien.val_tot_recebto
                       dePrazoMedio             = IF (estatis_clien.val_praz_recebto / estatis_clien.val_tot_praz_recebto) <> ? THEN (estatis_clien.val_praz_recebto / estatis_clien.val_tot_praz_recebto) ELSE 0                   
                       deAtrasoMedio            = IF (estatis_clien.val_recebto / estatis_clien.val_tot_recebto) <> ? THEN (estatis_clien.val_recebto / estatis_clien.val_tot_recebto) ELSE 0.
                                         
                IF idx = 1 THEN DO:
                    ASSIGN deVendasPeriodo = estatis_clien.val_vendas.
                END.
                
            END.
        END.

        IF iMes = 1 THEN DO:
    
            ASSIGN iMes = 12
                   iAno = iAno - 1.
    
        END.
        ELSE DO:
    
            ASSIGN iMes = iMes - 1.
    
        END.
                  
    END.
    
    ASSIGN deMedia = IF (deValRecebtoTot / deValRecebtoTotTot) <> 0 THEN (deValRecebtoTot / deValRecebtoTotTot) ELSE 0.

    IF deMedia = ? THEN
        deMedia = 0.

END PROCEDURE.
