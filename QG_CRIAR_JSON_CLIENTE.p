DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

DEFINE TEMP-TABLE Customer NO-UNDO
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
    FIELD ramoAtividade     AS CHAR.

FIND FIRST emitente WHERE emitente.cod-emitente = 153999 NO-LOCK NO-ERROR.
IF AVAIL emitente THEN DO:

    FIND FIRST es-emitente-dis WHERE es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.

    CREATE Customer.
    ASSIGN Customer.codigoCliente       = emitente.cod-emitente
           Customer.nomeCliente         = emitente.nome-emit
           Customer.nomeAbreviado       = emitente.nome-abrev
           Customer.canalVenda          = emitente.cod-canal-venda
           Customer.contribuinteICMS    = emitente.contrib-icms
           Customer.nomeMatriz          = emitente.nome-matriz
           Customer.grupoCliente        = emitente.cod-gr-cli
           Customer.codigoCNAE          = IF AVAIL es-emitente-dis THEN es-emitente-dis.cod-CNAE ELSE 0
           Customer.natureza            = emitente.natureza
           Customer.microRegiao         = emitente.nome-mic-reg
           Customer.estado              = emitente.estado
           Customer.celular             = emitente.telefone[1]
           Customer.telefone            = emitente.telefone[2]
           Customer.email               = emitente.e-mail
           Customer.cnpj                = emitente.cgc
           Customer.empresa             = 1
           Customer.ramoAtividade       = emitente.atividade.

    IF AVAIL es-emitente-dis THEN 
        IF SUBSTRING(es-emitente-dis.char-2,210,1) = "S" THEN 
            Customer.ativo = YES.
        ELSE
            Customer.ativo = NO.

    FIND FIRST nota-fiscal WHERE nota-fiscal.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN
        Customer.novo = NO.
    ELSE
        Customer.novo = YES.
END.                                                      

/* Code to populate the temp-table */  
ASSIGN cTargetType = "file"   
       cFile       = "C:\Temp\Customer.json"   
       lFormatted  = TRUE.

lRetOK = TEMP-TABLE Customer:WRITE-JSON(cTargetType, cFile, lFormatted).

MESSAGE cFile
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
