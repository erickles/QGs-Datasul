{include/i-buffer.i}
DEFINE VAR mail-envia           AS CHAR FORMAT "X(30)"  NO-UNDO.
DEFINE VAR cod-solicita         AS INT FORMAT 9999      NO-UNDO.
DEFINE VAR quem-envia           AS CHAR FORMAT "X(50)"  NO-UNDO.
DEFINE VARIABLE c-mail-destino  AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c-observacoes           AS CHAR NO-UNDO.
DEFINE VARIABLE c-copias                AS CHAR NO-UNDO.
DEFINE VARIABLE c--destino AS CHAR INITIAL "" NO-UNDO.
DEFINE VARIABLE c-motivo                AS CHAR NO-UNDO.

DEF STREAM s-anexa.

DEF VAR assunts AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody1 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody2 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody3 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody4 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody5 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody6 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody7 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody8 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody9 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody10 AS CHAR INITIAL "" NO-UNDO.
DEF VAR cbody11 AS CHAR INITIAL "" NO-UNDO.
DEF VAR numero AS CHAR INITIAL "" NO-UNDO.
DEF VAR data-implantacao AS CHAR INITIAL "" NO-UNDO.
DEF VAR ref AS CHAR INITIAL "" NO-UNDO.
DEF VAR usuario-implantacao AS CHAR INITIAL "" NO-UNDO.
DEF VAR usuario-cc AS CHAR INITIAL "" NO-UNDO.
DEF VAR c-aprovador1 AS CHAR INITIAL "" NO-UNDO.
DEF VAR c-aprovador2 AS CHAR INITIAL "" NO-UNDO.

/**************VAR DE ENVIO DO EMAIL***************************/
DEF VAR c-out-de           AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR c-out-para         AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR c-out-assunto      AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR c-out-mensagem     AS CHAR FORMAT "x(430)" NO-UNDO.
DEF VAR c-out-assinatura   AS CHAR FORMAT "x(30)" NO-UNDO.
DEF VAR c-out-anexo        AS CHAR FORMAT "x(30)" NO-UNDO.

DEFINE VARIABLE c-conteudo   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-out-error  AS LOGICAL NO-UNDO.
/**************VAR DE ENVIO DO EMAIL***************************/
DEF TEMP-TABLE t-texto NO-UNDO 
    FIELD linha AS INTEGER 
    FIELD conteudo AS CHARACTER FORMAT "x(500)"
INDEX primario IS PRIMARY UNIQUE linha. 

UPDATE mail-envia   LABEL "E-mail origem"
       cod-solicita LABEL "Solicitacao"
       quem-envia   LABEL "Remetente"
       WITH 1 COL.

/*Gera Motivo*/
FIND FIRST es-prorroga-duplic WHERE es-prorroga-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
     IF AVAIL es-prorroga-duplic THEN DO:

        IF es-prorroga-duplic.motivo <> " " THEN DO:
             ASSIGN c-motivo = es-prorroga-duplic.motivo.
        END.
END.
/**/

