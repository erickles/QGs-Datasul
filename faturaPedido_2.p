{include/i-buffer.i}
/* In¡cio do programa que calcula um pedido */
{utp/ut-glob.i}
DEFINE VARIABLE cPedido AS CHARACTER FORMAT "X(12)"  NO-UNDO.

UPDATE cPedido.

/*ON WRITE OF nota-fiscal DO:

   RUN NOTA_FISCAL_COMITADA_BANCO.
   IF RETURN-VALUE = "NOK" THEN
      RETURN ERROR.

   RETURN.

END.*/

/* Defini‡Æo da vari veis */
def var h-bodi317pr          as HANDLE NO-UNDO.
def var h-bodi317sd          as HANDLE NO-UNDO.
def var h-bodi317im1bra      as HANDLE NO-UNDO.
def var h-bodi317va          as HANDLE NO-UNDO.
def var h-bodi317in          as HANDLE NO-UNDO.
def var h-bodi317ef          as HANDLE NO-UNDO.
def var l-proc-ok-aux        as LOG    NO-UNDO.
def var c-ultimo-metodo-exec as CHAR   NO-UNDO.
def var c-cod-estabel        as CHAR   NO-UNDO.
def var c-serie              as char   NO-UNDO.
def var da-dt-emis-nota      as date   NO-UNDO.
def var da-dt-base-dup       as date   NO-UNDO.
def var da-dt-prvenc         as date   NO-UNDO.
/*def var c-seg-usuario        as char   no-undo.*/
def var c-nome-abrev         as char   NO-UNDO.   
def var c-nr-pedcli          as char   NO-UNDO.
def var c-nat-operacao       as char   NO-UNDO.
def var c-cod-canal-venda    as char   NO-UNDO.
def var i-seq-wt-docto       as int    NO-UNDO.

/* Def temp-table de erros. Ela tb‚m est  definida na include dbotterr.i */
def temp-table rowerrors no-undo
    field errorsequence    as int
    field errornumber      as int
    field errordescription as char
    field errorparameters  as char
    field errortype        as char
    field errorhelp        as char
    field errorsubtype     as char.

/* Definicao da tabela temporaria tt-notas-geradas, include {dibo/bodi317ef.i1} */
def temp-table tt-notas-geradas no-undo
    field rw-nota-fiscal as   rowid
    field nr-nota        like nota-fiscal.nr-nota-fis
    field seq-wt-docto   like wt-docto.seq-wt-docto.

/* Defini‡Æo de um buffer para tt-notas-geradas */
def buffer b-tt-notas-geradas for tt-notas-geradas.

/*DEFINE INPUT  PARAMETER prRowid   AS ROWID       NO-UNDO.*/

/*FIND ws-p-venda WHERE
     ROWID(ws-p-venda) = prRowid NO-LOCK NO-ERROR.*/
FIND FIRST ws-p-venda WHERE /*ws-p-venda.cod-estabel = "18"
                        AND ws-p-venda.ind-sit-ped = 12
                        AND nr-pedcli BEGINS "1" NO-LOCK NO-ERROR.*/
    ws-p-venda.nr-pedcli = cPedido NO-LOCK NO-ERROR.

IF NOT AVAIL ws-p-venda THEN DO:
    MESSAGE "Pedido nao encontrado" VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN "NOK":U.
END.

/* Identifica Ultima Serie */
FOR EACH ser-estab NO-LOCK
   WHERE ser-estab.cod-estabel = ws-p-venda.cod-estabel 
   BREAK BY ser-estab.cod-estabel
         BY ser-estab.dt-ult-fat:

   IF LAST-OF(ser-estab.cod-estabel) THEN DO:

       c-serie = ser-estab.serie.
       /*DISPLAY ser-estab.cod-estabel
               ser-estab.serie
               ser-estab.dt-ult-fat.*/

   END.
            
END.


/* Informa‡äes do embarque para c lculo */
assign /*c-seg-usuario     = "super" /* Usu rio                    */*/
       c-cod-estabel     = ws-p-venda.cod-estabel     /* Estabelecimento do pedido  */
       /*c-serie           = "2"      /* S‚rie das notas            */*/
       c-nome-abrev      = ws-p-venda.nome-abrev    /* Nome abreviado do cliente  */
       c-nr-pedcli       = ws-p-venda.nr-pedcli     /* Nr pedido do cliente       */
       da-dt-emis-nota   = TODAY   /* Data de emissÆo da nota    */
       c-nat-operacao    = ?       /* Quando ‚ ? busca do pedido */
       c-cod-canal-venda = ?.      /* Quando ‚ ? busca do pedido */

