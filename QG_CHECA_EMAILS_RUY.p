FOR EACH es-comunica-cliente-envio WHERE nr-pedcli = "SAC" NO-LOCK:
    DISP TRIM(nome-abrev) data-envio STRING(TRIM(destino),"X(40)").
END.
