output to "C:\clientes.txt".
    
for each nota-fiscal where nota-fiscal.dt-emis-nota >= 09/01/2008 and
                           nota-fiscal.dt-emis-nota <= 09/30/2009 
                           no-lock
                           break by nota-fiscal.cod-emitente.

    if last-of(nota-fiscal.cod-emitente) then do:
        find first emitente where emitente.cod-emitente = nota-fiscal.cod-emitente and
                                  index(emitente.e-mail,"@") <> 0 no-lock no-error.

        if avail emitente then
            put nota-fiscal.cod-emitente
                " "
                emitente.nome-abrev
                " "
                emitente.nome-emit
                " "
                emitente.e-mail
                " "
                nota-fiscal.dt-emis-nota
                " "
                skip.
    end.
end.

output close.
