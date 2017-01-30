
/* Caso ser um newCostumer, notificar, do contrario, apenas atualizar */

DEFINE VARIABLE cMensagem AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

DEFINE TEMP-TABLE ttCliente NO-UNDO
    FIELD tipo              AS CHAR
    FIELD codigoCliente     AS INTE
    FIELD nomeCliente       AS CHAR
    FIELD nomeAbreviado     AS CHAR
    FIELD canalVenda        AS INTE
    FIELD contribuinteICMS  AS LOGICAL
    FIELD nomeMatriz        AS CHAR
    FIELD grupoCliente      AS INTE
    FIELD codigoCNAE        AS INTE
    FIELD natureza          AS INTE
    FIELD microRegiao       AS CHAR
    FIELD estado            AS CHAR
    FIELD celular           AS CHAR
    FIELD telefone          AS CHAR
    FIELD email             AS CHAR
    FIELD cnpj              AS CHAR
    FIELD empresa           AS INTE
    FIELD ativo             AS LOGICAL
    FIELD novo              AS LOGICAL
    FIELD ramoAtividade     AS CHAR
    FIELD mensagem          AS CHAR.

DEFINE TEMP-TABLE ttLocalEntrega NO-UNDO
    FIELD codigoCliente         AS INTE
    FIELD codigoEntrega         AS CHAR
    FIELD estado                AS CHAR
    FIELD cidade                AS CHAR
    FIELD nomeAbreviado         AS CHAR
    FIELD nomeFazenda           AS CHAR
    FIELD endereco              AS CHAR
    FIELD roteiro               AS CHAR
    FIELD roteiroAlternativo    AS CHAR.

FIND FIRST emitente WHERE emitente.cod-emitente = 153999 NO-LOCK NO-ERROR.
IF AVAIL emitente THEN DO:

    cMensagem = "O Cliente " + emitente.nome-emit + " esta disponivel no seu PedMobile! Toque aqui para criar um pedido com este cliente!".

    FIND FIRST es-emitente-dis WHERE es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    CREATE ttCliente.
    ASSIGN ttCliente.tipo               = "newCustomer"
           ttCliente.codigoCliente      = emitente.cod-emitente
           ttCliente.nomeCliente        = emitente.nome-emit
           ttCliente.nomeAbreviado      = emitente.nome-abrev
           ttCliente.canalVenda         = emitente.cod-canal-venda
           ttCliente.contribuinteICMS   = emitente.contrib-icms
           ttCliente.nomeMatriz         = emitente.nome-matriz
           ttCliente.grupoCliente       = emitente.cod-gr-cli
           ttCliente.codigoCNAE         = IF AVAIL es-emitente-dis THEN es-emitente-dis.cod-CNAE ELSE 0
           ttCliente.natureza           = emitente.natureza
           ttCliente.microRegiao        = emitente.nome-mic-reg
           ttCliente.estado             = emitente.estado
           ttCliente.celular            = emitente.telefone[1]
           ttCliente.telefone           = emitente.telefone[2]
           ttCliente.email              = emitente.e-mail
           ttCliente.cnpj               = emitente.cgc
           ttCliente.empresa            = 1
           ttCliente.ramoAtividade      = emitente.atividade.

    IF AVAIL es-emitente-dis THEN 
        IF SUBSTRING(es-emitente-dis.char-2,210,1) = "S" THEN 
            ttCliente.ativo = YES.
        ELSE
            ttCliente.ativo = NO.

    FIND FIRST nota-fiscal WHERE nota-fiscal.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN
        ttCliente.novo = NO.
    ELSE
        ttCliente.novo = YES.

    ASSIGN ttCliente.mensagem = cMensagem.

    FIND FIRST loc-entr WHERE loc-entr.nome-abrev   = emitente.nome-abrev
                          AND loc-entr.cod-entrega  = "Padrao"
                          NO-LOCK NO-ERROR.

    IF AVAIL loc-entr THEN DO:

        FIND es-loc-entr WHERE es-loc-entr.nome-abrev  = loc-entr.nome-abrev
                           AND es-loc-entr.cod-entrega = loc-entr.cod-entrega
                           NO-LOCK NO-ERROR.
        IF AVAIL es-loc-entr THEN DO:

            CREATE ttLocalEntrega.
            ASSIGN ttLocalEntrega.codigoCliente      = emitente.cod-emitente
                   ttLocalEntrega.codigoEntrega      = "Padrao"
                   ttLocalEntrega.estado             = TRIM(loc-entr.estado)
                   ttLocalEntrega.cidade             = TRIM(loc-entr.cidade)
                   ttLocalEntrega.nomeAbreviado      = loc-entr.nome-abrev
                   ttLocalEntrega.nomeFazenda        = TRIM(es-loc-entr.nome-fazenda)
                   ttLocalEntrega.endereco           = TRIM(loc-entr.endereco)
                   ttLocalEntrega.roteiro            = TRIM(es-loc-entr.roteiro)
                   ttLocalEntrega.roteiroAlternativo = TRIM(es-loc-entr.alternativa).

        END.

    END.

END.

DEFINE TEMP-TABLE Cliente        NO-UNDO LIKE ttCliente.
DEFINE TEMP-TABLE LocalEntrega   NO-UNDO LIKE ttLocalEntrega.

DEFINE DATASET Clientes FOR Cliente, LocalEntrega DATA-RELATION CustDelivery FOR Cliente, LocalEntrega RELATION-FIELDS(nomeAbreviado,nomeAbreviado) NESTED. 
    
DEFINE DATA-SOURCE dsCustomer FOR ttCliente.
    
DEFINE DATA-SOURCE dsDelivery FOR ttLocalEntrega.   
     
BUFFER Cliente:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsCustomer:HANDLE).
    
BUFFER LocalEntrega:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsDelivery:HANDLE).   

/*DATA-SOURCE dsCustomer:FILL-WHERE-STRING = "WHERE Customer.codigoCliente = 153999 ".*/
    
DATASET Clientes:FILL(). 

ASSIGN  cTargetType = "file"  
        cFile       = "C:\Temp\clientes.json"  lFormatted  = TRUE.
    
lRetOK = DATASET Clientes:WRITE-JSON(cTargetType, cFile, lFormatted).
