
FIND FIRST es-cond-esp WHERE es-cond-esp.cod-cond-esp = ws-p-venda.int-1 NO-LOCK NO-ERROR.
IF AVAIL es-cond-esp AND LOOKUP(es-repres-comis.u-char-2,"PROMOTOR,GERENTE,SUPERVISOR") = 0 THEN
    IF es-cond-esp.log-1 THEN
        ASSIGN l-termo-cond-esp = YES.

/*SD 1784/08 - Verifica se a condi»’o VV tem o flag Termo Redu»’o de Comiss’o habilitado*/
IF ws-p-venda.int-1 <> 0 THEN DO:
    IF l-tem-desc = NO                         AND 
       SUBSTRING(ws-p-venda.char-1,2,1) = "S"  AND 
       NOT l-termo-cond-esp                    THEN DO:

        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence     = i-nr-seq + 1
               RowErrors.ErrorNumber       = 0
               RowErrors.ErrorDescription  = "Termo de Redu»’o de Comiss’o."
               RowErrors.ErrorParameters   = ""
               RowErrors.ErrorType         = "OTHER"
               RowErrors.ErrorHelp         = "Termo de Condicao Especial n’o pode ser aceito !."
               RowErrors.ErrorSubType      = "ERROR".

        FIND FIRST b-ws-p-venda WHERE b-ws-p-venda.nr-pedcli  = ab_unmap.nrpedcli NO-ERROR.
        IF AVAIL b-ws-p-venda THEN
           ASSIGN SUBSTRING(b-ws-p-venda.char-1,2,1) = " ".

    END.
END.
