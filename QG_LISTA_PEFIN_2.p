DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-situacao        AS CHARACTER   NO-UNDO EXTENT 6 INIT ["Marcado para Inclusao","Enviado para Inclusao","Incluido no Pefin","Marcado para Exclusao","Enviado para Exclusao","Excluido do Pefin"].

DEFINE BUFFER bf-es-titulo-cr FOR es-titulo-cr.

OUTPUT TO "C:\Temp\es_titulo_cr.csv".

PUT "EMPRESA"           ";"
    "ESTAB"             ";"
    "EMPRESA"           ";"
    "SERIE"             ";"
    "TITULO"            ";"
    "PARCELA"           ";"
    "Situacao Pefin"    ";"
    "Titulo no pefin?"  ";"
    "Cliente no Pefin"  SKIP.

FOR EACH es-titulo-cr NO-LOCK:
    
    FIND FIRST es-emitente-dis WHERE es-emitente-dis.cod-emitente = es-titulo-cr.cod-emitente NO-LOCK NO-ERROR.
    
    FIND FIRST bf-es-titulo-cr WHERE bf-es-titulo-cr.ep-codigo  = es-titulo-cr.ep-codigo
                                 AND bf-es-titulo-cr.cod-esp    = es-titulo-cr.cod-esp
                                 AND es-titulo-cr.tem-pefin
                                 AND (bf-es-titulo-cr.serie <> es-titulo-cr.serie       OR 
                                      bf-es-titulo-cr.nr-docto <> es-titulo-cr.nr-docto OR
                                      bf-es-titulo-cr.parcela <> es-titulo-cr.parcela)
                                 NO-LOCK NO-ERROR.

    PUT UNFORM es-titulo-cr.ep-codigo                                                                  ";"
               es-titulo-cr.cod-estabel                                                                ";"
               es-titulo-cr.cod-esp                                                                    ";"
               "'" + es-titulo-cr.serie                                                                ";"
               "'" + es-titulo-cr.nr-docto                                                             ";"
               "'" + es-titulo-cr.parcela                                                              ";"
               IF es-titulo-cr.situacao-pefin = 0 THEN "" ELSE c-situacao[es-titulo-cr.situacao-pefin] ";"
               es-titulo-cr.tem-pefin FORMAT "Sim/Nao"                                                 ";"
               es-emitente-dis.log-pefin   FORMAT "Sim/Nao"                                            SKIP.

END.

OUTPUT CLOSE.
