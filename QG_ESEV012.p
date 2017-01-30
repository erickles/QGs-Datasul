DEFINE VARIABLE dValorOrcado AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iQuantidade AS INTEGER     NO-UNDO.
DEFINE VARIABLE cData AS CHARACTER   NO-UNDO.

FOR EACH es-eventos WHERE es-eventos.unidade-vendas = "MATO GROSSO SUL" NO-LOCK:
    FOR EACH es-ev-ocorrencias WHERE es-ev-ocorrencias.ano-refer = 2012
                                 AND es-eventos.cod-evento = es-ev-ocorrencias.cod-evento:
                       
        FOR EACH es-ev-despesas WHERE es-ev-despesas.cod-evento     = es-eventos.cod-evento
                                  AND es-ev-despesas.ano-referencia = es-ev-ocorrencias.ano-refer                                  
                                  NO-LOCK BREAK BY es-ev-despesas.cod-evento
                                                BY es-ev-despesas.ano-referencia
                                                BY es-ev-despesas.seq-despesa.
            
            IF es-ev-despesas.data-emissao = ? THEN
                MESSAGE es-ev-despesas.cod-evento
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            
            cData = cData + STRING(YEAR(es-ev-despesas.data-emissao)) + ";".

            IF FIRST-OF(es-ev-despesas.cod-evento) THEN
                ASSIGN dValorOrcado = dValorOrcado + es-ev-ocorrencias.valor-orcado
                       iQuantidade = iQuantidade + 1.

        END.

    END.
END.

DISP dValorOrcado
     iQuantidade
     cData.