FIND FIRST es-prorroga-duplic WHERE es-prorroga-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
     IF AVAIL es-prorroga-duplic THEN DO:

     FIND FIRST ws-p-venda WHERE es-prorroga-duplic.nr-pedcli = ws-p-venda.nr-pedcli NO-LOCK NO-ERROR.
     FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.

     FIND FIRST nota-fiscal WHERE nota-fiscal.nr-pedcli = ws-p-venda.nr-pedcli 
                              and nota-fiscal.nome-ab-cli = ws-p-venda.nome-abrev 
                              AND nota-fiscal.emite-duplic = YES NO-LOCK NO-ERROR.

           IF AVAIL nota-fiscal THEN DO:
                 
                 FIND FIRST titulo WHERE titulo.cod-estabel = es-prorroga-duplic.cod-estabel and
                                         titulo.ep-codigo   = 1 AND                  
                                         titulo.cod-esp     = "DP" AND               
                                         titulo.serie       = es-prorroga-duplic.serie AND  
                                         titulo.nr-docto    = es-prorroga-duplic.nr-nota-fis NO-LOCK NO-ERROR.


                 FIND FIRST es-embarque-pedido WHERE es-embarque-pedido.nr-pedcli  = ws-p-venda.nr-pedcli 
                                                 AND es-embarque-pedido.nome-abrev = ws-p-venda.nome-abrev NO-LOCK NO-ERROR.

                 IF AVAIL es-embarque-pedido THEN DO:
                      FIND FIRST es-embarque WHERE es-embarque.nr-fila = es-embarque-pedido.nr-fila NO-LOCK NO-ERROR.
                      FIND FIRST transporte WHERE transporte.cod-transp = es-embarque.cod-transp NO-LOCK NO-ERROR.
                 END.
           END.


        ASSIGN c-observacoes   = "".
        IF AVAIL ws-p-venda THEN DO:
          RUN pi-formata (INPUT trim(c-motivo), 500).
          FIND FIRST t-texto NO-LOCK NO-ERROR.
          IF AVAIL t-texto THEN DO:
          FOR EACH t-texto:
            IF t-texto.conteudo <> "" THEN
              ASSIGN c-observacoes = c-observacoes + " " + t-texto.conteudo.
            END.
          END.
        END.


        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = es-prorroga-duplic.usuar-implant NO-LOCK NO-ERROR.
        /* usuarios cc */
        FIND FIRST es-prorroga-duplic WHERE es-prorroga-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
             IF AVAIL es-prorroga-duplic THEN DO:
                 FOR EACH es-desconto-info WHERE es-desconto-info.nr-solicita = es-prorroga-duplic.nr-solicita NO-LOCK:
                        IF AVAIL es-desconto-info THEN DO:
                            FIND FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuar = es-desconto-info.usuar-copia NO-ERROR.
                                  IF AVAIL usuar_mestre THEN DO:
                                       ASSIGN usuario-cc = usuario-cc + usuar_mestre.nom_usuario + CHR(10).
                                  END.
                        END.
                 END.
             END. 

        /* usuarios aprovadores */
             FIND FIRST es-prorroga-duplic WHERE es-prorroga-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
                  IF AVAIL es-prorroga-duplic THEN DO:
                      FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuar = es-prorroga-duplic.usuar-aprov1 NO-LOCK NO-ERROR.
                        ASSIGN c-aprovador1 = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE "".

                      FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuar = es-prorroga-duplic.usuar-aprov2 NO-LOCK NO-ERROR.
                        ASSIGN c-aprovador2 = IF AVAIL usuar_mestre AND 
                            es-prorroga-duplic.usuar-aprov2 <> es-prorroga-duplic.usuar-aprov1 
                            THEN usuar_mestre.nom_usuario ELSE "".
                  END. 

        ASSIGN usuario-implantacao = IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE quem-envia.

        ASSIGN assunts = "PRORROGA°€O DE DUPLICATA - VLL " + STRING(cod-solicita) + "/" + STRING(YEAR(TODAY)).

        ASSIGN numero = "No.: " + STRING(cod-solicita) + "/" + STRING(YEAR(TODAY))
               data-implantacao = "Data: " + STRING(es-prorroga-duplic.dt-implant)
               ref = "Ref.: PRORROGA°€O DE DUPLICATA".

        ASSIGN cbody1 = "Gentileza efetuar prorroga»’o na duplicata, conforme abaixo:"
               cbody2 = IF AVAIL nota-fiscal THEN "NOTA FISCAL........... " + STRING(nota-fiscal.nr-nota-fis) ELSE "NOTA FISCAL........... "
               cbody3 = IF AVAIL nota-fiscal THEN "FILIAL................ " + STRING(nota-fiscal.cod-estabel) ELSE "FILIAL................ "
               cbody4 = IF AVAIL titulo THEN "DUPLICATA............. " + string(titulo.nr-docto) ELSE "DUPLICATA............. " 
               cbody5 = IF AVAIL nota-fiscal THEN "FATURAMENTO........... " + STRING(nota-fiscal.dt-emis-nota) ELSE "FATURAMENTO........... "
               cbody6 = IF AVAIL emitente THEN "CLIENTE............... "    + emitente.nome-emit ELSE "CLIENTE............... "
               cbody7 = IF AVAIL emitente THEN "COD................... "    + STRING(emitente.cod-emitente) ELSE "COD................... "
               cbody8 = "MOTIVO................ "  + c-observacoes
               cbody9 = IF AVAIL es-prorroga-duplic THEN "PRORROGAR (DIAS)...... " + STRING(es-prorroga-duplic.dias-prorroga) ELSE "PRORROGAR (DIAS)...... " 
               cbody10 = usuario-implantacao.   
        
        ASSIGN c-out-de = mail-envia
