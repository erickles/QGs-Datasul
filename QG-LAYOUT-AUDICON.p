DEFINE BUFFER b-movto-sintegra FOR movto-sintegra.
DEFINE VARIABLE c-reg AS CHAR FORMAT "X(2000)"  NO-UNDO.
DEFINE VARIABLE c-aux AS CHAR FORMAT "X(1500)".
DEFINE VARIABLE i-cod AS INTEGER                NO-UNDO.

FUNCTION cv-texto RETURNS CHARACTER
(INPUT c-texto AS CHAR):
    RETURN CODEPAGE-CONVERT(c-texto, "IBM850", SESSION:CHARSET).
END FUNCTION.

INPUT FROM VALUE("C:\RetornoSintegra\RS20110204101939.TXT").
    REPEAT:
        IMPORT UNFORMATTED c-reg.
        IF INTE(SUBSTR(c-reg,001,008)) = 0 THEN NEXT.
    
        ASSIGN c-reg = cv-texto(c-reg).
                                     /*1317*/
/*         c-aux = SUBSTR(c-reg,863).              */
/*         c-reg = SUBSTRING(c-reg,1,642) + c-aux. */

        MESSAGE "Cod.Cliente:        " INTE(SUBSTR(c-reg,001,008))                                                                          SKIP
                "UF:                 " SUBSTR(c-reg,009,002)                                                                                SKIP
                "Tipo Pesquisa:      " SUBSTR(c-reg,011,001)                                                                                SKIP
                "CNPJ/CPF:           " SUBSTR(c-reg,012,015)                                                                                SKIP
                "Inscricao Estadual: " SUBSTR(c-reg,027,015)                                                                                SKIP
                "Habilitado:         " SUBSTR(c-reg,042,001)                                                                                SKIP
                "Dt Sintegra:        " SUBSTR(c-reg,043,008)                                                                                SKIP
                "Razao Social:       " SUBSTR(c-reg,051,100)                                                                                SKIP
                "CEP:                " SUBSTR(c-reg,151,010)                                                                                SKIP
                "Inscricao Estadual: " SUBSTR(c-reg,161,018)                                                                                SKIP
                "CNPJ/CPF:           " SUBSTR(c-reg,179,016)                                                                                SKIP
                "Razao Social:       " SUBSTR(c-reg,195,100)                                                                                SKIP
                "Logradouro:         " SUBSTR(c-reg,295,080)                                                                                SKIP
                "Numero:             " SUBSTR(c-reg,375,040)                                                                                SKIP
                "Complemento:        " SUBSTR(c-reg,415,040)                                                                                SKIP
                "Bairro:             " SUBSTR(c-reg,455,040)                                                                                SKIP
                "Municipio:          " SUBSTR(c-reg,495,040)                                                                                SKIP
                "UF:                 " SUBSTR(c-reg,535,003)                                                                                SKIP
                "CEP:                " SUBSTR(c-reg,538,010)                                                                                SKIP
                "Telefone:           " SUBSTR(c-reg,548,016)                                                                                SKIP
                "Atividade Economica:" SUBSTR(c-reg,564,500)                                                                                SKIP
                "Reg. Apur. ICMS:    " SUBSTR(c-reg,1064,120)                                                                               SKIP                                        
                "Sit. Cadastral:     " SUBSTR(c-reg,1184,050)                                                                               SKIP                                        
                "Data Consulta:      " IF INTE(SUBSTR(c-reg,1242,008)) = 0 THEN ? ELSE
                                            DATE(INTE(SUBSTR(c-reg,1246,002)),INTE(SUBSTR(c-reg,1248,002)),INTE(SUBSTR(c-reg,1242,004)))    SKIP
                "Msg. Sintegra       " SUBSTR(c-reg,1250,060)                                                                              SKIP                                        
                "Sit. Sintegra:      " SUBSTR(c-reg,1310,001)                                                                              SKIP                                        
                "No. Consulta:       " SUBSTR(c-reg,1317,015)                                                                              SKIP                                        
                "Insc.Estaduais:     " SUBSTR(c-reg,1332,200)                                                                              SKIP                                        
                VIEW-AS ALERT-BOX INFO BUTTONS OK.                        
        
    END.
INPUT CLOSE.
