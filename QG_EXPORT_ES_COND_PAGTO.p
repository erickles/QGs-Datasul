OUTPUT TO C:\temp\es_cond_pagto.txt.
FOR EACH es-cond-pagto WHERE es-cond-pagto.cod-cond-pag >= 500
                         AND es-cond-pagto.cod-cond-pag <= 534
                         AND es-cond-pagto.cod-cond-pag <> 527
                         AND es-cond-pagto.cod-cond-pag <> 533
                         NO-LOCK:
    EXPORT es-cond-pagto.
END.
OUTPUT CLOSE.
