
OUTPUT TO "C:\Temp\cond_geral.csv".

PUT UNFORM "assunto"   ";"
           "de"        ";"
           "dt-env"    ";"
           "hr-env"    ";"
           "para"      SKIP.

FOR EACH es-envia-email WHERE (es-envia-email.chave-acesso  = "11793" OR es-envia-email.chave-acesso  = "14488")
                          AND es-envia-email.codigo-acesso = "COND_VENDAS"
                          NO-LOCK:

    PUT UNFORM es-envia-email.assunto   ";"
               es-envia-email.de        ";"
               es-envia-email.dt-env    ";"
               es-envia-email.hr-env    ";"
               es-envia-email.para      SKIP.
END.

OUTPUT CLOSE.
