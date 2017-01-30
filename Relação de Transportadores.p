DEF VAR situacao  AS CHAR FORMAT "X(35)" NO-UNDO.
DEF VAR Inscricao AS CHAR FORMAT "X(35)" NO-UNDO.
DEF VAR Natureza  AS CHAR FORMAT "X(35)" NO-UNDO.
DEF VAR Email     AS CHAR FORMAT "X(40)" NO-UNDO.

OUTPUT to c:\transp2.csv.

PUT "Cod.Emitente"  ";"
    "Nome"          ";"
    "Natureza"      ";"
    "CNPJ"          ";"
    "Inscricao"     ";"
    "Estado"        ";"
    "Email"         ";"
    "Telefone"      ";"
    "Telefax"       ";" 
    "Situacao"      SKIP.

FOR EACH transporte:
    find first emitente where transporte.cgc = emitente.cgc no-error.
        if avail emitente then do:
            if transporte.ind-situacao = 1 then  /*Situacao*/
                assign situacao = "ativo".
            else
                assign situacao = "inativo".

            Case transporte.natureza: /*Natureza*/
                when 1 then
                    assign Natureza = "Pessoa Fisica".
                when 2 then
                    assign Natureza = "Pessoa Juridica".
                when 3 then
                    assign Natureza = "Estrangeiro".
                when 4 then 
                    assign Natureza = "Trading".
            end case.

    find first cont-tran where cont-tran.cod-transp = transporte.cod-transp no-error.
        if avail cont-tran then
            assign Email = cont-tran.e-mail.
        else
            assign Email = "".                

            if transporte.ins-estadual = "" or transporte.ins-estadual = "ISENTO" then  /*Inscricao*/
                assign Inscricao = "ISENTO".
            else
                assign Inscricao = transporte.ins-estadual.

            put emitente.cod-emitente                       ";"
                transporte.nome                             ";"
                natureza                                    ";"
                STRING("'" + transporte.cgc) FORMAT "X(40)" ";"
                STRING("'" + Inscricao)      FORMAT "X(40)" ";"
                transporte.estado                           ";"
                Email                                       ";"
                transporte.telefone                         ";" 
                transporte.telefax                          ";"
                situacao SKIP.
        END.
END.

OUTPUT CLOSE.
