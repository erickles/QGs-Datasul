DEFINE BUFFER b-sintegra FOR movto-sintegra.
DEFINE BUFFER b2-sintegra FOR movto-sintegra.
DEFINE BUFFER b-receita  FOR movto-receita.

DEFINE VARIABLE i-cod-emitente AS INTEGER     NO-UNDO.

UPDATE i-cod-emitente.

FIND FIRST emitente WHERE emitente.cod-emitente = i-cod-emitente NO-LOCK NO-ERROR.
IF AVAIL emitente THEN DO:
    /* Sintegra */

    FOR EACH b-sintegra WHERE b-sintegra.cod-emitente    = emitente.cod-emitente NO-LOCK BREAK BY b-sintegra.cod-his DESC:
        IF FIRST-OF(b-sintegra.cod-his) THEN DO:            
            FIND FIRST b2-sintegra WHERE b2-sintegra.cod-emitente = emitente.cod-emitente 
                                     AND b2-sintegra.cod-his      = b-sintegra.cod-his
                                     NO-LOCK NO-ERROR.
            LEAVE.
        END.
    END.    
                                
    CREATE movto-sintegra.
    ASSIGN movto-sintegra.cod-emitente    = emitente.cod-emitente
           movto-sintegra.uf              = emitente.estado
           movto-sintegra.tipo-pesquisa   = "S"
           movto-sintegra.cnpj            = emitente.cgc
           movto-sintegra.insc-estadual   = emitente.ins-estadual
           movto-sintegra.habilitado      = "S"
           movto-sintegra.razao-social    = emitente.nome-emit
           movto-sintegra.cep             = emitente.cep
           movto-sintegra.endereco        = emitente.endereco
           movto-sintegra.numero          = "0"
           movto-sintegra.complemento     = ""
           movto-sintegra.bairro          = emitente.bairro
           movto-sintegra.municipio       = emitente.cidade     
           movto-sintegra.telefone        = emitente.telefone[1].

    ASSIGN movto-sintegra.situacao        = "HABILITADO"
           movto-sintegra.data-sintegra   = TODAY
           movto-sintegra.data-consulta   = TODAY
           movto-sintegra.situacao-s      = "S"
           movto-sintegra.hora            = STRING(TIME,"HH:MM:SS")
           movto-sintegra.cod-his         = IF AVAIL b-sintegra THEN b-sintegra.cod-his + 2 ELSE 1.

    MESSAGE movto-sintegra.cod-his
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
