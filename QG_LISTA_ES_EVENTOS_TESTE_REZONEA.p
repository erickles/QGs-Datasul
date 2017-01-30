OUTPUT TO "c:\rezonea_teste_eventos.csv".
PUT "Cod. Evento;Regiao" SKIP.
FOR EACH es-eventos WHERE es-eventos.nome-ab-reg = "BA 01" 
                       OR es-eventos.nome-ab-reg = "BA 02" NO-LOCK:

    PUT es-eventos.cod-evento       ";"
        es-eventos.nome-ab-reg    SKIP.
        
END.
OUTPUT CLOSE.
