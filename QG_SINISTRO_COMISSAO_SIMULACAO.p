DEFINE BUFFER bf-movto-comis FOR es-movto-comis.
DEFINE BUFFER bf_tit_acr     FOR tit_acr.

DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO.
DEFINE VARIABLE deValorFinal AS DECIMAL     NO-UNDO.

FIND FIRST tit_acr WHERE tit_acr.cdn_cliente     = 248521
                     AND tit_acr.cod_empresa     = "TOR"
                     AND tit_acr.cod_estab       = "12"
                     AND tit_acr.cod_espec_docto = "ANN"
                     AND tit_acr.cod_parcela     = "01"
                     AND tit_acr.cod_ser_docto   = "4"
                     AND tit_acr.cod_tit_acr     = "0038298"
                     NO-LOCK NO-ERROR.

IF NOT AVAIL tit_acr THEN DO:
        
    FIND FIRST bf_tit_acr WHERE bf_tit_acr.cdn_cliente     = 163593
                            AND bf_tit_acr.cod_empresa     = "TOR"
                            AND bf_tit_acr.cod_estab       = "05"
                            AND bf_tit_acr.cod_espec_docto = "DP"     
                            AND bf_tit_acr.cod_parcela     = "03"       
                            AND bf_tit_acr.cod_ser_docto   = "1"        
                            AND bf_tit_acr.cod_tit_acr     = "0095810"  
                            NO-LOCK NO-ERROR.

    FOR EACH movto_tit_acr OF bf_tit_acr NO-LOCK:
        
        FOR EACH aprop_ctbl_acr OF movto_tit_acr WHERE aprop_ctbl_acr.cod_cta_ctbl = "3710601" NO-LOCK:

            FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis = bf_tit_acr.cod_tit_acr
                                    AND nota-fiscal.serie        = bf_tit_acr.cod_ser_docto
                                    AND nota-fiscal.cod-estabel  = bf_tit_acr.cod_estab
                                    AND nota-fiscal.cod-emitente = bf_tit_acr.cdn_cliente
                                    NO-LOCK NO-ERROR.

            FIND FIRST repres WHERE repres.nome-abrev = nota-fiscal.no-ab-reppri NO-LOCK NO-ERROR.

            FIND FIRST repres_tit_acr WHERE repres_tit_acr.num_id_tit_acr = bf_tit_acr.num_id_tit_acr NO-LOCK NO-ERROR.
            IF AVAIL repres_tit_acr THEN DO:
                
                ASSIGN deValor = 0
                       deValor = ((movto_tit_acr.val_movto_tit_acr * repres_tit_acr.val_perc_comis_repres) / 100).

                MESSAGE "Valor do movimento" deValor                                                    SKIP
                        "Percentual de comissao do representante" repres_tit_acr.val_perc_comis_repres  SKIP
                        "Valor da comissao sobre o valor do movimento" deValor
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

            END.

            FIND FIRST bf-movto-comis WHERE bf-movto-comis.ep-codigo   = 1
                                        AND bf-movto-comis.cod-estabel = nota-fiscal.cod-estabel
                                        AND bf-movto-comis.cod-rep     = repres.cod-rep
                                        AND bf-movto-comis.tp-movto    = 200
                                        AND bf-movto-comis.dt-trans    <= TODAY
                                        AND bf-movto-comis.nro-docto   = nota-fiscal.nr-nota-fis
                                        AND bf-movto-comis.parcela     = bf_tit_acr.cod_parcela
                                        AND bf-movto-comis.serie       = nota-fiscal.serie
                                        NO-LOCK NO-ERROR.

            IF AVAIL bf-movto-comis THEN DO:

                ASSIGN deValorFinal = 0
                       deValorFinal = IF AVAIL bf-movto-comis THEN deValor - bf-movto-comis.valor ELSE deValor.

                IF deValorFinal < 0 THEN
                    deValorFinal = deValorFinal * -1.

                MESSAGE "Achou o movimento de comissao - venda" SKIP
                        "O estorno a ser gerado seria o valor total de comissao " deValor SKIP
                        "menos o valor do movimento de comissao " bf-movto-comis.valor    SKIP
                        "Valor a ser estornado sera de " deValorFinal
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                FIND FIRST es-movto-comis WHERE es-movto-comis.ep-codigo   = 1
                                            AND es-movto-comis.cod-estabel = nota-fiscal.cod-estabel
                                            AND es-movto-comis.nro-docto   = nota-fiscal.nr-nota-fis
                                            AND es-movto-comis.parcela     = tit_acr.cod_parcela
                                            AND es-movto-comis.esp-docto   = tit_acr.cod_espec_docto
                                            AND es-movto-comis.tp-movto    = 100
                                            AND es-movto-comis.serie       = nota-fiscal.serie
                                            AND es-movto-comis.cod-rep     = repres.cod-rep
                                            AND es-movto-comis.dt-apuracao = movto_tit_acr.dat_transacao
                                            AND es-movto-comis.dt-trans    = movto_tit_acr.dat_transacao
                                            AND es-movto-comis.Observacao  = "SINISTRO"
                                            AND es-movto-comis.origem      = "ACR"
                                            AND es-movto-comis.referencia  = "SINISTRO"
                                            NO-ERROR.

                IF AVAIL es-movto-comis THEN DO:
                    
                    IF es-movto-comis.valor < 0 THEN
                        es-movto-comis.valor = es-movto-comis.valor * -1.

                    MESSAGE "Foi gerado o estorno de comissao de venda com o valor de" es-movto-comis.valor SKIP
                            "Data de apuracao " es-movto-comis.dt-apuracao                                  SKIP
                            "Repres: " es-movto-comis.cod-rep                                               SKIP
                            "Doc." es-movto-comis.nro-docto
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.

            END.
            
            FIND FIRST bf-movto-comis WHERE bf-movto-comis.ep-codigo   = 1
                                        AND bf-movto-comis.cod-estabel = nota-fiscal.cod-estabel
                                        AND bf-movto-comis.cod-rep     = repres.cod-rep
                                        AND bf-movto-comis.tp-movto    = 201
                                        AND bf-movto-comis.dt-trans    <= TODAY
                                        AND bf-movto-comis.nro-docto   = nota-fiscal.nr-nota-fis
                                        AND bf-movto-comis.parcela     = tit_acr.cod_parcela
                                        AND bf-movto-comis.serie       = nota-fiscal.serie
                                        NO-LOCK NO-ERROR.

            IF AVAIL bf-movto-comis THEN DO:

                MESSAGE "Achou o movimento de comissao - cobranca"  SKIP
                        "O estorno a ser gerado seria o valor total de comissao " deValor SKIP
                        "menos o valor do movimento de comissao " bf-movto-comis.valor
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.

                FIND FIRST es-movto-comis WHERE es-movto-comis.ep-codigo   = 1
                                            AND es-movto-comis.cod-estabel = nota-fiscal.cod-estabel
                                            AND es-movto-comis.nro-docto   = nota-fiscal.nr-nota-fis
                                            AND es-movto-comis.parcela     = tit_acr.cod_parcela
                                            AND es-movto-comis.esp-docto   = tit_acr.cod_espec_docto
                                            AND es-movto-comis.tp-movto    = 101
                                            AND es-movto-comis.serie       = nota-fiscal.serie
                                            AND es-movto-comis.cod-rep     = repres.cod-rep
                                            AND es-movto-comis.dt-apuracao = movto_tit_acr.dat_transacao
                                            AND es-movto-comis.dt-trans    = movto_tit_acr.dat_transacao
                                            AND es-movto-comis.Observacao  = "SINISTRO"
                                            AND es-movto-comis.origem      = "ACR"
                                            AND es-movto-comis.referencia  = "SINISTRO"
                                            NO-ERROR.

                IF AVAIL es-movto-comis THEN DO:

                    IF es-movto-comis.valor < 0 THEN
                        es-movto-comis.valor = es-movto-comis.valor * -1.

                    MESSAGE "Foi gerado o estorno de comissao de cobranca com o valor de" es-movto-comis.valor  SKIP
                            "Data de apuracao " es-movto-comis.dt-apuracao                                      SKIP
                            "Repres: " es-movto-comis.cod-rep                                                   SKIP
                            "Doc." es-movto-comis.nro-docto
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.

            END.
            
        END.

    END.

END.
