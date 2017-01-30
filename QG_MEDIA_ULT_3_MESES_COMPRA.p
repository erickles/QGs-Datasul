{include/i-buffer.i}
{include/i-prgvrs.i ESCC022RP 2.04.00.001}
{utp/ut-glob.i}
{include/i-freeac.i}
{includes/varsituac.i}

/* Variable Definitions *******************************************************/
DEFINE VARIABLE dt-emis-ped             AS DATE                         NO-UNDO.
DEFINE VARIABLE c-comprador             AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-fornecedor            AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-forn-cidade           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-forn-estado           AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-forn-pais             AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-requisitante          AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE i-pedido                AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-ordem                 AS INTEGER                      NO-UNDO FORMAT "999999.99".
DEFINE VARIABLE c-estab-gest            AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-requisitante-p        AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE d-qt-solic              LIKE ordem-compra.qt-solic      NO-UNDO.
DEFINE VARIABLE d-pre-cli               LIKE ordem-compra.preco-fornec  NO-UNDO.
DEFINE VARIABLE c-moeda                 AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-situacao              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-via-transp            AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-processo              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-transportador         AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-mensagem              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE c-emitente              AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE i-parcela               AS INTEGER                      NO-UNDO.
DEFINE VARIABLE i-data-entre            AS DATE                         NO-UNDO.
DEFINE VARIABLE d-data-trans-origem     AS DATE                         NO-UNDO.
DEFINE VARIABLE c-nome-emit-origem      AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE i-tp-despesa            LIKE ordem-compra.tp-despesa    NO-UNDO.
DEFINE VARIABLE c-nome                  LIKE usuar-mater.nome-usuar     NO-UNDO.
DEFINE VARIABLE c-nome-estabel          AS CHAR FORMAT "X(15)"          NO-UNDO.
DEFINE VARIABLE c-desc-desp             AS CHAR FORMAT "X(15)"          NO-UNDO.
DEFINE VARIABLE c-mes                   AS CHAR FORMAT "X(10)" EXTENT 12 NO-UNDO.
DEFINE VARIABLE c-lotacao               AS CHAR FORMAT "X(06)"          NO-UNDO.
DEFINE VARIABLE c-narrativa             AS CHAR FORMAT "X(50)"          NO-UNDO.
DEFINE VARIABLE c-natureza              AS CHAR FORMAT "X(14)"          NO-UNDO.
DEFINE VARIABLE c-conta                 AS CHAR FORMAT "X(17)"          NO-UNDO.

DEFINE VARIABLE dtInicial               AS DATE        NO-UNDO.
DEFINE VARIABLE dtFinal                 AS DATE        NO-UNDO.

/* Buffers ********************************************************************/
DEFINE BUFFER bf-emitente     FOR emitente.
DEFINE BUFFER bf-docum-est    FOR docum-est.

