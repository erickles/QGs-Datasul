DEFINE VARIABLE c-texto         AS CHAR    FORMAT "X(5000)" INIT "Pedido foi encaminhado aos seguintes usuarios : " NO-UNDO.
DEFINE VARIABLE c-usuario       AS CHAR    FORMAT "X(5000)" NO-UNDO.
DEFINE VARIABLE l-tem           AS LOG INIT NO              NO-UNDO.
define variable l-nutri         as logical initial no.
define variable i-cod-hist-s    as integer.
define variable i-cod-hist-r    as integer.
DEFINE BUFFER b-es-his-follow    FOR es-his-follow.
define variable l-out           as logical.

define variable row-id          as rowid.

DEFINE TEMP-TABLE tt-permissao      NO-UNDO
    FIELD cod_usuario               AS CHAR
    FIELD r-rowid-ped-venda         AS ROWID
    FIELD r-rowid-permissao         AS ROWID
    FIELD pontos                    AS INTEGER.

define buffer b-movto-sintegra for movto-sintegra.
define buffer b-movto-receita for movto-receita.

find first ws-p-venda where ws-p-venda.nr-pedcli = "ess005" no-lock no-error.
if avail ws-p-venda then
    assign row-id = rowid(ws-p-venda).

run validaSintegra(input row-id,
                   output l-out).

message l-out view-as alert-box.

PROCEDURE ValidaSintegra:

    DEFINE INPUT  PARAMETER r-rowidPedido AS ROWID      NO-UNDO.
    define output parameter l-bloq-s      as logical    no-undo.
    /*Erick - Bloqueia pedidos onde o cliente tenha inscriªío, cpf ou cnpj nío hahilitado (sd 2053/09)*/             
    find first ws-p-venda where rowid(ws-p-venda) = r-rowidPedido no-error.
    find first emitente where emitente.cod-emitente = inte(ws-p-venda.nome-abrev) no-lock no-error.
    
    for each ws-p-item of ws-p-venda no-lock.         
        FIND FIRST ITEM WHERE ITEM.it-codigo = ws-p-item.it-codigo NO-LOCK NO-ERROR.
        IF avail item and item.ge-codigo  = 44 then l-nutri = yes.        
    end.
                       
    if l-nutri then do:          
        
        FIND FIRST es-param-bloqueio NO-LOCK NO-ERROR.
        IF NOT AVAIL es-param-bloqueio THEN RETURN.
    
        FIND es-follow-up where es-follow-up.cdn-follow-up = es-param-bloqueio.bloq-comercial 
        NO-LOCK NO-ERROR.   
    
        RUN esp/espd1911.p (INPUT ROWID(ws-p-venda),
                            INPUT ROWID(es-follow-up),
                            INPUT FALSE, 
                            OUTPUT TABLE tt-permissao).
    
        FOR EACH tt-permissao :          
            FIND es-permis-acess where ROWID(es-permis-acess) = r-rowid-permissao NO-LOCK NO-ERROR.
            IF AVAIL es-permis-acess THEN 
                RUN ValidaGrava.           
        END.
        
        /*Busca por bloqueio do sintegra*/
        FOR EACH b-movto-sintegra NO-LOCK WHERE b-movto-sintegra.cod-emitente = inte(ws-p-venda.nome-abrev)
                                  BREAK by b-movto-sintegra.cod-hist:
        
            IF LAST(b-movto-sintegra.cod-hist) then ASSIGN i-cod-hist-s = b-movto-sintegra.cod-hist.
          
        END. 
        /*Busca por bloqueio do sintegra*/
        FIND LAST movto-sintegra WHERE movto-sintegra.cod-emitente = inte(ws-p-venda.nome-abrev) AND
                                       movto-sintegra.cod-hist     = i-cod-hist-s                and
                                       movto-sintegra.cnpj         = emitente.cgc
                                       NO-LOCK NO-ERROR.                

        IF AVAIL movto-sintegra AND (movto-sintegra.situacao begins "Nao Habi" OR
                                     movto-sintegra.situacao begins "N∆o Habi" OR
                                     movto-sintegra.situacao begins "Baixad"   OR
                                     movto-sintegra.situacao begins "Suspen"   or
                                     movto-sintegra.situacao begins "Canc") THEN DO:

            message "Bloqueio Sintegra" view-as alert-box.

            DEFINE VARIABLE i-sequence AS INTEGER NO-UNDO.
    
            /* Gera Historico de Manutencao */              
            FIND LAST es-his-follow where es-his-follow.nome-abrev    = ws-p-venda.nome-abrev AND
                                          es-his-follow.nr-pedcli     = ws-p-venda.nr-pedcli  AND 
                                          es-his-follow.cdn-follow-up = es-follow-up.cdn-follow-up
                                          NO-LOCK NO-ERROR.
            
            i-sequence = IF NOT AVAIL es-his-follow THEN 1 ELSE es-his-follow.seq-his-follow + 1. 
            
            CREATE b-es-his-follow.
            ASSIGN b-es-his-follow.nome-abrev         = ws-p-venda.nome-abrev
                   b-es-his-follow.nr-pedcli          = ws-p-venda.nr-pedcli
                   b-es-his-follow.cdn-follow-up      = es-follow-up.cdn-follow-up
                   b-es-his-follow.seq-his-follow     = i-sequence                                    
                   b-es-his-follow.acao-follow        = 'Encaminhado'
                   b-es-his-follow.dat-his-follow     = TODAY 
                   b-es-his-follow.hra-his-follow     = TIME
                   b-es-his-follow.dsl-follow-up      = 'Cliente com Inscriá∆o ou CPF/CNPJ n∆o habilitado.' + 
                                                        chr(10) +
                                                        c-texto 
                   b-es-his-follow.cod-usuario        = 'Sistema'
                   b-es-his-follow.usuarios           = c-usuario
                   b-es-his-follow.log-encerra-follow = TRUE
                   b-es-his-follow.log-sistema        = TRUE.
              
            l-bloq-s = yes.

            assign ws-p-venda.ind-sit-ped = 5.
    
            RELEASE b-es-his-follow NO-ERROR.            
    
        end. /*if avail movto-sintegra*/             
    
        /*Busca por bloqueio da receita*/
        FOR EACH b-movto-receita NO-LOCK WHERE b-movto-receita.cod-emitente = ws-p-venda.cod-emitente 
                                  BREAK by b-movto-receita.cod-hist:
    
            IF LAST(b-movto-receita.cod-hist) THEN
                ASSIGN i-cod-hist-r = b-movto-receita.cod-hist.
          
        END.
    
        FIND LAST movto-receita WHERE movto-receita.cod-emitente   = inte(ws-p-venda.nome-abrev) AND
                                      movto-receita.cod-hist       = i-cod-hist-r                and
                                      movto-receita.cnpj           = emitente.cgc
                                      NO-LOCK NO-ERROR.
    
        IF AVAIL movto-receita AND (movto-receita.situacao begins "Nao Habi" OR     
                                    movto-receita.situacao begins "N∆o Habi" OR     
                                    movto-receita.situacao begins "Baixad"   OR     
                                    movto-receita.situacao begins "Suspen"   OR     
                                    movto-receita.situacao begins "Cancel") THEN DO:
            
            message "Bloqueio Receita" view-as alert-box.
    
            DEFINE VARIABLE i-sequence-r AS INTEGER NO-UNDO.
    
            /* Gera Historico de Manutencao */
            FIND LAST es-his-follow where es-his-follow.nome-abrev    = ws-p-venda.nome-abrev AND
                                          es-his-follow.nr-pedcli     = ws-p-venda.nr-pedcli  AND 
                                          es-his-follow.cdn-follow-up = es-follow-up.cdn-follow-up
                                          NO-LOCK NO-ERROR.
            
            i-sequence = IF NOT AVAIL es-his-follow THEN 1 ELSE es-his-follow.seq-his-follow + 1. 
    
            CREATE b-es-his-follow.
            ASSIGN b-es-his-follow.nome-abrev         = ws-p-venda.nome-abrev
                   b-es-his-follow.nr-pedcli          = ws-p-venda.nr-pedcli
                   b-es-his-follow.cdn-follow-up      = es-follow-up.cdn-follow-up
                   b-es-his-follow.seq-his-follow     = i-sequence-r                                    
                   b-es-his-follow.acao-follow        = 'Encaminhado'
                   b-es-his-follow.dat-his-follow     = TODAY 
                   b-es-his-follow.hra-his-follow     = TIME
                   b-es-his-follow.dsl-follow-up      = 'Cliente com Inscriªío ou CPF/CNPJ nío habilitado.' + 
                                                        chr(10) +
                                                        c-texto 
                   b-es-his-follow.cod-usuario        = 'Sistema'
                   b-es-his-follow.usuarios           = c-usuario
                   b-es-his-follow.log-encerra-follow = TRUE
                   b-es-his-follow.log-sistema        = TRUE.
    
            l-bloq-s = yes.
    
            RELEASE b-es-his-follow NO-ERROR.            
    
        end.
    end.
    /*----*/
