{include/i-freeac.i}

DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

DEFINE VARIABLE cTargetType2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cContent     AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE lFormatted2  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK2      AS LOGICAL   NO-UNDO.

DEFINE TEMP-TABLE tt-region NO-UNDO
    FIELD state         AS CHAR
    FIELD abbreviation  AS CHAR.

DEFINE TEMP-TABLE tt-cities NO-UNDO
    FIELD code                  AS CHAR
    FIELD federalCode           AS CHAR
    FIELD name                  AS CHAR
    FIELD stateAbbreviation     AS CHAR SERIALIZE-HIDDEN
    FIELD postalCode            AS CHAR
    FIELD initialPostalCode1    AS CHAR
    FIELD finalPostalCode1      AS CHAR
    FIELD initialPostalCode2    AS CHAR
    FIELD finalPostalCode2      AS CHAR.

DEFINE TEMP-TABLE list   NO-UNDO LIKE tt-region.
DEFINE TEMP-TABLE cities   NO-UNDO LIKE tt-cities.

DEFINE DATASET Regions FOR list, cities
DATA-RELATION sRegion FOR list, cities RELATION-FIELDS(abbreviation,stateAbbreviation) NESTED.

DEFINE DATA-SOURCE dsRegion       FOR tt-region.
DEFINE DATA-SOURCE dsCities    FOR tt-cities.

BUFFER list:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsRegion:HANDLE).
BUFFER cities:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsCities:HANDLE).

    FOR EACH mgcad.cidade NO-LOCK WHERE mgcad.cidade.estado <> "EX" BY mgcad.cidade.estado BY mgcad.cidade.cidade:

        FIND FIRST es-cidade OF mgcad.cidade NO-LOCK NO-ERROR.
        
        FIND FIRST tt-region WHERE tt-region.abbreviation = mgcad.cidade.estado NO-LOCK NO-ERROR.
        IF NOT AVAIL tt-region THEN DO:

            FIND FIRST mgcad.unid-feder WHERE mgcad.unid-feder.estado = mgcad.cidade.estado NO-LOCK NO-ERROR.

            CREATE tt-region.
            ASSIGN tt-region.state = IF AVAIL mgcad.unid-feder THEN TRIM(fn-free-accent(mgcad.unid-feder.no-estado)) ELSE ""
                   tt-region.abbreviation = mgcad.cidade.estado.
        END.

        CREATE tt-cities.
        ASSIGN tt-cities.code               = TRIM(mgcad.cidade.estado) + " " + STRING(mgcad.cidade.cdn-munpio-ibge)
               tt-cities.federalCode        = STRING(mgcad.cidade.cdn-munpio-ibge)
               tt-cities.name               = TRIM(fn-free-accent(mgcad.cidade.cidade))
               tt-cities.stateAbbreviation  = mgcad.cidade.estado
               tt-cities.postalCode         = IF AVAIL es-cidade THEN es-cidade.cep ELSE "00000000"
               tt-cities.initialPostalCode1 = IF AVAIL es-cidade THEN es-cidade.cep-ini-1 ELSE "00000000"
               tt-cities.finalPostalCode1   = IF AVAIL es-cidade THEN es-cidade.cep-fim-1 ELSE "00000000"
               tt-cities.initialPostalCode2 = IF AVAIL es-cidade THEN es-cidade.cep-ini-2 ELSE "00000000"
               tt-cities.finalPostalCode2   = IF AVAIL es-cidade THEN es-cidade.cep-fim-2 ELSE "00000000".

    END.

    DATASET Regions:FILL().

    ASSIGN cTargetType = "file"   
           cFile       = "C:\Temp\regions.json"
           lFormatted  = TRUE.

    lRetOK = DATASET Regions:WRITE-JSON(cTargetType, cFile, lFormatted).
