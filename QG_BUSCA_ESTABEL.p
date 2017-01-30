DEFINE VARIABLE c-cod-estabel       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lErroBuscaEstabel   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE cCodEstabel AS CHARACTER   NO-UNDO.

DEFINE TEMP-TABLE ttBuscaEstabel NO-UNDO
    FIELD int-1       LIKE es-busca-estabel.int-1 /*canal de venda*/
    FIELD uf-entrega  LIKE es-busca-estabel.uf-entrega
    FIELD it-codigo   LIKE es-busca-estabel.it-codigo
    FIELD item-pedido LIKE es-busca-estabel.it-codigo
    FIELD ge-codigo   LIKE es-busca-estabel.ge-codigo
    FIELD fm-codigo   LIKE es-busca-estabel.fm-codigo
    FIELD fm-cod-com  LIKE es-busca-estabel.fm-cod-com
    FIELD cod-grupo   LIKE es-busca-estabel.cod-grupo
    FIELD cod-estabel LIKE es-busca-estabel.cod-estabel
    FIELD pontuacao   AS INTEGER.

RUN piBuscaEstabel(INPUT "padrao",
                   INPUT "134808",
                   INPUT "40005021").

FOR EACH ttBuscaEstabel
    BREAK BY ttBuscaEstabel.item-pedido
          BY ttBuscaEstabel.pontuacao DESC:

    IF FIRST-OF(ttBuscaEstabel.item-pedido) AND FIRST-OF(ttBuscaEstabel.pontuacao) THEN DO:
        IF cCodEstabel <> "" AND cCodEstabel <> ttBuscaEstabel.cod-estabel THEN
            ASSIGN lErroBuscaEstabel = YES.

        ASSIGN cCodEstabel = ttBuscaEstabel.cod-estabel.

    END.

    MESSAGE cCodEstabel
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

PROCEDURE piBuscaEstabel:
/************************************************************************************
**  Programa : ESP/ESPD079.p
** Descricao : Busca Automatica de Estabelecimento
**     Autor : Kleber Sotte {Tortuga}
**      Data : 25.04.2009
**************************************************************************************/

DEFINE INPUT PARAMETER c-cod-entrega    LIKE loc-entr.cod-entrega.
DEFINE INPUT PARAMETER c-nome-abrev     LIKE emitente.nome-abrev.
DEFINE INPUT PARAMETER c-it-codigo      LIKE ws-p-venda.nr-pedcli.

DEFINE VARIABLE ls-uf-entrega   AS CHARACTER NO-UNDO.
DEFINE VARIABLE i-pontos        AS INTEGER   NO-UNDO.
DEFINE VARIABLE i-pontos-aux    AS INTEGER   NO-UNDO.
DEFINE BUFFER bes-busca-estabel FOR es-busca-estabel.
DEFINE BUFFER bemitente         FOR emitente.

ASSIGN ls-uf-entrega = "".

FIND FIRST loc-entr WHERE loc-entr.cod-entrega    = c-cod-entrega
                          AND loc-entr.nome-abrev = c-nome-abrev NO-LOCK NO-ERROR.

/*KSR - 03.12.2009*/
FIND FIRST bemitente 
     WHERE bemitente.nome-abrev = c-nome-abrev NO-LOCK NO-ERROR.
/**/

ASSIGN
    ls-uf-entrega = "?," + loc-entr.estado.

/*Defini»’o de pontua»’o
uf_entrega = 3200
it-codigo  = 1600
ge-codigo  = 800
fm-codigo  = 400
fm-cod-com = 200
cod-grupo  = 100
*/
ASSIGN i-pontos-aux  = 1
       c-cod-estabel = "".
EMPTY TEMP-TABLE ttBuscaEstabel.

