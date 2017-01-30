DEFINE VARIABLE c-reg AS CHARACTER   NO-UNDO.

FUNCTION cv-texto RETURNS CHARACTER
(INPUT c-texto AS CHAR):
    RETURN CODEPAGE-CONVERT(c-texto, "IBM850", SESSION:CHARSET).
END FUNCTION.

INPUT FROM VALUE("C:\RetornoReceita\CNPJ2220110202005903.TXT").
    REPEAT:

        IMPORT UNFORMATTED c-reg.
        IF INT(SUBSTR(c-reg,001,008)) = 0 THEN NEXT.

        ASSIGN c-reg = cv-texto(c-reg).

        MESSAGE "Cod.Emitente:      "   SUBSTR(c-reg,001,010)   SKIP
                "CNPJ:              "   SUBSTR(c-reg,011,015)   SKIP
                "CNPJ:              "   SUBSTR(c-reg,292,015)   SKIP
                "Dt.Sit.Cadastral:  "   IF SUBSTR(c-reg,307,001) = " " OR SUBSTR(c-reg,307,001) = "?" THEN ? ELSE DATE(INT(SUBSTR(c-reg,311,002)),INTE(SUBSTR(c-reg,313,002)),INTE(SUBSTR(c-reg,307,004)))  SKIP
                "NomeEmpresarial:   "   SUBSTR(c-reg,84,200)    SKIP
                "NomeFantasia:      "   SUBSTR(c-reg,515,100)   SKIP
                "NaturezaJuridica:  "   SUBSTR(c-reg,1115,100)  SKIP
                "Logradouro:        "   SUBSTR(c-reg,1215,080)  SKIP
                "Numero:            "   SUBSTR(c-reg,1295,040)  SKIP
                "Complemento:       "   SUBSTR(c-reg,1335,040)  SKIP
                "CEP:               "   SUBSTR(c-reg,1375,008)  SKIP
                "Bairro:            "   SUBSTR(c-reg,1383,040)  SKIP
                "Municipio:         "   SUBSTR(c-reg,1423,040)  SKIP
                "UF:                "   SUBSTR(c-reg,1463,002)  SKIP
                "Sit.Cadastral:     "   SUBSTR(c-reg,1465,50)   SKIP
                "Dt.Sit.Cadastral   "   IF SUBSTR(c-reg,1515,001) = " " OR SUBSTR(c-reg,1515,001) = "?" THEN ? ELSE DATE(INT(SUBSTR(c-reg,1519,002)),INTE(SUBSTR(c-reg,1521,002)),INTE(SUBSTR(c-reg,1515,004))) SKIP
                "NomeEmpresarial:   "   SUBSTR(c-reg,315,200)   SKIP
                "CEP:               "   SUBSTR(c-reg,284,008)   SKIP
                "Sit.Cadastral:     "   SUBSTR(c-reg,1465,050)  SKIP
                "Dt.Sit.Cadastral:  "   IF SUBSTR(c-reg,1573,001) = " " OR SUBSTR(c-reg,1573,001) = "?" THEN ? ELSE DATE(SUBSTR(c-reg,1573,008))   SKIP
                "SituacaoEspecial:  "   SUBSTR(c-reg,1523,050)
                "DtPesquisa:        "   IF INTE(SUBSTR(c-reg,1581,008)) = 0 THEN ? ELSE DATE(SUBSTR(c-reg,1585,002) + SUBSTR(c-reg,1587,002) + SUBSTR(c-reg,1581,004))    SKIP
                "DtOpcao:           "   IF INTE(SUBSTR(c-reg,1717,008)) = 0 THEN ? ELSE DATE(INTE(SUBSTR(c-reg,1721,002)),INTE(SUBSTR(c-reg,1723,002)),INTE(SUBSTR(c-reg,1717,004)))    SKIP
                "Porte:             "   SUBSTR(c-reg,1725,030)
                "HoraPesquisa:          "IF SUBSTR(c-reg,1589,008) <> "" THEN STRING(SUBSTRING(SUBSTR(c-reg,1589,008),1,2) + ":" +
                                                                                           SUBSTRING(SUBSTR(c-reg,1589,008),3,2) + ":" +
                                                                                           SUBSTRING(SUBSTR(c-reg,1589,008),5,2))
                                                                                           ELSE ""
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            
            
    END.
INPUT CLOSE.
   
