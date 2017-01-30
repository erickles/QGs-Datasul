{include/i-buffer.i}
{cdp/cdcfgdis.i}
{utp/ut-glob.i}

DEFINE VARIABLE v_nr_nota  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v_dt_nota  AS CHARACTER   NO-UNDO FORMAT "x(10)".
DEFINE VARIABLE c-ped-aux  AS CHARACTER   NO-UNDO.

DEFINE BUFFER b-ws-p-venda  FOR ws-p-venda.
DEFINE BUFFER b-nota-fiscal FOR nota-fiscal.

FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis  = "0053643"
                         AND nota-fiscal.cod-estabel  = "26"
                         AND nota-fiscal.serie        = "3"
                         NO-LOCK NO-ERROR.

IF AVAIL nota-fiscal THEN DO:

    FIND ws-p-venda WHERE ws-p-venda.nr-pedcli = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.
    IF NOT AVAIL ws-p-venda THEN NEXT.
    
    FIND FIRST es-tipo-operacao WHERE es-tipo-operacao.cod-tipo-oper = ws-p-venda.cod-tipo-oper NO-LOCK NO-ERROR.
    IF NOT AVAIL es-tipo-operacao THEN NEXT.
            
    /* Verifica se Operacao e de venda entrega futura / Remessa */
    IF (SUBSTRING(es-tipo-operacao.char-1,1,1) = "S" AND es-tipo-operacao.cod-oper-rem > 0) OR SUBSTRING(es-tipo-operacao.char-1,2,1) = "S" THEN.
    ELSE NEXT.
    
    FIND FIRST param-of    NO-LOCK NO-ERROR.
    FIND FIRST param-estoq NO-LOCK NO-ERROR.

    /* Se ja contabilizado nao permite que zere valores */
    /*IF param-estoq.contab-ate >= nota-fiscal.dt-emis THEN NEXT.*/

    FOR EACH doc-fiscal WHERE doc-fiscal.cod-estabel = nota-fiscal.cod-estabel
                          AND doc-fiscal.serie        = nota-fiscal.serie
                          AND doc-fiscal.nr-doc-fis   = nota-fiscal.nr-nota-fis
                          AND doc-fiscal.cod-emitente = nota-fiscal.cod-emitente
                          NO-LOCK:
        
        /* Se remessa entrega futura - localiza nota mae */
        IF SUBSTRING(es-tipo-operacao.char-1,2,1) = "S" THEN DO:
            
            RELEASE b-nota-fiscal.

            c-ped-aux = "".

            /* Verifica se tem Pedido Mae, Desmembramentos ou Remessa Automatica */
            IF ws-p-venda.nr-pedrep <> ""                   AND 
               ws-p-venda.nr-pedcli <> ws-p-venda.nr-pedrep THEN DO:
    
                IF ws-p-venda.cod-tipo-oper = 9 OR ws-p-venda.cod-tipo-oper = 130 OR 
                   ws-p-venda.cod-tipo-oper = 5 OR ws-p-venda.cod-tipo-oper = 10  THEN DO:
    
                    RUN piPedidoMae (INPUT  ws-p-venda.nr-pedrep,
                                     INPUT  "",
                                     OUTPUT c-ped-aux).
                END.
                ELSE DO:
                    RUN piPedidoMae (INPUT  ws-p-venda.nr-pedrep,
                                     INPUT  ws-p-venda.nome-abrev,
                                     OUTPUT c-ped-aux).
                END.
            END.

            MESSAGE c-ped-aux
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

            IF c-ped-aux = "" THEN DO:
                IF INDEX(c-ped-aux,"/") > 0 THEN DO:
                    FIND b-ws-p-venda NO-LOCK WHERE b-ws-p-venda.nr-pedcli = SUBSTRING(c-ped-aux,1,R-INDEX(c-ped-aux,"/") - 1) NO-ERROR.
                    IF AVAIL b-ws-p-venda THEN DO:
                        IF  (ws-p-venda.cod-tipo-oper = 10  AND b-ws-p-venda.cod-tipo-oper = 5)   OR 
                            (ws-p-venda.cod-tipo-oper = 9   AND b-ws-p-venda.cod-tipo-oper = 3)   OR 
                            (ws-p-venda.cod-tipo-oper = 8   AND b-ws-p-venda.cod-tipo-oper = 2)   OR 
                            (ws-p-venda.cod-tipo-oper = 119 AND b-ws-p-venda.cod-tipo-oper = 118) OR
                            (ws-p-venda.cod-tipo-oper = 130 AND b-ws-p-venda.cod-tipo-oper = 129) THEN
                            c-ped-aux = b-ws-p-venda.nr-pedcli.                                 
                    END.  
                END.
            END.
             
            IF c-ped-aux <> "" AND c-ped-aux <> ws-p-venda.nr-pedcli THEN DO:
    
                FIND b-ws-p-venda WHERE b-ws-p-venda.nr-pedcli = c-ped-aux NO-LOCK NO-ERROR.   
                IF AVAIL b-ws-p-venda THEN DO:
    
                    ASSIGN v_nr_nota = ""
                           v_dt_nota = "".
    
                    FIND FIRST b-nota-fiscal WHERE b-nota-fiscal.nome-ab-cli = b-ws-p-venda.nome-abrev
                                               AND b-nota-fiscal.nr-pedcli   = b-ws-p-venda.nr-pedcli
                                               AND b-nota-fiscal.dt-cancel   = ? NO-LOCK NO-ERROR.
    
                    IF AVAIL b-nota-fiscal THEN DO:
                        ASSIGN v_nr_nota = b-nota-fiscal.nr-nota-fis
                               v_dt_nota = STRING(b-nota-fiscal.dt-emis,"99/99/9999").
                    END.
                END.
            END.
        END.

        /* Tratamento da observacao para faturamento de entrega futura */
        IF SUBSTRING(es-tipo-operacao.char-1,1,1) = "S" THEN DO:
            
            /* Verifica se eh uma nota de venda ou remessa quando operacao Triangular  */
            FOR EACH it-doc-fisc OF doc-fiscal EXCLUSIVE-LOCK:
            
                &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
                
                    &IF "{&bf_dis_versao_ems}" < "2.07" &THEN 
                        IF AVAIL param-of AND SUBSTRING(param-of.char-1,102,1) = "0" THEN 
                    &ELSE
                        IF AVAIL param-of AND NOT param-of.log-escrit-nf-remes-operac-trian THEN 
                    &ENDIF                                                                                        
        
                    /* Para os estabelecimentos 05 e 09, escritura o valor contabil */
                    /*
                    ASSIGN it-doc-fisc.vl-tot-item  = IF (nota-fiscal.cod-estabel = "05" AND nota-fiscal.cod-estabel = "09") THEN it-doc-fisc.vl-tot-item ELSE 0
                           it-doc-fisc.vl-icmsnt-it = 0
                           it-doc-fisc.vl-icmsou-it = 0
                           it-doc-fisc.vl-ipint-it  = 0
                           it-doc-fisc.vl-ipiou-it  = 0.
                    */
                    /*
                    MESSAGE "1"                                                                                                                     SKIP
                            IF (nota-fiscal.cod-estabel = "05" AND nota-fiscal.cod-estabel = "09") THEN STRING(it-doc-fisc.vl-tot-item) ELSE "0"    SKIP
                            "it-doc-fisc.vl-tot-item "  + STRING(it-doc-fisc.vl-tot-item)                                                           SKIP
                            "it-doc-fisc.vl-icmsnt-it " + STRING(it-doc-fisc.vl-icmsnt-it)                                                          SKIP
                            "it-doc-fisc.vl-icmsou-it " + STRING(it-doc-fisc.vl-icmsou-it)                                                          SKIP
                            "it-doc-fisc.vl-ipint-it "  + STRING(it-doc-fisc.vl-ipint-it)                                                           SKIP
                            "it-doc-fisc.vl-ipiou-it "  + STRING(it-doc-fisc.vl-ipiou-it)
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    */

                    MESSAGE IF (nota-fiscal.cod-estabel = "05" AND nota-fiscal.cod-estabel = "09") THEN it-doc-fisc.vl-tot-item ELSE 0 SKIP
                            0    SKIP
                            0   SKIP
                            0   SKIP
                            0
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.

                    IF (nota-fiscal.cod-estabel = "05" OR nota-fiscal.cod-estabel = "09") AND it-doc-fisc.vl-tot-item = 0 THEN DO:
        
                        FIND FIRST it-nota-fisc WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
                                                  AND it-nota-fisc.it-codigo   = it-doc-fisc.it-codigo
                                                  AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis
                                                  AND it-nota-fisc.serie       = nota-fiscal.serie
                                                  NO-LOCK NO-ERROR.
        
                        /* ASSIGN it-doc-fisc.vl-tot-item = IF AVAIL it-nota-fisc THEN it-nota-fisc.vl-tot-item ELSE 0. */
    
                        MESSAGE "2"
                                IF AVAIL it-nota-fisc THEN STRING(it-nota-fisc.vl-tot-item) ELSE "0"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
                    END.
    
                &ENDIF
    
                /*** Icms Substituto ***/
                ASSIGN it-doc-fisc.vl-bsubs-it  = 0
                       it-doc-fisc.vl-icmsub-it = 0.

                MESSAGE "Zera o ICMS substituto"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.

            /*
            ASSIGN doc-fiscal.observacao  = "SIMPLES     FATURAMENTO"
                   doc-fiscal.vl-cont-doc = IF (nota-fiscal.cod-estabel = "05" OR nota-fiscal.cod-estabel = "09") THEN doc-fiscal.vl-cont-doc ELSE 0
                   doc-fiscal.vl-icmsnt   = 0
                   doc-fiscal.vl-icmsou   = 0
                   doc-fiscal.vl-ipint    = 0
                   doc-fiscal.vl-ipiou    = 0
                   doc-fiscal.vl-bsubs    = 0
                   doc-fiscal.vl-icmsub   = 0.
            */
            MESSAGE "Coloca na observacao: SIMPLES     FATURAMENTO"   SKIP
                    IF (nota-fiscal.cod-estabel = "05" OR nota-fiscal.cod-estabel = "09") THEN "Mantem valor contabil" ELSE "Zera valor contabil"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
        END.
        ELSE
            IF SUBSTRING(es-tipo-operacao.char-1,2,1) = "S" AND AVAIL b-nota-fiscal THEN DO:
                /* REMESSA */
                /* SD 4999 - Na remessa, nao aparece o valor contabil para 05 e 09 */
                /*
                ASSIGN doc-fiscal.observacao   = "Material Faturado Pela NF No. " + v_nr_nota + " de " + v_dt_nota
                       doc-fiscal.vl-cont-doc  = IF (nota-fiscal.cod-estabel = "05" OR nota-fiscal.cod-estabel = "09") THEN 0 ELSE doc-fiscal.vl-cont-doc.
                */
                MESSAGE "Material Faturado Pela NF No. " + STRING(v_nr_nota) + " de " + STRING(v_dt_nota)   SKIP
                        IF (nota-fiscal.cod-estabel = "05" OR nota-fiscal.cod-estabel = "09") THEN "0" ELSE STRING(doc-fiscal.vl-cont-doc)
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
    END.
