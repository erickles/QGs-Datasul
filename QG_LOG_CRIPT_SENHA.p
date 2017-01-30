{include/i-buffer.i}

OUTPUT TO "c:\temp\log-senha-cripto.csv".

PUT "Cod.Usuario"       ";"
    "Nome usuario"      ";"
    "Dt.interacao"      ";"
    "Hr.interacao"      ";"
    "Tipo interacao"    SKIP.

FOR EACH es-log-senha-cripto NO-LOCK:

    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = es-log-senha-cripto.cod-usuario NO-LOCK NO-ERROR.        

    PUT UNFORM es-log-senha-cripto.cod-usuario                              ";"
               IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""  ";"
               es-log-senha-cripto.data-interacao                           ";"
               SUBSTRING(es-log-senha-cripto.hora-interacao,1,8)            ";"
               TRIM(es-log-senha-cripto.tipo-interacao)                     SKIP.
END.

OUTPUT CLOSE.
