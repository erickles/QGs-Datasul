
FOR EACH es-movto-comis WHERE es-movto-comis.dt-apuracao = 03/31/2017
                          AND es-movto-comis.cod-rep = 3223
                          BY es-movto-comis.dt-today:
    
    DISP es-movto-comis.dt-apuracao
         es-movto-comis.dt-integracao
         es-movto-comis.dt-today
         es-movto-comis.dt-trans
         es-movto-comis.dt-vencto
         es-movto-comis.valor.

    UPDATE es-movto-comis.dt-apuracao es-movto-comis.dt-today es-movto-comis.dt-trans.
    
END.
