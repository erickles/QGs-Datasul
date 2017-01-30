DEFINE INPUT PARAMETER iCodEmitente LIKE emitente.cod-emitente  NO-UNDO.
DEFINE INPUT PARAMETER cCodEstabel  LIKE estabelec.cod-estabel  NO-UNDO.
DEFINE INPUT PARAMETER cItCodigo    LIKE ITEM.it-codigo         NO-UNDO.
DEFINE INPUT PARAMETER deQtdPedida  LIKE ws-p-item.qt-pedida    NO-UNDO.
/** Converter Strings Acentuadas **/
{include/i-freeac.i}                                 
                                 
/** Definicao de Tabelas Temporarias **/    

DEFINE TEMP-TABLE tt-preco NO-UNDO
    FIELD r-rowid-item    AS ROWID
    FIELD r-rowid-preco   AS ROWID
    FIELD pontos          AS INTEGER.

DEFINE OUTPUT PARAMETER TABLE FOR tt-preco.

/** Definicao de Variaveis **/                                                  
    
DEFINE VARIABLE ls-cidade            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-estado            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-cod-estabel       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-tipo-frete        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-tipo-cliente      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-canal-venda       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-nome-ab-reg       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-ge-codigo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-fm-codigo         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-fm-cod-com        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-tipo-oper         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-cod-gr-cli        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-nome-matriz       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-cod-emitente      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-balsa             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ls-embarque-export   AS CHARACTER   NO-UNDO. /* mfo 1933/09 */

DEFINE VARIABLE de-qt-pedido         AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-qt-pedido-2       AS DECIMAL                             NO-UNDO.
DEFINE VARIABLE de-qt-pedido-3       AS DECIMAL                             NO-UNDO.

DEFINE VARIABLE ls-it-codigo         AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE ls-cod-refer         AS CHARACTER                           NO-UNDO.
DEFINE VARIABLE ls-grupo-prod        AS CHARACTER                           NO-UNDO.

DEFINE VARIABLE c-cidade             LIKE es-busca-preco.cidade             NO-UNDO.
DEFINE VARIABLE c-estado             LIKE es-busca-preco.uf-destino         NO-UNDO.
DEFINE VARIABLE c-cod-estabel        LIKE es-busca-preco.cod-estabel        NO-UNDO.
DEFINE VARIABLE i-tipo-frete         LIKE es-busca-preco.ind-tp-frete       NO-UNDO.
DEFINE VARIABLE i-tipo-cliente       LIKE es-busca-preco.contribuinte       NO-UNDO.
DEFINE VARIABLE c-canal-venda        LIKE es-busca-preco.cod-canal-venda    NO-UNDO.
DEFINE VARIABLE c-nome-ab-reg        LIKE es-busca-preco.nome-ab-reg        NO-UNDO.
DEFINE VARIABLE i-ge-codigo          LIKE es-busca-preco.ge-codigo          NO-UNDO.
DEFINE VARIABLE c-fm-codigo          LIKE es-busca-preco.fm-codigo          NO-UNDO.
DEFINE VARIABLE c-fm-cod-com         LIKE es-busca-preco.fm-cod-com         NO-UNDO.
DEFINE VARIABLE i-cod-oper           LIKE es-busca-preco.cod-tipo-oper      NO-UNDO.
DEFINE VARIABLE i-cod-gr-cli         LIKE emitente.cod-gr-cli               NO-UNDO.
DEFINE VARIABLE c-nome-matriz        LIKE emitente.nome-matriz              NO-UNDO.
DEFINE VARIABLE i-cod-emitente       LIKE emitente.cod-emitente             NO-UNDO.

DEFINE VARIABLE c-it-codigo          LIKE ITEM.it-codigo                    NO-UNDO.
DEFINE VARIABLE c-cod-refer          LIKE ITEM.cod-refer                    NO-UNDO.
DEFINE VARIABLE c-grupo-prod         LIKE es-grupo-prod.cod-grupo           NO-UNDO.

DEFINE VARIABLE i-pontos             AS   INTEGER                           NO-UNDO.

DEFINE VARIABLE d-qt-pedida          LIKE ws-p-item.qt-pedida          NO-UNDO.
DEFINE VARIABLE c-matriz             AS   CHARACTER                    NO-UNDO.
DEFINE VARIABLE i-cont               AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE l-acumula            AS   LOGICAL                      NO-UNDO.
DEFINE VARIABLE i-periodo            AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE da-transacao         AS   DATE                         NO-UNDO.
DEFINE VARIABLE i-nr-mes             AS   INTEGER                      NO-UNDO.
DEFINE BUFFER   b-item                FOR  item.
DEFINE BUFFER   buf-item              FOR  item.
DEFINE BUFFER   b-es-item             FOR  es-item.
DEFINE BUFFER   b-emitente            FOR emitente.
DEFINE BUFFER   b-ped-item            FOR ped-item.
DEFINE BUFFER   bf-emitente            FOR emitente.