END PROCEDURE.

PROCEDURE ValidaGrava:

    FIND FIRST usuar_mestre WHERE
               usuar_mestre.cod_usuario = es-permis-acess.cod_usuario NO-LOCK NO-ERROR.
    IF NOT AVAIL usuar_mestre THEN RETURN.

    FIND FIRST es-aprov-pedido WHERE
               es-aprov-pedido.cod-usuario   = es-permis-acess.cod_usuario AND
               es-aprov-pedido.nome-abrev    = ws-p-venda.nome-abrev        AND
               es-aprov-pedido.nr-pedcli     = ws-p-venda.nr-pedcli         AND
               es-aprov-pedido.cdn-follow-up = es-follow-up.cdn-follow-up   NO-ERROR.
    IF NOT AVAIL es-aprov-pedido THEN DO:
       CREATE es-aprov-pedido.
       ASSIGN es-aprov-pedido.cod-usuario   = es-permis-acess.cod_usuario   
              es-aprov-pedido.nome-abrev    = ws-p-venda.nome-abrev         
              es-aprov-pedido.nr-pedcli     = ws-p-venda.nr-pedcli          
              es-aprov-pedido.cdn-follow-up = es-follow-up.cdn-follow-up
              es-aprov-pedido.ind-tp-follow = es-permis-acess.ind-tp-follow
              es-aprov-pedido.ind-aprovador = no.
    END.
    IF es-aprov-pedido.ind-aprovador = NO THEN DO:
         
         ASSIGN es-aprov-pedido.ind-aprovador = YES
                c-texto                       = c-texto + CHR(10) + chr(10) + es-aprov-pedido.cod-usuario + ' ( ' + usuar_mestre.nom_usuario + ' ) ' + CHR(10).
                c-usuario                     = IF c-usuario = " " THEN es-aprov-pedido.cod-usuario
                                                ELSE c-usuario + "," + es-aprov-pedido.cod-usuario.
                  
    END.

    ASSIGN l-tem = YES.

END PROCEDURE.
