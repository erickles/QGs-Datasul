OUTPUT TO "c:\Temp\comissoes.csv".

PUT "ep-codigo;"
    "cod-estabel;"
    "nro-docto;"
    "parcela;"
    "esp-docto;"
    "serie;"      
    "tp-movto;"   
    "cod-rep;"    
    "dt-apuracao;"
    "dt-digita;"  
    "dt-today;"   
    "dt-trans;"   
    "Observacao;" 
    "origem;"     
    "referencia;" 
    "usuario;"    
    "valor" SKIP.      

FOR EACH es-movto-comis WHERE es-movto-comis.Observacao  = "DESFAZIMENTO/DEVOLUCAO/RETORNO"
                          AND es-movto-comis.origem      = "ACR"
                          AND es-movto-comis.referencia  = "DESF/DEVOL/RET"
                          NO-LOCK:

    PUT es-movto-comis.ep-codigo    ";"
        es-movto-comis.cod-estabel  ";"
        es-movto-comis.nro-docto    ";"
        es-movto-comis.parcela      ";"
        es-movto-comis.esp-docto    ";"
        es-movto-comis.serie        ";"
        es-movto-comis.tp-movto     ";"
        es-movto-comis.cod-rep      ";"
        es-movto-comis.dt-apuracao  ";"
        es-movto-comis.dt-digita    ";"
        es-movto-comis.dt-today     ";"
        es-movto-comis.dt-trans     ";"
        es-movto-comis.Observacao   ";"
        es-movto-comis.origem       ";"
        es-movto-comis.referencia   ";"
        es-movto-comis.usuario      ";"
        es-movto-comis.valor        SKIP.
END.

OUTPUT CLOSE.