FOR EACH bes-busca-estabel NO-LOCK
   /*WHERE LOOKUP(es-busca-estabel.uf-entrega,ls-uf-entrega) > 0*/:

    ASSIGN i-pontos = 0.

    FOR EACH ITEM NO-LOCK WHERE 
        ITEM.it-codigo = c-it-codigo
        ,
        FIRST es-item OF ITEM NO-LOCK:


        ASSIGN i-pontos = 0.

        /* restringe dados dos itens */
        IF bes-busca-estabel.uf-entrega      <> ?  AND LOOKUP(bes-busca-estabel.uf-entrega,loc-entr.estado)                      = 0 THEN NEXT.
        IF bes-busca-estabel.it-codigo       <> ?  AND LOOKUP(bes-busca-estabel.it-codigo,c-it-codigo)                = 0 THEN NEXT.
        IF bes-busca-estabel.ge-codigo       <> ?  AND LOOKUP(STRING(bes-busca-estabel.ge-codigo),STRING(ITEM.ge-codigo))        = 0 THEN NEXT.
        IF bes-busca-estabel.fm-codigo       <> ?  AND LOOKUP(bes-busca-estabel.fm-codigo,ITEM.fm-codigo)                        = 0 THEN NEXT.
        IF bes-busca-estabel.fm-cod-com      <> ?  AND LOOKUP(bes-busca-estabel.fm-cod-com,ITEM.fm-cod-com)                      = 0 THEN NEXT.
        IF bes-busca-estabel.cod-grupo       <> ?  AND LOOKUP(bes-busca-estabel.cod-grupo,es-item.cod-grupo)                     = 0 THEN NEXT.
        IF bes-busca-estabel.int-1           <> ?  AND LOOKUP(string(bes-busca-estabel.int-1),string(bemitente.cod-canal-venda)) = 0 THEN NEXT. /*KSR - 03.12.2009 - CANAL DE VENDA*/
        /*IF bes-busca-estabel.cod-tipo-oper   <> ?  AND LOOKUP(string(bes-busca-estabel.cod-tipo-oper),string(ws-p-venda.cod-tipo-oper))   = 0 THEN NEXT.*/

        /* Pontua Registros 
        itens com o valor ? n’o tem pontua»’o*/
        /*ASSIGN i-pontos = 3200. /*sempre inicio com 3200 porque ² a pontua»’o da UF e para entrar neste bloco, a UF OBRIGATORIAMENTE tem que ser igual a do pedido
                                 levando em considera»’o que a UF nunca pode conter o valor de ?*/*/

        IF bes-busca-estabel.int-1      <> ? THEN i-pontos = i-pontos + 6400.
        IF bes-busca-estabel.uf-entrega <> ? THEN i-pontos = i-pontos + 3200.
        IF bes-busca-estabel.it-codigo  <> ? THEN i-pontos = i-pontos + 1600.
        IF bes-busca-estabel.ge-codigo  <> ? THEN i-pontos = i-pontos + 800.
        IF bes-busca-estabel.fm-codigo  <> ? THEN i-pontos = i-pontos + 400.
        IF bes-busca-estabel.fm-cod-com <> ? THEN i-pontos = i-pontos + 200.
        IF bes-busca-estabel.cod-grupo  <> ? THEN i-pontos = i-pontos + 100.
        /*IF bes-busca-estabel.cod-tipo-oper  <> ? THEN i-pontos = i-pontos + 50.*/

        CREATE ttBuscaEstabel.
        ASSIGN ttBuscaEstabel.int-1       = bes-busca-estabel.int-1
               ttBuscaEstabel.uf-entrega  = bes-busca-estabel.uf-entrega
               ttBuscaEstabel.it-codigo   = bes-busca-estabel.it-codigo
               ttBuscaEstabel.item-pedido = c-it-codigo
               ttBuscaEstabel.ge-codigo   = bes-busca-estabel.ge-codigo
               ttBuscaEstabel.fm-codigo   = bes-busca-estabel.fm-codigo
               ttBuscaEstabel.fm-cod-com  = bes-busca-estabel.fm-cod-com
               ttBuscaEstabel.cod-grupo   = bes-busca-estabel.cod-grupo
               ttBuscaEstabel.cod-estabel = bes-busca-estabel.cod-estabel
               ttBuscaEstabel.pontuacao   = i-pontos.
        
    END.

/*     IF i-pontos >= i-pontos-aux THEN DO:                      */
/*         ASSIGN c-cod-estabel = bes-busca-estabel.cod-estabel  */
/*                i-pontos-aux = i-pontos.                       */
/*     END.                                                      */

END.


/*KSR - COMPARO O ESTABELECIMENTO DE CADA ITEM (DE MAIOR PONTUA€ÇO), SE FOR DIFERENTE, BLOQUEIO.*/
ASSIGN lErroBuscaEstabel = NO
       cCodEstabel       = "".

END PROCEDURE.
