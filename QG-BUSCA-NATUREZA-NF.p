/* Busca Autom tica de Tipo de Opera‡Æo (Nota de Remessa Automatica) */

{include/i-freeac.i}                                 

DEFINE TEMP-TABLE tt-cfop NO-UNDO
    FIELD r-rowid-item    AS ROWID
    FIELD r-rowid-cfop    AS ROWID
    FIELD pontos          AS INTEGER.

/** Definicao de Parametros de Entrada **/

DEFINE INPUT  PARAMETER pr-rowid      AS ROWID      NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-cfop.

/** Definicao de Variaveis **/

DEFINE VARIABLE ls-cod-estabel       AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-estado            AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-cnae              AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-contribui         AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-natureza          AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-it-codigo         AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-it-reg            AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-ge-codigo         AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-fm-codigo         AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-fm-cod-com        AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-cod-tipo-oper     AS CHARACTER                      NO-UNDO.
DEFINE VARIABLE ls-nat-oper-inte     AS CHARACTER                      NO-UNDO.

DEFINE VARIABLE c-cod-estabel        LIKE es-cfop.cod-estabel          NO-UNDO.
DEFINE VARIABLE c-estado             LIKE es-cfop.estado               NO-UNDO.
DEFINE VARIABLE i-cnae               LIKE es-cfop.cod-cnae             NO-UNDO.
DEFINE VARIABLE i-contribui          LIKE es-cfop.contribui            NO-UNDO.
DEFINE VARIABLE i-natureza           LIKE es-cfop.natureza             NO-UNDO.
DEFINE VARIABLE c-it-codigo          LIKE es-cfop.it-codigo            NO-UNDO.
DEFINE VARIABLE c-ge-codigo          LIKE es-cfop.ge-codigo            NO-UNDO.
DEFINE VARIABLE c-fm-codigo          LIKE es-cfop.fm-codigo            NO-UNDO.
DEFINE VARIABLE c-fm-cod-com         LIKE es-cfop.fm-codigo-comercial  NO-UNDO.

DEFINE VARIABLE lContribui           AS   LOGICAL                      NO-UNDO.

DEFINE VARIABLE i-pontos             AS   INTEGER                      NO-UNDO.

DEFINE VARIABLE i-cont               AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-cont-1             AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-cont-2             AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-cont-3             AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-cont-4             AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE i-cont-5             AS   INTEGER                      NO-UNDO.

DEFINE VARIABLE iContEstab           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iContUf              AS INTEGER    NO-UNDO.

DEFINE VARIABLE pcEstabel            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE pcEstado             AS CHARACTER  NO-UNDO.

/** Localiza Pedido de Venda **/

FIND nota-fiscal WHERE 
     ROWID(nota-fiscal) = pr-rowid NO-LOCK NO-ERROR.
IF NOT AVAIL nota-fiscal THEN
    RETURN 'nok':U.

/** Cria Possibilidades para os Dataos do Pedido de Venda  **/
FIND FIRST emitente WHERE emitente.nome-abrev = nota-fiscal.nome-abrev NO-LOCK NO-ERROR.
IF AVAIL emitente THEN
    
FIND FIRST es-emitente-dis WHERE 
           es-emitente-dis.cod-emitente = emitente.cod-emitente 
           NO-LOCK NO-ERROR.
IF AVAIL es-emitente-dis THEN
    
FIND FIRST loc-entr NO-LOCK 
     WHERE loc-entr.nome-abrev  = nota-fiscal.nome-abrev 
       AND loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-ERROR.

