DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE BUFFER bf-busca-preco FOR es-busca-preco.
DEFINE BUFFER bf2-busca-preco FOR es-busca-preco.

FOR EACH es-busca-preco NO-LOCK WHERE es-busca-preco.nr-tabpre   = "TRA19-12"
                                  AND es-busca-preco.cod-estabel = "19":

    CREATE bf-busca-preco.
    BUFFER-COPY es-busca-preco EXCEPT es-busca-preco.cod-estabel es-busca-preco.nr-busca TO bf-busca-preco.
    FIND LAST bf2-busca-preco NO-LOCK NO-ERROR.
    ASSIGN bf-busca-preco.cod-estabel = "44"
           bf-busca-preco.nr-busca    = bf2-busca-preco.nr-busca + 1.

    iCont = iCont + 1.
END.

DISP iCont.
