FIND es-titulo-cr WHERE es-titulo-cr.ep-codigo   = 1
                    AND es-titulo-cr.cod-estabel = "12"
                    AND es-titulo-cr.cod-esp     = "DP"
                    AND es-titulo-cr.serie       = "4"
                    AND es-titulo-cr.nr-docto    = "0037480"
                    AND es-titulo-cr.parcela     = "01" NO-ERROR.
IF AVAIL es-titulo-cr THEN DO:
    UPDATE es-titulo-cr.situacao-pefin.
END.
