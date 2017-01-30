DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
/*
{include/varsituac.i}

OUTPUT TO "c:\temp\pedido_port.csv".

PUT "PEDIDO;DATA IMPLANT;PORTADOR;SITUACAO" SKIP.
*/
FOR EACH ws-p-venda WHERE ws-p-venda.ind-sit-ped < 17 
                      AND (ws-p-venda.cod-estabel = "19"
                       OR ws-p-venda.cod-estabel = "05"
                       OR ws-p-venda.cod-estabel = "24")
                      AND (ws-p-venda.cod-tipo-oper = 1 
                       OR ws-p-venda.cod-tipo-oper = 2)
                       NO-LOCK:

    FIND FIRST es-loc-entr WHERE es-loc-entr.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
    IF AVAIL es-loc-entr AND es-loc-entr.boleto = 2 THEN DO:

        FIND FIRST ped-venda WHERE ped-venda.nr-pedcli  = ws-p-venda.nr-pedcli
                               AND ped-venda.nome-abrev = ws-p-venda.nome-abrev
                               NO-LOCK NO-ERROR.
        IF AVAIL ped-venda THEN DO:
            IF ped-venda.cod-portador = 113 THEN
                iCont = iCont + 1.
            /*
            PUT UNFORM ws-p-venda.nr-pedcli                ";"
                       ws-p-venda.dt-implant               ";"
                       ped-venda.cod-portador              ";"
                       cSituacao[ws-p-venda.ind-sit-ped]   SKIP.
            */
        END.
    END.
END.
/*
OUTPUT CLOSE.
*/
MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
