{include/i-buffer.i}
{utp/ut-glob.i}

c-seg-usuario = "fln28716".

DEFINE VARIABLE c-lista          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lst-gr-usu     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-lst-gr-usu-div AS CHARACTER   NO-UNDO.

DEFINE BUFFER buf-es-dep-usuar FOR es-dep-usuar.

FIND FIRST ws-p-venda WHERE ws-p-venda.nr-pedcli = "1175w0026" NO-LOCK NO-ERROR.

MESSAGE ws-p-venda.user-impl
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

RUN piGrupoAcesso.

PROCEDURE piGrupoAcesso :
/* {Begin} SD1448-07 Kleber Sotte
       Alerta no PedWeb Pedido Retornado ao Repres
       grava no campo log-1 que o representante reConfirmou o pedido*/
        /*
       IF c-seg-usuario = 'repres' THEN
       SET RowObject.log-1 = FALSE.
       */
    /**{End} SD1448-07***********************************************/
    
    FIND ws-usuario NO-LOCK WHERE 
         ws-usuario.usuario = c-seg-usuario NO-ERROR.
    IF AVAIL ws-usuario THEN  
       ASSIGN c-lista = TRIM(ws-usuario.estabelecimento).   

    c-lst-gr-usu = c-seg-usuario.

    FOR EACH es-dep-usuar NO-LOCK
       WHERE es-dep-usuar.cod-usuario = c-seg-usuario:
       FOR EACH buf-es-dep-usuar NO-LOCK
          WHERE buf-es-dep-usuar.cod-departamento = es-dep-usuar.cod-departamento
            AND buf-es-dep-usuar.log-principal:
          c-lst-gr-usu = IF c-lst-gr-usu = '' THEN buf-es-dep-usuar.cod-usuario
                         ELSE c-lst-gr-usu + ',' + buf-es-dep-usuar.cod-usuario.
       END.
    END.


    /* MVR - 13/12/2010 - Utiliza Include de Permissao de Acesso */
    /* Verifica se nao e representante */
    IF c-seg-usuario <> 'repres' THEN DO:
        /*FIND repres WHERE 
             repres.nome-abrev = RowObject.no-ab-reppri NO-LOCK NO-ERROR.
        IF AVAIL repres THEN DO:
            /* Verifica se usuario atende regiao do repres do pedido */
            FIND FIRST es-usuario-ger WHERE
                       es-usuario-ger.cod_usuario = c-seg-usuario      AND
                       es-usuario-ger.nome-ab-reg = repres.nome-ab-reg NO-LOCK NO-ERROR.
            IF AVAIL es-usuario-ger THEN DO:*/
               c-lst-gr-usu = IF c-lst-gr-usu = '' THEN 'Repres'
                              ELSE c-lst-gr-usu + ',' + 'Repres'.
            /*END.
        END.*/
    END.

    /* mfo - 30/12/2008 - SD 1806 */
    IF c-seg-usuario <> 'repres' THEN DO:
        ASSIGN c-lst-gr-usu-div = ''.
        FIND FIRST es-param-bloqueio NO-LOCK NO-ERROR.
        IF AVAIL es-param-bloqueio THEN DO:
            FOR EACH buf-es-dep-usuar NO-LOCK
               WHERE buf-es-dep-usuar.cod-departamento = es-param-bloqueio.cod-departamento
                 AND buf-es-dep-usuar.log-principal:
               c-lst-gr-usu-div = IF c-lst-gr-usu-div = '' THEN buf-es-dep-usuar.cod-usuario
                              ELSE c-lst-gr-usu-div + ',' + buf-es-dep-usuar.cod-usuario.   
            END.
        END.

        IF LOOKUP(c-seg-usuario, c-lst-gr-usu-div) > 0 THEN DO:
            c-lst-gr-usu = IF c-lst-gr-usu = '' THEN ws-p-venda.user-impl
                           ELSE c-lst-gr-usu + ',' +  ws-p-venda.user-impl.
        END.
    END.
    
END PROCEDURE.

c-seg-usuario = "ess55813".

MESSAGE c-lista             SKIP(1)
        c-lst-gr-usu        SKIP(1)
        c-lst-gr-usu-div
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
