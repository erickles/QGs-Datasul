
/* Caso ser um newCostumer, notificar, do contrario, apenas atualizar */
DEFINE VARIABLE cMensagem AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iContDesc   AS INTEGER   NO-UNDO.

DEFINE TEMP-TABLE tFile NO-UNDO
    FIELD cPathName  AS CHARACTER FORMAT 'x(50)' 
    FIELD cFileName  AS CHARACTER FORMAT 'x(24)'
    FIELD dtModfied  AS DATE      FORMAT '99/99/9999'
    FIELD inTime     AS INTEGER
    FIELD cTipo      AS CHARACTER FORMAT 'X(5)'
    INDEX tFile-prim AS PRIMARY UNIQUE cPathName cFileName
    INDEX tFile-name cFileName dtModfied inTime.

DEFINE TEMP-TABLE ttPedidoVenda NO-UNDO
    FIELD NumeroPedido                      AS CHAR
    FIELD CodigoCliente                     AS INTE
    FIELD CodigoEstabelecimento             AS CHAR
    FIELD CodigoRepresentante               AS INTE
    FIELD NumeroCondicaoPagamento           AS INTE
    FIELD NumeroCondicaoPagamentoEspecial   AS INTE
    FIELD TipoFrete                         AS INTE
    FIELD TipoVeiculo                       AS INTE
    FIELD TipoCarga                         AS INTE
    FIELD Balsa                             AS LOGICAL
    FIELD DescVol                           AS LOGICAL
    FIELD TipoOperacao                      AS INTE
    FIELD ValorTotalPedido                  AS DECI
    FIELD GeCodigo                          AS INTE
    FIELD NaturezaOperacao                  AS CHAR
    FIELD DataImplantacao                   AS DATE
    FIELD SituacaoPedido                    AS INTE
    FIELD InstrucoesVendas                  AS CHAR
    FIELD InstrucoesLogistica               AS CHAR
    FIELD NumeroItens                       AS INTE
    FIELD VendaDolarizada                   AS LOGICAL
    FIELD IndiceTabela                      AS INTE
    FIELD PossuiConsulta                    AS LOGICAL
    FIELD TermoReducao                      AS LOGICAL
    FIELD DataEmbarque                      AS DATE
    FIELD DataEntrega                       AS DATE
    FIELD NumeroPedidoVinculado             AS CHAR
    FIELD CodigoConcorrente                 AS INTE
    FIELD NomeConcorrente                   AS CHAR
    FIELD Email                             AS CHAR
    FIELD Celular                           AS CHAR
    FIELD Fixo                              AS CHAR
    FIELD DataRemessa                       AS DATE
    FIELD EncargoPadrao                     AS DECI
    FIELD EncargoAplicado                   AS DECI
    FIELD EncargoPadraoPeriodo              AS DECI
    FIELD EncargoAplicadoPeriodo            AS DECI
    FIELD EncargoAplicadoPercentual         AS DECI
    FIELD EncargoPadraoMaxDatas             AS DECI
    FIELD EncargoPadraoMaxDias              AS DECI
    FIELD TabelaFinanceiraNumero            AS INTE
    FIELD TabelaFinanceiraIndice            AS INTE
    FIELD IndiceFinanceiro                  AS DECI
    FIELD EncargoPadraoPercentual           AS DECI
    FIELD CondicaoEspecial                  AS LOGICAL
    FIELD DataCancelamento                  AS DATE.

DEFINE TEMP-TABLE ttPedidoItem NO-UNDO
    FIELD NumeroPedido                  AS CHAR
    FIELD CodigoItem                    AS CHAR
    FIELD Sequencia                     AS INTE
    FIELD TabelaPreco                   AS CHAR
    FIELD STabelaPreco                  AS CHAR
    FIELD QuantidadePedida              AS DECI
    FIELD ValorPrecoUnitario            AS DECI
    FIELD ValorPrecoTabela              AS DECI
    FIELD ValorPrecoOriginal            AS DECI
    FIELD PercentualComissaoVenda       AS DECI
    FIELD PercentualComissaoPagamento   AS DECI
    FIELD SPercentualComissaoVenda      AS DECI
    FIELD SPercentualComissaoPagamento  AS DECI
    FIELD DescontoICMS                  AS DECI
    FIELD ValorTotalItem                AS DECI
    FIELD ValorTotalItemSemICMS         AS DECI
    FIELD ValorPrecoSemICMS             AS DECI
    FIELD VolumeFamilia                 AS DECI
    FIELD ValorFamilia                  AS DECI
    FIELD ComissaoReduzida              AS LOGICAL.

