DEFINE VARIABLE c-reg AS CHARACTER   NO-UNDO.
DEFINE BUFFER b-movto-receita FOR movto-receita.

FUNCTION cv-texto RETURNS CHARACTER
(INPUT c-texto AS CHAR):
    RETURN CODEPAGE-CONVERT(c-texto, "IBM850", SESSION:CHARSET).
END FUNCTION.

INPUT FROM VALUE("C:\RetornoReceita\CPF20110127130456.TXT").
    REPEAT:
        IMPORT UNFORMATTED c-reg.
        IF INTE(SUBSTR(c-reg,001,008)) = 0 THEN NEXT.
    
        ASSIGN c-reg = cv-texto(c-reg).

        MESSAGE "Cod.Emitente:  "   INTE(SUBSTR(c-reg,001,010)) SKIP
                "CPF:           "   SUBSTR(c-reg,011,011)       SKIP
                "Nome:          "   SUBSTR(c-reg,022,100)       SKIP
                "Sit.Cadastral: "   SUBSTR(c-reg,122,050)       SKIP
                "CPF:           "   SUBSTR(c-reg,172,011)       SKIP
                "Nome:          "   SUBSTR(c-reg,183,100)       SKIP
                "Sit.Cadastral: "   SUBSTR(c-reg,283,050)       SKIP
                "Cod.Controle:  "   SUBSTR(c-reg,333,030)       SKIP
                "Dt.Pesquisa:   "   IF INTE(SUBSTR(c-reg,363,008)) = 0 THEN ? ELSE DATE(INTE(SUBSTR(c-reg,367,002)),INTE(SUBSTR(c-reg,369,002)),INTE(SUBSTR(c-reg,363,004)))    SKIP
                "Id. Registro:  "   IF SUBSTR(c-reg,371,008) <> "" THEN STRING(SUBSTRING(SUBSTR(c-reg,371,008),1,2) + ":" +
                                                    SUBSTRING(SUBSTR(c-reg,371,008),3,2) + ":" +
                                                    SUBSTRING(SUBSTR(c-reg,371,008),5,2))
                                                    ELSE ""                                                                                                 
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
    END.

    INPUT CLOSE.
