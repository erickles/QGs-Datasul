DEFINE BUFFER bf-cfop FOR es-cfop.

OUTPUT TO "c:\naturezas.csv".
FOR EACH es-cfop NO-LOCK WHERE (es-cfop.cod-tipo-oper = "3" 
                            OR es-cfop.cod-tipo-oper = "45")                           
                           BREAK BY es-cfop.estado
                                 BY es-cfop.nat-operacao-interna:
    
    IF es-cfop.cod-tipo-oper = "3" THEN DO:    
        FIND bf-cfop WHERE bf-cfop.estado       = es-cfop.estado
                       AND bf-cfop.cod-tipo-oper = "9" 
                        NO-LOCK NO-ERROR.
    END.
    ELSE DO:
        FIND bf-cfop WHERE bf-cfop.estado       = es-cfop.estado
                       AND bf-cfop.cod-tipo-oper = "46" 
                        NO-LOCK NO-ERROR.
    END.        

    IF FIRST-OF(es-cfop.nat-operacao-interna) THEN DO:   
        PUT es-cfop.cod-tipo-oper ";"
            es-cfop.cod-estabel ";"
            es-cfop.ge-codigo ";"            
            es-cfop.estado ";"
            es-cfop.nat-operacao-interna ";"
            IF AVAIL bf-cfop THEN bf-cfop.cod-tipo-oper ELSE "" ";"
            IF AVAIL bf-cfop THEN bf-cfop.nat-operacao-interna ELSE "" ";"
            SKIP.
    END.

END.
