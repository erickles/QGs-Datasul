
OUTPUT TO "c:\temp\pessoa_jurid.csv".

FOR EACH pessoa_jurid WHERE TRIM(pessoa_jurid.nom_ender_cobr) = "" NO-LOCK:

    FIND FIRST emsuni.cliente WHERE emsuni.cliente.num_pessoa = pessoa_jurid.num_pessoa_jurid
        NO-LOCK NO-ERROR.
    IF AVAIL emsuni.cliente THEN DO:
        PUT cliente.cdn_cliente             ";"
            pessoa_jurid.num_pessoa_jurid   SKIP.
    END.

END.
1
OUTPUT CLOSE.

