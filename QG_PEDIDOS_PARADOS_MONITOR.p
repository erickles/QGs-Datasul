FOR EACH ws-p-import WHERE ws-p-import.implantado = FALSE 
                       AND ws-p-import.erro = FALSE:
    ASSIGN ws-p-import.implantado = YES.
    DISP ws-p-import.atualizado
         ws-p-import.cod-rep
         ws-p-import.data-atualizado
         ws-p-import.data-envio
         ws-p-import.data-erro
         ws-p-import.data-implantado
         ws-p-import.data-importacao
         ws-p-import.erro implantado
         ws-p-import.nr-pedcli 
         WITH 1 COL.
END.