DEFINE TEMP-TABLE tt-compras
    FIELD cEstabelec            AS CHAR FORMAT "X(40)"
    FIELD dtTrans               AS DATE FORMAT 99/99/9999
    FIELD cMesTrans             AS CHAR FORMAT "X(12)"
    FIELD cNrDoc                AS CHAR FORMAT "X(12)"
    FIELD cSerie                AS CHAR FORMAT "X(12)"
    FIELD cContaContabil        AS CHAR FORMAT "X(12)"
    FIELD cGrupoEstoque         AS CHAR
    FIELD cFamilia              AS CHAR
    FIELD cItem                 AS CHAR FORMAT "X(12)"
    FIELD cDescItem             AS CHAR FORMAT "X(40)"
    FIELD cTipoDespesa          AS CHAR
    FIELD cUnidade              AS CHAR
    FIELD cNatureza             AS CHAR
    FIELD iCodEmitente          AS INTE
    FIELD cNomeEmitente         AS CHAR
    FIELD cNaturezaOper         AS CHAR
    FIELD cDescrNatureza        AS CHAR
    FIELD dtEmissao             AS DATE FORMAT 99/99/9999
    FIELD iQuantidade           AS INTE FORMAT ">>>>>,>>9.9999"
    FIELD dePreco               AS DECI FORMAT ">>>,>>>,>>9.99999"
    FIELD iNrPedido             AS INTE
    FIELD DtEmissaoPedido       AS DATE FORMAT 99/99/9999
    FIELD cComprador            AS CHAR
    FIELD cNomeComprador        AS CHAR
    FIELD cLotComprador         AS CHAR
    FIELD cRequisitante         AS CHAR
    FIELD cNarrativa            AS CHAR
    FIELD cFornecedor           AS CHAR
    FIELD iGrupoFornec          AS INTE
    FIELD cCidadeFornec         AS CHAR
    FIELD cUfFornec             AS CHAR
    FIELD cPaisFornec           AS CHAR
    FIELD cProcesso             AS CHAR
    FIELD cTransportador        AS CHAR
    FIELD cViaTranp             AS CHAR
    FIELD cMensagem             AS CHAR
    FIELD cEstabGestor          AS CHAR
    FIELD cNomeRequisitante     AS CHAR
    FIELD deQuantidadePedido    AS DECI FORMAT ">>>>>,>>9.9999"
    FIELD dePrecoFornec         AS DECI FORMAT ">>>,>>>,>>9.99999"
    FIELD cMoeda                AS CHAR
    FIELD cSituacao             AS CHAR
    FIELD iOrdem                AS INTE
    FIELD iParcela              AS INTE
    FIELD deQuantidade          AS DECI FORMAT ">>>>>,>>9.9999"
    FIELD dtEntrega             AS DATE FORMAT 99/99/9999
    FIELD cCondPagto            AS CHAR
    FIELD dtTransOrig           AS DATE FORMAT 99/99/9999
    FIELD cDocOrigem            AS CHAR
    FIELD cSerOrigem            AS CHAR
    FIELD iCodEmitOrigem        AS INTE
    FIELD cNomeEmitOrigem       AS CHAR
    FIELD dtTransOrigem         AS DATE FORMAT 99/99/9999.

DEFINE VARIABLE dtBase AS DATE        NO-UNDO FORMAT 99/99/9999.

UPDATE dtBase.

ASSIGN dtInicial = DATE("01/" + STRING(MONTH(dtBase)) + "/" + STRING(YEAR(dtBase)))
       dtFinal   = DATE("01/" + STRING(MONTH(dtBase) + 1) + "/" + STRING(YEAR(dtBase))) - 1.

OUTPUT TO "c:\Temp\Compras.csv".

