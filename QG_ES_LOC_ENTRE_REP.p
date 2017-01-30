DEFINE VARIABLE iCont AS INTEGER    NO-UNDO.
DEFINE VARIABLE id AS INTEGER       NO-UNDO.
DEFINE BUFFER bf-es-loc-entr-rep FOR es-loc-entr-rep.

DEFINE TEMP-TABLE tt-repres
    FIELD cod-rep       AS INTEGER
    FIELD cod-entrega   AS CHAR
    FIELD nome-abrev    AS CHAR
    INDEX cod-rep cod-entrega nome-abrev.

FOR EACH es-loc-entr NO-LOCK:

    CREATE tt-repres.
    ASSIGN tt-repres.cod-rep        = es-loc-entr.cod-rep
           tt-repres.cod-entrega    = es-loc-entr.cod-entrega
           tt-repres.nome-abrev     = es-loc-entr.nome-abrev.

    DO id = 1 TO NUM-ENTRIES(es-loc-entr.char-1):
        IF INTE(ENTRY(id,es-loc-entr.char-1)) <> 0 THEN DO:
            
            FIND FIRST tt-repres WHERE tt-repres.cod-rep        = INTE(ENTRY(id,es-loc-entr.char-1))
                                   AND tt-repres.cod-entrega    = es-loc-entr.cod-entrega
                                   AND tt-repres.nome-abrev     = es-loc-entr.nome-abrev NO-ERROR.

            IF NOT AVAIL tt-repres THEN DO:
                CREATE tt-repres.
                ASSIGN tt-repres.cod-rep        = INTE(ENTRY(id,es-loc-entr.char-1))
                       tt-repres.cod-entrega    = es-loc-entr.cod-entrega
                       tt-repres.nome-abrev     = es-loc-entr.nome-abrev.
            END.            

        END.
    END.
END.

FOR EACH tt-repres NO-LOCK BY tt-repres.cod-rep:
    
    FIND FIRST bf-es-loc-entr-rep WHERE bf-es-loc-entr-rep.cod-rep     = tt-repres.cod-rep    
                                    AND bf-es-loc-entr-rep.cod-entrega = tt-repres.cod-entrega
                                    AND bf-es-loc-entr-rep.nome-abrev  = tt-repres.nome-abrev 
                                    NO-ERROR.

    IF NOT AVAIL bf-es-loc-entr-rep THEN DO:
        CREATE bf-es-loc-entr-rep.
        ASSIGN bf-es-loc-entr-rep.cod-rep        = tt-repres.cod-rep
               bf-es-loc-entr-rep.cod-entrega    = tt-repres.cod-entrega
               bf-es-loc-entr-rep.nome-abrev     = tt-repres.nome-abrev.
    END.

END.
