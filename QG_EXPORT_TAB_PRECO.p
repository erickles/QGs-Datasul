OUTPUT TO C:\TAB_PRECO.TXT.
FOR EACH tb-preco WHERE tb-preco.nr-tabpre = "" NO-LOCK:
    EXPORT tb-preco.
END.

OUTPUT CLOSE.
