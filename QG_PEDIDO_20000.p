FIND FIRST ws-p-venda WHERE LENGTH(TRIM(observacoes)) > 20000 NO-ERROR.
IF AVAIL ws-p-venda THEN DO:
    DISP ws-p-venda.nr-pedcli
         ws-p-venda.observacoes.
    UPDATE ws-p-venda.observacoes.
END.
