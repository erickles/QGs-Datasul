{include/i-freeac.i}

DEFINE VARIABLE cBoleto AS CHARACTER   NO-UNDO.

OUTPUT TO "C:\Temp\CORREC_CLI_2.CSV".

PUT UNFORM "COD CLI"        ";"
           "NOME CLI"       ";"
           "ENDERECO"       ";"
           "ENDERECO COB"   ";"
           "PORTADOR"       ";"
           "MODALIDADE"     ";"
           "BOLETO"         ";"
           "ESTADO"         ";"
           "CIDADE"         ";"
           "IDENTIFIC"      SKIP.

FOR EACH emitente WHERE emitente.endereco <> emitente.endereco-cob 
                    AND (emitente.identific = 1 OR emitente.identific = 3)
                    AND (emitente.cod-gr-cli <> 3 AND emitente.cod-gr-cli <> 9 AND emitente.cod-gr-cli <> 92)
                    NO-LOCK:

    FIND FIRST es-loc-entr WHERE es-loc-entr.nome-abrev = emitente.nome-abrev NO-LOCK NO-ERROR.
    IF AVAIL es-loc-entr THEN
        IF es-loc-entr.boleto = 1 THEN 
            cBoleto = "ACOMPANHA NF".
        ELSE 
            cBoleto = "CORREIO".

    PUT UNFORM emitente.cod-emitente                                    ";"
               REPLACE(fn-free-accent(emitente.nome-emit),";","")       ";"
               REPLACE(fn-free-accent(emitente.endereco),";","")        ";"
               REPLACE(fn-free-accent(emitente.endereco-cob),";","")    ";"
               emitente.port-pref                                       ";"
               emitente.mod-pref                                        ";"
               cBoleto                                                  ";"
               REPLACE(fn-free-accent(emitente.estado),";","")          ";"
               REPLACE(fn-free-accent(emitente.cidade),";","")          ";"
               IF emitente.identific = 1 THEN "CLIENTE" ELSE "AMBOS"    SKIP.

END.

OUTPUT CLOSE.
