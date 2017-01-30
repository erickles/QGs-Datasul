OUTPUT TO "c:\repres_mitsui.txt".

FOR EACH es-repres-comis WHERE  es-repres-comis.u-int-1 = 4.
    FIND FIRST usuar_mestre WHERE INTE(usuar_mestre.char-1) = es-repres-comis.cod-rep NO-ERROR.
    IF AVAIL usuar_mestre THEN DO:

        ASSIGN usuar_mestre.cod_e_mail_local = REPLACE(usuar_mestre.cod_e_mail_local,"tortuba","mitsuisal").

        PUT es-repres-comis.cod-rep  "  "       
            usuar_mestre.cod_e_mail_local
            SKIP.
    END.
END.
OUTPUT CLOSE.
