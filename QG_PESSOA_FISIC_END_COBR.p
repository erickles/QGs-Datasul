OUTPUT TO "c:\temp\pessoa_fisic_2.csv".

FOR EACH pessoa_fisic WHERE TRIM(pessoa_fisic.cod_cep_cobr) = "" :

    FIND FIRST emsuni.cliente WHERE emsuni.cliente.num_pessoa = pessoa_fisic.num_pessoa_fisic
        NO-LOCK NO-ERROR.
    IF AVAIL emsuni.cliente THEN DO:
        
        FIND FIRST emitente WHERE emitente.cod-emitente = cliente.cdn_cliente NO-LOCK NO-ERROR.
        IF AVAIL emitente AND emitente.identific <> 2 THEN DO:

            PUT cliente.cdn_cliente             ";"
                pessoa_fisic.num_pessoa_fisic   ";"
                SKIP.

            ASSIGN pessoa_fisic.cod_cep_cobr = emitente.cep-cob.

            /*
            ASSIGN pessoa_fisic.cod_cx_post_cobr        = emitente.cx-post-cob /*emitente.cep-cob emitente.cgc-cob */
                   pessoa_fisic.cod_e_mail_cobr         = ""
                   pessoa_fisic.cod_pais_cobr           = "BRA"
                   pessoa_fisic.cod_unid_federac_cobr   = emitente.estado-cob
                   pessoa_fisic.nom_bairro_cobr         = emitente.bairro-cob
                   pessoa_fisic.nom_cidad_cobr          = emitente.cidade-cob
                   pessoa_fisic.nom_condad_cobr         = ""
                   pessoa_fisic.nom_ender_cobr          = emitente.endereco-cob
                   pessoa_fisic.nom_ender_cobr_text     = emitente.endereco-cob-text
                   pessoa_fisic.nom_ender_compl_cobr    = "".
            */
        END.
    END.

END.

OUTPUT CLOSE.
