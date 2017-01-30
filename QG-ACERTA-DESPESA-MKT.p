FOR EACH es-ev-integr-desp WHERE es-ev-integr-desp.cod-evento     = 10934
                             AND es-ev-integr-desp.ano-referencia = 2011:
    DISPLAY es-ev-integr-desp.nr-pedcli
            es-ev-integr-desp.vl-total
            es-ev-integr-desp.vl-unitario
            es-ev-integr-desp.dt-implant hr-implant 
            es-ev-integr-desp.it-codigo.
    UPDATE es-ev-integr-desp.vl-total.
END.
