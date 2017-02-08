DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

/*
Types of users:

1 - Customer
2 - Sales Representative
3 - Sales Supervisor
4 - Sales Promoter
5 - Commercial technical assistant
6 - Sales Manager
7 - ERP User
*/

DEFINE TEMP-TABLE UserSystem NO-UNDO
    FIELD userCode      AS CHAR
    FIELD userName      AS CHAR
    FIELD userPassword  AS CHAR
    FIELD idFederal     AS CHAR
    FIELD idFederalType AS INTE
    FIELD userType      AS INTE.

DEFINE TEMP-TABLE tt-CustomerSystem NO-UNDO
    FIELD userCode          AS CHAR
    FIELD saleChannel       AS INTE
    FIELD icmsPayer         AS LOGICAL
    FIELD customerGroup     AS INTE
    FIELD cnaeCode          AS INTE
    FIELD microRegion       AS CHAR
    FIELD state             AS CHAR
    FIELD city              AS CHAR
    FIELD phone             AS CHAR
    FIELD mobile            AS CHAR
    FIELD active            AS LOGICAL
    FIELD activityBusiness  AS CHAR
    FIELD matrixCode        AS CHAR.

DEFINE TEMP-TABLE tt-DeliveryPropertySystem NO-UNDO
    FIELD userCode                  AS CHAR
    FIELD deliveryCode              AS CHAR
    FIELD state                     AS CHAR
    FIELD city                      AS CHAR
    FIELD propertyName              AS CHAR
    FIELD propertyAdress            AS CHAR
    FIELD propertyScript            AS CHAR
    FIELD propertyAlternativeScript AS CHAR. 

DEFINE TEMP-TABLE CustomerSystem NO-UNDO LIKE tt-CustomerSystem.
DEFINE TEMP-TABLE DeliveryPropertySystem NO-UNDO LIKE tt-DeliveryPropertySystem.

DEFINE DATASET Customer FOR CustomerSystem, DeliveryPropertySystem
DATA-RELATION sCustomer FOR CustomerSystem, DeliveryPropertySystem RELATION-FIELDS(userCode,userCode) NESTED.

DEFINE DATA-SOURCE dsCustomer           FOR tt-CustomerSystem.
DEFINE DATA-SOURCE dsDeliveryProperty   FOR tt-DeliveryPropertySystem.

BUFFER CustomerSystem:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsCustomer:HANDLE).
BUFFER DeliveryPropertySystem:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsDeliveryProperty:HANDLE).

/* Code to populate the temp-table */
FOR EACH emitente NO-LOCK WHERE emitente.cod-emitente = 153999,
    EACH es-emitente-dis WHERE es-emitente-dis.cod-emitente = emitente.cod-emitente NO-LOCK:

    CREATE UserSystem.
    ASSIGN UserSystem.userCode        = STRING(emitente.cod-emitente)
           UserSystem.userName        = emitente.nome-emit
           UserSystem.userPassword    = "teste"
           UserSystem.idFederal       = emitente.cgc
           UserSystem.idFederalType   = emitente.natureza
           UserSystem.userType        = 1.
    
    CREATE CustomerSystem.
    ASSIGN CustomerSystem.userCode          = STRING(emitente.cod-emitente)
           CustomerSystem.saleChannel       = emitente.cod-canal-venda
           CustomerSystem.icmsPayer         = emitente.contrib-icms
           CustomerSystem.customerGroup     = emitente.cod-gr-cli
           CustomerSystem.cnaeCode          = es-emitente-dis.cod-CNAE
           CustomerSystem.microRegion       = TRIM(emitente.nome-mic-reg)
           CustomerSystem.state             = emitente.estado
           CustomerSystem.city              = emitente.cidade
           CustomerSystem.phone             = emitente.telefone[2]
           CustomerSystem.mobile            = emitente.telefone[1]
           CustomerSystem.active            = TRUE
           CustomerSystem.activityBusiness  = TRIM(emitente.atividade)
           CustomerSystem.matrixCode        = TRIM(emitente.nome-matriz).

    FOR EACH loc-entr WHERE loc-entr.nome-abrev  = emitente.nome-abrev 
                        AND loc-entr.cod-entrega = "Padrao" NO-LOCK,
                        EACH es-loc-entr WHERE es-loc-entr.nome-abrev  = loc-entr.nome-abrev
                                           AND es-loc-entr.cod-entrega = loc-entr.cod-entrega
                                           NO-LOCK:

        CREATE DeliveryPropertySystem.
        ASSIGN DeliveryPropertySystem.userCode                  = STRING(emitente.cod-emitente)
               DeliveryPropertySystem.deliveryCode              = TRIM(loc-entr.cod-entrega)
               DeliveryPropertySystem.state                     = loc-entr.estado
               DeliveryPropertySystem.city                      = loc-entr.cidade
               DeliveryPropertySystem.propertyName              = es-loc-entr.nome-fazenda
               DeliveryPropertySystem.propertyAdress            = loc-entr.endereco
               DeliveryPropertySystem.propertyScript            = es-loc-entr.roteiro
               DeliveryPropertySystem.propertyAlternativeScript = es-loc-entr.alternativa.
                        
    END.

END.

ASSIGN cTargetType = "file"
       cFile       = "C:\Temp\type1\UserSystem.json"
       lFormatted  = TRUE.

lRetOK = TEMP-TABLE UserSystem:WRITE-JSON(cTargetType, cFile, lFormatted).

DATASET Customer:FILL().

ASSIGN cTargetType = "file"   
       cFile       = "C:\Temp\type1\CustomerSystem.json"
       lFormatted  = TRUE.

lRetOK = DATASET Customer:WRITE-JSON(cTargetType, cFile, lFormatted).
