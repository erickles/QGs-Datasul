DEFINE BUFFER b-sintegra FOR movto-sintegra.
DEFINE BUFFER b-receita  FOR movto-receita.

FOR EACH ws-p-venda WHERE (ws-p-venda.ind-sit-ped < 17 OR ws-p-venda.ind-sit-ped = 18) NO-LOCK:
    FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.
/*     FIND FIRST emitente WHERE emitente.cod-emitente = 38028 NO-LOCK NO-ERROR. */
    IF AVAIL emitente THEN DO:
        /* Sintegra */
        FIND LAST b-sintegra WHERE b-sintegra.cod-emitente = emitente.cod-emitente 
                               AND b-sintegra.cod-entrega  = emitente.cod-entrega
                               NO-LOCK NO-ERROR.

        FIND FIRST movto-sintegra WHERE movto-sintegra.cod-emitente = emitente.cod-emitente
                                    AND movto-sintegra.data-consulta   = TODAY NO-LOCK NO-ERROR.

        IF NOT AVAIL movto-sintegra THEN DO:        

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
                   movto-sintegra.situacao-s      = "HABILITADO"
                   movto-sintegra.hora            = STRING(TIME)
                   movto-sintegra.cod-his         = IF AVAIL b-sintegra THEN b-sintegra.cod-his + 1 ELSE 1 NO-ERROR.
        END.
        /* Receita */
/*         FIND LAST b-receita WHERE b-receita.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.     */
/*         CREATE movto-receita.                                                                          */
/*         ASSIGN movto-receita.cod-emitente    = emitente.cod-emitente                                   */
/*                movto-receita.cnpj            = emitente.cgc                                            */
/*                movto-receita.cnpj-s          = emitente.cgc                                            */
/*                movto-receita.data-abertura   = TODAY                                                   */
/*                movto-receita.razao-social    = emitente.nome-emit                                      */
/*                movto-receita.nome-fantasia   = emitente.nome-emit                                      */
/*                movto-receita.natureza        = ""                                                      */
/*                movto-receita.logradouro      = emitente.endereco                                       */
/*                movto-receita.numero          = "0"                                                     */
/*                movto-receita.complemento     = ""                                                      */
/*                movto-receita.cep             = emitente.cep                                            */
/*                movto-receita.bairro          = emitente.bairro                                         */
/*                movto-receita.municipio       = emitente.cidade                                         */
/*                movto-receita.uf              = emitente.cidade                                         */
/*                movto-receita.situacao        = "REGULAR"                                               */
/*                movto-receita.data-situacao   = TODAY                                                   */
/*                movto-receita.razao-social-s  = emitente.nome-emit                                      */
/*                movto-receita.cep-s           = emitente.cep                                            */
/*                movto-receita.situacao-s      = "REGULAR".                                              */
/*                                                                                                        */
/*         ASSIGN movto-receita.data-situacao-2   = TODAY                                                 */
/*                movto-receita.situacao-especial = "REGULAR"                                             */
/*                movto-receita.data-situacao-esp = ?                                                     */
/*                movto-receita.data-pesquisa     = TODAY                                                 */
/*                movto-receita.opcao-simples     = ""                                                    */
/*                movto-receita.data-opcao        = TODAY                                                 */
/*                movto-receita.porte             = ""                                                    */
/*                movto-receita.cod-his           = IF AVAIL b-receita THEN b-receita.cod-his + 1 ELSE 1. */
/*                                                                                                        */
/*         ASSIGN movto-receita.hora              = STRING(TIME).                                         */
    END.
END.
