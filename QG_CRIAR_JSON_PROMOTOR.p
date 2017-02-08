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

DEFINE TEMP-TABLE SalesPromoterSystem NO-UNDO
    FIELD userCode              AS CHAR
    FIELD userRegion            AS CHAR
    FIELD actingCode            AS INTE
    FIELD lineCode              AS CHAR
    FIELD situation             AS INTE
    FIELD salesPromoterCity     AS CHAR
    FIELD salesPromoterState    AS CHAR
    FIELD lastOrder             AS CHAR
    FIELD active                AS LOGICAL.

/* Code to populate the temp-table */
FOR EACH repres NO-LOCK WHERE repres.cod-rep = 2534,
    EACH es-repres-comis WHERE es-repres-comis.cod-rep = repres.cod-rep
                           AND NOT es-repres-comis.log-1
                           AND es-repres-comis.situacao = 1,
    EACH pm-rep-param WHERE pm-rep-param.cod_rep = repres.cod-rep:

    CREATE UserSystem.
    ASSIGN UserSystem.userCode        = STRING(repres.cod-rep)
           UserSystem.userName        = repres.nome
           UserSystem.userPassword    = "teste"
           UserSystem.idFederal       = repres.cgc
           UserSystem.idFederalType   = repres.natureza
           UserSystem.userType        = 4.

    CREATE SalesPromoterSystem.
    ASSIGN SalesPromoterSystem.userCode             = STRING(repres.cod-rep)
           SalesPromoterSystem.userRegion           = repres.nome-ab-reg
           SalesPromoterSystem.actingCode           = es-repres-comis.u-int-1
           SalesPromoterSystem.lineCode             = TRIM(es-repres-comis.u-char-2)
           SalesPromoterSystem.situation            = es-repres-comis.situacao
           SalesPromoterSystem.salesPromoterCity    = repres.cidade
           SalesPromoterSystem.salesPromoterState   = repres.estado
           SalesPromoterSystem.lastOrder            = TRIM(pm-rep-param.nr_ultimo_pedido)
           SalesPromoterSystem.active               = TRUE /*pm-rep-param.ind_situacao*/.
END.

ASSIGN cTargetType = "file"
       cFile       = "C:\Temp\type4\UserSystem.json"
       lFormatted  = TRUE.

lRetOK = TEMP-TABLE UserSystem:WRITE-JSON(cTargetType, cFile, lFormatted).

ASSIGN cTargetType = "file"
       cFile       = "C:\Temp\type4\SalesPromoterSystem.json"
       lFormatted  = TRUE.

lRetOK = TEMP-TABLE SalesPromoterSystem:WRITE-JSON(cTargetType, cFile, lFormatted).
