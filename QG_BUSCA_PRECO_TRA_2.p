DEFINE VARIABLE i-cod-emitente  AS INTEGER      LABEL "Cod. Emitente"   NO-UNDO.
DEFINE VARIABLE c-it-codigo     AS CHARACTER    LABEL "Cod. Item"       NO-UNDO.
DEFINE VARIABLE i-contrib       AS INTEGER                              NO-UNDO.
DEFINE VARIABLE d-preco         AS DECIMAL     NO-UNDO.

UPDATE i-cod-emitente LABEL "Emitente"
       c-it-codigo    LABEL "Item".
    
FIND FIRST emitente WHERE emitente.cod-emitente = i-cod-emitente NO-LOCK NO-ERROR.
IF AVAIL emitente THEN DO:

    FOR EACH es-busca-preco WHERE es-busca-preco.uf-destino     = emitente.estado
                              AND es-busca-preco.nr-tabpre      BEGINS "TRA"
                              AND es-busca-preco.cod-tipo-oper  = 7
                              AND es-busca-preco.data-1         <= TODAY
                              AND es-busca-preco.data-2         >= TODAY
                              AND (es-busca-preco.contribuinte = 3                                  OR
                                   INTE(es-busca-preco.contribuinte) = INTE(emitente.contrib-icms)  OR 
                                   (INTE(es-busca-preco.contribuinte) = 2 AND INTE(emitente.contrib-icms) = 0)):

        IF es-busca-preco.cod-emitente <> emitente.cod-emitente AND es-busca-preco.cod-emitente <> ? THEN NEXT.

        FIND FIRST estabelec WHERE estabelec.estado = emitente.estado NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN DO:
            IF es-busca-preco.cod-estabel <> ? THEN
                IF estabelec.cod-estabel <> es-busca-preco.cod-estabel THEN NEXT.
        END.

        FIND LAST preco-item WHERE preco-item.it-codigo = c-it-codigo
                               AND preco-item.nr-tabpre = es-busca-preco.nr-tabpre
                               NO-LOCK NO-ERROR.

        i-contrib = IF emitente.contrib-icms THEN 1 ELSE 2.

        IF AVAIL item THEN DO:

            FIND FIRST es-cfop WHERE es-cfop.estado        = emitente.estado
                                 AND es-cfop.cod-tipo-oper = "7"
                                 AND es-cfop.ge-codigo     = STRING(ITEM.ge-codigo)
                                 AND es-cfop.cod-estabel   = es-busca-preco.cod-estabel
                                 AND es-cfop.contribui     = i-contrib
                                 NO-LOCK NO-ERROR.

            IF NOT AVAIL es-cfop THEN
                FIND FIRST es-cfop WHERE es-cfop.estado    = emitente.estado
                                     AND es-cfop.cod-tipo-oper = "7"
                                     AND es-cfop.ge-codigo     = STRING(ITEM.ge-codigo)
                                     AND es-cfop.cod-estabel   = es-busca-preco.cod-estabel
                                     AND es-cfop.contribui     = 3
                                     NO-LOCK NO-ERROR.
        END.

        IF AVAIL preco-item THEN DO:

            ASSIGN d-preco = preco-item.preco-venda.                    
                
            IF AVAIL es-cfop THEN DO:
                ASSIGN d-preco = d-preco - (d-preco * (es-cfop.desc-icms / 100)).
            END.

            MESSAGE "Preco:             " + STRING(d-preco)                 SKIP
                    "Tabela Preco:      " + STRING(preco-item.nr-tabpre)    SKIP
                    "Busca de Preco:    " + STRING(es-busca-preco.nr-busca)
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.
    END.
END.
