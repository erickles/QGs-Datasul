OUTPUT TO "c:\comissao.txt".
FOR EACH ws-p-import WHERE DATE(ws-p-import.data-envio) = 09/15/2014 NO-LOCK:
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ws-p-import.nr-pedcli
                            AND ws-p-venda.ind-sit-ped <> 22
                            NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN DO:
        FIND FIRST repres WHERE repres.nome-abrev = ws-p-venda.no-ab-reppri NO-LOCK NO-ERROR.
        IF AVAIL repres THEN DO:
            FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = repres.cod-rep NO-LOCK NO-ERROR.
            IF AVAIL es-repres-comis AND es-repres-comis.log-1 THEN DO:
                FIND FIRST ws-p-item OF ws-p-venda WHERE ws-p-item.perc-comis-vd    = 0
                                                      OR ws-p-item.perc-comis-svd   = 0
                                                      OR ws-p-item.perc-comis-spg   = 0
                                                      OR ws-p-item.perc-comis-pg    = 0
                                                      NO-LOCK NO-ERROR.
                IF AVAIL ws-p-item THEN
                    PUT ws-p-venda.nr-pedcli ";"
                        ws-p-venda.ind-sit-ped
                        SKIP.
            END.
        END.
    END.

END.

OUTPUT CLOSE.
