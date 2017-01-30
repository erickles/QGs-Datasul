OUTPUT TO "c:\temp\notas_repres_com.csv".

PUT "cdn_fornecedor;"
    "cod_empresa;"
    "cod_espec_docto;"
    "cod_estab;"
    "cod_parcela;"
    "cod_tit_ap;"
    "cod_ser_docto;"
    "dat_emis_docto;"
    SKIP.

FOR EACH es-repres-docum WHERE NOT es-repres-docum.atualizado
    
                                   /*
                                   AND es-repres-docum.serie     = ""
                                   AND es-repres-docum.cod-emitente = 49169
                                   AND es-repres-docum.nro-docto = "0000256"*/ :
    
    FIND FIRST tit_ap WHERE tit_ap.cdn_fornecedor   = es-repres-docum.cod-emitente
                        AND tit_ap.cod_empresa      = "TOR"
                        AND tit_ap.cod_espec_docto  = "PC"
                        /*AND tit_ap.cod_estab        = es-repres-docum.cod-estab*/
                        AND tit_ap.cod_ser_docto    = es-repres-docum.serie
                        AND tit_ap.cod_tit_ap       = es-repres-docum.nro-docto
                        NO-LOCK NO-ERROR.

    IF AVAIL tit_ap THEN DO:

        es-repres-docum.atualizado = YES.

        PUT UNFORM tit_ap.cdn_fornecedor   ";"
                   tit_ap.cod_empresa      ";"
                   tit_ap.cod_espec_docto  ";"
                   tit_ap.cod_estab        ";"
                   tit_ap.cod_parcela      ";"
                   tit_ap.cod_tit_ap       ";"
                   tit_ap.cod_ser_docto    ";"
                   tit_ap.dat_emis_docto   SKIP.
        /*
        MESSAGE tit_ap.cdn_fornecedor 
                tit_ap.cod_empresa 
                tit_ap.cod_espec_docto 
                tit_ap.cod_estab 
                tit_ap.cod_parcela 
                tit_ap.cod_tit_ap 
                tit_ap.cod_ser_docto 
                tit_ap.dat_emis_docto
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                */
        
    END.
        
END.

OUTPUT CLOSE.
