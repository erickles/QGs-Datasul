OUTPUT TO "c:\Buscas_Natureza.csv".

PUT "COD CNAE"                  ";"
    "COD ESTABEL"               ";"    
    "MENSAGEM INTERNA"          ";"
    "TIPO OPERACAO"             ";"
    "CONTRIBUINTE ICMS"         ";"
    "DESCONTO ICMS"             ";"
    "AJUSTE DE TABELA"          ";"
    "ESTADO"                    ";"
    "FAMILIA MATERIAL"          ";"
    "FAMILIA COMERCIAL"         ";"
    "GRUPO DE ESTOQUE"          ";"
    "ITEM"                      ";"
    "ITEM REGISTRADO"           ";"    
    "NATUREZA OPERACAO"         ";"
    "NATUREZA"                  ";"
    "SUBSTITUICAO TRIBUTARIA"   SKIP.

FOR EACH es-cfop NO-LOCK.
    PUT es-cfop.cod-CNAE                    ";"
        es-cfop.cod-estabel                 ";"        
        es-cfop.cod-mensagem-interna        ";"
        es-cfop.cod-tipo-oper               ";"
        es-cfop.contribui                   ";"
        es-cfop.desc-icms                   ";"
        es-cfop.difer-icms                  ";"
        es-cfop.estado                      ";"
        es-cfop.fm-codigo                   ";"
        es-cfop.fm-codigo-comercial         ";"
        es-cfop.ge-codigo                   ";"
        es-cfop.it-codigo                   ";"
        es-cfop.log-item-reg                ";"        
        es-cfop.nat-operacao-interna        ";"
        es-cfop.natureza                    ";"
        es-cfop.substitui-tributaria        SKIP.
END.

OUTPUT CLOSE.
