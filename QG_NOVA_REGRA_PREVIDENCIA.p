DEFINE VARIABLE deDesconto AS DECIMAL     NO-UNDO.

RUN piCalculoFuncionario(INPUT 8550,
                         OUTPUT deDesconto).

MESSAGE deDesconto
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE piCalculoFuncionario:

    DEFINE INPUT PARAMETER deSalario AS DECI.
    DEFINE OUTPUT PARAMETER deAcumulador AS DECI.

    DEFINE VARIABLE deAux AS DECIMAL     NO-UNDO.

    /* Ate R$ 4.000,00, desconta 1% */
    IF deSalario >= 4000 THEN
        ASSIGN deAcumulador = deAcumulador + 40.
    ELSE DO:
        ASSIGN deAcumulador = deAcumulador + (deSalario * 0.01).
        RETURN.
    END.
    
    /* De R$ 4.001,00 a R$ 10.000,00, desconta mais 4% */
    IF deSalario >= 10001 THEN
        ASSIGN deAcumulador = deAcumulador + 240.
    ELSE DO:
        ASSIGN deAcumulador = deAcumulador + ((deSalario - 4000) * 0.04).
        RETURN.
    END.

    /* Acima de R$ 10.000,00, desconta 6% */
    IF deSalario >= 10001 THEN
        ASSIGN deAcumulador = deAcumulador + ((deSalario - 10000) * 0.06).

END PROCEDURE.