/** Cria Possibilidades para os Dataos do Pedido de Venda  **/
FIND FIRST emitente WHERE emitente.cod-emitente = iCodEmitente NO-LOCK NO-ERROR.

FIND FIRST repres NO-LOCK WHERE repres.cod-rep = 9999 NO-ERROR.

FIND FIRST loc-entr NO-LOCK WHERE loc-entr.nome-abrev = emitente.nome-abrev
                            AND loc-entr.cod-entrega = "Padrao" NO-ERROR.

ASSIGN ls-cidade        = "?," + TRIM(fn-free-accent(loc-entr.cidade))
       ls-estado        = "?," + TRIM(loc-entr.estado)
       ls-cod-estabel   = "?," + cCodEstabel
       ls-tipo-frete    = "4," + STRING(1)
       ls-cod-gr-cli    = "?," + STRING(emitente.cod-gr-cli)
       ls-nome-matriz   = "?," + fn-free-accent(emitente.nome-matriz)
       ls-cod-emitente  = "?," + STRING(emitente.cod-emitente).

IF emitente.contrib-icms THEN
    ASSIGN ls-tipo-cliente   = "3," + STRING(1).
ELSE 
    ASSIGN ls-tipo-cliente = "3," + STRING(2).

ASSIGN ls-canal-venda  = "?," + STRING(emitente.cod-canal-venda)
       ls-nome-ab-reg  = "?," + TRIM(fn-free-accent(repres.nome-ab-reg)).

ASSIGN ls-ge-codigo   = "?,"
       ls-fm-codigo   = "?,"
       ls-fm-cod-com  = "?,"
       ls-tipo-oper   = "?,"
       ls-it-codigo   = "?,"
       ls-cod-refer   = "?,"
       ls-grupo-prod  = "?,".

ASSIGN ls-balsa = "N"
       ls-embarque-export = "0".

/** Cria Possibilidades dos Itens do Pedido **/

FIND FIRST ITEM NO-LOCK WHERE item.it-codigo = cItCodigo NO-ERROR.
IF AVAIL ITEM THEN DO:

    FIND es-item WHERE es-item.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
    
    ASSIGN ls-ge-codigo    = ls-ge-codigo  + STRING(ITEM.ge-codigo)             + ","
           ls-fm-codigo    = ls-fm-codigo  + fn-free-accent(ITEM.fm-codigo)     + ","
           ls-fm-cod-com   = ls-fm-cod-com + fn-free-accent(ITEM.fm-cod-com)    + ","
           ls-tipo-oper    = ls-tipo-oper  + STRING(7)                          + ","
           ls-it-codigo    = ls-it-codigo  + fn-free-accent(cItCodigo)          + ","
           ls-cod-refer    = ls-cod-refer  + item.cod-refer                     + ","
           ls-grupo-prod   = ls-grupo-prod + IF AVAIL es-item THEN fn-free-accent(es-item.cod-grupo) + ',' ELSE ''
           de-qt-pedido    = de-qt-pedido  + deQtdPedida.
END.

/** Seleciona Registro mais Adequado **/
DEFINE VARIABLE iCont-1 AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-2 AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-3 AS INTEGER     NO-UNDO.

DEFINE VARIABLE pc-cidade   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE pc-estado   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE pc-estabel  AS CHARACTER   NO-UNDO.