END.

PROCEDURE piPedidoMae:

    DEFINE INPUT  PARAMETER pcNrPedRep   AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcNomeAbrev  AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER pcNrPedMae   AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE pcNrPedRepAux        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE pdtImplantAux        AS DATETIME    NO-UNDO.
    
    DEFINE BUFFER b-ws-p-venda   FOR ws-p-venda.
    DEFINE BUFFER b-ped-venda    FOR ped-venda.
    DEFINE BUFFER b-es-tipo-oper FOR es-tipo-operacao.
    
    IF pcNomeAbrev = "" THEN
       FOR FIRST b-ws-p-venda FIELDS(nome-abrev nr-pedcli cod-tipo-oper nr-pedrep dt-implant) 
           WHERE b-ws-p-venda.nr-pedcli  = pcNrPedrep  NO-LOCK.
       END.
    ELSE 
       FOR FIRST b-ws-p-venda FIELDS(nome-abrev nr-pedcli cod-tipo-oper nr-pedrep dt-implant) 
           WHERE b-ws-p-venda.nr-pedcli  = pcNrPedrep 
             AND b-ws-p-venda.nome-abrev = pcNomeAbrev NO-LOCK.
       END.

    IF NOT AVAIL b-ws-p-venda THEN DO:
       ASSIGN pcNrPedMae = "".
       RETURN "OK":U.
    END.

    FIND FIRST b-es-tipo-oper WHERE b-es-tipo-oper.cod-tipo-oper = b-ws-p-venda.cod-tipo-oper NO-LOCK NO-ERROR.
    IF NOT AVAIL b-es-tipo-oper THEN DO:
       ASSIGN pcNrPedMae = "".
              RETURN "OK":U.
    END.

    /* Se nao E Operacao de Remessa Desconsidera */
    IF SUBSTRING(es-tipo-operacao.char-1,2,1) <> "S" THEN DO:
       ASSIGN pcNrPedMae = "".
       RETURN "OK":U.
    END.
    
    FIND b-ped-venda WHERE b-ped-venda.nome-abrev = b-ws-p-venda.nome-abrev 
                       AND b-ped-venda.nr-pedcli  = b-ws-p-venda.nr-pedcli  NO-LOCK NO-ERROR.
    IF NOT AVAIL b-ped-venda THEN DO:
       ASSIGN pcNrPedMae = "".
       RETURN "OK":U.
    END.
    
    FIND natur-oper WHERE natur-oper.nat-operacao = b-ped-venda.nat-operacao NO-LOCK NO-ERROR.
    IF NOT AVAIL natur-oper THEN DO:
       ASSIGN pcNrPedMae = "".
       RETURN "OK":U.
    END.

    ASSIGN pcNrPedMae = b-ws-p-venda.nr-pedcli.
    
    /* Verifica pedido Mae principal, caso o pedido seja desmembrado mais vezes,
       Se pedido emite duplicata significa que ja e a venda, logo nao procura pedido mae */
    IF b-ws-p-venda.nr-pedrep <> "" AND b-ws-p-venda.nr-pedrep <> b-ws-p-venda.nr-pedcli AND
       natur-oper.emite-duplic = FALSE THEN DO:
       RUN piPedidoMae (INPUT  b-ws-p-venda.nr-pedrep,
                        INPUT  pcNomeAbrev, 
                        OUTPUT pcNrPedRepAux).
       IF pcNrPedRepAux <> "" THEN 
          ASSIGN pcNrPedMae = pcNrPedRepAux.   
    END.

    RETURN "OK":U.

END PROCEDURE.
