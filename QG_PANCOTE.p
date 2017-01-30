FOR EACH titulo WHERE titulo.cod-emitente = 95544 
                  AND titulo.nr-pedcli = "1062w0033":

    DISP titulo.cod-estabel 
         titulo.nr-pedcli 
         titulo.vl-saldo 
         titulo.nr-docto
         titulo.dt-vencim
         titulo.dt-liq
         titulo.cod-rep.

    UPDATE titulo.cod-rep.

END.