FOR EACH docum-est WHERE docum-est.dt-trans     >= dtInicial
                     AND docum-est.dt-trans     <= dtFinal
                     AND docum-est.cod-emitente >= 000000
                     AND docum-est.cod-emitente <= 999999
                     NO-LOCK:

    IF docum-est.CE-atual = NO THEN NEXT.

    FIND FIRST tit-ap WHERE tit-ap.ep-codigo   = 1
                        AND tit-ap.cod-fornec  = docum-est.cod-emitente
                        AND tit-ap.cod-estabel = docum-est.cod-estabel
                        AND tit-ap.serie       = docum-est.serie-docto
                        AND tit-ap.nr-docto    = docum-est.nro-docto
                        NO-LOCK NO-ERROR.

    FOR EACH item-doc-est WHERE item-doc-est.cod-emitente   = docum-est.cod-emitente
                            AND item-doc-est.serie-docto    = docum-est.serie
                            AND item-doc-est.nro-docto      = docum-est.nro-docto
                            AND item-doc-est.nat-operacao   = docum-est.nat-operacao
                            AND item-doc-est.it-codigo      >= "10000000"
                            AND item-doc-est.it-codigo      <= "29999999",
                            EACH item OF item-doc-est WHERE (item.ge-codigo = 1 OR item.ge-codigo = 2)
                            NO-LOCK:

        FIND emitente WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
        IF NOT AVAIL emitente THEN NEXT.
        
        /*IF emitente.cod-gr-forn <> 1 AND emitente.cod-gr-forn <> 3 THEN NEXT.*/
        
        ASSIGN i-pedido = item-doc-est.num-pedido
               i-ordem  = item-doc-est.numero-ordem.

        FIND natur-oper WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
        FIND familia WHERE familia.fm-codigo = item.fm-codigo NO-LOCK NO-ERROR.

        IF AVAIL emitente THEN ASSIGN c-emitente = emitente.nome-emit.
        
        FIND pedido-compr WHERE pedido-compr.num-pedido = i-pedido NO-LOCK NO-ERROR.
        ASSIGN dt-emis-ped = IF AVAIL pedido-compr THEN pedido-compr.data-pedido ELSE ?.
                        
        FIND ordem-compra WHERE ordem-compra.it-codigo     = item-doc-est.it-codigo
                            AND ordem-compra.num-pedido    = i-pedido
                            AND ordem-compra.numero-ordem  = i-ordem 
                            NO-LOCK NO-ERROR.
        
        IF AVAIL ordem-compra THEN DO:
            ASSIGN i-tp-despesa = ordem-compra.tp-despesa
                   c-comprador  = ordem-compra.cod-comprado.

            IF ordem-compra.tp-despesa <> 301 AND
               ordem-compra.tp-despesa <> 334 AND
               ordem-compra.tp-despesa <> 335 AND
               ordem-compra.tp-despesa <> 336 AND
               ordem-compra.tp-despesa <> 303 THEN NEXT.
        END.
        ELSE
            ASSIGN i-tp-despesa = 0
                   c-comprador  = "".
        
        IF i-tp-despesa = 0 THEN NEXT.

        ASSIGN c-requisitante = IF AVAIL ordem-compra THEN ordem-compra.usuario ELSE "".
                
        ASSIGN c-mes[1]  = "JANEIRO"
               c-mes[2]  = "FEVEREIRO"
               c-mes[3]  = "MARCO"
               c-mes[4]  = "ABRIL"
               c-mes[5]  = "MAIO"
               c-mes[6]  = "JUNHO"
               c-mes[7]  = "JULHO"
               c-mes[8]  = "AGOSTO"
               c-mes[9]  = "SETEMBRO"
               c-mes[10] = "OUTUBRO"
               c-mes[11] = "NOVEMBRO"
               c-mes[12] = "DEZEMBRO".
        
        FIND FIRST estabelec WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN ASSIGN c-nome-estabel = estabelec.cidade.

        FIND FIRST grup-estoque WHERE grup-estoque.ge-codigo = ITEM.ge-codigo NO-LOCK NO-ERROR.

        FIND FIRST tipo-rec-desp WHERE tipo-rec-desp.tp-codigo = i-tp-despesa NO-LOCK NO-ERROR.
        IF AVAIL tipo-rec-desp THEN
            ASSIGN c-desc-desp = CAPS(fn-free-accent(tipo-rec-desp.descricao)).
        
        FIND FIRST pedido-compr WHERE pedido-compr.num-pedido = i-pedido NO-LOCK NO-ERROR.
        IF AVAIL pedido-compr THEN DO:
            ASSIGN c-natureza   = IF pedido-compr.natureza = 1 THEN "COMPRA"
                                  ELSE IF pedido-compr.natureza = 2 THEN "SERVICO"
                                      ELSE "BENEFICIAMENTO".
            
            ASSIGN c-via-transp = fn-free-accent({adinc/i01ad268.i 04 pedido-compr.via-transp}).
    
            FIND FIRST usuar-mater WHERE usuar-mater.cod-usuario = c-comprador NO-LOCK NO-ERROR.
                                                                                                              
            IF AVAIL usuar-mater THEN DO:
                ASSIGN c-nome = usuar-mater.nome-usuar
                       c-lotacao = SUBSTRING(usuar-mater.char-1,2,4).
            END.
            ELSE                                                                                      
                ASSIGN c-nome    = " "
                       c-lotacao = " ".

            FIND FIRST emitente WHERE emitente.cod-emitente = pedido-compr.cod-emitente NO-LOCK NO-ERROR.
            IF AVAIL emitente THEN DO:
                ASSIGN c-fornecedor  = emitente.nome-emit
                       c-forn-cidade = emitente.cidade
                       c-forn-estado = emitente.estado
                       c-forn-pais   = emitente.pais.
            END.

            IF NOT AVAIL ordem-compra THEN DO:
                FIND FIRST contabiliza WHERE contabiliza.ge-codigo = item.ge-codigo NO-LOCK NO-ERROR.

                IF AVAIL contabiliza THEN DO:
                    FIND FIRST conta-contab WHERE conta-contab.conta-contabil = contabiliza.conta-contabil NO-LOCK NO-ERROR.
                    IF AVAIL contabiliza THEN
                        ASSIGN c-conta = CAPS(fn-free-accent(conta-contab.titulo)).
                END.
            END.

            IF AVAIL ordem-compra THEN DO:

                FIND FIRST conta-contab WHERE conta-contab.conta-contabil = ordem-compra.conta-contabil 
                                          AND conta-contab.ep-codigo      = estabelec.ep-codigo 
                                          NO-LOCK NO-ERROR.
                        
                IF AVAIL conta-contab THEN
                    ASSIGN c-conta = CAPS(fn-free-accent(conta-contab.titulo)).    
                        
                FIND FIRST usuar-mater WHERE usuar-mater.cod-usuario = ordem-compra.requisitante NO-LOCK NO-ERROR.
                IF AVAIL usuar-mater THEN
                    ASSIGN c-requisitante-p = usuar-mater.nome-usuar.

                ASSIGN d-qt-solic = ordem-compra.qt-solic
                       d-pre-cli  = ordem-compra.preco-fornec
                       c-situacao = {ininc/i02in274.i 4 ordem-compra.situacao} .

                ASSIGN c-narrativa  = fn-free-accent(REPLACE(REPLACE(REPLACE(ordem-compra.narrativa,CHR(13),""),CHR(10),""),CHR(9),"")).

                FIND FIRST moeda WHERE moeda.mo-codigo = ordem-compra.mo-codigo NO-LOCK NO-ERROR.
                IF AVAIL moeda THEN
                    ASSIGN c-moeda = moeda.descricao.

            END.

            FIND FIRST estabelec WHERE estabelec.cod-estabel = pedido-compr.cod-estab-gestor NO-LOCK NO-ERROR.
            IF AVAIL estabelec THEN
                ASSIGN c-estab-gest = STRING(estabelec.nome + " - " + estabelec.cidade).

            FIND FIRST proc-compra WHERE proc-compra.nr-processo = pedido-compr.nr-processo NO-LOCK NO-ERROR.
            IF AVAIL proc-compra THEN
                ASSIGN c-processo = proc-compra.descricao.
            ELSE
                ASSIGN c-processo = "".

            FIND FIRST mensagem WHERE mensagem.cod-mensagem = pedido-compr.cod-mensagem NO-LOCK NO-ERROR.
            IF AVAIL mensagem THEN
                ASSIGN c-mensagem = mensagem.descricao.
            ELSE 
                ASSIGN c-mensagem = "".

            FIND FIRST transporte WHERE transporte.cod-transp = pedido-compr.cod-transp NO-LOCK NO-ERROR.
            IF AVAIL transporte THEN
                ASSIGN c-transportador = transporte.nome-abrev.
            ELSE
                ASSIGN c-transportador = "".

            ASSIGN  i-pedido = item-doc-est.num-pedido
                    i-ordem  = item-doc-est.numero-ordem.
        END.
        
        FIND FIRST rat-ordem OF item-doc-est NO-LOCK NO-ERROR.

        IF AVAIL rat-ordem THEN DO:
            FIND FIRST prazo-compra WHERE prazo-compra.numero-ordem = rat-ordem.numero-ordem
                                      AND prazo-compra.parcela      = rat-ordem.parcela NO-LOCK NO-ERROR.

            IF AVAIL prazo-compra THEN
                ASSIGN i-ordem      = rat-ordem.numero-ordem
                       i-parcela    = prazo-compra.parcela
                       i-data-entre = prazo-compra.data-entrega.                               
        END.
        ELSE DO:
            FIND FIRST prazo-compra WHERE prazo-compra.numero-ordem = item-doc-est.numero-ordem 
                                      AND prazo-compra.parcela      = item-doc-est.parcela NO-LOCK NO-ERROR.
            IF AVAIL prazo-compra THEN
                ASSIGN i-ordem      = item-doc-est.numero-ordem
                       i-parcela    = prazo-compra.parcela
                       i-data-entre = prazo-compra.data-entrega.
        END.

        IF AVAIL pedido-compr THEN
            FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = pedido-compr.cod-cond-pag NO-LOCK NO-ERROR.

        FIND bf-emitente WHERE bf-emitente.cod-emitente = item-doc-est.emite-comp NO-LOCK NO-ERROR.

        FIND bf-docum-est WHERE bf-docum-est.cod-emitente = item-doc-est.emite-comp
                            AND bf-docum-est.serie        = item-doc-est.serie-comp
                            AND bf-docum-est.nro-docto    = item-doc-est.nro-comp     
                            AND bf-docum-est.nat-operacao = item-doc-est.nat-comp   
                            NO-LOCK NO-ERROR.

        ASSIGN d-data-trans-origem  = IF AVAIL bf-docum-est THEN bf-docum-est.dt-trans ELSE docum-est.dt-trans
               c-nome-emit-origem   = IF AVAIL bf-emitente AND item-doc-est.emite-comp <> 0 THEN bf-emitente.nome-emit ELSE "".
        
        CREATE tt-compras.
        ASSIGN tt-compras.cEstabelec            = CAPS(string(docum-est.cod-estabel + " - " + fn-free-accent(c-nome-estabel)))
               tt-compras.dtTrans               = docum-est.dt-trans
               tt-compras.cMesTrans             = c-mes[MONTH(docum-est.dt-trans)]
               tt-compras.cNrDoc                = docum-est.nro-docto
               tt-compras.cSerie                = docum-est.serie
               tt-compras.cContaContabil        = c-conta
               tt-compras.cGrupoEstoque         = CAPS(STRING(STRING(ITEM.ge-codigo) + " - " + fn-free-accent(grup-estoque.descricao)))
               tt-compras.cFamilia              = fn-free-accent(familia.descricao)
               tt-compras.cItem                 = item-doc-est.it-codigo
               tt-compras.cDescItem             = fn-free-accent(ITEM.desc-item)
               tt-compras.cTipoDespesa          = IF AVAIL tipo-rec-desp THEN STRING(STRING(i-tp-despesa) + " - " + c-desc-desp) ELSE STRING(i-tp-despesa)
               tt-compras.cUnidade              = CAPS(ITEM.un)
               tt-compras.cNatureza             = c-natureza
               tt-compras.iCodEmitente          = docum-est.cod-emitente
               tt-compras.cNomeEmitente         = fn-free-accent(c-emitente)
               tt-compras.cNaturezaOper         = CAPS(docum-est.nat-operacao)
               tt-compras.cDescrNatureza        = fn-free-accent(natur-oper.denominacao)
               tt-compras.dtEmissao             = docum-est.dt-emissao
               tt-compras.iQuantidade           = item-doc-est.quantidade
               tt-compras.dePreco               = item-doc-est.preco-total[1]
               tt-compras.iNrPedido             = i-pedido
               tt-compras.DtEmissaoPedido       = dt-emis-ped
               tt-compras.cComprador            = c-comprador
               tt-compras.cNomeComprador        = c-nome
               tt-compras.cLotComprador         = c-lotacao
               tt-compras.cRequisitante         = c-requisitante
               tt-compras.cNarrativa            = fn-free-accent(c-narrativa)
               tt-compras.cFornecedor           = fn-free-accent(c-fornecedor)
               tt-compras.cCidadeFornec         = fn-free-accent(c-forn-cidade)
               tt-compras.cUfFornec             = fn-free-accent(c-forn-estado)
               tt-compras.cPaisFornec           = CAPS(fn-free-accent(c-forn-pais))
               tt-compras.cProcesso             = fn-free-accent(c-processo)
               tt-compras.cTransportador        = fn-free-accent(c-transportador)
               tt-compras.cViaTranp             = CAPS(c-via-transp)
               tt-compras.cMensagem             = CAPS(fn-free-accent(c-mensagem))
               tt-compras.cEstabGestor          = fn-free-accent(c-estab-gest)
               tt-compras.cNomeRequisitante     = fn-free-accent(c-requisitante-p)
               tt-compras.deQuantidadePedido    = d-qt-solic
               tt-compras.dePrecoFornec         = d-pre-cli
               tt-compras.cMoeda                = fn-free-accent(c-moeda)
               tt-compras.cSituacao             = CAPS(fn-free-accent(c-situacao))
               tt-compras.iOrdem                = i-ordem
               tt-compras.iParcela              = i-parcela
               tt-compras.deQuantidade          = item-doc-est.quantidade
               tt-compras.dtEntrega             = i-data-entre
               tt-compras.cCondPagto            = IF AVAIL cond-pagto THEN CAPS(fn-free-accent(cond-pagto.descricao)) ELSE ""
               tt-compras.dtTransOrig           = d-data-trans-origem
               tt-compras.cDocOrigem            = item-doc-est.nro-comp
               tt-compras.cSerOrigem            = item-doc-est.serie-comp
               tt-compras.iCodEmitOrigem        = item-doc-est.emite-comp
               tt-compras.cNomeEmitOrigem       = c-nome-emit-origem
               tt-compras.dtTransOrigem         = d-data-trans-origem
               tt-compras.iGrupoFornec          = emitente.cod-gr-forn.

    END.

    ASSIGN c-conta          = ""
           c-narrativa      = ""
           c-fornecedor     = ""
           c-forn-cidade    = ""
           c-forn-estado    = ""
           c-forn-pais      = ""
           c-estab-gest     = ""
           c-requisitante-p = ""
           c-requisitante   = ""
           d-qt-solic       = 0
           d-pre-cli        = 0
           c-situacao       = ""
           c-via-transp     = ""
           c-emitente       = ""
           c-comprador      = "".
