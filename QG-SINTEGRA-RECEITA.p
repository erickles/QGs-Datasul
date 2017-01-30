find first emitente where emitente.cod-emitente = 179707 no-lock no-error.
if avail emitente then do:
            
    FIND LAST movto-sintegra WHERE movto-sintegra.cod-emitente = emitente.cod-emitente       AND
                                   movto-sintegra.cnpj         = emitente.cgc
                                   NO-LOCK NO-ERROR.
        
    IF AVAIL movto-sintegra AND (movto-sintegra.situacao begins "Nao Habi"   OR
                                 movto-sintegra.situacao begins "N"          OR
                                 movto-sintegra.situacao begins "N∆o Habi"   OR
                                 movto-sintegra.situacao begins "Baixad"     OR
                                 movto-sintegra.situacao begins "Suspen"     OR
                                 movto-sintegra.situacao begins "Canc"       OR
                                 movto-sintegra.situacao begins "Pendente"   OR
                                 movto-sintegra.situacao begins "inscriá∆o n∆o encontrada") then
                    
        message "Bloqueado no Sintegra" movto-sintegra.situacao view-as alert-box.
    else do:
        message "OK Sintegra" movto-sintegra.situacao view-as alert-box.
        FIND LAST movto-receita WHERE movto-receita.cod-emitente = emitente.cod-emitente 
                                  AND movto-receita.cnpj         = emitente.cgc 
                                  NO-LOCK NO-ERROR.
    
        if AVAIL movto-receita AND (movto-receita.situacao-s begins "Nao Habi" OR
                                    movto-receita.situacao-s begins "N"        OR
                                    movto-receita.situacao-s begins "N∆o Habi" OR
                                    movto-receita.situacao-s begins "Baixad"   OR
                                    movto-receita.situacao-s begins "Suspen"   OR
                                    movto-receita.situacao-s begins "Cancel"   OR
                                    movto-receita.situacao-s begins "Pendente" OR
                                    movto-receita.situacao-s begins "inscriá∆o n∆o encontrada") THEN
        message "Bloqueado na Receita" movto-receita.situacao-s view-as alert-box.
        else message "OK Receita" movto-receita.situacao-s view-as alert-box.
    end.
end.


find first es-param-bloqueio no-lock no-error.

FIND es-follow-up WHERE es-follow-up.cdn-follow-up  = es-param-bloqueio.bloq-comercial NO-LOCK NO-ERROR.

CREATE tt-follow.
ASSIGN tt-follow.r-rowid-pedido = ROWID(ws-p-venda) 
       tt-follow.r-rowid-follow = ROWID(es-follow-up).

CREATE tt-erros-geral.
ASSIGN tt-erros-geral.identif-msg = ws-p-venda.nome-abrev + CHR(24) + ws-p-venda.nr-pedcli
       tt-erros-geral.cod-erro    = es-follow-up.cdn-follow-up
       tt-erros-geral.des-erro    = "Cliente com a situaá∆o" + movto-sintegra.situacao + " no Sintegra." + chr(10) + 
                                    "Consulta realizada em " + movto-sintegra.data-consulta + " as " + movto-sintegra.hora.

CREATE tt-erros-geral.
ASSIGN tt-erros-geral.identif-msg = ws-p-venda.nome-abrev + CHR(24) + ws-p-venda.nr-pedcli
       tt-erros-geral.cod-erro    = es-follow-up.cdn-follow-up
       tt-erros-geral.des-erro    = "Cliente com a situaá∆o" + movto-receita.situacao-s + "na Receita" + chr(10) + 
                                    "Consulta realizada em " + movto-receita.data-pesquisa + " as " + movto-receita.hora.
