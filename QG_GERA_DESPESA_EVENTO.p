DEFINE BUFFER bfes-ev-integr-desp FOR es-ev-integr-desp.
DEFINE VARIABLE desc-icms LIKE es-cfop.desc-icms     NO-UNDO.
DEFINE VARIABLE deTotItem AS DECIMAL     NO-UNDO.

DEFINE TEMP-TABLE tt-cfop NO-UNDO
    FIELD r-rowid-item    AS ROWID
    FIELD r-rowid-cfop    AS ROWID
    FIELD pontos          AS INTEGER.

DEFINE TEMP-TABLE tt-es-ev-integr-desp LIKE es-ev-integr-desp.

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = "ADMKT564/11" NO-LOCK NO-ERROR.

/* Checa o desconto de ICMS */
RUN esp/espd1901.p (INPUT ROWID(ws-p-venda),
                    OUTPUT TABLE tt-cfop).

FOR EACH tt-cfop NO-LOCK BREAK BY tt-cfop.pontos:

    IF FIRST-OF(tt-cfop.pontos) THEN DO:

        FIND es-cfop NO-LOCK WHERE ROWID (es-cfop) = tt-cfop.r-rowid-cfop NO-ERROR.

        IF AVAIL es-cfop AND
           es-cfop.desc-icms > 0 THEN
            ASSIGN deTotItem = (deTotItem * es-cfop.desc-icms) / 100
                   desc-icms = es-cfop.desc-icms.

    END.
    
END.

FIND FIRST bfes-ev-integr-desp NO-LOCK WHERE bfes-ev-integr-desp.nome-abrev = ws-p-venda.nome-abrev 
                                         AND bfes-ev-integr-desp.nr-pedcli  = ws-p-venda.nr-pedcli  
                                         AND bfes-ev-integr-desp.origem     = "PV" NO-ERROR.

    IF AVAIL bfes-ev-integr-desp THEN DO:
    
        FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
    
            FIND tt-es-ev-integr-desp EXCLUSIVE-LOCK
                WHERE tt-es-ev-integr-desp.origem     = "PV"
                  AND tt-es-ev-integr-desp.nome-abrev = ws-p-venda.nome-abrev 
                  AND tt-es-ev-integr-desp.nr-pedcli  = ws-p-venda.nr-pedcli
                  AND tt-es-ev-integr-desp.it-codigo  = ws-p-item.it-codigo NO-ERROR.
    
            
            IF NOT AVAIL tt-es-ev-integr-desp THEN DO:
    
                CREATE tt-es-ev-integr-desp.
                ASSIGN tt-es-ev-integr-desp.origem     = "PV"
                       tt-es-ev-integr-desp.nome-abrev = ws-p-venda.nome-abrev 
                       tt-es-ev-integr-desp.nr-pedcli  = ws-p-venda.nr-pedcli
                       tt-es-ev-integr-desp.it-codigo  = ws-p-item.it-codigo.
    
            END.
    
            ASSIGN tt-es-ev-integr-desp.cod-evento     = bfes-ev-integr-desp.cod-evento
                   tt-es-ev-integr-desp.ano-referencia = bfes-ev-integr-desp.ano-referencia
                   tt-es-ev-integr-desp.tipo-item      = bfes-ev-integr-desp.tipo-item
                   tt-es-ev-integr-desp.quantidade     = ws-p-item.qt-pedida
                   tt-es-ev-integr-desp.vl-unitario    = ws-p-item.vl-preuni
                   tt-es-ev-integr-desp.vl-total       = (tt-es-ev-integr-desp.quantidade * ws-p-item.vl-preuni)
                   tt-es-ev-integr-desp.usuario        = "kprezend"
                   tt-es-ev-integr-desp.dt-implant     = TODAY
                   tt-es-ev-integr-desp.hr-implant     = TIME.
            
            
            ASSIGN /*tt-es-ev-integr-desp.vl-total = tt-es-ev-integr-desp.vl-total - (tt-es-ev-integr-desp.vl-total * desc-icms) / 100*/
                   tt-es-ev-integr-desp.vl-total = ws-p-venda.vl-tot-ped.
            
        END.
    
        FOR EACH tt-es-ev-integr-desp EXCLUSIVE-LOCK
            WHERE tt-es-ev-integr-desp.origem         = "PV"
              AND tt-es-ev-integr-desp.nome-abrev     = ws-p-venda.nome-abrev 
              AND tt-es-ev-integr-desp.nr-pedcli      = ws-p-venda.nr-pedcli
              AND tt-es-ev-integr-desp.cod-evento     = bfes-ev-integr-desp.cod-evento    
              AND tt-es-ev-integr-desp.ano-referencia = bfes-ev-integr-desp.ano-referencia
              AND tt-es-ev-integr-desp.tipo-item      = bfes-ev-integr-desp.tipo-item :
    
            FIND FIRST ws-p-item OF ws-p-venda NO-LOCK
                WHERE ws-p-item.it-codigo = tt-es-ev-integr-desp.it-codigo NO-ERROR.
            /*
            IF NOT AVAIL ws-p-item THEN DO:
                DELETE es-ev-integr-desp.            
            END.                         
            */
        END.
    END.
