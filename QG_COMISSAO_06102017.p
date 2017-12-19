DEFINE VARIABLE c-mais-que-30 AS CHARACTER   NO-UNDO.

FIND FIRST es-param-comis NO-LOCK WHERE es-param-comis.ep-codigo = "1" NO-ERROR.

FIND FIRST tit_acr WHERE tit_acr.cod_estab       = "12"
                     AND tit_acr.cod_espec_docto = "DP"
                     AND tit_acr.cod_ser_docto   = "4"
                     AND tit_acr.cod_tit_acr     = "0053304"
                     AND tit_acr.cod_parcela     = "01"
                     NO-LOCK NO-ERROR.
IF AVAIL tit_acr THEN DO:
    
    FOR EACH movto_tit_acr OF tit_acr WHERE movto_tit_acr.ind_trans_acr_abrev = "LIQ" 
                                         OR movto_tit_acr.ind_trans_acr_abrev = "LQTE":
        
        IF movto_tit_acr.dat_trans < TODAY - 35     /*AND 
            ROWID(tit_acr) <> gr-titulo-rt*/          THEN 
       NEXT.

        FOR EACH repres_tit_acr NO-LOCK WHERE repres_tit_acr.cod_estab              = movto_tit_acr.cod_estab
                                          AND repres_tit_acr.num_id_tit_acr         = movto_tit_acr.num_id_tit_acr        
                                          AND repres_tit_acr.cdn_repres             = tit_acr.cdn_repres
                                          AND repres_tit_acr.val_perc_comis_repres  < 100:

            FIND FIRST es-repres-comis WHERE es-repres-comis.cod-rep = repres_tit_acr.cdn_repres NO-LOCK NO-ERROR.

            IF NOT AVAIL es-repres-comis THEN 
                NEXT.

            IF movto_tit_acr.dat_trans < 05/01/2001 THEN
                NEXT.

            IF tit_acr.cod_portador = "98008" OR tit_acr.cod_portador = "98009" OR tit_acr.cod_portador = "98010" THEN
                NEXT.

            IF  movto_tit_acr.dat_liquidac_tit_acr <> ? AND 
            (movto_tit_acr.dat_liquidac_tit_acr > (movto_tit_acr.dat_vencto_tit_acr + 30)) AND 
            movto_tit_acr.dat_liquidac_tit_acr < 01/20/2011 AND 
            es-repres-comis.u-int-1 < 4 THEN 
            NEXT.

            IF  movto_tit_acr.dat_trans > (movto_tit_acr.dat_vencto_tit_acr + 30) THEN
                ASSIGN c-mais-que-30 = "*".
            ELSE
                ASSIGN c-mais-que-30 = " ".

            MESSAGE "ok" c-mais-que-30
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

            FIND LAST es-movto-comis NO-LOCK WHERE es-movto-comis.ep-codigo   = "TOR"
                                               AND es-movto-comis.cod-estabel = repres_tit_acr.cod_estab
                                               AND es-movto-comis.cod-rep     = repres_tit_acr.cdn_repres
                                               AND es-movto-comis.tp-movto    = es-param-comis.cod-baixa-normal
                                               NO-ERROR.
                                       /*
                                       AND es-movto-comis.dt-trans    = movto_tit_acr.dat_transacao
                                       AND es-movto-comis.nro-docto   = tit_acr.cod_tit_acr
                                       AND es-movto-comis.parcela     = tit_acr.cod_parcela
                                       AND es-movto-comis.referencia  = "Baixas"
                                       AND es-movto-comis.valor       = ROUND((movto_tit_acr.val_movto_tit_acr * tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr) *
                                                                       (repres_tit_acr.val_perc_comis_repres * ( 100 - repres_tit_acr.val_perc_comis_repres_emis) / 10000),2)
                                       AND (es-movto-comis.u-int-1     = movto_tit_acr.num_id_movto_tit_acr OR
                                           es-movto-comis.u-int-1     = 0)
                                       NO-ERROR.
                                       */
            IF NOT AVAIL es-movto-comis THEN DO:
                MESSAGE "nao achou"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                /*
               CREATE es-movto-comis.
               ASSIGN es-movto-comis.ep-codigo            = "1"
                      es-movto-comis.cod-estabel          = repres_tit_acr.cod_estab 
                      es-movto-comis.cod-rep              = repres_tit_acr.cdn_repres
                      es-movto-comis.tp-movto             = es-param-comis.cod-baixa-normal
                      es-movto-comis.dt-trans             = movto_tit_acr.dat_transacao
                      es-movto-comis.nro-docto            = tit_acr.cod_tit_acr   
                      es-movto-comis.parcela              = tit_acr.cod_parcela
                      es-movto-comis.referencia           = "Baixas"
                      es-movto-comis.u-int-1              = movto_tit_acr.num_id_movto_tit_acr
                      SUBSTR(es-movto-comis.u-char-2,1,1) = c-mais-que-30.
    
               ASSIGN da-data-nova = tit_acr.dat_ult_liquidac_tit_acr.
               RUN pi-acha-apuracao.
               ASSIGN es-movto-comis.dt-apuracao = da-data-nova
                      es-movto-comis.u-date-1    = da-data-real.
    
               ASSIGN es-movto-comis.dt-today    = TODAY
                      es-movto-comis.esp-docto   = /*repres_tit_acr.cod_espec_docto*/ tit_acr.cod_espec_docto
                      es-movto-comis.origem      = "TWFIN490"
                      es-movto-comis.usuario     = IF v_cod_usuar_corren <> " " THEN v_cod_usuar_corren ELSE v5_cod_usuar_corren
                      es-movto-comis.serie       = tit_acr.cod_ser_docto
                      es-movto-comis.valor       = ROUND((movto_tit_acr.val_movto_tit_acr * tit_acr.val_liq_tit_acr / tit_acr.val_origin_tit_acr) *
                                                   (repres_tit_acr.val_perc_comis_repres * ( 100 - repres_tit_acr.val_perc_comis_repres_emis) / 10000),2).
    
               IF ROWID(tit_acr) = gr-titulo-rt  THEN DO:
                  es-movto-comis.observacao = "Comissao Reativada".
               END.
               */
            END.

        END.

    END.

END.
