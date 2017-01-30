OUTPUT TO "C:\Temp\EmailSendingReport052016.csv".

PUT "FROM"          ";"
    "TO"            ";"
    "DT INCLUSAO"   ";"
    "HR INCLUSAO"   ";"
    "DT ENVIO"      ";"
    "HR ENVIO"      ";"
    "ASSUNTO"       ";"
    "TIME SENT"     SKIP.

FOR EACH es-envia-email WHERE es-envia-email.dt-incl >= 05/01/2016
                          AND es-envia-email.dt-incl <= 05/31/2016 
                          NO-LOCK:

    PUT es-envia-email.de       ";"
        es-envia-email.para     ";"
        es-envia-email.dt-incl  ";"
        es-envia-email.hr-incl  ";"
        es-envia-email.dt-env   ";"
        es-envia-email.hr-env   ";"
        es-envia-email.assunto  SKIP.

END.

OUTPUT CLOSE.
