OUTPUT TO c:\pedidos_entrada.csv.

PUT "PEDIDO;DATA;HORA;PROG;STATUS;CONT;OPERACAO" SKIP.

FOR EACH ped-venda WHERE ped-venda.dt-implant >= 01/01/2013
                      AND ped-venda.dt-implant <= 06/30/2013,
                      FIRST natur-oper OF ped-venda WHERE emite-duplic
                      NO-LOCK:

    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ped-venda.nr-pedcli
                            AND ws-p-venda.nome-abrev = ped-venda.nome-abrev
                            NO-LOCK NO-ERROR.

    IF NOT AVAIL ws-p-venda THEN NEXT.

    FIND FIRST repres WHERE repres.nome-abrev = ws-p-venda.no-ab-reppri NO-LOCK NO-ERROR.

    IF NOT AVAIL repres THEN NEXT.
    FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = repres.cod-rep NO-LOCK NO-ERROR.
    IF es-repres-comis.u-int-1 = 4 OR es-repres-comis.u-int-1 = 2 THEN NEXT.

    /*IF ws-p-venda.cod-tipo-oper <> 1 AND ws-p-venda.cod-tipo-oper <> 2 THEN NEXT.*/
    IF NOT SUBSTRING(ws-p-venda.char-2,25,1) = 'S' THEN
        PUT ped-venda.nr-pedcli                         ";"
            ped-venda.dt-implant                        ";"
            STRING(ws-p-venda.hr-implant,"HH:MM:SS")    ";"
            SUBSTRING(ws-p-venda.char-2,25,1)           ";"
            ws-p-venda.ind-sit-ped                      ";"
            "1"                                         ";"
            ws-p-venda.cod-tipo-oper                    SKIP.

END.

OUTPUT CLOSE.
