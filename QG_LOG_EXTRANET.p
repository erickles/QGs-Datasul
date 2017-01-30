OUTPUT TO "c:\temp\log-web.csv".

PUT "cod-emitente" ";"  
    "cod-estabel"  ";"  
    "desc-trans"   ";"  
    "nr-nota-fis"  ";"  
    "nr-pedcli"    ";"  
    "parcela"      ";"  
    "serie"        ";"  
    "tipo-usu"     ";"  
    "usuario"      ";"  
    "data"         ";"  
    "hora"         SKIP.

FOR EACH ws-logextranet WHERE ws-logextranet.data >= 01/01/2015 NO-LOCK.

    PUT ws-logextranet.cod-emitente ";"
        ws-logextranet.cod-estabel  ";"
        ws-logextranet.desc-trans   ";"
        ws-logextranet.nr-nota-fis  ";"
        ws-logextranet.nr-pedcli    ";"
        ws-logextranet.parcela      ";"
        ws-logextranet.serie        ";"
        ws-logextranet.tipo-usu     ";"
        ws-logextranet.usuario      ";"
        ws-logextranet.data         ";"
        ws-logextranet.hora         SKIP.

END.

OUTPUT CLOSE.
