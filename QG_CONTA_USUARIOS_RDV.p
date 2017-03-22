DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

OUTPUT TO "C:\Temp\usuarios.csv".

FOR EACH es-rdv-usuario NO-LOCK BREAK BY es-rdv-usuario.cod-aprovador:
    IF FIRST-OF(es-rdv-usuario.cod-aprovador) THEN DO:    
        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = es-rdv-usuario.cod-aprovador NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre AND NOT usuar_mestre.nom_usuario BEGINS "DESAT" THEN DO:

            FIND FIRST es-rdv-aponta WHERE es-rdv-aponta.funcionario = usuar_mestre.cod_usuario 
                                       AND YEAR(es-rdv-aponta.dat-digitacao) = 2017
                                       NO-LOCK NO-ERROR.
            IF AVAIL es-rdv-aponta THEN DO:
                PUT usuar_mestre.nom_usuario SKIP.
                iCont = iCont + 1.
            END.

        END.
    END.
END.

OUTPUT CLOSE.

MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
