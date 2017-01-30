FOR EACH ws-p-venda FIELDS(ws-p-venda.dt-implant ws-p-venda.nr-pedcli ws-p-venda.nome-abrev) /*WHERE ws-p-venda.dt-implant >= 01/01/2013
                                                    AND ws-p-venda.dt-implant <= 09/02/2013    */
                                                    NO-LOCK:

    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:

        FOR EACH ws-p-desc FIELDS(ws-p-desc.nome-abrev) OF ws-p-item WHERE LENGTH(ws-p-desc.nome-abrev) > 12 NO-LOCK:

            DISP ws-p-desc.nr-pedcli.

        END.

    END.    

END.