DO iCont-1 = 1 TO NUM-ENTRIES(ls-cidade):

    DO iCont-2 = 1 TO NUM-ENTRIES(ls-estado):

        DO iCont-3 = 1 TO NUM-ENTRIES(ls-cod-estabel):
          
            ASSIGN pc-cidade  = IF ENTRY(iCont-1,ls-cidade) = "?" THEN ? ELSE ENTRY(iCont-1,ls-cidade)
                   pc-estado  = IF ENTRY(iCont-2,ls-estado) = "?" THEN ? ELSE ENTRY(iCont-2,ls-estado)    
                   pc-estabel = IF ENTRY(iCont-3,ls-cod-estabel) = "?" THEN ? ELSE ENTRY(iCont-3,ls-cod-estabel).

            FOR EACH es-busca-preco NO-LOCK WHERE es-busca-preco.cidade       BEGINS pc-cidade
                                            AND es-busca-preco.uf-destino   = pc-estado 
                                            AND es-busca-preco.cod-estabel  = pc-estabel
                                            AND es-busca-preco.qtidade-ini <= de-qt-pedido
                                            AND es-busca-preco.qtidade-fim >= de-qt-pedido:

                IF TODAY < es-busca-preco.data-1 OR TODAY > es-busca-preco.data-2 THEN NEXT.
                
                IF ls-balsa = "s" AND es-busca-preco.log-1 = NO THEN NEXT.
                IF ls-balsa = "n" AND es-busca-preco.log-1 THEN NEXT. /*KSR - 17.08.2009*/
            
                IF LOOKUP(STRING(es-busca-preco.int-1), ls-embarque-export) = 0 THEN NEXT.  /* mfo 1933/09 */
                
                ASSIGN c-cidade       = TRIM(fn-free-accent(es-busca-preco.cidade))
                       c-estado       = es-busca-preco.uf-destino
                       c-cod-estabel  = es-busca-preco.cod-estabel
                       i-tipo-frete   = es-busca-preco.ind-tp-frete
                       i-tipo-cliente = es-busca-preco.contribuinte
                       c-canal-venda  = es-busca-preco.cod-canal-venda
                       c-nome-ab-reg  = fn-free-accent(es-busca-preco.nome-ab-reg)
                       i-ge-codigo    = es-busca-preco.ge-codigo
                       c-fm-codigo    = fn-free-accent(es-busca-preco.fm-codigo)
                       c-fm-cod-com   = fn-free-accent(es-busca-preco.fm-cod-com)
                       i-cod-oper     = es-busca-preco.cod-tipo-oper
                       c-it-codigo    = es-busca-preco.it-codigo
                       c-cod-refer    = es-busca-preco.cod-refer
                       c-grupo-prod   = fn-free-accent(es-busca-preco.cod-grupo)
                       i-cod-gr-cli   = es-busca-preco.cod-gr-cli
                       c-nome-matriz  = fn-free-accent(es-busca-preco.nome-matriz)
                       i-cod-emitente = es-busca-preco.cod-emitente.
                    
                IF i-cod-emitente <> ? THEN DO:
                   FIND FIRST emitente NO-LOCK WHERE emitente.cod-emitente = i-cod-emitente NO-ERROR.
                   IF AVAIL emitente THEN
                      ASSIGN c-canal-venda     = emitente.cod-canal-venda
                             i-cod-gr-cli      = emitente.cod-gr-cli
                             c-nome-matriz     = fn-free-accent(emitente.nome-matriz).
                END.
            
                IF c-it-codigo <> ? THEN DO:
                    FIND ITEM WHERE ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL ITEM THEN 
                        ASSIGN c-fm-codigo  = fn-free-accent(ITEM.fm-codigo)
                               c-fm-cod-com = fn-free-accent(ITEM.fm-cod-com)
                               i-ge-codigo  = ITEM.ge-codigo.
            
                    FIND es-item WHERE es-item.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
                    IF AVAIL es-item THEN
                        c-grupo-prod = fn-free-accent(es-item.cod-grupo).
                END.
            
                /* Restringe dados do pedido */
                IF LOOKUP(c-cidade,ls-cidade)                     = 0 THEN NEXT.
                IF LOOKUP(c-estado,ls-estado)                     = 0 THEN NEXT.
                IF LOOKUP(c-cod-estabel,ls-cod-estabel)           = 0 THEN NEXT.
                IF LOOKUP(STRING(i-tipo-frete),ls-tipo-frete)     = 0 THEN NEXT.
                IF LOOKUP(STRING(i-tipo-cliente),ls-tipo-cliente) = 0 THEN NEXT. 
                IF LOOKUP(STRING(i-cod-gr-cli),ls-cod-gr-cli)     = 0 THEN NEXT.
                IF LOOKUP(STRING(i-cod-emitente),ls-cod-emitente) = 0 THEN NEXT.
                IF LOOKUP(STRING(c-nome-matriz),ls-nome-matriz)   = 0 THEN NEXT.
                
                /* restringe dados dos itens */
                IF LOOKUP(string(c-canal-venda),ls-canal-venda)   = 0 THEN NEXT.
                IF LOOKUP(c-nome-ab-reg,ls-nome-ab-reg)           = 0 THEN NEXT.
                IF LOOKUP(STRING(i-ge-codigo),ls-ge-codigo)       = 0 THEN NEXT.
                IF LOOKUP(c-fm-codigo,ls-fm-codigo)               = 0 THEN NEXT.
                IF LOOKUP(c-fm-cod-com,ls-fm-cod-com)             = 0 THEN NEXT.
                IF LOOKUP(STRING(i-cod-oper),ls-tipo-oper)        = 0 THEN NEXT.
                IF LOOKUP(c-it-codigo,ls-it-codigo)               = 0 THEN NEXT.
                IF LOOKUP(c-cod-refer,ls-cod-refer)               = 0 THEN NEXT.                              
                IF LOOKUP(c-grupo-prod,ls-grupo-prod)             = 0 THEN NEXT.
                
                FIND FIRST ITEM WHERE item.it-codigo = cItCodigo NO-LOCK NO-ERROR.
                IF AVAIL ITEM THEN DO:
                
                    IF ITEM.codigo-orig >= 1 AND ITEM.codigo-orig <= 3 AND es-busca-preco.int-2 = 2 /*Fora Reso*/ THEN NEXT.
                    IF (ITEM.codigo-orig < 1 OR ITEM.codigo-orig > 3)  AND es-busca-preco.int-2 = 1 /*Resolucao*/ THEN NEXT.

                    /* restringe dados dos itens */
                    IF i-ge-codigo  <> ? AND i-ge-codigo  <> ITEM.ge-codigo             THEN NEXT.
                    IF c-fm-codigo  <> ? AND c-fm-codigo  <> STRING(ITEM.fm-codigo)     THEN NEXT.
                    IF c-fm-cod-com <> ? AND c-fm-cod-com <> STRING(ITEM.fm-cod-com)    THEN NEXT.
                    IF i-cod-oper   <> ? AND i-cod-oper   <> 7                          THEN NEXT.
                    IF c-it-codigo  <> ? AND c-it-codigo  <> ITEM.it-codigo             THEN NEXT.
                    IF c-cod-refer  <> ? AND c-cod-refer  <> ITEM.cod-refer             THEN NEXT.

                    FIND es-item WHERE es-item.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
                    IF c-grupo-prod     <> ?             AND
                       AVAIL es-item                     AND
                       c-grupo-prod <> es-item.cod-grupo THEN NEXT.
            
                    ASSIGN d-qt-pedida  = 0.                  
                    
                    CASE es-busca-preco.acumula-valores:

                        WHEN 1 THEN DO: /* Nao Acumula */
                            IF deQtdPedida < es-busca-preco.qtidade-item-ini OR
                               deQtdPedida > es-busca-preco.qtidade-item-fim THEN
                               NEXT.
                        END.

                    END.
            
                    /* Pontua Registros */
                                                                      
                    i-pontos = 0.                                     
                                                                      
                    IF i-cod-oper           <> ? THEN i-pontos = i-pontos + 2621440. 
                    IF c-cidade             <> ? THEN i-pontos = i-pontos + 1310720. 
                    IF c-estado             <> ? THEN i-pontos = i-pontos + 655360 . 
                    IF es-busca-preco.int-2 <> 0 THEN i-pontos = i-pontos + 327680 .                                                                  
                    IF c-cod-estabel        <> ? THEN i-pontos = i-pontos + 163840 . 
                    IF i-tipo-frete         <> 4 THEN i-pontos = i-pontos + 81920  . 
                    IF i-cod-emitente       <> ? THEN i-pontos = i-pontos + 40960  . 
                    IF i-tipo-cliente       <> 3 THEN i-pontos = i-pontos + 20480  . 
                    IF c-canal-venda        <> ? THEN i-pontos = i-pontos + 10240  . 
                    IF i-cod-gr-cli         <> ? THEN i-pontos = i-pontos + 5120   . 
                    IF c-nome-matriz        <> ? THEN i-pontos = i-pontos + 2560   . 
                    IF c-nome-ab-reg        <> ? THEN i-pontos = i-pontos + 1280   . 
                    IF c-it-codigo          <> ? THEN i-pontos = i-pontos + 640    . 
                    IF i-ge-codigo          <> ? THEN i-pontos = i-pontos + 320    . 
                    IF c-fm-codigo          <> ? THEN i-pontos = i-pontos + 160    . 
                    IF c-fm-cod-com         <> ? THEN i-pontos = i-pontos + 80     .
                    IF c-grupo-prod         <> ? THEN i-pontos = i-pontos + 40     . 
                    IF c-cod-refer          <> ? THEN i-pontos = i-pontos + 20     . 
                    IF es-busca-preco.int-1 <> 0 THEN i-pontos = i-pontos + 10     .  /* mfo 1933/09 */
                    
                    IF c-fm-cod-com = "Aves" THEN  
                       i-pontos = i-pontos + 2621440 + 10.

                    FIND FIRST tt-preco NO-ERROR.
                    IF NOT AVAIL tt-preco THEN DO:
                        CREATE tt-preco.
                        ASSIGN tt-preco.r-rowid-preco = ROWID(es-busca-preco)
                               tt-preco.pontos = i-pontos.
                    END.
                    ELSE DO:
                        IF tt-preco.pontos < i-pontos THEN DO:
                            ASSIGN tt-preco.r-rowid-preco = ROWID(es-busca-preco)
                                   tt-preco.pontos = i-pontos.
                        END.
                    END.
                END.
            END.
        END.
    END.
END.
