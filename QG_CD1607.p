/*
OUTPUT TO "c:\clientes_ports.csv".

PUT "Cod. Emitente;Nome Emitente" SKIP.
*/
FOR EACH emitente WHERE emitente.port-prefer = 411:
    /*
    PUT emitente.cod-emitente   ";"
        emitente.nome-emit      SKIP.
    */
    ASSIGN emitente.port-prefer = 112.

    RUN cdp/cd1608.p (INPUT emitente.cod-emitente,
                      INPUT emitente.cod-emitente,
                      INPUT 4, /* Todos (Cliente/Fornecedor/Ambos) */
                      INPUT 2, /* Somenta nao atualizados */
                      INPUT 1,
                      INPUT 0,
                      INPUT "c:\cliente_port.txt",
                      INPUT "",
                      INPUT "").
                          
END.

/*OUTPUT CLOSE.*/