/*        c-out-para = mail-envia */
               c-out-assunto = assunts
               c-out-mensagem = "                                                    " + numero + CHR(10) +
                                "                                                    " + data-implantacao + CHR(10) + CHR(10) +
                                "     " + ref + CHR(10) + CHR(10) + CHR(10) +                        
                                cbody1 + CHR(10) + CHR(10) +
                                cbody2 + CHR(10) +
                                cbody3 + CHR(10) +
                                cbody4 + CHR(10) +
                                cbody5 + CHR(10) +
                                cbody6 + CHR(10) + CHR(10) +
                                cbody7 + CHR(10) + CHR(10) +
                                cbody9 + CHR(10) + CHR(10) + 
                                cbody8 + CHR(10) + CHR(10) + CHR(10) +
                                "Sem mais" + CHR(10) + CHR(10) + CHR(10) +
                                cbody10 + CHR(10) + CHR(10) +
                                "CC: " + chr(10) + usuario-cc + CHR(10) + CHR(10) +
                                "Aprovadores: " + CHR(10) + c-aprovador1 + CHR(10) + c-aprovador2. 
        
/* Execucao Envia Mail para usuarios parametrizados no Sistema */
FOR EACH es-desconto-mail:
     FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = es-desconto-mail.cod-usuario NO-LOCK NO-ERROR.
         IF AVAIL usuar_mestre THEN DO:

             ASSIGN c-mail-destino = usuar_mestre.cod_e_mail_local.
             RUN mail/wsmail.p (INPUT c-out-de,   /* remetente */
                                INPUT c-mail-destino,   /* destinatario */
                                INPUT c-out-assunto,
                                INPUT c-out-mensagem,
                                OUTPUT l-out-error).

             ASSIGN c-mail-destino = "".
         END.
END.
/**/
        
/*gera listagem de usuarios copia*/
FIND FIRST es-prorroga-duplic WHERE es-prorroga-duplic.nr-solicita = cod-solicita NO-LOCK NO-ERROR.
     IF AVAIL es-prorroga-duplic THEN DO:

         FOR EACH es-prorroga-mail WHERE es-prorroga-mail.nr-solicita = es-prorroga-duplic.nr-solicita NO-LOCK:

                IF AVAIL es-prorroga-mail THEN DO:
                    FIND FIRST usuar_mestre NO-LOCK WHERE usuar_mestre.cod_usuar = es-prorroga-mail.usuar-copia NO-ERROR.
                          IF AVAIL usuar_mestre THEN DO:

                               ASSIGN c-mail-destino = usuar_mestre.cod_e_mail_local.
                               RUN mail/wsmail.p (INPUT c-out-de,   /* remetente */
                                                  INPUT c-mail-destino,   /* destinatario */
                                                  INPUT c-out-assunto,
                                                  INPUT c-out-mensagem,
                                                  OUTPUT l-out-error).
                    
                               ASSIGN c-mail-destino = "".

                          END.
                END.
         END.
     END. 
/**/

END.


/*Formata texto*/
PROCEDURE pi-formata: 
    def input param c-editor as char no-undo. 
    def input param i-len as integer no-undo. 
    
    def var i-linha as integer no-undo. 
    def var i-aux as integer no-undo. 
    def var c-aux as char no-undo. 
    def var c-ret as char no-undo. 
    
    for each t-texto: 
    delete t-texto. 
    end. 
    
    assign c-ret = chr(255) + chr(255). 
    
    do while c-editor <> "": 
        if c-editor <> "" then do: 
            assign i-aux = index(c-editor, chr(10)). 
            if i-aux > i-len or (i-aux = 0 and length(c-editor) > i-len) then 
                assign i-aux = r-index(c-editor, " ", i-len + 1). 
            if i-aux = 0 then 
                assign c-aux = substr(c-editor, 1, i-len) 
                       c-editor = substr(c-editor, i-len + 1). 
            else 
                assign c-aux = substr(c-editor, 1, i-aux - 1) 
                c-editor = substr(c-editor, i-aux + 1). 
            if i-len = 0 then 
                assign entry(1, c-ret, chr(255)) = c-aux. 
            else do: 
                assign i-linha = i-linha + 1. 
                create t-texto. 
                assign t-texto.linha = i-linha 
                t-texto.conteudo = c-aux. 
            end. 
        end. 
        if i-len = 0 then 
            return c-ret. 
    end. 
    return c-ret. 
end procedure.



