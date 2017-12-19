FOR EACH es-fat-duplic WHERE es-fat-duplic.cod-estabel  = "18"
                         AND es-fat-duplic.parcela      = "01"
                         AND es-fat-duplic.serie        = "2"
                         AND es-fat-duplic.nr-fatura    = "0118754"
                         NO-LOCK:

    DISP es-fat-duplic.usuario-geracao
         es-fat-duplic.data-geracao
         es-fat-duplic.titulo-banco
         es-fat-duplic.u-log-1
         TRIM(es-fat-duplic.u-char-1) FORMAT "x(50)" WITH 1 COL.
        
END.
