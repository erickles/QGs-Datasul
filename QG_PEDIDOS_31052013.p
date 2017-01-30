FOR EACH ws-p-venda WHERE ws-p-venda.nr-pedcli = "366-2314",
                       FIRST ped-venda WHERE ped-venda.nr-pedcli = ws-p-venda.nr-pedcli
                                         AND ped-venda.nome-abrev = ws-p-venda.nome-abrev:

    FOR EACH ped-ent OF ped-venda:
        /*DISP ped-ent.dt-atualizacao.*/
        IF ped-ent.dt-atualizacao <> 05/31/2013 THEN
            ASSIGN ped-ent.dt-atualizacao = 05/31/2013.
    END.

    FOR EACH ped-item OF ped-venda:
        IF ped-item.dt-userimp <> 05/31/2013 THEN
            ASSIGN ped-item.dt-userimp = 05/31/2013.
    END.
    
    IF ws-p-venda.dt-implant <> 05/31/2013 THEN
        ASSIGN ws-p-venda.dt-implant = 05/31/2013.

    IF ped-venda.dt-implant <> 05/31/2013 THEN
        ASSIGN ped-venda.dt-implant = 05/31/2013.
    
END.
