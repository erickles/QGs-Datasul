DEFINE VARIABLE c-nr-docto  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-nr-pedido AS CHARACTER   NO-UNDO.

FIND FIRST es-movto-comis WHERE es-movto-comis.cod-estabel = "19"
                            AND es-movto-comis.cod-rep     = 1062
                            AND es-movto-comis.dt-apuracao = 07/25/2016
                            AND es-movto-comis.dt-trans    = 07/27/2016
                            AND es-movto-comis.ep-codigo   = "1"
                            AND es-movto-comis.esp-docto   = "DP"
                            AND es-movto-comis.tp-movto    = 204
                            AND es-movto-comis.valor       = 1455.94
                            NO-ERROR.
/*
MESSAGE es-movto-comis.cod-estabel  SKIP
        es-movto-comis.serie        SKIP
        es-movto-comis.nro-docto  
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
es-movto-comis.serie = "-".
FIND FIRST nota-fiscal WHERE nota-fiscal.cod-estabel  = es-movto-comis.cod-estabel
                         AND nota-fiscal.serie        = es-movto-comis.serie
                         AND nota-fiscal.nr-fatura    = es-movto-comis.nro-docto 
                         NO-LOCK NO-ERROR.
IF NOT AVAIL nota-fiscal THEN DO:
    
    ASSIGN c-nr-docto = "0" + es-movto-comis.nro-docto.

    FIND FIRST nota-fiscal WHERE nota-fiscal.cod-estabel  = es-movto-comis.cod-estabel
                             AND nota-fiscal.serie        = "1"
                             AND nota-fiscal.nr-fatura    = c-nr-docto 
                             NO-LOCK NO-ERROR.                                                 
    IF NOT AVAIL nota-fiscal THEN
        FIND FIRST nota-fiscal WHERE nota-fiscal.cod-estabel  = es-movto-comis.cod-estabel
                                 AND nota-fiscal.serie        = "-"
                                 AND nota-fiscal.nr-fatura    = c-nr-docto 
                                 NO-LOCK NO-ERROR.
        IF NOT AVAIL nota-fiscal THEN
            FIND FIRST nota-fiscal WHERE nota-fiscal.cod-estabel  = es-movto-comis.cod-estabel
                                     AND nota-fiscal.serie        = "2" /*BOMBA*/
                                     AND nota-fiscal.nr-fatura    = c-nr-docto 
                                     NO-LOCK NO-ERROR.
END.

IF AVAIL nota-fiscal THEN DO:
    MESSAGE nota-fiscal.nr-nota-fis SKIP
            nota-fiscal.serie       SKIP
            nota-fiscal.nr-fatura   SKIP
            nota-fiscal.cod-estabel SKIP
            nota-fiscal.nr-pedcli
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    IF nota-fiscal.nr-pedcli <> "" THEN
        ASSIGN c-nr-pedido = nota-fiscal.nr-pedcli.
    ELSE 
        ASSIGN c-nr-pedido = SUBSTRING(nota-fiscal.observ-nota, 1975, 12).
END.
ELSE
    ASSIGN c-nr-pedido = "". 

    MESSAGE c-nr-pedido
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