IF AVAIL loc-entr THEN      
    ASSIGN ls-cod-estabel   = "?," + nota-fiscal.cod-estabel
           ls-estado        = "?," + IF AVAIL loc-entr THEN loc-entr.estado ELSE ''
           ls-cnae          = "?," + IF AVAIL es-emitente-dis THEN STRING(es-emitente-dis.cod-cnae) ELSE ''
           ls-contribui     = "3," + IF emitente.contrib-icms THEN '1' ELSE '2'
           ls-natureza      = "5," + STRING(emitente.natureza)
           ls-fm-codigo     = "?," 
           ls-fm-cod-com    = "?," 
           ls-it-codigo     = "?," 
           ls-ge-codigo     = "?,"
           ls-nat-oper-inte = "?," + nota-fiscal.nat-operacao.
   
/** Cria Possibilidades dos Itens do Pedido **/    
FOR EACH it-nota-fisc NO-LOCK 
   WHERE it-nota-fisc.nr-nota-fis   = nota-fiscal.nr-nota-fis
     AND it-nota-fisc.serie         = nota-fiscal.serie
     AND it-nota-fisc.cod-estabel   = nota-fiscal.cod-estabel,
   FIRST ITEM  NO-LOCK 
   WHERE ITEM.it-codigo = it-nota-fisc.it-codigo:

   ASSIGN ls-fm-codigo     = ls-fm-codigo     + fn-free-accent(ITEM.fm-codigo)          + ","
          ls-fm-cod-com    = ls-fm-cod-com    + fn-free-accent(ITEM.fm-cod-com)         + ","
          ls-it-codigo     = ls-it-codigo     + fn-free-accent(it-nota-fisc.it-codigo)  + ","
          ls-ge-codigo     = ls-ge-codigo     + STRING(ITEM.ge-codigo)                  + ",".
END.

