DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

DEFINE TEMP-TABLE Articles NO-UNDO
    FIELD articleId             AS INTE
    FIELD articleTitle          AS CHAR
    FIELD articleDescription    AS CHAR
    FIELD articleUrl            AS CHAR
    FIELD articleDate           AS CHAR
    FIELD articleFileName       AS CHAR
    FIELD articleCover          AS CHAR
    FIELD articleCoverURL       AS CHAR.

CREATE Articles.
ASSIGN Articles.articleId          = 0
       Articles.articleTitle       = "Noticiero Edici¢n 03"
       Articles.articleDescription = "Edici¢n 01 - A¤o 01"
       Articles.articleUrl         = ""
       Articles.articleDate        = "06.2015"
       Articles.articleFileName    = "Noticiero Edici¢n 03.pdf"
       Articles.articleCover       = ""
       Articles.articleCoverURL    = "https://portal.tortuga.com.br/mmm/Handler.ashx?app=3&id=13&action=cover".

ASSIGN cTargetType = "file"
       cFile       = "C:\Temp\Articles.json"
       lFormatted  = TRUE.

lRetOK = TEMP-TABLE Articles:WRITE-JSON(cTargetType, cFile, lFormatted).
