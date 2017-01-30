FOR EACH es-busca-preco WHERE nr-busca = 28104
                           OR nr-busca = 28111
                           OR nr-busca = 28112
                           OR nr-busca = 28113
                           OR nr-busca = 28114
                           OR nr-busca = 31080
                           OR nr-busca = 31631:

    ASSIGN es-busca-preco.ge-codigo  = ?
           es-busca-preco.fm-codigo  = ?
           es-busca-preco.fm-cod-com = "AVES"
           es-busca-preco.data-2     = 12/31/2014.

END.

FOR EACH es-busca-preco WHERE nr-busca = 28105
                           OR nr-busca = 28107
                           OR nr-busca = 28108
                           OR nr-busca = 28109
                           OR nr-busca = 28110
                           OR nr-busca = 31081
                           OR nr-busca = 31632:

    ASSIGN es-busca-preco.ge-codigo = ?
           es-busca-preco.fm-codigo = ?
           es-busca-preco.fm-cod-com = "AVES"
           es-busca-preco.data-2     = 12/31/2014.

END.









