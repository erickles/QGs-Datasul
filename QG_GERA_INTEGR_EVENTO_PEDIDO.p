DEFINE VARIABLE nrPedcli        AS CHAR FORMAT "X(12)".
DEFINE VARIABLE codigoEvento    AS INTEGER     NO-UNDO.
DEFINE VARIABLE desc-icms       LIKE es-cfop.desc-icms     NO-UNDO.
DEFINE VARIABLE deTotItem       AS DECIMAL    NO-UNDO.

DEFINE TEMP-TABLE tt-cfop NO-UNDO
        FIELD r-rowid-item    AS ROWID
        FIELD r-rowid-cfop    AS ROWID
        FIELD pontos          AS INTEGER.

UPDATE nrPedcli codigoEvento.

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = nrPedcli.
IF AVAIL ws-p-venda THEN DO:

    ASSIGN deTotItem = 0.

    /* Checa o desconto de ICMS */
    RUN esp/espd1901.p (INPUT ROWID(ws-p-venda),
                        OUTPUT TABLE tt-cfop).

    FOR EACH tt-cfop NO-LOCK BREAK BY tt-cfop.pontos:

        IF FIRST-OF(tt-cfop.pontos) THEN DO:

            FIND es-cfop NO-LOCK WHERE ROWID (es-cfop) = tt-cfop.r-rowid-cfop NO-ERROR.
            IF AVAIL es-cfop AND es-cfop.desc-icms > 0 THEN
                ASSIGN deTotItem = (deTotItem * es-cfop.desc-icms) / 100
                       desc-icms = es-cfop.desc-icms.
                
        END.
    END.

    RUN piIntegraItemDesp(INPUT ws-p-venda.nr-pedcli, INPUT "").

END.

PROCEDURE piIntegraItemDesp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER numeroPedido AS CHAR.
    DEFINE INPUT PARAMETER usuario      AS CHAR.        

    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
        ASSIGN deTotItem = deTotItem + (ws-p-item.qt-pedida * ws-p-item.vl-preuni).
    END.
    
    DEFINE BUFFER bfes-ev-integr-desp FOR es-ev-integr-desp.    

    FIND FIRST bfes-ev-integr-desp NO-LOCK WHERE bfes-ev-integr-desp.nr-pedcli  = numeroPedido
                                             AND bfes-ev-integr-desp.origem     = "PV" NO-ERROR.

    IF AVAIL bfes-ev-integr-desp THEN DO:
    
        FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
    
            FIND es-ev-integr-desp EXCLUSIVE-LOCK
                WHERE es-ev-integr-desp.origem     = "PV"
                  AND es-ev-integr-desp.nome-abrev = ws-p-venda.nome-abrev 
                  AND es-ev-integr-desp.nr-pedcli  = ws-p-venda.nr-pedcli
                  AND es-ev-integr-desp.it-codigo  = ws-p-item.it-codigo NO-ERROR.
    
            IF NOT AVAIL es-ev-integr-desp THEN DO:
                
                CREATE es-ev-integr-desp.
                ASSIGN es-ev-integr-desp.origem     = "PV"
                       es-ev-integr-desp.nome-abrev = ws-p-venda.nome-abrev 
                       es-ev-integr-desp.nr-pedcli  = ws-p-venda.nr-pedcli
                       es-ev-integr-desp.it-codigo  = ws-p-item.it-codigo.
    
            END.
    
            ASSIGN es-ev-integr-desp.cod-evento     = bfes-ev-integr-desp.cod-evento
                   es-ev-integr-desp.ano-referencia = bfes-ev-integr-desp.ano-referencia
                   es-ev-integr-desp.tipo-item      = bfes-ev-integr-desp.tipo-item
                   es-ev-integr-desp.quantidade     = ws-p-item.qt-pedida
                   es-ev-integr-desp.vl-unitario    = ws-p-item.vl-preuni
                   es-ev-integr-desp.vl-total       = (es-ev-integr-desp.quantidade * ws-p-item.vl-preuni)
                   es-ev-integr-desp.usuario        = usuario
                   es-ev-integr-desp.dt-implant     = TODAY
                   es-ev-integr-desp.hr-implant     = TIME.

            ASSIGN es-ev-integr-desp.vl-total = es-ev-integr-desp.vl-total - (es-ev-integr-desp.vl-total * desc-icms) / 100
                   es-ev-integr-desp.vl-total = ws-p-venda.vl-tot-ped.
               
        END.
    
        FOR EACH es-ev-integr-desp EXCLUSIVE-LOCK
            WHERE es-ev-integr-desp.origem         = "PV"
              AND es-ev-integr-desp.nome-abrev     = ws-p-venda.nome-abrev 
              AND es-ev-integr-desp.nr-pedcli      = ws-p-venda.nr-pedcli
              AND es-ev-integr-desp.cod-evento     = bfes-ev-integr-desp.cod-evento    
              AND es-ev-integr-desp.ano-referencia = bfes-ev-integr-desp.ano-referencia
              AND es-ev-integr-desp.tipo-item      = bfes-ev-integr-desp.tipo-item :
    
            FIND FIRST ws-p-item OF ws-p-venda NO-LOCK
                WHERE ws-p-item.it-codigo = es-ev-integr-desp.it-codigo NO-ERROR.
            IF NOT AVAIL ws-p-item THEN DO:
                DELETE es-ev-integr-desp.
            END.                         
        END.
    END.
    ELSE DO:

        CREATE es-ev-integr-desp.
        ASSIGN es-ev-integr-desp.origem         = "PV"                  
               es-ev-integr-desp.nome-abrev     = ws-p-venda.nome-abrev 
               es-ev-integr-desp.nr-pedcli      = ws-p-venda.nr-pedcli
               es-ev-integr-desp.cod-evento     = codigoEvento
               es-ev-integr-desp.ano-referencia = 2013
               es-ev-integr-desp.tipo-item      = 10.

    END.

END PROCEDURE.
