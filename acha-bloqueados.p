for each emitente no-lock.
    
    find last movto-sintegra where movto-sintegra.cod-emitente = emitente.cod-emitente no-lock no-error.
           
    if avail movto-sintegra then

       if movto-sintegra.situacao begins "Nao Habi" OR
       movto-sintegra.situacao begins "NÆo Habi" OR
       movto-sintegra.situacao begins "Baixad"   OR
       movto-sintegra.situacao begins "Suspen"   or
       movto-sintegra.situacao begins "Canc" then
    
        disp emitente.cod-emitente
             movto-sintegra.situacao.

end.
