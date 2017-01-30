{include/i-freeac.i}

DEFINE VARIABLE cBanco          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cGrupo          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTipoPagamento  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cIdentific      AS CHARACTER   NO-UNDO.

OUTPUT TO c:\temp\Fornecedores2016.csv.

    PUT "Codigo;"
        "Nome;"
        "Pais;"
        "CNPJ;"
        "Nome Abrev;"
        "Insc estadual;"
        "Endereco;"
        "Cidade;"
        "Estado;"
        "Cep;"
        "Telefone 1;"
        "Telefone 2;"
        "Email;"
        "Grupo fornec;"
        "Banco;"
        "Agencia;"
        "Conta corrente;"
        "Inativo;"
        "Tipo pagamento;"
        "Identificacao;"
        "Dt Implant"
        SKIP.

FOR EACH emitente WHERE (INTE(emitente.identific) = 2 OR INTE(emitente.identific) = 3) 
                    /*AND YEAR(emitente.data-implant) <= 2016*/
                    AND NOT emitente.nome-emit MATCHES "*eliminado*"    
                    NO-LOCK:
    
    FIND FIRST es-emit-fornec WHERE es-emit-fornec.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    
    IF AVAIL es-emit-fornec /*AND es-emit-fornec.log-2 = YES*/ THEN DO:

        FIND FIRST grupo-fornec WHERE grupo-fornec.cod-gr-forn = emitente.cod-gr-forn NO-LOCK NO-ERROR.
        IF AVAIL grupo-fornec THEN
            cGrupo = grupo-fornec.descricao.
        ELSE
            cGrupo = "".

        FIND FIRST emsuni.banco WHERE emsuni.banco.cod_banco = STRING(emitente.cod-banco) NO-LOCK NO-ERROR.

        IF AVAIL emsuni.banco THEN
            cBanco = STRING(emsuni.banco.cod_banco)  + " - " + STRING(emsuni.banco.nom_banco).
        ELSE
            cBanco = "".

        cIdentific = "".
        IF INTE(emitente.identific) = 2 THEN
            cIdentific = "Fornecedor".
        ELSE
            cIdentific = "Ambos".

        cTipoPagamento = "".
        CASE emitente.tp-pagto:

            WHEN 1 THEN
                cTipoPagamento = "DOC".

            WHEN 2 THEN
                cTipoPagamento = "Credito Conta Corrente".

            WHEN 3 THEN
                cTipoPagamento = "Cheque Administrativo".

            WHEN 4 THEN
                cTipoPagamento = "Cobranca em Carteira".

            WHEN 5 THEN
                cTipoPagamento = "Cheque Nominal".

            WHEN 6 THEN
                cTipoPagamento = "Debito em Conta Corrente".

            WHEN 7 THEN
                cTipoPagamento = "Cartao de Credito".

            WHEN 8 THEN
                cTipoPagamento = "Agendamento Eletronico".

        END CASE.

        cTipoPagamento = STRING(emitente.tp-pagto) + " - " + cTipoPagamento.

        PUT UNFORMATTED 
            emitente.cod-emit                                       ";"
            fn-free-accent(REPLACE(emitente.nome-emit,";",""))      ";"
            fn-free-accent(REPLACE(emitente.pais,";",""))           ";"
            "'" + fn-free-accent(emitente.cgc)                      ";"
            fn-free-accent(REPLACE(emitente.nome-abrev,";",""))     ";"
            emitente.ins-estadual                                   ";"
            fn-free-accent(REPLACE(emitente.endereco,";",""))       ";"
            fn-free-accent(REPLACE(emitente.cidade,";",""))         ";"
            fn-free-accent(REPLACE(emitente.estado,";",""))         ";"
            fn-free-accent(REPLACE(emitente.cep,";",""))            ";"
            fn-free-accent(REPLACE(emitente.telefone[1],";",""))    ";"
            fn-free-accent(REPLACE(emitente.telefone[2],";",""))    ";"
            fn-free-accent(REPLACE(emitente.e-mail,";",""))         ";"
            fn-free-accent(cGrupo)                                  ";"
            fn-free-accent(cBanco)                                  ";"
            fn-free-accent(REPLACE(emitente.agencia,";",""))        ";"
            fn-free-accent(REPLACE(emitente.conta-corren,";",""))   ";"
            es-emit-fornec.log-2                                    ";"
            fn-free-accent(cTipoPagamento)                          ";"
            fn-free-accent(cIdentific)                              ";"
            emitente.data-implant                                   SKIP.

    END.

END.

OUTPUT CLOSE.
