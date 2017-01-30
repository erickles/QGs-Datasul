DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.
DEFINE BUFFER b-receita  FOR movto-receita.
DEFINE VARIABLE iCodigo AS INTEGER     NO-UNDO.

UPDATE iCodigo.

FIND FIRST emitente WHERE emitente.cod-emitente = iCodigo NO-LOCK NO-ERROR.
IF AVAIL emitente THEN DO:

    /* Receita */
    /* FIND LAST b-receita WHERE b-receita.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR. */
    FOR EACH b-receita WHERE b-receita.cod-emitente = emitente.cod-emitente NO-LOCK:
        IF b-receita.cod-his >= iCont THEN
            iCont = b-receita.cod-his + 1.
    END.

    CREATE movto-receita.
    ASSIGN movto-receita.cod-emitente    = emitente.cod-emitente
           movto-receita.cnpj            = emitente.cgc
           movto-receita.cnpj-s          = emitente.cgc
           movto-receita.data-abertura   = TODAY
           movto-receita.razao-social    = emitente.nome-emit
           movto-receita.nome-fantasia   = emitente.nome-emit
           movto-receita.natureza        = ""
           movto-receita.logradouro      = emitente.endereco
           movto-receita.numero          = "0"
           movto-receita.complemento     = ""
           movto-receita.cep             = emitente.cep
           movto-receita.bairro          = emitente.bairro
           movto-receita.municipio       = emitente.cidade
           movto-receita.uf              = emitente.cidade
           movto-receita.situacao        = "REGULAR"
           movto-receita.data-situacao   = TODAY
           movto-receita.razao-social-s  = emitente.nome-emit
           movto-receita.cep-s           = emitente.cep
           movto-receita.situacao-s      = "REGULAR".

    ASSIGN movto-receita.data-situacao-2   = TODAY
           movto-receita.situacao-especial = "REGULAR"
           movto-receita.data-situacao-esp = ?
           movto-receita.data-pesquisa     = TODAY
           movto-receita.opcao-simples     = ""
           movto-receita.data-opcao        = TODAY
           movto-receita.porte             = ""
           movto-receita.cod-his           = iCont.

    ASSIGN movto-receita.hora              = STRING(TIME).
END.
