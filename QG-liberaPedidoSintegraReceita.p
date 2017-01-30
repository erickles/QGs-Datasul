      
DEFINE VARIABLE h-acomp         AS HANDLE      NO-UNDO.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp  NO-ERROR.
RUN pi-inicializar        IN h-acomp(INPUT "Acompanhamento") NO-ERROR.

/*
1229-1451    09  5111II           4.264,97
1472-2713    09  5121EI           6.934,46
495-1686     09  5111II           1.837,92
2477-1179    09  5111II           4.625,48
1229-1487    09  5111II           1.302,67
1817-0998    19  6111AR           2.762,44
2020-1003    19  6111AR           4.232,64
2020-1004    19  6111AR           2.420,58
1811-703     19  6111AR          16.968,15
3219-004     19  5111II           3.811,18
*/

FOR EACH ws-p-venda 
   WHERE ws-p-venda.ind-sit-ped = 14 /*nr-pedcli = "MFT174/11GO154/11"*/
   /*ws-p-venda.ind-sit-ped = 15*/
     /*AND ws-p-venda.ind-sit-ped <= 16 */:
       
   RUN pi-acompanhar  IN h-acomp (INPUT ws-p-venda.nr-pedcli)   NO-ERROR.

    /*

    ASSIGN OVERLAY(ws-p-venda.char-1,304,2)  = ""
               OVERLAY(ws-p-venda.Char-1,322,10) = ""
               OVERLAY(ws-p-venda.Char-1,332,16) = "".
       
       ASSIGN OVERLAY(ws-p-venda.char-1,307,2)  = ""
              OVERLAY(ws-p-venda.Char-1,348,10) = ""
              OVERLAY(ws-p-venda.Char-1,358,16) = "".

       */
       
       ASSIGN OVERLAY(ws-p-venda.char-1,304,2)  = "OK"
               OVERLAY(ws-p-venda.Char-1,322,10) = STRING(TODAY,"99/99/9999")
               OVERLAY(ws-p-venda.Char-1,332,16) = "SISTEMA".
       
       ASSIGN OVERLAY(ws-p-venda.char-1,307,2)  = "OK"
              OVERLAY(ws-p-venda.Char-1,348,10) = STRING(TODAY,"99/99/9999")
              OVERLAY(ws-p-venda.Char-1,358,16) = "SISTEMA".
         
END.

RUN pi-finalizar   IN h-acomp              NO-ERROR.
