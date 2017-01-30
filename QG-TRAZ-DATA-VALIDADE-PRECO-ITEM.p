DEFINE VARIABLE preco AS DECIMAL     NO-UNDO.
DEFINE BUFFER b3-p-venda FOR ws-p-venda.

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = "1787w0001" NO-ERROR.
FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
    RUN setPrecoItem(INPUT ws-p-item.nr-tabpre,
                     INPUT ws-p-item.it-codigo,
                     INPUT "",
                     INPUT 4500,
                     INPUT 1,
                     INPUT ws-p-venda.dt-implant,
                     INPUT ws-p-venda.nome-abrev,
                     INPUT ws-p-venda.no-ab-reppri,
                     OUTPUT preco).

    MESSAGE preco
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.

PROCEDURE setPrecoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER pc-nr-tabpre     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-it-codigo     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-cod-refer     AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pde-qt-pedida    AS DECIMAL   NO-UNDO.
    DEFINE INPUT  PARAMETER pi-nr-sequencia  AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER pdt-implant      AS DATE      NO-UNDO.
    DEFINE INPUT  PARAMETER pc-nome-abrev    AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER pc-no-ab-reppri  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pde-preco        AS DECIMAL   NO-UNDO.

    FIND FIRST repres WHERE repres.nome-abrev = pc-no-ab-reppri NO-LOCK NO-ERROR.
    
    FIND LAST es-cad-cli WHERE es-cad-cli.nome-abrev = pc-nome-abrev 
                           AND es-cad-cli.log-renov  = NO 
                           NO-LOCK NO-ERROR.

    FIND FIRST b3-p-venda WHERE b3-p-venda.nome-abrev = pc-nome-abrev 
                            AND b3-p-venda.nr-pedcli  <> ws-p-venda.nr-pedcli
                            NO-LOCK NO-ERROR.

    IF AVAIL es-cad-cli THEN
        MESSAGE es-cad-cli.dt-atualiz
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    IF (AVAIL es-cad-cli                            AND
       es-cad-cli.dt-inclusao  <= 10/20/2011 /*20*/ AND
       es-cad-cli.dt-atualiz > 10/20/2011  /*20*/ AND
       es-cad-cli.dt-atualiz = pdt-implant        AND
       NOT AVAIL b3-p-venda) OR (AVAIL repres AND repres.nome-ab-reg BEGINS "B.H." AND TODAY <= 10/28/2011) THEN DO:
        /*
        ASSIGN ws-p-venda.dt-impl = 10/19/2011
               pdt-implant        = 10/19/2011.
               */
        pdt-implant        = 10/20/2011.
    END.        
            
    FIND FIRST tb-preco 
         WHERE tb-preco.nr-tabpre  = pc-nr-tabpre 
           AND tb-preco.dt-inival <= pdt-implant
           AND tb-preco.dt-fimval >= pdt-implant
           NO-LOCK NO-ERROR.
    IF AVAIL tb-preco THEN DO:       

       FIND FIRST preco-item WHERE
                  preco-item.nr-tabpre  = pc-nr-tabpre   AND
                  preco-item.it-codigo  = pc-it-codigo   AND
                  preco-item.cod-refer  = pc-cod-refer   AND
                  preco-item.quant-min <= pde-qt-pedida  AND
                  preco-item.dt-inival <= pdt-implant    AND 
                  preco-item.situacao   = 1              NO-LOCK NO-ERROR.
       IF AVAIL preco-item THEN DO:

          IF ws-p-venda.tp-frete = 2 THEN 
             pde-preco = preco-item.preco-fob.
          ELSE
             pde-preco = preco-item.preco-venda.
       
       END.          
    END.

END PROCEDURE.
