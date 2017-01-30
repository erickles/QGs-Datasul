{include/i-freeac.i}

OUTPUT TO "C:\Temp\it-registro.csv".

PUT "cod-emissor"     ";"
    "cod-emitente-ex" ";"
    "cod-resp-tec"    ";"
    "dt-emissao"      ";"
    "dt-validade"     ";"
    "historico"       ";"
    "it-codigo"       ";"
    "justificativa"   ";"
    "observacao"      ";"
    "pais"            ";"
    "reg-codigo"      ";"
    "situacao"        ";"
    "tipo-registro"   SKIP.

FOR EACH it-registro NO-LOCK:

    PUT UNFORM it-registro.cod-emissor                                          ";"
                it-registro.cod-emitente-ex                                     ";"
                it-registro.cod-resp-tec                                        ";"
                it-registro.dt-emissao                                          ";"
                it-registro.dt-validade                                         ";"
                REPLACE(fn-free-accent(it-registro.historico),CHR(10), " ")     ";"
                REPLACE(fn-free-accent(it-registro.it-codigo),CHR(10), " ")     ";"
                REPLACE(fn-free-accent(it-registro.justificativa),CHR(10), " ") ";"
                REPLACE(fn-free-accent(it-registro.observacao),CHR(10), " ")    ";"
                REPLACE(fn-free-accent(it-registro.pais),CHR(10), " ")          ";"
                REPLACE(fn-free-accent(it-registro.reg-codigo),CHR(10), " ")    ";"
                it-registro.situacao                                            ";"
                it-registro.tipo-registro                                       SKIP.

END.

OUTPUT CLOSE.
