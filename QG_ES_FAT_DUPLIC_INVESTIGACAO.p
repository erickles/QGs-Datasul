DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
{prgesp\include\i-tt-ad490.i tt-titulo} /* Temp-Table titulo     */
DEFINE BUFFER btitulo FOR titulo.

OUTPUT TO "c:\fat_duplic.csv".

PUT "CLIENTE;"
    "NR FATURA;"
    "ESTABELEC;"
    "SERIE;"
    "PARCELA"
    SKIP.

FOR EACH es-fat-duplic WHERE /*es-fat-duplic.data-geracao >= 08/15/2014
                        AND es-fat-duplic.data-geracao <= 08/15/2014*/
                        AND es-fat-duplic.u-log-1      = NO
                        NO-LOCK:
    iCont = iCont + 1.
    FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis = es-fat-duplic.nr-fatura
                             AND nota-fiscal.cod-estabel = es-fat-duplic.cod-estabel
                             AND nota-fiscal.serie       = es-fat-duplic.serie 
                             AND nota-fiscal.dt-cancel   = ? 
                             NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        FIND FIRST emitente OF nota-fiscal NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:
            PUT emitente.cod-emitente       ";"
                es-fat-duplic.nr-fatura     ";"
                es-fat-duplic.cod-estabel   ";"
                es-fat-duplic.serie         ";"
                es-fat-duplic.parcela       SKIP.
        END.
    END.
END.

/*
FOR EACH es-fat-duplic WHERE es-fat-duplic.data-geracao >= 09/03/2014
                        AND es-fat-duplic.data-geracao <= 09/03/2014
                        AND es-fat-duplic.u-log-1      = NO
                        NO-LOCK: /*,
        FIRST titulo NO-LOCK
        WHERE titulo.ep-codigo   = 1
          AND titulo.nr-docto    = es-fat-duplic.nr-fatura
          AND titulo.cod-estabel = es-fat-duplic.cod-estabel
          AND titulo.serie       = es-fat-duplic.serie
          AND titulo.parcela     = es-fat-duplic.parcela:*/
        /*,
        FIRST btitulo NO-LOCK
        WHERE btitulo.ep-codigo    = 1
          AND btitulo.nr-docto     = titulo.nr-docto
          AND btitulo.cod-estabel  = titulo.cod-estabel
          AND btitulo.serie        = titulo.serie
          AND btitulo.parcela      = titulo.parcela
          AND btitulo.vl-saldo     = titulo.vl-original
          AND btitulo.dt-vencimen >= TODAY:*/

    PUT es-fat-duplic.nr-fatura     ";"
        es-fat-duplic.cod-estabel   ";"
        es-fat-duplic.serie         ";"
        es-fat-duplic.parcela       SKIP

    iCont = iCont + 1.
END.*/

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
/* PUT STRING(iCont). */

OUTPUT CLOSE.
