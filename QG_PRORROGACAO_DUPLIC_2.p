{include/i-buffer.i}
{include/i-ambiente.i}

DEFINE VARIABLE cod-solicita AS INTEGER   NO-UNDO.

DEFINE VARIABLE c-mail-destino  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-out-de        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-out-assunto   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-out-mensagem  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-out-error     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-observacoes   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-motivo        AS CHAR NO-UNDO.
DEFINE VARIABLE VALOR-EXTENSO   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE mail-envia      AS CHARACTER   NO-UNDO INITIAL "erick.souza@tortuga.com.br".

DEF VAR assunts             AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody1              AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody2              AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody3              AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody4              AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody5              AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody6              AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody7              AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody8              AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody9              AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody10             AS CHAR INITIAL "" NO-UNDO.
DEF VAR numero              AS CHAR INITIAL "" NO-UNDO.
DEF VAR data-implantacao    AS CHAR INITIAL "" NO-UNDO.
DEF VAR ref                 AS CHAR INITIAL "" NO-UNDO.
DEF VAR usuario-implantacao AS CHAR INITIAL "" NO-UNDO.
DEF VAR usuario-cc          AS CHAR INITIAL "" NO-UNDO.
DEF VAR c-aprovador1        AS CHAR INITIAL "" NO-UNDO.
DEF VAR c-aprovador2        AS CHAR INITIAL "" NO-UNDO.
DEF VAR l-itens             AS LOGICAL NO-UNDO.
DEF VAR i                   AS INTEGER INITIAL 1 NO-UNDO.
DEF VAR c-item1             AS CHAR FORMAT "X(70)" NO-UNDO.
DEF VAR c-item2             AS CHAR FORMAT "X(70)" NO-UNDO.
DEF VAR c-item3             AS CHAR FORMAT "X(70)" NO-UNDO.
DEF VAR c-item4             AS CHAR FORMAT "X(70)" NO-UNDO.
DEF VAR c-item5             AS CHAR FORMAT "X(70)" NO-UNDO.

UPDATE cod-solicita LABEL "Codigo da solicitacao".

DEF TEMP-TABLE t-texto NO-UNDO 
    FIELD linha AS INTEGER 
    FIELD conteudo AS CHARACTER FORMAT "x(500)"
INDEX primario IS PRIMARY UNIQUE linha. 

/*Gera Motivo*/
FIND FIRST es-desconto-duplic WHERE es-desconto-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
IF AVAIL es-desconto-duplic THEN DO:
    FOR EACH es-desconto-item NO-LOCK WHERE es-desconto-item.nr-solicita = es-desconto-duplic.nr-solicita BREAK BY es-desconto-item.it-codigo:
        IF es-desconto-item.motivo <> " " THEN DO:

            ASSIGN l-itens = YES.
                  
            IF i = 1 THEN DO:
                ASSIGN c-item1 = "ITEM " + es-desconto-item.it-codigo + "-" + es-desconto-item.motivo.
            END.

            IF i = 2 THEN DO:
                ASSIGN c-item2 = "ITEM " + es-desconto-item.it-codigo + "-" + es-desconto-item.motivo.
            END.

            IF i = 3 THEN DO:
                ASSIGN c-item3 = "ITEM " + es-desconto-item.it-codigo + "-" + es-desconto-item.motivo.
            END.

            IF i = 4 THEN DO:
                ASSIGN c-item4 = "ITEM " + es-desconto-item.it-codigo + "-" + es-desconto-item.motivo.
            END.

            IF i = 5 THEN DO:
                ASSIGN c-item5 = "ITEM " + es-desconto-item.it-codigo + "-" + es-desconto-item.motivo.
            END.

            ASSIGN i = i + 1.
        END.
    END.
END.

IF es-desconto-duplic.motivo <> " " THEN DO:
    IF c-motivo <> " " THEN DO:
        ASSIGN c-motivo = c-motivo + " OBS: " + es-desconto-duplic.motivo.  
    END.
    ELSE ASSIGN c-motivo = "OBS: " + es-desconto-duplic.motivo.
END.
/**/

