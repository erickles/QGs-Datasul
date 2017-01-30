output to c:\fornecedores.csv.
    
FOR each movto-sintegra where (movto-sintegra.data-consulta = 03/30/2011
                          or movto-sintegra.data-consulta = 03/31/2011)
                          and movto-sintegra.situacao-s  = "N" no-lock:
    
/*     find first es-emit-fornec where es-emit-fornec.cod-emitente = movto-sintegra.cod-emitente. */
/*     if avail es-emit-fornec then                                                               */
/*         assign es-emit-fornec.log-2 = no.                                                      */
/*                                                                                                */
/*     put es-emit-fornec.cod-emitente   ";"                                                      */
/*         skip.                                                                                  */
end.

output close.
