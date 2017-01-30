DEFINE VARIABLE cgl-compl-mensagem AS CHARACTER   NO-UNDO.


FIND FIRST ped-venda NO-LOCK
    WHERE  ped-venda.nome-abrev = "189695"
    AND    ped-venda.nr-pedcli  = "110293/c/R" NO-ERROR.

MESSAGE ped-venda.dsp-pre-fat
        ped-venda.cod-sit-ped
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

IF  AVAIL  ped-venda THEN DO:
    IF ped-venda.cod-sit-ped = 5 OR
       ped-venda.cod-sit-pre > 2 OR
       NOT ped-venda.dsp-pre-fat  /* Suspenso */ THEN DO: 
        
        ASSIGN cgl-compl-mensagem = STRING(cod-sit-ped) + "," + STRING(cod-sit-pre) + "," + STRING(dsp-pre-fat).
        RETURN 'NOK':U.
    END.
    ELSE DO: 
        ASSIGN cgl-compl-mensagem = "".
        RETURN 'OK':U.
    END.
END.