END.

PUT "Estabel;"  
    "Dt. Trans.;"  
    "Màs Trans.;"  
    "Documento;"  
    "Serie;"  
    "Conta Contabil;"  
    "Grupo Estoque;"  
    "Familia;"  
    "Item;"  
    "Desc. Item;"  
    "TP Despesa;"  
    "Unidade;"  
    "Naureza;"  
    "Cod.Emitente;"  
    "Nome Emitente;"  
    "Natureza Operaá∆o;"  
    "Descriá∆o;"
    "Dt.Emiss∆o;"
    "Quantidade;"
    "Preáo;"
    "Nr.Pedido;"
    "Dt.emiss∆o Pedido;"
    "Comprador;"
    "Nome Comprador;"
    "Lotaá∆o Comprador;"
    "Requisitante;"
    "Narrativa Pedido;"
    "Fornecedor;"
    "Cidade - Forn;"
    "UF - Forn;"
    "Pais - Forn;"
    "Processo;"
    "Transportador;"
    "Via Transporte;"
    "Mensagem;"
    "Estabel Gestor;"
    "Requisitante;"
    "Quant. do Pedido;"
    "Preáo Fornecedor;"
    "Moeda;"
    "Situacao;"
    "Ordem;"
    "Parc;"
    "Qtde;"
    "Entrega;"
    "Cond. Pagto;"
    "Dt. Trans.Origem;"
    "Documento Origem;"
    "Serie Origem;"
    "Cod.Emitente Origem;"
    "Nome Emitente Origem;"
    "Grupo Fornec"
    SKIP.