/* Inicializa‡Æo das BOS para C lculo */
run dibo/bodi317in.p persistent set h-bodi317in.
run inicializaBOS in h-bodi317in(output h-bodi317pr,
                                 output h-bodi317sd,     
                                 output h-bodi317im1bra,
                                 output h-bodi317va).

/* In¡cio da transa‡Æo */
repeat trans:
    /* Limpar a tabela de erros em todas as BOS */
    run emptyRowErrors        in h-bodi317in.

    /* Cria o registro WT-DOCTO para o pedido */
    run criaWtDocto in h-bodi317sd
            (input  c-seg-usuario,
             input  c-cod-estabel,
             input  c-serie,
             input  "1", 
             input  c-nome-abrev,
             input  c-nr-pedcli,
             input  1,    
             input  9999, 
             input  da-dt-emis-nota,
             input  0,  
             input  c-nat-operacao,
             input  c-cod-canal-venda,
             output i-seq-wt-docto,
             output l-proc-ok-aux).

    /* Busca poss¡veis erros que ocorreram nas valida‡äes */
    run devolveErrosbodi317sd in h-bodi317sd(output c-ultimo-metodo-exec,
                                             output table RowErrors).

    /* Pesquisa algum erro ou advertˆncia que tenha ocorrido */
    find first RowErrors no-lock no-error.
    
    /* Caso tenha achado algum erro ou advertˆncia, mostra em tela */
    if  avail RowErrors then
        for each RowErrors:
            /* <Mostra os Erros/Advertˆncias encontradas */

            MESSAGE RowErrors.errorDescription
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

        end.
    
    /* Caso ocorreu problema nas valida‡äes, nÆo continua o processo */
    if  not l-proc-ok-aux then
        undo, leave.

    /* Limpar a tabela de erros em todas as BOS */
    run emptyRowErrors        in h-bodi317in.

    /* Gera os itens para o pedido, com tela de acompanhamento */
    run inicializaAcompanhamento      in h-bodi317sd.
    run geraWtItDoctoComItensDoPedido in h-bodi317sd(output l-proc-ok-aux).
    run finalizaAcompanhamento        in h-bodi317sd.

    /* Busca poss¡veis erros que ocorreram nas valida‡äes */
    run devolveErrosbodi317sd         in h-bodi317sd(output c-ultimo-metodo-exec,
                                                     output table RowErrors).

    /* Pesquisa algum erro ou advertˆncia que tenha ocorrido */
    find first RowErrors no-lock no-error.
    
    /* Caso tenha achado algum erro ou advertˆncia, mostra em tela */
    if  avail RowErrors then
        for each RowErrors:
            MESSAGE RowErrors.errorDescription
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

            /* <Mostra os Erros/Advertˆncias encontradas */
        end.
    
    /* Caso ocorreu problema nas valida‡äes, nÆo continua o processo */
    if  not l-proc-ok-aux then
        undo, leave.

    /* Limpar a tabela de erros em todas as BOS */
    run emptyRowErrors        in h-bodi317in.

    /* Atende todos os itens do pedido, com tela de acompanhamento */
    run inicializaAcompanhamento in h-bodi317pr.
    run atendeTotalPed           in h-bodi317pr (input  i-seq-wt-docto,
                                                 output l-proc-ok-aux).
    run finalizaAcompanhamento   in h-bodi317pr.

    /* Busca poss¡veis erros que ocorreram nas valida‡äes */
    run devolveErrosbodi317pr    in h-bodi317pr (output c-ultimo-metodo-exec,
                                                 output table RowErrors).

    /* Pesquisa algum erro ou advertˆncia que tenha ocorrido */
    find first RowErrors no-lock no-error.
    
    /* Caso tenha achado algum erro ou advertˆncia, mostra em tela */
    if  avail RowErrors then
        for each RowErrors:
            MESSAGE RowErrors.errorDescription
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

            /* <Mostra os Erros/Advertˆncias encontradas */
        end.
    
    /* Caso ocorreu problema nas valida‡äes, nÆo continua o processo */
    if  not l-proc-ok-aux then
        undo, leave.

    /* Limpar a tabela de erros em todas as BOS */
    run emptyRowErrors        in h-bodi317in.

    /* Calcula o pedido, com acompanhamento */
    run inicializaAcompanhamento in h-bodi317pr.
    run confirmaCalculo          in h-bodi317pr(input  i-seq-wt-docto,
                                                output l-proc-ok-aux).
    run finalizaAcompanhamento   in h-bodi317pr.

    /* Busca poss¡veis erros que ocorreram nas valida‡äes */
    run devolveErrosbodi317pr    in h-bodi317pr (output c-ultimo-metodo-exec,
                                                 output table RowErrors).

    /* Pesquisa algum erro ou advertˆncia que tenha ocorrido */
    find first RowErrors no-lock no-error.
    
    /* Caso tenha achado algum erro ou advertˆncia, mostra em tela */
    if  avail RowErrors then
        for each RowErrors:
            /* <Mostra os Erros/Advertˆncias encontradas */
            MESSAGE RowErrors.errorDescription
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        end.
    
    /* Caso ocorreu problema nas valida‡äes, nÆo continua o processo */
    if  not l-proc-ok-aux then
        undo, leave.
        
    /* Efetiva os pedidos e cria a nota */
    run dibo/bodi317ef.p persistent set h-bodi317ef.
    run emptyRowErrors           in h-bodi317in.
    run inicializaAcompanhamento in h-bodi317ef.
    run setaHandlesBOS           in h-bodi317ef(h-bodi317pr,     
                                                h-bodi317sd, 
                                                h-bodi317im1bra, 
                                                h-bodi317va).
    run efetivaNota              in h-bodi317ef(input  i-seq-wt-docto,
                                                input  yes,
                                                output l-proc-ok-aux).
    run finalizaAcompanhamento   in h-bodi317ef.

    /* Busca poss¡veis erros que ocorreram nas valida‡äes */
    run devolveErrosbodi317ef    in h-bodi317ef(output c-ultimo-metodo-exec,
                                                output table RowErrors).

    /* Pesquisa algum erro ou advertˆncia que tenha ocorrido */
    find first RowErrors
         where RowErrors.ErrorSubType = "ERROR":U no-error.

    /* Caso tenha achado algum erro ou advertˆncia, mostra em tela */
    if  avail RowErrors then
        for each RowErrors:
            /* <Mostra os Erros/Advertˆncias encontradas */
            MESSAGE RowErrors.errorDescription
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
        end.
    
    /* Caso ocorreu problema nas valida‡äes, nÆo continua o processo */
    if  not l-proc-ok-aux then do:
        delete procedure h-bodi317ef.
        undo, leave.
    end.

    /* Busca as notas fiscais geradas */
    run buscaTTNotasGeradas in h-bodi317ef(output l-proc-ok-aux,
                                           output table tt-notas-geradas).

    /* Elimina o handle do programa bodi317ef */
    delete procedure h-bodi317ef.
    
    /*MESSAGE "Antes de desfazer" VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

    /*UNDO, LEAVE.*/

    leave.
