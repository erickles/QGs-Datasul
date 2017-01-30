
DEFINE VARIABLE cData AS CHARACTER   NO-UNDO FORMAT "99/9999".
DEFINE VARIABLE iMes    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iAno    AS INTEGER     NO-UNDO.
DEFINE VARIABLE idx     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMeses  AS INTEGER     NO-UNDO INITIAL 12.

DEFINE VARIABLE deVendasAcumuladas  AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deValorSaldo        AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deVendasPeriodo     AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deValorTotRebto     AS DECIMAL     NO-UNDO.

UPDATE cData.

ASSIGN iMes = INTE(SUBSTRING(cData,1,2))
       iAno = INTE(SUBSTRING(cData,3,4)).

DO idx = 1 TO iMeses:
    
    FIND FIRST estatis_clien WHERE estatis_clien.cdn_clien                  = 270836 
                               AND estatis_clien.cod_empresa                = "TOR"
                               AND MONTH(estatis_clien.dat_estatis_clien)   = iMes
                               AND YEAR(estatis_clien.dat_estatis_clien)   = iAno
                               NO-LOCK NO-ERROR.
    IF AVAIL estatis_clien THEN DO:

        ASSIGN deVendasAcumuladas = deVendasAcumuladas + estatis_clien.val_vendas
               deValorSaldo       = deValorSaldo + val_sdo_clien
               deValorTotRebto    = deValorTotRebto + estatis_clien.val_recebto.

        IF idx = 1 THEN DO:
            ASSIGN deVendasPeriodo = estatis_clien.val_vendas.
        END.
            

        MESSAGE STRING(iMes,"99") + "/" + STRING(iAno)          SKIP                
                "Vendas: " estatis_clien.val_vendas             SKIP
                "Valor Recebimento: " estatis_clien.val_recebto SKIP
                estatis_clien.val_praz_recebto / estatis_clien.val_tot_praz_recebto
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

    END.
    ELSE DO:
        MESSAGE STRING(iMes,"99") + "/" + STRING(iAno)  SKIP
                "Atraso M‚dio: 0"                       SKIP
                "Prazo M‚dio: 0"                        SKIP
                "Vendas: 0"                             SKIP                     
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.

    IF iMes = 1 THEN DO:

        ASSIGN iMes = 12
               iAno = iAno - 1.

    END.
    ELSE DO:

        ASSIGN iMes = iMes - 1.

    END.

END.

MESSAGE "Vendas: " deVendasPeriodo                  SKIP
        "Vendas acumuladas: " deVendasAcumuladas    SKIP
        "Valor Saldo" deValorSaldo                  SKIP
        "Valor tot rebto: " deValorTotRebto
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*
 Valor Recebimento dividido pela soma Valor Total Recebimento
FOR EACH estatis_clien WHERE estatis_clien.cdn_clien = 270836
                         AND estatis_clien.cod_empresa = "TOR"
                         /*AND estatis_clien.dat_estatis_clien*/
                         NO-LOCK:

    DISP cod_grp_clien 
         dat_estatis_clien 
         num_pessoa 
         val_praz_recebto 
         val_recebto 
         val_sdo_clien 
         val_tot_praz_recebto 
         val_tot_recebto 
         val_vendas
         estatis_clien.num_livre_1 estatis_clien.num_livre_2 estatis_clien.val_devol
         WITH 1 COL.

END.
*/
/*
cod_empresa
cdb_cliente
*/
