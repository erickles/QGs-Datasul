DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE VARIABLE lValido AS LOGICAL     NO-UNDO INITIAL NO.
OUTPUT TO "C:\ultimos_pedidos.csv".

PUT "Cod. Rep;"
    "Nr. Ped.;"
    "Nr. Ped. Param;"
    "Dt. Implant" SKIP.

FOR EACH repres NO-LOCK,
    EACH es-repres-comis WHERE es-repres-comis.cod-rep = repres.cod-rep
                           AND es-repres-comis.situacao = 1 NO-LOCK:
    iCont = 1.
    FOR EACH ws-p-venda WHERE ws-p-venda.no-ab-reppri = repres.nome-abrev
                          AND SUBSTRING(ws-p-venda.char-2,25,1) <> "S"
                          AND ws-p-venda.cod-tipo-oper = 1
                          AND ws-p-venda.dt-implant > 07/01/2009
                          AND ws-p-venda.nr-pedcli BEGINS STRING(repres.cod-rep) + "-"
                          NO-LOCK BREAK BY ws-p-venda.dt-implant
                                        BY ws-p-venda.hr-implant:

        DO iCont = 1 TO LENGTH(ws-p-venda.nr-pedcli):

            IF NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "a" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "b" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "c" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "d" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "e" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "f" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "g" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "h" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "i" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "j" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "k" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "l" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "m" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "n" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "o" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "p" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "q" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "r" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "s" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "t" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "u" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "v" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "w" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "X" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "Y" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "z" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "A" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "B" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "C" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "D" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "E" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "F" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "G" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "H" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "I" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "J" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "K" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "L" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "M" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "N" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "O" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "P" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "Q" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "R" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "S" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "T" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "U" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "V" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "W" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "X" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "Y" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "Z" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "/" AND
               NOT SUBSTR(ws-p-venda.nr-pedcli,iCont,1) = "\" THEN DO:

                IF iCont = LENGTH(ws-p-venda.nr-pedcli) THEN DO:
                    FIND FIRST pm-rep-param WHERE pm-rep-param.cod_rep = repres.cod-rep NO-LOCK NO-ERROR.
                    IF AVAIL pm-rep-param THEN DO:
                        IF INTE(REPLACE(ws-p-venda.nr-pedcli,STRING(repres.cod-rep) + "-","")) > INTE(REPLACE(pm-rep-param.nr_ultimo_pedido,STRING(repres.cod-rep) + "-","")) THEN
                            PUT repres.cod-rep                  ";"
                                ws-p-venda.nr-pedcli            ";"
                                pm-rep-param.nr_ultimo_pedido   ";"
                                ws-p-venda.dt-implant           ";"
                                SKIP.
                            LEAVE.
                    END.                    
                END.
            END.
            ELSE DO:
                LEAVE.
            END.
        END.
    END.
END.

OUTPUT CLOSE.
