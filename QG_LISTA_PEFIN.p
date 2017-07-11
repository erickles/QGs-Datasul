DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-situacao        AS CHARACTER   NO-UNDO EXTENT 6 INIT ["Marcado para Inclusao","Enviado para Inclusao","Incluido no Pefin","Marcado para Exclusao","Enviado para Exclusao","Excluido do Pefin"].

OUTPUT TO "C:\Temp\es_titulo_cr.csv".

PUT "EMPRESA"           ";"
    "ESTAB"             ";"
    "EMPRESA"           ";"
    "SERIE"             ";"
    "TITULO"            ";"
    "PARCELA"           ";"
    "Situacao Pefin"    ";"
    "Tem pefin?         "SKIP.

FOR EACH es-titulo-cr NO-LOCK:
    
    PUT es-titulo-cr.ep-codigo                                                                  ";"
        es-titulo-cr.cod-estabel                                                                ";"
        es-titulo-cr.cod-esp                                                                    ";"
        "'" + es-titulo-cr.serie                                                                ";"
        "'" + es-titulo-cr.nr-docto                                                             ";"
        "'" + es-titulo-cr.parcela                                                              ";"
        IF es-titulo-cr.situacao-pefin = 0 THEN "" ELSE c-situacao[es-titulo-cr.situacao-pefin] ";"
        es-titulo-cr.tem-pefin                                                                  SKIP.

END.

OUTPUT CLOSE.
