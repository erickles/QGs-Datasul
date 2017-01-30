DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

DEFINE TEMP-TABLE tt-repres NO-UNDO
    FIELD codigoRepresentante   AS INTE
    FIELD nomeRepresentante     AS CHAR    
    FIELD cnpj                  AS CHAR
    FIELD estado                AS CHAR
    FIELD representante         AS LOGICAL
    FIELD linhaCodigo           AS INTE
    FIELD regiao                AS CHAR
    FIELD situacao              AS INTE
    FIELD senha                 AS CHAR.

FOR EACH repres NO-LOCK,
    EACH es-repres-comis WHERE es-repres-comis.cod-rep = repres.cod-rep:

    CREATE tt-repres.
    ASSIGN tt-repres.codigo                 = repres.cod-rep
           tt-repres.nomeRepresentante      = repres.nome
           tt-repres.cnpj                   = repres.cgc
           tt-repres.estado                 = repres.estado
           tt-repres.representante          = es-repres-comis.log-1
           tt-repres.linhaCodigo            = es-repres-comis.u-int-1
           tt-repres.regiao                 = repres.nome-ab-reg
           tt-repres.situacao               = es-repres-comis.situacao
           tt-repres.senha                  = "teste".

END.

/* Code to populate the temp-table */  
ASSIGN cTargetType = "file"   
       cFile       = "C:\Temp\repres.json"
       lFormatted  = TRUE.

lRetOK = TEMP-TABLE tt-repres:WRITE-JSON(cTargetType, cFile, lFormatted).
