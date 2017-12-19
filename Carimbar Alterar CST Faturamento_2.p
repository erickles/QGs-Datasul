/* Alterar CST Faturamento */

FIND FIRST it-nota-fisc WHERE it-nota-fisc.nr-nota-fis = "0076204"
                          AND it-nota-fisc.cod-estabel = "26"
                          AND it-nota-fisc.serie       = "3"
                          AND it-nota-fisc.it-codigo   = "59217789"
                          AND it-nota-fisc.nr-seq-fat  = 10.

DISP it-nota-fisc.nr-nota-fis               LABEL "Nr Nota"
     it-nota-fisc.cod-estabel               LABEL "Estabelecimento"
     it-nota-fisc.serie
     it-nota-fisc.it-codigo
     it-nota-fisc.nr-seq-fat
     cod-sit-tributar-pis       LABEL "CST"
     cod-sit-tributar-cofins    LABEL "CST"
     WITH 1 COL.


ASSIGN cod-sit-tributar-pis    = '06'.
ASSIGN cod-sit-tributar-cofins = '06'.