/** Seleciona Registro mais Adequado **/
DO iContEstab = 1 TO NUM-ENTRIES(ls-cod-estabel):

    pcEstabel = IF ENTRY(iContEstab,ls-cod-estabel) = '?' THEN ? ELSE ENTRY(iContEstab,ls-cod-estabel).

    DO iContUf = 1 TO NUM-ENTRIES(ls-estado):
    
        pcEstado = IF ENTRY(iContUf,ls-estado) = '?' THEN ? ELSE ENTRY(iContUf,ls-estado).

        DO i-cont = 1 TO NUM-ENTRIES(ls-nat-oper-inte):
        
           DO i-cont-2 = 1 TO NUM-ENTRIES(ls-contribui):
        
              DO i-cont-3 = 1 TO NUM-ENTRIES(ls-natureza):

                  DO i-cont-4 = 1 TO NUM-ENTRIES(ls-cnae):
        
                       FOR EACH es-cfop NO-LOCK
                          WHERE es-cfop.nat-operacao-interna = ENTRY(i-cont,ls-nat-oper-inte)
                            AND es-cfop.cod-estabel          = pcEstabel
                            AND es-cfop.estado               = pcEstado
                            AND es-cfop.cod-cnae             = INTE(ENTRY(i-cont-4,ls-cnae))
                            AND es-cfop.contribui            = INTE(ENTRY(i-cont-2,ls-contribui))
                            AND es-cfop.natureza             = INTE(ENTRY(i-cont-3,ls-natureza)):
                    
                          ASSIGN c-it-codigo   = fn-free-accent(es-cfop.it-codigo)
                                 c-ge-codigo   = es-cfop.ge-codigo
                                 c-fm-codigo   = fn-free-accent(es-cfop.fm-codigo)
                                 c-fm-cod-com  = fn-free-accent(es-cfop.fm-codigo-comercial).
            
                          IF c-it-codigo <> ? THEN DO:
                            FIND ITEM WHERE 
                                 ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.
                            IF AVAIL ITEM THEN 
                               ASSIGN
                                 c-fm-codigo   = fn-free-accent(ITEM.fm-codigo)
                                 c-fm-cod-com  = fn-free-accent(ITEM.fm-cod-com)
                                 c-ge-codigo   = STRING(ITEM.ge-codigo). 
                          END.
            
                          /* restringe dados dos itens */
                          IF LOOKUP(c-it-codigo,ls-it-codigo)             = 0 THEN NEXT.
                          IF LOOKUP(STRING(c-ge-codigo),ls-ge-codigo)     = 0 THEN NEXT.
                          IF LOOKUP(c-fm-codigo,ls-fm-codigo)             = 0 THEN NEXT.
                          IF LOOKUP(c-fm-cod-com,ls-fm-cod-com)           = 0 THEN NEXT.           
            
                          FOR EACH it-nota-fisc NO-LOCK
                             WHERE it-nota-fisc.nr-nota-fis   = nota-fiscal.nr-nota-fis
                               AND it-nota-fisc.serie         = nota-fiscal.serie
                               AND it-nota-fisc.cod-estabel   = nota-fiscal.cod-estabel,
                               FIRST ITEM NO-LOCK 
                                   WHERE item.it-codigo = it-nota-fisc.it-codigo : 
            
                                  /* Restringe tipo de operacao */
                                  IF es-cfop.nat-operacao-interna <> ? AND 
                                     es-cfop.nat-operacao-interna <> it-nota-fisc.nat-operacao THEN NEXT.
            
                                  /* Verifica Item Registrado */
                                  FIND es-regprod WHERE 
                                       es-regprod.it-codigo = ITEM.it-codigo NO-LOCK NO-ERROR.
            
                                  /* restringe dados dos itens */
                                  IF c-it-codigo  <> ? AND c-it-codigo  <> ITEM.it-codigo         THEN NEXT.
                                  IF c-ge-codigo  <> ? AND c-ge-codigo  <> STRING(ITEM.ge-codigo) THEN NEXT.
                                  IF c-fm-codigo  <> ? AND c-fm-codigo  <> ITEM.fm-codigo         THEN NEXT.
                                  IF c-fm-cod-com <> ? AND c-fm-cod-com <> ITEM.fm-cod-com        THEN NEXT.
            
                                  /* Valida Item Registrado */
                                  IF AVAIL es-regprod     AND NOT es-cfop.log-item-reg           THEN NEXT.
                                  IF NOT AVAIL es-regprod AND es-cfop.log-item-reg               THEN NEXT.  
            
                                  /* Pontua Registros */
            
                                  i-pontos = 0.
                                  
                                  ASSIGN i-pontos = IF es-cfop.estado       = ? THEN i-pontos ELSE i-pontos + 3200
                                         i-pontos = IF es-cfop.cod-estabel  = ? THEN i-pontos ELSE i-pontos + 1500
                                         i-pontos = IF es-cfop.cod-cnae     = ? THEN i-pontos ELSE i-pontos + 700
                                         i-pontos = IF es-cfop.contribui    = 3 THEN i-pontos ELSE i-pontos + 330 
                                         i-pontos = IF es-cfop.natureza     = 5 THEN i-pontos ELSE i-pontos + 160  
                                         i-pontos = IF c-it-codigo          = ? THEN i-pontos ELSE i-pontos + 80
                                         i-pontos = IF c-ge-codigo          = ? THEN i-pontos ELSE i-pontos + 40
                                         i-pontos = IF c-fm-codigo          = ? THEN i-pontos ELSE i-pontos + 20
                                         i-pontos = IF c-fm-cod-com         = ? THEN i-pontos ELSE i-pontos + 10.  
                                       
                                  FIND tt-cfop WHERE 
                                       tt-cfop.r-rowid-item = ROWID(it-nota-fisc) NO-ERROR.
                                  IF NOT AVAIL tt-cfop THEN DO:
                                     CREATE tt-cfop.
                                     ASSIGN tt-cfop.r-rowid-item = ROWID(it-nota-fisc).
                                  END.
                                  IF tt-cfop.pontos <= i-pontos THEN DO:                   
                                     ASSIGN tt-cfop.pontos       = i-pontos
                                            tt-cfop.r-rowid-cfop = ROWID(es-cfop).                   
                                  END.            
                          END.            
                       END.
                  END.        
              END.        
           END.       
        END.
    END.    
END.       