FIND FIRST es-desconto-duplic WHERE es-desconto-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
IF AVAIL es-desconto-duplic THEN DO:

    FIND FIRST ws-p-venda WHERE es-desconto-duplic.nr-pedcli = ws-p-venda.nr-pedcli NO-LOCK NO-ERROR.
    FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.

    FIND FIRST nota-fiscal WHERE nota-fiscal.nr-pedcli = ws-p-venda.nr-pedcli 
                             AND nota-fiscal.nome-ab-cli = ws-p-venda.nome-abrev 
                             AND nota-fiscal.emite-duplic = YES NO-LOCK NO-ERROR.

    IF AVAIL nota-fiscal THEN DO:
                 
        FIND FIRST tit_acr WHERE tit_acr.cod_estab       = es-desconto-duplic.cod-estabel 
                             AND tit_acr.cod_empresa     = "1" 
                             AND tit_acr.cod_espec_docto = "DP" 
                             AND tit_acr.cod_ser_docto   = es-desconto-duplic.serie 
                             AND tit_acr.cod_tit_acr     = es-desconto-duplic.nr-nota-fis NO-LOCK NO-ERROR.

        FIND FIRST es-embarque-pedido WHERE es-embarque-pedido.nr-pedcli  = ws-p-venda.nr-pedcli 
                                        AND es-embarque-pedido.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.

        IF AVAIL es-embarque-pedido THEN DO:
            FIND FIRST es-embarque WHERE es-embarque.nr-fila = es-embarque-pedido.nr-fila NO-LOCK NO-ERROR.
            FIND FIRST transporte WHERE transporte.cod-transp = es-embarque.cod-transp NO-LOCK NO-ERROR.
        END.
    END.

    ASSIGN c-observacoes   = "".

    IF AVAIL ws-p-venda THEN DO:
        RUN pi-formata (INPUT TRIM(c-motivo), 500).
        FIND FIRST t-texto NO-LOCK NO-ERROR.

        IF AVAIL t-texto THEN DO:
            FOR EACH t-texto:
                IF t-texto.conteudo <> "" THEN
                    ASSIGN c-observacoes = c-observacoes + " " + t-texto.conteudo.
            END.
        END.
    END.

    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = es-desconto-duplic.usuar-implant NO-LOCK NO-ERROR.

    /* usuarios cc */
    FIND FIRST es-desconto-duplic WHERE es-desconto-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
    IF AVAIL es-desconto-duplic THEN DO:
        FOR EACH es-desconto-info WHERE es-desconto-info.nr-solicita = es-desconto-duplic.nr-solicita NO-LOCK:
            IF AVAIL es-desconto-info THEN DO:
                FIND FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuar = es-desconto-info.usuar-copia NO-ERROR.
                IF AVAIL usuar_mestre THEN DO:
                    ASSIGN usuario-cc = usuario-cc + usuar_mestre.nom_usuario + CHR(10).
                END.
            END.
        END.
    END. 

    /* usuarios aprovadores */
    FIND FIRST es-desconto-duplic WHERE es-desconto-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
    IF AVAIL es-desconto-duplic THEN DO:
        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuar = es-desconto-duplic.usuar-aprov1 NO-LOCK NO-ERROR.
        ASSIGN c-aprovador1 = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuar = es-desconto-duplic.usuar-aprov2 NO-LOCK NO-ERROR.
        ASSIGN c-aprovador2 = IF AVAIL usuar_mestre AND es-desconto-duplic.usuar-aprov2 <> es-desconto-duplic.usuar-aprov1 THEN 
                                usuar_mestre.nom_usuario ELSE "".
    END. 

    ASSIGN usuario-implantacao = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "erick.souza@tortuga.com.br".
    
    ASSIGN assunts = "DESCONTO NO RECEBIMENTO DE DUPLICATA - VLL " + STRING(cod-solicita) + "/" + STRING(YEAR(TODAY)).
    ASSIGN numero = "No.: " + STRING(cod-solicita) + "/" + STRING(YEAR(TODAY))
           data-implantacao = "Data: " + STRING(es-desconto-duplic.dt-implant)
           ref = "Ref.: DESCONTO NO RECEBIMENTO DE DUPLICATA".

    ASSIGN cbody1 = "Gentileza efetuar o desconto na duplicata, conforme abaixo:"
           cbody2 = IF AVAIL es-desconto-duplic THEN "FRETE.......... " + STRING(es-desconto-duplic.nr-frete) ELSE "FRETE.......... "
           cbody3 = IF AVAIL nota-fiscal THEN "N.F.F.......... "        + STRING(nota-fiscal.nr-nota-fis) ELSE "N.F.F.......... "
           cbody4 = IF AVAIL tit_acr THEN "DUPLICATA...... "             + string(tit_acr.cod_tit_acr) ELSE "DUPLICATA...... " 
           cbody5 = IF AVAIL nota-fiscal THEN "FILIAL......... "        + STRING(nota-fiscal.cod-estabel) ELSE "FILIAL......... "
           cbody6 = IF AVAIL emitente THEN "CLIENTE........ "           + emitente.nome-emit ELSE "CLIENTE........ "
           cbody7 = IF AVAIL emitente THEN "COD............ "           + STRING(emitente.cod-emitente) ELSE "COD............ "
           cbody8 = IF AVAIL es-desconto-duplic THEN "DESCONTO....... " + "R$ " + STRING(DEC(es-desconto-duplic.vl-tot-desc),">,>>>,>>>.99") ELSE "DESCONTO....... " + "R$ 0,00" 
           cbody9 = "MOTIVO........."    + c-observacoes
           cbody10 = usuario-implantacao.
           /*cbody10 = "   " + quem-envia.*/

    /*CHAMADA PARA A ROTINA DE CONVERSAO DE MOEDA POR EXTENSO*/
    /* POR RODRIGO PELOSINI */
    RUN esp/valor-por-extenso-2.p (INPUT DEC(es-desconto-duplic.vl-tot-desc), OUTPUT VALOR-EXTENSO, INPUT "real","reais","centavo" ).
    /* FIM CHAMADA PARA A ROTINA DE CONVERSAO DE MOEDA POR EXTENSO*/                                                                                                                                                      

    IF l-itens = NO  THEN DO:
        ASSIGN c-out-de         = mail-envia
               c-out-assunto    = assunts
               c-out-mensagem   = "                                                    " + numero + CHR(10) +
                            "                                                    " + data-implantacao + CHR(10) + CHR(10) +
                            "     " + ref + CHR(10) + CHR(10) + CHR(10) +
                            cbody1 + CHR(10) + CHR(10) + CHR(10) +
                            cbody2 + CHR(10) +
                            cbody3 + CHR(10) +
                            cbody4 + CHR(10) +
                            cbody5 + CHR(10) +
                            cbody6 + CHR(10) +
                            cbody7 + CHR(10) +
                            /*cbody8 + CHR(10) +*/
                            cbody9 + CHR(10) + CHR(10) +
                            cbody8 + VALOR-EXTENSO + CHR(10) + CHR(10) + CHR(10) +
                            "Sem mais" + CHR(10) + CHR(10) + CHR(10) +
                            cbody10 + CHR(10) + CHR(10) +
                            "CC: " + chr(10) + usuario-cc + CHR(10) + CHR(10) +
                            "Aprovadores: " + CHR(10) + c-aprovador1 + CHR(10) + c-aprovador2. 
    END.
    ELSE DO:
        ASSIGN c-out-de = mail-envia
        /*        c-out-para = mail-envia */
               c-out-assunto = assunts
               c-out-mensagem = "                                                    " + numero + CHR(10) +
                                "                                                    " + data-implantacao + CHR(10) + CHR(10) +
                                "     " + ref + CHR(10) + CHR(10) + CHR(10) +
                                cbody1 + CHR(10) + CHR(10) + CHR(10) +
                                cbody2 + CHR(10) +
                                cbody3 + CHR(10) +
                                cbody4 + CHR(10) +
                                cbody5 + CHR(10) +
                                cbody6 + CHR(10) +
                                cbody7 + CHR(10) +
                                /*cbody8 + CHR(10) +*/
                                "  " + SUBSTRING(c-item1,1,70) + CHR(10) +
                                "  " + SUBSTRING(c-item2,1,70) + CHR(10) + 
                                "  " + SUBSTRING(c-item3,1,70) + CHR(10) + 
                                "  " + SUBSTRING(c-item4,1,70) + CHR(10) + 
                                "  " + SUBSTRING(c-item5,1,70) + CHR(10) + CHR(10) +
                                cbody8 + VALOR-EXTENSO + CHR(10) + CHR(10) + CHR(10) +
                                "Sem mais" + CHR(10) + CHR(10) + CHR(10) +
                                cbody10 + CHR(10) + CHR(10) +
                                "CC: " + chr(10) + usuario-cc + CHR(10) + CHR(10) +
                                "Aprovadores: " + CHR(10) + c-aprovador1 + CHR(10) + c-aprovador2. 
    
    END.

    IF adm-ambiente <> "PRODUCAO" THEN
        c-out-assunto = c-out-assunto + " (TESTE DE HOMOLOGACAO - DESCONSIDERE)".

    /* Execucao Envia Mail para usuarios parametrizados no Sistema */
    FOR EACH es-desconto-mail:
        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = es-desconto-mail.cod-usuario NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN DO:
    
            ASSIGN c-mail-destino = usuar_mestre.cod_e_mail_local.
    
            /* Caso seja um email tortuga, dispara internamente */
            IF INDEX(c-mail-destino,"@tortuga.com.br") > 0 THEN DO:
                
                RUN mail/wsmail.p (INPUT c-out-de,
                                   INPUT c-mail-destino,
                                   INPUT c-out-assunto,
                                   INPUT c-out-mensagem,
                                   OUTPUT l-out-error).
            END.
            ELSE DO:
                /* Caso seja um email externo (@dsm) dispara externamente via pescador no servidor */
                CREATE es-comunica-cliente-envio.
                ASSIGN es-comunica-cliente-envio.char-1         = c-out-de
                       es-comunica-cliente-envio.destino        = c-mail-destino
                       es-comunica-cliente-envio.texto-mensagem = c-out-mensagem
                       es-comunica-cliente-envio.nome-abrev     = "DESCONTO-DUPLIC"
                       es-comunica-cliente-envio.nr-pedcli      = STRING(cod-solicita).
            END.
    
            ASSIGN c-mail-destino = "".
        END.
    END.
    /**/