FOR EACH tt-compras NO-LOCK:
    PUT tt-compras.cEstabelec           ";"
        tt-compras.dtTrans              ";"
        tt-compras.cMesTrans            ";"
        tt-compras.cNrDoc               ";"
        tt-compras.cSerie               ";"
        tt-compras.cContaContabil       ";"
        tt-compras.cGrupoEstoque        ";"
        tt-compras.cFamilia             ";"
        tt-compras.cItem                ";"
        tt-compras.cDescItem            ";"
        tt-compras.cTipoDespesa         ";"
        tt-compras.cUnidade             ";"
        tt-compras.cNatureza            ";"
        tt-compras.iCodEmitente         ";"
        tt-compras.cNomeEmitente        ";"
        tt-compras.cNaturezaOper        ";"
        tt-compras.cDescrNatureza       ";"
        tt-compras.dtEmissao            ";"
        tt-compras.iQuantidade          ";"
        tt-compras.dePreco              ";"
        tt-compras.iNrPedido            ";"
        tt-compras.DtEmissaoPedido      ";"
        tt-compras.cComprador           ";"
        tt-compras.cNomeComprador       ";"
        tt-compras.cLotComprador        ";"
        tt-compras.cRequisitante        ";"
        tt-compras.cNarrativa           ";"
        tt-compras.cFornecedor          ";"
        tt-compras.cCidadeFornec        ";"
        tt-compras.cUfFornec            ";"
        tt-compras.cPaisFornec          ";"
        tt-compras.cProcesso            ";"
        tt-compras.cTransportador       ";"
        tt-compras.cViaTranp            ";"
        tt-compras.cMensagem            ";"
        tt-compras.cEstabGestor         ";"
        tt-compras.cNomeRequisitante    ";"
        tt-compras.deQuantidadePedido   ";"
        tt-compras.dePrecoFornec        ";"
        tt-compras.cMoeda               ";"
        tt-compras.cSituacao            ";"
        tt-compras.iOrdem               ";"
        tt-compras.iParcela             ";"
        tt-compras.deQuantidade         ";"
        tt-compras.dtEntrega            ";"
        tt-compras.cCondPagto           ";"
        tt-compras.dtTransOrig          ";"
        tt-compras.cDocOrigem           ";"
        tt-compras.cSerOrigem           ";"
        tt-compras.iCodEmitOrigem       ";"
        tt-compras.cNomeEmitOrigem      ";"
        tt-compras.iGrupoFornec         SKIP.

END.

OUTPUT CLOSE.