DEFINE TEMP-TABLE ttPedidoCondicao NO-UNDO
    FIELD NumeroPedido          AS CHAR
    FIELD NumeroSequencia       AS INTE
    FIELD DataPagamento         AS DATE
    FIELD PercentualPagamento   AS DECI
    FIELD ValorPagamento        AS DECI
    FIELD NumeroDiasVencimento  AS INTE.

DEFINE TEMP-TABLE ttPedidoDesconto NO-UNDO
    FIELD NumeroPedido              AS CHAR
    FIELD CodigoItem                AS CHAR
    FIELD RegraComercial            AS CHAR
    FIELD DescontoAplicado          AS DECI
    FIELD DescontoSugerido          AS DECI
    FIELD SequenciaMatriz           AS INTE
    FIELD Regra                     AS INTE.

DEFINE TEMP-TABLE PedidoVenda       NO-UNDO LIKE ttPedidoVenda.
DEFINE TEMP-TABLE PedidoItem        NO-UNDO LIKE ttPedidoItem.
DEFINE TEMP-TABLE PedidoCondicao    NO-UNDO LIKE ttPedidoCondicao.
DEFINE TEMP-TABLE PedidoDesconto    NO-UNDO LIKE ttPedidoDesconto.

DEFINE DATASET Pedidos FOR PedidoVenda, PedidoItem , PedidoCondicao, PedidoDesconto 
DATA-RELATION PedItem FOR PedidoVenda, PedidoItem RELATION-FIELDS(NumeroPedido,NumeroPedido) NESTED 
DATA-RELATION PedCond FOR PedidoVenda, PedidoCondicao RELATION-FIELDS(NumeroPedido,NumeroPedido) NESTED 
DATA-RELATION PedItemDesc FOR PedidoItem, PedidoDesconto RELATION-FIELDS(NumeroPedido,NumeroPedido,CodigoItem,CodigoItem) NESTED. 
    
DEFINE DATA-SOURCE dsPedidoVenda    FOR ttPedidoVenda.
DEFINE DATA-SOURCE dsPedidoItem     FOR ttPedidoItem.
DEFINE DATA-SOURCE dsPedidoCondicao FOR ttPedidoCondicao.
DEFINE DATA-SOURCE dsPedidoDesconto FOR ttPedidoDesconto.

BUFFER PedidoVenda:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsPedidoVenda:HANDLE).
BUFFER PedidoItem:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsPedidoItem:HANDLE).
BUFFER PedidoCondicao:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsPedidoCondicao:HANDLE).
BUFFER PedidoDesconto:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsPedidoDesconto:HANDLE).

DEFINE VARIABLE cProgramZip      AS CHARACTER FORMAT "x(100)" NO-UNDO.
cProgramZip = SEARCH("PACL\pacomp.exe").
IF cProgramZip = ? THEN LEAVE.

