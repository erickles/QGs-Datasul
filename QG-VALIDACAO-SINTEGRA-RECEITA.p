DEFINE VARIABLE c-nr-pedcli AS CHARACTER   NO-UNDO FORMAT "X(10)".

UPDATE c-nr-pedcli LABEL "Numero do Pedido".

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = c-nr-pedcli NO-LOCK NO-ERROR.
IF AVAIL ws-p-venda THEN DO:
    FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
    FIND LAST movto-sintegra WHERE movto-sintegra.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
    IF AVAIL movto-sintegra THEN DO:

        IF (movto-sintegra.situacao BEGINS "Nao Habi"                   OR
            movto-sintegra.situacao BEGINS "N∆o Habi"                   OR
            movto-sintegra.situacao BEGINS "Baixad"                     OR
            movto-sintegra.situacao BEGINS "Suspen"                     OR
            movto-sintegra.situacao BEGINS "Cancel"                     OR
            movto-sintegra.situacao BEGINS "inscriá∆o n∆o encontrada"   OR
            movto-sintegra.situacao BEGINS "habilitado com restriá∆o"   OR
            movto-sintegra.situacao BEGINS "habilitado com restricao"   OR
            movto-sintegra.situacao BEGINS "habilitado com restriá‰es"  OR
            movto-sintegra.situacao BEGINS "habilitado com restricoes"  OR
            movto-sintegra.situacao =      "Pendente"                   OR
            movto-sintegra.situacao BEGINS "inativ"                     OR
            movto-sintegra.situacao BEGINS "inscriá∆o n∆o encontrada"   OR
            movto-sintegra.situacao BEGINS "inscricao nao encontrada"   OR
            movto-sintegra.situacao =      "inapta"                     OR
            movto-sintegra.situacao =      "retorno desconhecido"       OR
            TRIM(movto-sintegra.situacao) =      ""                     OR
            movto-sintegra.situacao =      ?                            )      THEN
            
        MESSAGE movto-sintegra.situacao
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

    END.

END.


    

