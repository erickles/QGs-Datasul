FOR EACH es-movto-comis WHERE es-movto-comis.dt-today = 02/26/2015
                          AND es-movto-comis.tp-movto = 200
                          NO-LOCK:

    DISP es-movto-comis.dt-apuracao
         es-movto-comis.dt-today
         es-movto-comis.tp-movto.
                    
END.
