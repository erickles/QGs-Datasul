/* Alterar CST Faturamento */

FIND FIRST it-nota-fisc WHERE it-nota-fisc.nr-nota-fis = "0404325"
                          AND it-nota-fisc.cod-estabel = "19"
                          AND it-nota-fisc.serie       = "4"
                          AND it-nota-fisc.it-codigo   = "40084110"
                          AND it-nota-fisc.nr-seq-fat  = 10.

DISP it-nota-fisc.nr-nota-fis               LABEL "Nr Nota"
     it-nota-fisc.cod-estabel               LABEL "Estabelecimento"
     it-nota-fisc.serie
     it-nota-fisc.it-codigo
     it-nota-fisc.nr-seq-fat
     cod-sit-tributar-pis       LABEL "CST"
     cod-sit-tributar-cofins    LABEL "CST"
     WITH 1 COL.


ASSIGN cod-sit-tributar-pis    = '09'.
ASSIGN cod-sit-tributar-cofins = '09'.

