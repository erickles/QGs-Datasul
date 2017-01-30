DEFINE VARIABLE l-termo-cond-esp    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-tem-desc          AS LOGICAL     NO-UNDO.
DEFINE BUFFER b-ws-p-venda FOR ws-p-venda.

ASSIGN l-termo-cond-esp = NO.

FIND FIRST ws-p-venda WHERE nr-pedcli = "1457w0088" NO-LOCK NO-ERROR.
FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = 1457 NO-LOCK NO-ERROR.

FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
    FOR EACH ws-p-desc OF ws-p-item NO-LOCK:
       IF ws-p-desc.desc-aplicado = ws-p-desc.desc-sugerido THEN DO:
           FIND es-regra-desc WHERE es-regra-desc.seq-matriz       = ws-p-desc.seq-matriz AND
                                    es-regra-desc.cod-regra-comerc = ws-p-desc.cod-regra-comerc NO-LOCK NO-ERROR.
           IF AVAIL es-regra-desc THEN DO:
               IF es-regra-desc.comis-venda = 2 THEN DO: /*se neste item pode-se praticar desconto que reduz comiss o*/
                   ASSIGN l-tem-desc = YES.
               END.
           END.
       END.
    END.
END.

FIND FIRST es-cond-esp WHERE es-cond-esp.cod-cond-esp = ws-p-venda.int-1 NO-LOCK NO-ERROR.
IF AVAIL es-cond-esp AND LOOKUP(es-repres-comis.u-char-2,"PROMOTOR,GERENTE,SUPERVISOR") = 0 THEN
    IF es-cond-esp.log-1 THEN
        ASSIGN l-termo-cond-esp = YES.
    MESSAGE es-cond-esp.log-1
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
/*SD 1784/08 - Verifica se a condiªío VV tem o flag Termo Reduªío de Comissío habilitado*/
IF ws-p-venda.int-1 <> 0 THEN DO:
    IF l-tem-desc = NO                         AND 
       SUBSTRING(ws-p-venda.char-1,2,1) = "S"  AND 
       NOT l-termo-cond-esp                    THEN DO:

        MESSAGE "Termo de Condicao Especial nao pode ser aceito !."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
        FIND FIRST b-ws-p-venda WHERE b-ws-p-venda.nr-pedcli  = ws-p-venda.nr-pedcli NO-ERROR.
        /*
        IF AVAIL b-ws-p-venda THEN
           ASSIGN SUBSTRING(b-ws-p-venda.char-1,2,1) = " ".
        */
    END.
END.
