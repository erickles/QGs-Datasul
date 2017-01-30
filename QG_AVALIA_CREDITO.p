{include/i-buffer.i}
{cdp/cdapi013.i}
{utp/ut-glob.i}

FIND FIRST ped-venda WHERE ped-venda.nr-pedcli  = "1062w0965"
                       AND ped-venda.nome-abrev = "172797"
                       NO-LOCK NO-ERROR.
IF AVAIL ped-venda THEN DO:

    FIND FIRST emitente WHERE emitente.nome-abrev = ped-venda.nome-abrev NO-LOCK NO-ERROR.

    CREATE tt-param-aval.
    ASSIGN tt-param-aval.nr-pedido     = ped-venda.nr-pedido
           tt-param-aval.param-aval    = (IF emitente.ind-aval = 2 THEN 1 ELSE 3)
           tt-param-aval.embarque      = NO
           tt-param-aval.efetiva       = YES
           tt-param-aval.retorna       = NO
           tt-param-aval.reavalia-forc = YES
           tt-param-aval.vl-a-aval     = ped-venda.vl-liq-ped
           tt-param-aval.usuario       = c-seg-usuario
           tt-param-aval.programa      = 'QG':U.
    
    RUN cdp/cdapi013.p (INPUT-OUTPUT TABLE tt-param-aval,
                        INPUT-OUTPUT TABLE tt-erros-aval).

    FOR EACH tt-erros-aval NO-LOCK:

        DISP tt-erros-aval WITH WIDTH 300.

    END.

    IF NOT AVAIL tt-erros-aval THEN
        MESSAGE "Nao foram encontrados erros"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.
