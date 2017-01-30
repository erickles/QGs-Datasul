DEFINE VARIABLE i AS INTEGER     NO-UNDO.

{include/i-freeac.i}

OUTPUT TO c:\temp\Fornecedores2015.csv.

    PUT "Codigo;"
        "Nome;"
        "Pais;"
        "CNPJ;"
        "Nome Abrev;"
        "Dt Implant"
        SKIP.

FOR EACH emitente WHERE INTE(emitente.identific) = 2 
                    AND YEAR(emitente.data-implant) = 2015
                    AND NOT emitente.nome-emit MATCHES "*eliminado*"
                    NO-LOCK:
    
    FIND FIRST es-emit-fornec WHERE 
        es-emit-fornec.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    
    
    IF AVAIL es-emit-fornec THEN
        IF es-emit-fornec.log-2 = YES THEN
            
            ASSIGN i = i + 1.

    PUT UNFORMATTED 
        emitente.cod-emit                   ";"
        fn-free-accent(emitente.nome-emit)  ";"
        fn-free-accent(emitente.pais)       ";"
        "'" + emitente.cgc                  ";"
        emitente.nome-abrev                 ";"
        emitente.data-implant               SKIP.

END.

OUTPUT CLOSE.
