DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

OUTPUT TO "C:\Temp\movtos_cta_corren.csv".

PUT "VALOR MOVTO; TP TRANS CX" SKIP.

FOR EACH movto_cta_corren WHERE movto_cta_corren.cod_cta_corren             = "BB MATRIZ"
                            AND YEAR(movto_cta_corren.dat_movto_cta_corren) = 2017
                            AND MONTH(movto_cta_corren.dat_movto_cta_corren) = 6
                            AND movto_cta_corren.cod_modul_dtsul = "ACR"
                            NO-LOCK:

    ASSIGN deValor = deValor + movto_cta_corren.val_movto_cta_corren
           iCont   = iCont + 1.
    /*
    DISP movto_cta_corren WITH WIDTH 300 1 COL.
    LEAVE.
    */

    PUT movto_cta_corren.val_movto_cta_corren ";"
        cod_tip_trans_cx                      SKIP.

END.

OUTPUT CLOSE.
