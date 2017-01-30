DEFINE VARIABLE iTotal AS INTEGER     NO-UNDO.
DEFINE VARIABLE deTotal LIKE ws-p-venda.vl-tot-ped.

FOR EACH ws-p-import WHERE DATE(ws-p-import.data-importacao) >= 04/30/2014 
                       AND DATE(ws-p-import.data-importacao) <= 04/30/2014 
                       NO-LOCK:
    FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = ws-p-import.nr-pedcli NO-LOCK NO-ERROR.
    IF AVAIL ws-p-venda THEN DO:
        /*            
        DISP INTEGER(MTIME(ws-p-import.data-envio) / 1000)
             STRING(INTEGER(MTIME(ws-p-import.data-envio) / 1000) ,"HH:MM:SS")
             ws-p-venda.hr-implant
             STRING(INTEGER(ws-p-venda.hr-implant) ,"HH:MM:SS")
             INTEGER(ws-p-venda.hr-implant) - INTEGER(MTIME(ws-p-import.data-envio) / 1000)
             STRING(INTEGER(ws-p-venda.hr-implant) - INTEGER(MTIME(ws-p-import.data-envio) / 1000),"HH:MM:SS").
        */                
        ASSIGN iTotal   = iTotal + INTEGER(ws-p-venda.hr-implant) - INTEGER(MTIME(ws-p-import.data-envio) / 1000)
               deTotal  = deTotal + ws-p-venda.vl-tot-ped.
    END.
END.

DISP iTotal / 1375
     STRING(INTEGER(iTotal / 1375) ,"HH:MM:SS")
     deTotal.