end.
        
/*MESSAGE "terminou" VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

/* Finaliza‡Æo das BOS utilizada no c lculo */
run finalizaBOS in h-bodi317in.

/*

/* Mostrar as notas geradas */
for first tt-notas-geradas no-lock:
    find last b-tt-notas-geradas no-error.
    for  first nota-fiscal 
        where rowid(nota-fiscal) = tt-notas-geradas.rw-nota-fiscal no-lock:
    end.
    bell.
    if  tt-notas-geradas.nr-nota = b-tt-notas-geradas.nr-nota then
        run utp/ut-msgs.p(input "show",
                          input 15263,
                          input string(tt-notas-geradas.nr-nota) + "~~" +
                                string(nota-fiscal.cod-estabel)  + "~~" +
                                string(nota-fiscal.serie)).
    else
        run utp/ut-msgs.p(input "show",
                          input 15264,
                          input string(tt-notas-geradas.nr-nota)   + "~~" +
                                string(b-tt-notas-geradas.nr-nota) + "~~" +
                                string(nota-fiscal.cod-estabel)    + "~~" +
                                string(nota-fiscal.serie)).
end.
*/
/* Fim do programa que calcula um pedido */

/*PROCEDURE NOTA_FISCAL_COMITADA_BANCO:

    MESSAGE "NOTA_FISCAL_COMITADA_BANCO" VIEW-AS ALERT-BOX INFO BUTTONS OK.

    RETURN "OK".

END PROCEDURE.*/