END.

/*Formata texto*/
PROCEDURE pi-formata:

    DEF INPUT PARAM c-editor    AS CHAR NO-UNDO.
    DEF INPUT PARAM i-len       AS INTEGER NO-UNDO.
    
    DEF VAR i-linha AS INTEGER NO-UNDO.
    DEF VAR i-aux   AS INTEGER NO-UNDO.
    DEF VAR c-aux   AS CHAR NO-UNDO.
    DEF VAR c-ret   AS CHAR NO-UNDO.
    
    FOR EACH t-texto:
        DELETE t-texto.
    END.
    
    ASSIGN c-ret = CHR(255) + CHR(255). 
    
    DO WHILE c-editor <> "": 
        IF c-editor <> "" THEN DO:
            ASSIGN i-aux = INDEX(c-editor, CHR(10)). 
            IF i-aux > i-len OR (i-aux = 0 AND LENGTH(c-editor) > i-len) THEN
                ASSIGN i-aux = R-INDEX(c-editor, " ", i-len + 1). 
            IF i-aux = 0 THEN
                ASSIGN c-aux = SUBSTR(c-editor, 1, i-len)
                       c-editor = SUBSTR(c-editor, i-len + 1).
            ELSE
                ASSIGN c-aux = SUBSTR(c-editor, 1, i-aux - 1)
                c-editor = SUBSTR(c-editor, i-aux + 1). 
            IF i-len = 0 THEN 
                ASSIGN ENTRY(1, c-ret, CHR(255)) = c-aux. 
            ELSE DO: 
                ASSIGN i-linha = i-linha + 1. 
                CREATE t-texto. 
                ASSIGN t-texto.linha = i-linha 
                t-texto.conteudo = c-aux. 
            END.
        END.
        IF i-len = 0 THEN
            RETURN c-ret. 
    END.

    RETURN c-ret.

END PROCEDURE.
