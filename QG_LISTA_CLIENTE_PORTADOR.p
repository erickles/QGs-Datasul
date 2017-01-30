/*
OUTPUT TO "c:\temp\clientes_port.csv".

PUT "CLIENTE;PORTADOR;PORTADOR PREF" SKIP.
*/
FOR EACH emitente WHERE (emitente.identific = 1 OR emitente.identific = 3)
                    AND emitente.cod-emitente >= 266001
                    AND emitente.cod-emitente <= 286000:

    IF emitente.cod-emitente = 120397
    OR emitente.cod-emitente = 123382
    OR emitente.cod-emitente = 127027
    OR emitente.cod-emitente = 205640 THEN NEXT.
    
    FIND FIRST es-loc-entr WHERE es-loc-entr.nome-abrev  = emitente.nome-abrev
                             AND es-loc-entr.cod-entrega = "padrao"
                             NO-LOCK NO-ERROR.

    IF AVAIL es-loc-entr AND es-loc-entr.boleto = 2 THEN DO:
        FIND LAST nota-fiscal OF emitente WHERE (nota-fiscal.cod-estabel = "19" OR 
                                                 nota-fiscal.cod-estabel = "05" OR 
                                                 nota-fiscal.cod-estabel = "24") 
                             AND nota-fiscal.emite-duplic
                             AND nota-fiscal.dt-cancela = ? NO-LOCK NO-ERROR.

        IF AVAIL nota-fiscal THEN DO:
            
            ASSIGN emitente.portador    = 113
                   emitente.port-prefer = 113.
            
           /*
           PUT emitente.cod-emitente   ";"
                emitente.portador       ";"
                emitente.port-prefer    SKIP.
            */
        END.
    END.
    
END.
/*
OUTPUT CLOSE.
*/
