DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

FOR EACH es-fat-duplic WHERE es-fat-duplic.data-geracao >= 08/23/2011
                         AND es-fat-duplic.u-log-1      = NO NO-LOCK:
        
    /*DISP es-fat-duplic.cod-estabel es-fat-duplic.nr-fatura es-fat-duplic.parcela es-fat-duplic.serie es-fat-duplic.titulo-banco.*/

    iCont = iCont + 1.    
        
END.

DISP iCont.
