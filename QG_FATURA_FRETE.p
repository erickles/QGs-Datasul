DEFINE VARIABLE cFatura AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cEstab  AS CHARACTER   NO-UNDO.

UPDATE cFatura  LABEL "Fatura"
       cEstab   LABEL "Estabelecimento".

DISABLE TRIGGERS FOR LOAD OF movtrp.fatura-frete.
FOR EACH movtrp.fatura-frete WHERE nr-fatura = cFatura AND cod-estabel = cEstab
                              AND dt-criacao > 04/01/2013:

    DISP cgc-transp cod-estabel dt-criacao serie vl-fatura WITH WIDTH 300 1 COL.
    UPDATE dt-integr-ap hr-integr-ap user-integr-ap.
END.
