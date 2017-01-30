FIND FIRST tit_ap WHERE tit_ap.cod_estab       = "19"
                    AND tit_ap.cod_espec_docto = "FE"
                    AND tit_ap.cod_ser_docto   = "ANTT"
                    AND tit_ap.cod_tit_ap      = "620491"
                    AND tit_ap.cod_parcela     = "03"
                    NO-ERROR.

FOR EACH movto_tit_ap OF tit_ap:

    /*DISP movto_tit_ap WITH WIDTH 300.*/
END.

ASSIGN tit_ap.cod_ser_docto   = "ANT".
DISP tit_ap.cod_ser_docto FORMAT "X(10)".
