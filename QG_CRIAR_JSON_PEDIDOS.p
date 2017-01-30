DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE PedidoVenda NO-UNDO
    FIELD NumeroPedido              AS CHAR
    FIELD CodigoCliente             AS INTE
    FIELD CodigoEstabelecimento     AS CHAR
    FIELD CodigoRepresentante       AS INTE
    FIELD NumeroCondicaoPagamento   AS INTE.

FOR EACH ws-p-venda WHERE ws-p-venda.log-5
                      AND ws-p-venda.no-ab-reppri = "3076"
                      AND ws-p-venda.dt-implant   >= 01/01/2016 
                      NO-LOCK:

    FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
    FIND FIRST repres   WHERE repres.nome-abrev = ws-p-venda.no-ab-reppri NO-LOCK NO-ERROR.

    CREATE Pedidovenda.
    ASSIGN Pedidovenda.NumeroPedido             = ws-p-venda.nr-pedcli
           Pedidovenda.CodigoCliente            = emitente.cod-emitente
           Pedidovenda.CodigoEstabelecimento    = ws-p-venda.cod-estabel
           Pedidovenda.CodigoRepresentante      = repres.cod-rep
           Pedidovenda.NumeroCondicaoPagamento  = ws-p-venda.cod-cond-pag.

END.

/*
CREATE Mensagem.
ASSIGN Mensagem.tipo        = "mensagem"
       Mensagem.titulo      = "Titulo da mensagem"
       Mensagem.mensagem    = "Esta eh uma mensagem de teste e vocˆ a recebeu!"
       Mensagem.dtMensagem  = TODAY
       Mensagem.hrMensagem  = STRING(time,"HH:MM:SS").
*/


ASSIGN cTargetType = "file"   
       cFile       = "C:\Temp\Pedidos.json"
       lFormatted  = TRUE.

lRetOK = TEMP-TABLE Pedidovenda:WRITE-JSON(cTargetType, cFile, lFormatted).
