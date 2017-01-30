DEFINE VARIABLE linha AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-rep AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i-qtd AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-cidade AS CHARACTER   NO-UNDO FORMAT "X(40)".

{include/varsituac.i}

OUTPUT TO "c:\pedidos_pendentes.csv".

PUT "ESTABEL"       ";"
    "NR PEDIDO"     ";"
    "COD.CLI"       ";"
    "NOME CLIENTE"  ";"
    "COD.REP"       ";"
    "LINHA"         ";"
    "REGIAO"        ";"
    "QTD AGENDAS"   ";"
    "CIDADE"        ";"
    "ESTADO"        ";"
    "STATUS"        ";"
    "CONTAGEM"      ";"
    SKIP.
    
FOR EACH ws-p-venda WHERE ws-p-venda.cod-tipo-oper = 139
                      AND ws-p-venda.ind-sit-ped <> 22
                      AND ws-p-venda.ind-sit-ped <> 17
                      AND YEAR(ws-p-venda.dt-impl) = 2016
                      NO-LOCK:
        
        c-rep = REPLACE(ws-p-venda.nr-pedcli, "MKTAG","").
        c-rep = REPLACE(c-rep, "MKT-","").
        c-rep = REPLACE(c-rep, "AGD-","").
        c-rep = REPLACE(c-rep, "AGD","").
        c-rep = REPLACE(c-rep, "MKT_","").
        c-rep = REPLACE(c-rep, "MKTB","").
        c-rep = REPLACE(c-rep, "MKTC","").
        c-rep = REPLACE(c-rep, "MKTFG","").
        c-rep = REPLACE(c-rep, "MKTBG","").
        c-rep = REPLACE(c-rep, "/11","").
        c-rep = REPLACE(c-rep, "/12","").
        c-rep = REPLACE(c-rep, "/2","").
        c-rep = REPLACE(c-rep, "/12A","").
        c-rep = REPLACE(c-rep, "/R","").
        c-rep = REPLACE(c-rep, "A11","").
        c-rep = REPLACE(c-rep, "A","").
        c-rep = REPLACE(c-rep, "B","").
        c-rep = REPLACE(c-rep, "C","").
        c-rep = REPLACE(c-rep, "MKT","").
        c-rep = REPLACE(c-rep, "c001","").
        c-rep = REPLACE(c-rep, "c002","").
        c-rep = REPLACE(c-rep, "c003","").
        c-rep = REPLACE(c-rep, "/","").
        
        FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
        FIND FIRST es-repres-comis WHERE es-repres-comis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
        FIND FIRST repres WHERE repres.cod-rep = es-repres-comis.cod-rep NO-LOCK NO-ERROR.
        
        ASSIGN linha = "".
        
        IF NOT AVAIL es-repres-comis THEN
            FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = INTE(c-rep) NO-LOCK NO-ERROR.
    
        IF NOT AVAIL repres THEN
            FIND FIRST repres WHERE repres.cod-rep = INTE(c-rep) NO-LOCK NO-ERROR.
    
        IF AVAIL es-repres-comis THEN DO:
            CASE es-repres-comis.u-int-1:
                WHEN 1 THEN
                    linha  = "Nutricao".
                WHEN 2 THEN
                    linha  = "Saude".
                WHEN 3 THEN
                    linha  = "Nutricao\Saude".
                WHEN 4 THEN
                    linha  = "Mitsuisal".
            END CASE.
        END.
        
        ASSIGN i-qtd = 0.
    
        FOR EACH ws-p-item OF ws-p-venda:
            i-qtd = i-qtd + ws-p-item.qt-pedida.
        END.
    
        FIND FIRST loc-entr WHERE loc-entr.nome-abrev = ws-p-venda.nome-abrev
                              AND loc-entr.cod-entrega = ws-p-venda.cod-entrega
                              NO-LOCK NO-ERROR.
    
        ASSIGN c-cidade = IF AVAIL loc-entr THEN loc-entr.cidade ELSE "".
    
        PUT ws-p-venda.cod-estabel                          ";"
            ws-p-venda.nr-pedcli                            ";"
            ws-p-venda.nome-abrev                           ";"
            emitente.nome-emit                              ";"
            c-rep                                           ";"
            linha FORMAT "X(20)"                            ";"
            IF AVAIL repres THEN repres.nome-ab-reg ELSE "" ";"
            i-qtd                                           ";"
            c-cidade FORMAT "X(40)"                         ";"
            IF AVAIL loc-entr THEN loc-entr.estado ELSE ""  ";"
            cSituacao[ws-p-venda.ind-sit-ped] FORMAT "X(20)"              ";"
            "1"                                             SKIP.    
END.

OUTPUT CLOSE.