/* Pedidos */
FOR EACH ws-p-venda WHERE ws-p-venda.log-5
                      AND ws-p-venda.no-ab-reppri = "4731"
                      AND ws-p-venda.dt-implant   >= 01/01/2016
                      AND INDEX(ws-p-venda.nr-pedcli,"/") = 0
                      AND INDEX(ws-p-venda.nr-pedcli,"\") = 0
                      NO-LOCK BREAK BY ws-p-venda.dt-implant:
    
    FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
    FIND FIRST repres   WHERE repres.nome-abrev = ws-p-venda.no-ab-reppri NO-LOCK NO-ERROR.

    FIND FIRST ped-venda WHERE ped-venda.nr-pedcli  = ws-p-venda.nr-pedcli
                           AND ped-venda.nome-abrev = ws-p-venda.nome-abrev
                           NO-LOCK NO-ERROR.

    IF ws-p-venda.cod-cond-pag <> 0 THEN
        FIND FIRST cond-pagto WHERE cond-pagto.cod-cond-pag = ws-p-venda.cod-cond-pag NO-LOCK NO-ERROR.

    IF AVAIL cond-pagto THEN
        FIND FIRST tab-finan WHERE tab-finan.nr-tab-finan = cond-pagto.nr-tab-finan NO-LOCK NO-ERROR.

    CREATE ttPedidovenda.
    ASSIGN ttPedidovenda.NumeroPedido                       = ws-p-venda.nr-pedcli
           ttPedidovenda.CodigoCliente                      = emitente.cod-emitente
           ttPedidovenda.CodigoEstabelecimento              = ws-p-venda.cod-estabel
           ttPedidovenda.CodigoRepresentante                = repres.cod-rep
           ttPedidovenda.NumeroCondicaoPagamento            = ws-p-venda.cod-cond-pag
           ttPedidovenda.NumeroCondicaoPagamentoEspecial    = ws-p-venda.int-1
           ttPedidovenda.TipoFrete                          = ws-p-venda.tp-frete
           ttPedidovenda.TipoVeiculo                        = ws-p-venda.tp-veiculo
           ttPedidovenda.TipoCarga                          = ws-p-venda.tp-carga
           ttPedidovenda.Balsa                              = IF SUBSTRING(ws-p-venda.char-1,1,1)   = 'S' THEN YES ELSE NO
           ttPedidovenda.DescVol                            = IF SUBSTRING(ws-p-venda.char-2,233,1) = 'S' THEN YES ELSE NO
           ttPedidovenda.TipoOperacao                       = ws-p-venda.cod-tipo-oper
           ttPedidovenda.ValorTotalPedido                   = ws-p-venda.vl-tot-ped
           ttPedidovenda.NaturezaOperacao                   = IF AVAIL ped-venda THEN ped-venda.nat-operacao ELSE ws-p-venda.nat-operacao
           ttPedidovenda.DataImplantacao                    = ws-p-venda.dt-implant
           ttPedidovenda.SituacaoPedido                     = ws-p-venda.ind-sit-ped
           ttPedidovenda.InstrucoesVendas                   = ws-p-venda.comunicacao
           ttPedidovenda.InstrucoesLogistica                = ws-p-venda.roteiro-saude
           ttPedidovenda.NumeroItens                        = ws-p-venda.nr-item
           ttPedidovenda.VendaDolarizada                    = NO
           ttPedidovenda.IndiceTabela                       = 0
           ttPedidovenda.PossuiConsulta                     = IF ws-p-venda.nr-consulta <> 0 THEN YES ELSE NO
           ttPedidovenda.TermoReducao                       = IF SUBSTRING(ws-p-venda.char-1,2,1) = 'S' THEN YES ELSE NO
           ttPedidovenda.DataEmbarque                       = ws-p-venda.dt-entrega
           ttPedidovenda.DataEntrega                        = ws-p-venda.dt-entrega + 10
           ttPedidovenda.NumeroPedidoVinculado              = ws-p-venda.nr-pedrep
           ttPedidovenda.CodigoConcorrente                  = 0
           ttPedidovenda.NomeConcorrente                    = ""
           ttPedidovenda.Email                              = TRIM(emitente.e-mail)
           ttPedidovenda.Celular                            = TRIM(emitente.telefone[1])
           ttPedidovenda.Fixo                               = TRIM(emitente.telefone[2])
           ttPedidovenda.DataRemessa                        = IF SUBSTRING(ws-p-venda.char-2,221,10) <> "" THEN DATE(SUBSTRING(ws-p-venda.char-2,221,10)) ELSE ?
           ttPedidovenda.EncargoPadrao                      = ws-p-venda.dec-2
           ttPedidovenda.EncargoAplicado                    = ws-p-venda.dec-2
           ttPedidovenda.EncargoPadraoPeriodo               = 0
           ttPedidovenda.EncargoAplicadoPeriodo             = 0
           ttPedidovenda.EncargoAplicadoPercentual          = 0
           ttPedidovenda.EncargoPadraoMaxDatas              = 0
           ttPedidovenda.EncargoPadraoMaxDias               = 0
           ttPedidovenda.TabelaFinanceiraNumero             = IF AVAIL cond-pagto THEN cond-pagto.nr-tab-finan ELSE 0
           ttPedidovenda.TabelaFinanceiraIndice             = IF AVAIL cond-pagto THEN cond-pagto.nr-ind-finan ELSE 0
           ttPedidovenda.IndiceFinanceiro                   = IF AVAIL tab-finan THEN tab-finan.tab-ind-fin[cond-pagto.nr-ind-finan] ELSE 0
           ttPedidovenda.EncargoPadraoPercentual            = 0
           ttPedidovenda.CondicaoEspecial                   = IF SUBSTRING(ws-p-venda.char-2,26,1) = 'S' THEN YES ELSE NO
           ttPedidovenda.DataCancelamento                   = ws-p-venda.dt-cancela.

    /* Itens */
    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:

        FIND FIRST ITEM WHERE ITEM.it-codigo = ws-p-item.it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN
            ASSIGN ttPedidovenda.GeCodigo = ITEM.ge-codigo.

        CREATE ttPedidoItem.
        ASSIGN ttPedidoItem.NumeroPedido                    = ws-p-venda.nr-pedcli
               ttPedidoItem.CodigoItem                      = ws-p-item.it-codigo
               ttPedidoItem.Sequencia                       = ws-p-item.nr-sequencia
               ttPedidoItem.TabelaPreco                     = ws-p-item.nr-tabpre
               ttPedidoItem.STabelaPreco                    = ws-p-item.nr-tabpre
               ttPedidoItem.QuantidadePedida                = ws-p-item.qt-pedida / item.lote-mulven
               ttPedidoItem.ValorPrecoUnitario              = ws-p-item.vl-preuni
               ttPedidoItem.ValorPrecoTabela                = ws-p-item.vl-pretab
               ttPedidoItem.ValorPrecoOriginal              = ws-p-item.vl-preori
               ttPedidoItem.PercentualComissaoVenda         = ws-p-item.perc-comis-vd
               ttPedidoItem.PercentualComissaoPagamento     = ws-p-item.perc-comis-pg
               ttPedidoItem.SPercentualComissaoVenda        = ws-p-item.perc-comis-svd
               ttPedidoItem.SPercentualComissaoPagamento    = ws-p-item.perc-comis-spg
               ttPedidoItem.DescontoICMS                    = 0
               ttPedidoItem.ValorTotalItem                  = ws-p-item.vl-tot-it
               ttPedidoItem.ValorTotalItemSemICMS           = 0
               ttPedidoItem.ValorPrecoSemICMS               = 0
               ttPedidoItem.VolumeFamilia                   = 0
               ttPedidoItem.ValorFamilia                    = 0
               ttPedidoItem.ComissaoReduzida                = NO.
        
        iContDesc = 0.

        /* Descontos */
        FOR EACH ws-p-desc WHERE ws-p-desc.nome-abrev = ws-p-item.nome-abrev 
                             AND ws-p-desc.nr-pedcli  = ws-p-item.nr-pedcli
                             AND ws-p-desc.it-codigo  = ws-p-item.it-codigo
                             NO-LOCK:                        

            CREATE ttPedidoDesconto.
            ASSIGN ttPedidoDesconto.NumeroPedido        = ws-p-desc.nr-pedcli
                   ttPedidoDesconto.CodigoItem          = ws-p-desc.it-codigo
                   ttPedidoDesconto.RegraComercial      = ws-p-desc.cod-regra-comerc
                   ttPedidoDesconto.DescontoAplicado    = ws-p-desc.desc-aplicado
                   ttPedidoDesconto.DescontoSugerido    = ws-p-desc.desc-sugerido
                   ttPedidoDesconto.SequenciaMatriz     = ws-p-desc.seq-matriz.

            CASE ttPedidoDesconto.RegraComercial:

                WHEN "QUANTIDADE" THEN
                    ASSIGN ttPedidoDesconto.Regra = 1.

                WHEN "VALOR" THEN
                    ASSIGN ttPedidoDesconto.Regra = 2.

                WHEN "ADICIONAL" THEN
                    ASSIGN ttPedidoDesconto.Regra = 3.

                WHEN "ADICIONAL 2" THEN
                    ASSIGN ttPedidoDesconto.Regra = 4.

                WHEN "ESPECIAL" THEN
                    ASSIGN ttPedidoDesconto.Regra = 5.

                WHEN "ESPECIAL 2" THEN
                    ASSIGN ttPedidoDesconto.Regra = 6.

                WHEN "LOGISTICA" THEN
                    ASSIGN ttPedidoDesconto.Regra = 7.

            END CASE.

        END.

    END.
    
    /* Parcelas - Condicao de pagamento customizada */
    FOR EACH ws-cond-ped WHERE ws-cond-ped.nr-pedcli  = ws-p-venda.nr-pedcli 
                           AND ws-cond-ped.nome-abrev = ws-p-venda.nome-abrev
                           NO-LOCK:

        CREATE ttPedidoCondicao.
        ASSIGN ttPedidoCondicao.NumeroPedido         = ws-p-venda.nr-pedcli
               ttPedidoCondicao.NumeroSequencia      = ws-cond-ped.nr-sequencia
               ttPedidoCondicao.DataPagamento        = ws-cond-ped.data-pagto
               ttPedidoCondicao.PercentualPagamento  = ws-cond-ped.perc-pagto
               ttPedidoCondicao.ValorPagamento       = ws-cond-ped.vl-pagto
               ttPedidoCondicao.NumeroDiasVencimento = ws-cond-ped.nr-dias-venc.

    END.    

    DATASET Pedidos:FILL().

    FILE-INFO:FILE-NAME = "\\SRVVM27\PedMobile_Producao\Backup\" + ws-p-venda.no-ab-reppri + "\json\".

    IF NOT FILE-INFO:FULL-PATHNAME EQ ? THEN DO:

        ASSIGN cTargetType = "file"  
               cFile       = "\\SRVVM27\PedMobile_Producao\Backup\" + ws-p-venda.no-ab-reppri + "\json\" + ws-p-venda.nr-pedcli + ".json"  lFormatted  = TRUE.
    
        lRetOK = DATASET Pedidos:WRITE-JSON(cTargetType, cFile, lFormatted).

    END.

    EMPTY TEMP-TABLE ttPedidoVenda.
    EMPTY TEMP-TABLE ttPedidoItem.
    EMPTY TEMP-TABLE ttPedidoDesconto.
    EMPTY TEMP-TABLE ttPedidoCondicao.
    
    EMPTY TEMP-TABLE PedidoVenda.
    EMPTY TEMP-TABLE PedidoItem.
    EMPTY TEMP-TABLE PedidoDesconto.
    
    
END.

DEFINE VARIABLE cDirDestino AS CHARACTER   NO-UNDO.

cDirDestino = "\\SRVVM27\PedMobile_Producao\Backup\" + "4731" + "\json" + "\" + "Backup" + STRING(TODAY,"99999999") + replace(STRING(TIME,"HH:MM:SS"),":","") + ".zip".

OS-COMMAND SILENT VALUE(cProgramZip + " -a ") VALUE(cDirDestino) VALUE("\\SRVVM27\PedMobile_Producao\Backup\" + "4731" + "\json\" + "*.json").

/* Mapeia os arquivos do diretorio */
EMPTY TEMP-TABLE tFile.
RUN ReadDir("\\SRVVM27\PedMobile_Producao\Backup\" + "4731" + "\json\", NO).

DEFINE VARIABLE cComando AS CHARACTER   NO-UNDO.

cComando = "DEL " + "\\SRVVM27\PedMobile_Producao\Backup\" + "4731" + "\json\*.json".
OS-COMMAND SILENT VALUE(cComando).
/*
FOR EACH tFile:
    
    IF INDEX(tFile.cFileName,".json") > 0 THEN DO:

        cComando = "DEL " + tFile.cPathName + tFile.cFileName.
        OS-COMMAND SILENT VALUE(cComando).
    END.
        
END.                                    
*/
PROCEDURE ReadDir:

    DEFINE INPUT PARAMETER cDir       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER lRecursive AS LOGICAL   NO-UNDO.
   
    DEFINE VARIABLE cFile AS CHARACTER NO-UNDO EXTENT 3.

    INPUT FROM OS-DIR( cDir ).
    REPEAT:
        IMPORT cFile.
      
        /* Skip current and parent dir */
        IF cFile[1] EQ '.' OR cFile[1] EQ '..' THEN NEXT.
     
        /* We only want to store files in the TT, not dirs */
        IF cFile[3] BEGINS 'F' THEN DO:

            FILE-INFO:FILE-NAME = cFile[2].
        
            FIND FIRST tFile WHERE tFile.cFileName = cFile[1] NO-ERROR.
            IF NOT AVAIL tFile THEN 
                CREATE tFile.

            ASSIGN tFile.cPathName  = REPLACE(cFile[2],cFile[1],'') 
                   tFile.cFileName  = cFile[1]
                   tFile.dtModfied  = FILE-INFO:FILE-MOD-DATE
                   tFile.inTime     = FILE-INFO:FILE-MOD-TIME
                   tFile.cTipo      = FILE-INFO:FILE-TYPE.

        END.
     
        /* Recursive read */
        IF cFile[3] BEGINS 'D' AND lRecursive THEN 
            RUN ReadDir( INPUT cFile[2], INPUT yes ).

    END.
    INPUT CLOSE.

END PROCEDURE.
