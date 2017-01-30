OUTPUT TO C:\temp\cond_pagto.txt.
FOR EACH cond-pagto WHERE cond-pagto.cod-cond-pagto >= 500
                      AND cond-pagto.cod-cond-pagto <= 534
                      AND cond-pagto.cod-cond-pagto <> 527
                      AND cond-pagto.cod-cond-pagto <> 533
                      NO-LOCK:
    EXPORT cond-pagto.
END.
OUTPUT CLOSE.
