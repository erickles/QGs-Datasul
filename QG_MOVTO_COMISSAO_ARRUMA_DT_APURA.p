OUTPUT TO "C:\temp\comissao.csv".

PUT "ep-codigo"    ";"
    "tp-movto"     ";"
    "valor"        ";"
    "dt-apuracao"  ";"
    "dt-today"     ";"
    "dt-trans"     ";"
    "nro-docto"    ";"
    "parcela"      ";"
    "serie"        ";"
    "origem"       ";"
    "observacao"   SKIP.

FOR EACH es-movto-comis WHERE /*es-movto-comis.cod-rep      = 2553*/
                          /*AND es-movto-comis.dt-apuracao = 01/20/2016*/
                         /*AND es-movto-comis.tp-movto     = 201*/
                          /*AND es-movto-comis.nro-docto    = "0101469"*/
                          /*AND es-movto-comis.cod-estabel  = "18"
                          AND es-movto-comis.parcela      = "01"
                          AND es-movto-comis.serie        = "2"
                          AND (es-movto-comis.tp-movto     = 101 /*OR es-movto-comis.tp-movto = 101*/)
                          /*AND es-movto-comis.valor        = 34.03*/
                          AND es-movto-comis.ep-codigo    = 1
                          AND es-movto-comis.esp-docto    = "DP"*/
                          es-movto-comis.dt-apuracao >= 12/19/2016 NO-LOCK:

    PUT es-movto-comis.ep-codigo    ";"
        es-movto-comis.tp-movto     ";"
        es-movto-comis.valor        ";"
        es-movto-comis.dt-apuracao  ";"
        es-movto-comis.dt-today     ";"
        es-movto-comis.dt-trans     ";"
        es-movto-comis.nro-docto    ";"
        es-movto-comis.parcela      ";"
        es-movto-comis.serie        ";"
        es-movto-comis.origem       ";"
        es-movto-comis.observacao   SKIP.

    /*es-movto-comis.dt-apuracao = 12/20/2016.*/

    /*
    UPDATE es-movto-comis.dt-apuracao          
         es-movto-comis.dt-today
         es-movto-comis.dt-trans.
    */
    /*ASSIGN es-movto-comis.dt-apuracao = 12/14/2015.*/
    /*LEAVE.*/
    
END.
                            
OUTPUT CLOSE.
