FOR EACH ws-p-venda WHERE ws-p-venda.nr-pedcli = "4431w0268" NO-LOCK:

    FIND FIRST nota-fiscal WHERE nota-fiscal.nr-pedcli   = ws-p-venda.nr-pedcli
                             AND nota-fiscal.nome-ab-cli = ws-p-venda.nome-abrev
                             NO-LOCK NO-ERROR.                         
    IF AVAIL nota-fiscal THEN DO:

        FOR EACH es-movto-comis /*NO-LOCK*/ WHERE es-movto-comis.cod-rep      = 4431
                                  /*AND es-movto-comis.dt-apuracao = 01/20/2016*/
                                    /*AND es-movto-comis.tp-movto     = 201*/
                                    AND es-movto-comis.nro-docto    = nota-fiscal.nr-nota-fis
                                  /*AND es-movto-comis.cod-estabel  = "18"
                                  AND es-movto-comis.parcela      = "01"
                                  AND es-movto-comis.serie        = "2"
                                  AND (es-movto-comis.tp-movto     = 101 /*OR es-movto-comis.tp-movto = 101*/)
                                  /*AND es-movto-comis.valor        = 34.03*/
                                  AND es-movto-comis.ep-codigo    = 1
                                  AND es-movto-comis.esp-docto    = "DP"*/:

            ASSIGN es-movto-comis.dt-apuracao = 08/25/2016
                   es-movto-comis.dt-today    = 08/26/2016
                   es-movto-comis.dt-trans    = 08/25/2016.
        
            DISP es-movto-comis.ep-codigo
                 es-movto-comis.tp-movto
                 es-movto-comis.valor 
                 es-movto-comis.dt-apuracao
                 es-movto-comis.dt-today
                 es-movto-comis.dt-trans
                 es-movto-comis.nro-docto
                 es-movto-comis.parcela
                 es-movto-comis.serie
                 es-movto-comis.origem
                 es-movto-comis.observacao.

            /*
            UPDATE es-movto-comis.dt-apuracao          
                 es-movto-comis.dt-today
                 es-movto-comis.dt-trans.
            */
            /*ASSIGN es-movto-comis.dt-apuracao = 12/14/2015.*/
            /*LEAVE.*/
            
        END.

    END.

END.
