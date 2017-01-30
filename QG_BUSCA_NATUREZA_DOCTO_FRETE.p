DEFINE VARIABLE cCodEstabel         AS CHAR    NO-UNDO.
DEFINE VARIABLE cNatOperNF          AS CHAR    NO-UNDO.
DEFINE VARIABLE cUFEstabel          AS CHAR    NO-UNDO.
DEFINE VARIABLE cUFTransp           AS CHAR    NO-UNDO.
DEFINE VARIABLE cUFNota             AS CHAR    NO-UNDO.
DEFINE VARIABLE vCodEmitente        AS INTEGER NO-UNDO.
DEFINE VARIABLE vCodEmitTransp      AS INTEGER NO-UNDO.
DEFINE VARIABLE vTipo               AS INTEGER NO-UNDO.
DEFINE VARIABLE vTpItem             AS INTEGER NO-UNDO.
DEFINE VARIABLE vAux                AS DECIMAL NO-UNDO.
DEFINE VARIABLE vBaseIcms           AS DECIMAL NO-UNDO.
DEFINE VARIABLE vVlrIcms            AS DECIMAL NO-UNDO.
DEFINE VARIABLE cCidadeTransp       AS CHAR    NO-UNDO.
DEFINE VARIABLE cCidadeEmit         AS CHAR    NO-UNDO.
DEFINE VARIABLE vInativo            as integer no-undo.

{utp/ut-glob.i}

/* Leitura do Registro */
/*                                                        */
/* FIND CURRENT docto-frete-nf NO-ERROR.                  */
/* MESSAGE docto-frete-nf.nr-documento VIEW-AS ALERT-BOX. */
/*                                                        */

FIND FIRST docto-frete-nf NO-LOCK WHERE docto-frete-nf.cnpj-emit        = "04113946000115"
                                    AND docto-frete-nf.serie            = "C"
                                    AND docto-frete-nf.nr-documento     = "141"
                                    /*AND docto-frete-nf.id-tp-docto      = 1*/
                                    AND docto-frete-nf.dt-emissao-docto = 01/18/2012
                                    NO-ERROR.
IF AVAIL docto-frete-nf THEN DO:
    
    /*Busca c¢digo do estabelecimento*/
    FIND FIRST estabelec WHERE estabelec.cgc = docto-frete-nf.cgc-rem NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN DO:
        ASSIGN cCodEstabel = estabelec.cod-estabel
               cUFEstabel  = estabelec.estado
               cCidadeEmit = estabelec.cidade.
    END.

    /* MVR - 16/09/2010 - Busca UF do Transportador */
    ASSIGN cUFTransp      = ''
           vCodEmitTransp = 0
           cCidadeTransp  = ''.

    FOR EACH emitente FIELDS(cod-emitente identific nome-abrev cgc nome-emit estado cidade) NO-LOCK 
       WHERE emitente.cgc = docto-frete-nf.cgc-transp
         AND NOT emitente.nome-emit BEGINS "** Eliminado"
         AND emitente.identific > 1 /* Tem que ser fornecedor */:

       /* Verifica se fornecedor esta inativo Inativo */
       FIND es-emit-fornec WHERE
            es-emit-fornec.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
       IF AVAIL es-emit-fornec AND es-emit-fornec.log-2 THEN NEXT.
       
       ASSIGN cUFTransp      = emitente.estado
              vCodEmitTransp = emitente.cod-emitente
              cCidadeTransp  = emitente.cidade.

       LEAVE.

    END.
    IF vCodEmitTransp = 0 THEN DO:
       FOR EACH emitente FIELDS(cod-emitente identific nome-abrev cgc nome-emit estado cidade) NO-LOCK 
           WHERE emitente.cgc = docto-frete-nf.cgc-transp
             AND NOT emitente.nome-emit BEGINS "** Eliminado"
             AND emitente.identific > 1 /* Tem que ser fornecedor */:
           /* Verifica se fornecedor esta inativo Inativo */
           FIND es-emit-fornec WHERE
                es-emit-fornec.cod-emitente = emitente.cod-emitente NO-LOCK NO-ERROR.
           IF AVAIL es-emit-fornec AND es-emit-fornec.log-2 THEN DO:
              MESSAGE "CGC Transp: " docto-frete-nf.cgc-transp SKIP
                      "Cod. Fornec: " emitente.cod-emitente    SKIP 
                      "Nome:" emitente.nome-emit               SKIP(2)
                      "TRANSPORTADORA INATIVA NA FUN€ÇO CD0401." SKIP
                      "ANTES DE ATIVAR A TRANSPORTADORA, É OBRIGATÓRIA A CONSULTA AO SINTEGRA E RECEITA FEDERAL."
                      VIEW-AS ALERT-BOX INFO BUTTONS OK.
              RETURN "NOK":U.
           END.   
       END.
       MESSAGE "CGC TRANSP: " docto-frete-nf.cgc-transp SKIP(2)
               "TRANSPORTADORA NAO ENCONTRADA NA FUN€ÇO CD0401." SKIP
               "FAVOR EFETUAR O CADASTRO."
               VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN "NOK":U.
    END.

    /*Verifica se ‚ NF de Entrada ou de saida*/
    FIND FIRST movtrp.docto-frete WHERE docto-frete.id-tp-docto  = docto-frete-nf.id-tp-docto
                                    AND docto-frete.cnpj-emit           = docto-frete-nf.cnpj-emit
                                    AND docto-frete.nr-documento        = docto-frete-nf.nr-documento
                                    AND docto-frete.dt-emissao-docto    = docto-frete-nf.dt-emissao-docto NO-LOCK NO-ERROR.

    MESSAGE docto-frete.cd-nat-oper
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    IF AVAIL movtrp.docto-frete AND id-tipo-frete = 1  AND cCodEstabel <> "" THEN DO:  /*NF Saida*/
                  
        IF docto-frete-nf.nr-nf > 9999999 THEN 
           FIND FIRST nota-fiscal NO-LOCK WHERE nota-fiscal.cod-estabel = cCodEstabel /*Busca natureza da Nota fiscal para verificar a busca da nat oper de frete*/
                                             AND nota-fiscal.serie       = STRING(docto-frete-nf.cd-serie)
                                             AND nota-fiscal.nr-nota-fis = STRING(docto-frete-nf.nr-nf,"999999999") NO-ERROR.        
        ELSE 
            FIND FIRST nota-fiscal NO-LOCK WHERE nota-fiscal.cod-estabel = cCodEstabel /*Busca natureza da Nota fiscal para verificar a busca da nat oper de frete*/
                                             AND nota-fiscal.serie       = STRING(docto-frete-nf.cd-serie)
                                             AND nota-fiscal.nr-nota-fis = STRING(docto-frete-nf.nr-nf,"9999999") NO-ERROR.
        IF AVAIL nota-fiscal THEN 
           ASSIGN cNatOperNF = nota-fiscal.nat-operacao
                  cCodEstabel = nota-fiscal.cod-estabel.
        ELSE DO:
            MESSAGE 
                "Estabelec.: " cCodEstabel                              SKIP
                "Serie.: "     string(docto-frete-nf.cd-serie)          SKIP
                "Documento.: " string(docto-frete-nf.nr-nf,">>9999999") SKIP(2)
                "DOCUMENTO DE SAIDA NAO FOI ENCONTRADO."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK":U.
        END.

        FIND FIRST estabelec WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN DO:
            FIND FIRST emitente WHERE emitente.cod-emitente = INTEGER(estabelec.cod-emitente) NO-ERROR.
            IF AVAIL emitente THEN
               ASSIGN cUFNota    = emitente.estado.
        END.

    END.
    ELSE DO: /*NF Entrada*/
            
        /* MVR - 16/09/2010 - Busca CodEmitente da NFE */
        ASSIGN vCodEmitente = 0.
    
        /* Verifica Emitente de Acorco com o codigo lancado no NFE */
        FOR EACH emitente FIELDS(cod-emitente identific nome-abrev cgc nome-emit estado cidade) NO-LOCK 
           WHERE emitente.cgc = docto-frete-nf.cgc-rem 
             AND NOT emitente.nome-emit BEGINS "** Eliminado":

            IF docto-frete-nf.nr-nf > 9999999 THEN 
                FIND FIRST docum-est WHERE docum-est.cod-emitente = emitente.cod-emitente
                                       AND docum-est.serie-docto  = string(docto-frete-nf.cd-serie)
                                       AND docum-est.nro-docto    = string(docto-frete-nf.nr-nf,"999999999") NO-ERROR.                
            ELSE 
                FIND FIRST docum-est WHERE docum-est.cod-emitente = emitente.cod-emitente
                                       AND docum-est.serie-docto  = string(docto-frete-nf.cd-serie)
                                       AND docum-est.nro-docto    = string(docto-frete-nf.nr-nf,"9999999") NO-ERROR.
            IF NOT AVAIL docum-est THEN NEXT.
                
            IF emitente.identific > 1 /* Se fornecedor ou ambos */ THEN DO:
               FIND FIRST es-emit-fornec WHERE
                          es-emit-fornec.cod-emitente = emitente.cod-emitente AND
                          es-emit-fornec.log-2 /* Inativo */   NO-LOCK NO-ERROR.
               IF AVAIL es-emit-fornec THEN DO:
                  MESSAGE "Fornecedor: " emitente.cod-emitente  SKIP
                          "Nome: "       emitente.nome-emit     SKIP
                          "CGC: "        docto-frete-nf.cgc-rem SKIP(2)
                          "FORNECEDOR INATIVO NA FUN€ÇO CD0401, ANTES DE ATIVAR A TRANSPORTADORA, É OBRIGATÓRIA A CONSULTA AO SINTEGRA E RECEITA FEDERAL." SKIP
                          VIEW-AS ALERT-BOX INFO BUTTONS OK.
                  RETURN "NOK":U.
               END.
            END.
            
            ASSIGN vCodEmitente = emitente.cod-emitente.
            LEAVE.

        END.
    
        IF vCodEmitente = 0  THEN DO:
            /**Verifica se ‚ estrangeiro **/
            FIND FIRST emitente WHERE emitente.cod-emitente = INTEGER(docto-frete-nf.cgc-rem) NO-ERROR.
            IF AVAIL emitente THEN 
               ASSIGN vCodEmitente = INTEGER(docto-frete-nf.cgc-rem). /*Nf's de exporta‡Æo e importa‡Æo*/
        END.

        IF docto-frete-nf.nr-nf > 9999999 THEN 
            FIND FIRST docum-est WHERE docum-est.cod-emitente      = vCodEmitente
                                   AND docum-est.serie-docto       = string(docto-frete-nf.cd-serie)
                                   AND docum-est.nro-docto         = string(docto-frete-nf.nr-nf,"999999999") NO-ERROR.
        ELSE 
            FIND FIRST docum-est WHERE docum-est.cod-emitente      = vCodEmitente
                                   AND docum-est.serie-docto       = string(docto-frete-nf.cd-serie)
                                   AND docum-est.nro-docto         = string(docto-frete-nf.nr-nf,"9999999") NO-ERROR.
        IF AVAIL docum-est THEN
           ASSIGN cNatOperNF  = docum-est.nat-operacao
                  cCodEstabel = docum-est.cod-estabel.
        ELSE DO:           
            MESSAGE 
                "Fornecedor.: " vCodEmitente                             SKIP
                "Serie.: "      string(docto-frete-nf.cd-serie)          SKIP
                "Documento.: "  string(docto-frete-nf.nr-nf,">>9999999") SKIP
                "CGC Fornec.: " docto-frete-nf.cgc-rem                   SKIP(2)
                "DOCUMENTO DE ENTRADA NAO FOI ENCONTRADO." VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN "NOK":U.                          
        END.
           
        FIND FIRST emitente WHERE emitente.cod-emitente = vCodEmitente NO-ERROR.
        IF AVAIL emitente THEN
           ASSIGN cUFNota = emitente.estado.
            
        /*Busca c¢digo do estabelecimento*/
        FIND FIRST estabelec WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN DO:
            ASSIGN cCodEstabel = estabelec.cod-estabel
                   cUFEstabel  = estabelec.estado.
        END.

    END.

    
    /*Busca natureza de frete na tabela de busca nat oper automatica de frete*/    
    FIND FIRST es-busca-natureza-frete WHERE es-busca-natureza-frete.natoper-nota = STRING(cNatOperNF) NO-ERROR.

    MESSAGE STRING(cNatOperNF)
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    IF AVAIL es-busca-natureza-frete THEN DO:

        FIND FIRST es-busca-natureza-frete-movto WHERE es-busca-natureza-frete-movto.seq-busca = es-busca-natureza-frete.seq-busca 
                                                   AND es-busca-natureza-frete-movto.cod-estabel = STRING(cCodEstabel) NO-ERROR.
        IF AVAIL es-busca-natureza-frete-movto THEN DO:
            
           IF docto-frete.id-tp-docto = 1 THEN DO: /*CTRC */

                /*Verificar se o transportador tem a mesma UF da Tortuga*/
                IF cUFEstabel = cUFTransp THEN DO:
                    /*Verificar se o Transportador ² Simples Nacional*/
                        FIND FIRST es-emit-fornec WHERE es-emit-fornec.cod-emitente = vCodEmitTransp NO-ERROR.
                        IF AVAIL es-emit-fornec AND es-emit-fornec.log-1 = YES THEN DO:

                            MESSAGE "Natureza 1" STRING(es-busca-natureza-frete-movto.natoper-frete-simples)
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

                            /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-simples.*/
                        END.
                        ELSE DO:
                            MESSAGE "Natureza 2" STRING(es-busca-natureza-frete-movto.natoper-frete)
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete.*/
                        END.
                END.

                /*Verificar se o transportador tem a UF diferente da Tortuga*/
                IF cUFEstabel <> cUFTransp THEN DO:
                    IF cUFEstabel = "SP" THEN DO:
                    
                        IF cUFNota = "SP" THEN DO:
                            MESSAGE "Natureza 3" STRING(es-busca-natureza-frete-movto.natoper-frete-interestadsp)
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-interestadsp. /*Criar campo na ESGT007*/*/
                        END.
                        ELSE DO:
                            /*Verificar se o Transportador ² Simples Nacional*/
                            FIND FIRST es-emit-fornec WHERE es-emit-fornec.cod-emitente = vCodEmitTransp NO-ERROR.
                            IF AVAIL es-emit-fornec AND es-emit-fornec.log-1 = YES THEN DO:
                                MESSAGE "Natureza 4" STRING(es-busca-natureza-frete-movto.natoper-frete-simplesdiferUF)
                                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-simplesdiferUF.*/
                            END.
                            ELSE DO:
                                IF cUFNota <> cUFTransp THEN /*Verifica se a UF da Nota ² diferente a UF do Transportador*/
                                    MESSAGE "Natureza 5" STRING(es-busca-natureza-frete-movto.natoper-frete-diferUF)
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                        /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-diferUF.*/
        
                                IF cUFNota = cUFTransp THEN /*Verifica se a UF da Nota ² igual a UF do Transportador*/
                                    MESSAGE "Natureza 6" STRING(es-busca-natureza-frete-movto.natoper-frete-origemUF)
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                    /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-origemUF.*/   
                            END.
                        END.

                    END.
                    ELSE DO: /*cUFEstabel <> "SP" */
                        /*Verificar se o Transportador ² Simples Nacional*/
                        FIND FIRST es-emit-fornec WHERE es-emit-fornec.cod-emitente = vCodEmitTransp NO-ERROR.
                        IF AVAIL es-emit-fornec AND es-emit-fornec.log-1 = YES THEN DO:
                            MESSAGE "Natureza 7" STRING(es-busca-natureza-frete-movto.natoper-frete-simplesdiferUF)
                                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                            /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-simplesdiferUF.*/
                        END.
                        ELSE DO:
                            IF cUFNota <> cUFTransp THEN /*Verifica se a UF da Nota ² diferente a UF do Transportador*/
                                MESSAGE "Natureza 8" STRING(es-busca-natureza-frete-movto.natoper-frete-diferUF)
                                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                    /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-diferUF.*/
    
                            IF cUFNota = cUFTransp THEN /*Verifica se a UF da Nota ² igual a UF do Transportador*/
                                MESSAGE "Natureza 9" STRING(es-busca-natureza-frete-movto.natoper-frete-origemUF)
                                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-origemUF.*/
                        END.
                    END.                    
                END.
                
                FIND FIRST movtrp.docto-frete WHERE docto-frete.id-tp-docto = docto-frete-nf.id-tp-docto
                                         AND docto-frete.cnpj-emit   = docto-frete-nf.cnpj-emit
                                         AND docto-frete.serie       = docto-frete-nf.serie
                                         AND docto-frete.nr-documento= docto-frete-nf.nr-documento NO-ERROR.

                IF AVAIL movtrp.docto-frete THEN DO:
                    
                     /*ASSIGN docto-frete.cd-nat-oper = docto-frete.cd-nat-oper.*/
                     MESSAGE "Natureza 10" STRING(docto-frete.cd-nat-oper)
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    
                     FIND FIRST natur-oper WHERE natur-oper.nat-operacao = docto-frete.cd-nat-oper NO-LOCK NO-ERROR.
                     IF AVAIL natur-oper THEN DO:
                            
                        FIND FIRST negoc-embarcador WHERE negoc-embarcador.cgc-transportador = docto-frete.cgc-transp NO-LOCK NO-ERROR.

                            IF negoc-embarcador.id-pedagio-icms = 1 THEN DO: /*Se o ped gio incide na base do ICMS*/
                           
                                IF natur-oper.cd-trib-icm = 1 THEN /*tributado*/
                                    MESSAGE "Tributado" SKIP
                                            "docto-frete.id-trib-icms     " "1" SKIP
                                            "docto-frete.vl-base-calc-icms" STRING(docto-frete.vl-conhecimento) SKIP
                                            "docto-frete.vl-icms          " STRING((docto-frete.vl-conhecimento * docto-frete.aliquota-icms) / 100) SKIP
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                    /*
                                    ASSIGN docto-frete.id-trib-icms      = 1
                                           docto-frete.vl-base-calc-icms = docto-frete.vl-conhecimento
                                           docto-frete.vl-icms           = (docto-frete.vl-conhecimento * docto-frete.aliquota-icms) / 100.
                                    */          
                                 ELSE IF natur-oper.cd-trib-icm = 2 THEN /*NÆo tributado e Isento*/
                                     MESSAGE "NÆo tributado e Isento"               SKIP
                                             "docto-frete.id-trib-icms      " "2"   SKIP
                                             "docto-frete.aliquota-icms     " "0"   SKIP
                                             "docto-frete.vl-base-calc-icms " "0"   SKIP
                                             "docto-frete.vl-icms           " "0"
                                             VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                    /*
                                    ASSIGN docto-frete.id-trib-icms         = 2
                                           docto-frete.aliquota-icms        = 0
                                           docto-frete.vl-base-calc-icms    = 0
                                           docto-frete.vl-icms              = 0.
                                    */
                                 ELSE IF natur-oper.cd-trib-icm = 3 THEN /*Outros*/
                                     MESSAGE "Outros" SKIP
                                             "docto-frete.id-trib-icms     " docto-frete.id-trib-icms      "6" SKIP
                                             "docto-frete.aliquota-icms    " docto-frete.aliquota-icms     "0" SKIP
                                             "docto-frete.vl-base-calc-icms" docto-frete.vl-base-calc-icms STRING(docto-frete.vl-conhecimento) SKIP
                                             "docto-frete.vl-icms          " docto-frete.vl-icms           "0"
                                             VIEW-AS ALERT-BOX INFO BUTTONS OK.

                                    /*
                                     ASSIGN docto-frete.id-trib-icms        = 6
                                            docto-frete.aliquota-icms       = 0
                                            docto-frete.vl-base-calc-icms   = docto-frete.vl-conhecimento
                                            docto-frete.vl-icms             = 0.
                                    */        
                                 ELSE IF natur-oper.cd-trib-icm = 4 THEN DO: /*Reduzido*/
                                     /*Calcular base reduzida*/
                                     ASSIGN vAux = (100 - natur-oper.perc-red-icm) / 100.
                                       
                                     ASSIGN vBaseIcms = (docto-frete.vl-conhecimento * vAux).
    
                                     ASSIGN vVlrIcms = (vBaseIcms * docto-frete.aliquota-icms).
    
                                     MESSAGE "Reduzido" SKIP
                                             "docto-frete.id-trib-icms     " "1"                SKIP
                                             "docto-frete.vl-base-calc-icms" vBaseIcms          SKIP
                                             "docto-frete.vl-icms          " (vVlrIcms / 100)   SKIP
                                             VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                     /*
                                     ASSIGN docto-frete.id-trib-icms        = 1
                                            docto-frete.vl-base-calc-icms   = vBaseIcms 
                                            docto-frete.vl-icms             = (vVlrIcms / 100).
                                    */
                                 END.
                                 ELSE IF natur-oper.cd-trib-icm = 5 THEN /*Diferido*/
                                     MESSAGE "Diferido" SKIP
                                            "docto-frete.id-trib-icms " "4"
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                     /*ASSIGN docto-frete.id-trib-icms = 4.*/

                            END.
                            ELSE DO: /* Se o ped gio NÇO incide na base do ICMS */

                                IF natur-oper.cd-trib-icm = 1 THEN /*tributado*/
                                    MESSAGE "Tributado" SKIP
                                            "docto-frete.id-trib-icms      " "1" SKIP
                                            "docto-frete.vl-base-calc-icms " STRING((docto-frete.vl-conhecimento - docto-frete.vl-pedagio)) SKIP
                                            "docto-frete.vl-icms           " STRING((docto-frete.vl-base-calc-icms * docto-frete.aliquota-icms) / 100) SKIP
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                    /*
                                    ASSIGN docto-frete.id-trib-icms         = 1
                                           docto-frete.vl-base-calc-icms    = (docto-frete.vl-conhecimento - docto-frete.vl-pedagio)
                                           docto-frete.vl-icms              = (docto-frete.vl-base-calc-icms * docto-frete.aliquota-icms) / 100.
                                    */
                                 ELSE IF natur-oper.cd-trib-icm = 2 THEN /*NÆo tributado e Isento*/
                                     MESSAGE "NÆo tributado e Isento"  SKIP
                                             "docto-frete.id-trib-icms     " " 2" SKIP
                                             "docto-frete.aliquota-icms    " " 0" SKIP
                                             "docto-frete.vl-base-calc-icms" " 0" SKIP
                                             "docto-frete.vl-icms          " " 0"
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                    /*
                                    ASSIGN docto-frete.id-trib-icms      = 2
                                           docto-frete.aliquota-icms     = 0
                                           docto-frete.vl-base-calc-icms = 0
                                           docto-frete.vl-icms           = 0.
                                   */
                                 ELSE IF natur-oper.cd-trib-icm = 3 THEN /*Outros*/
                                     MESSAGE "Outros" SKIP
                                             "docto-frete.id-trib-icms      " "6" SKIP
                                             "docto-frete.aliquota-icms     " "0" SKIP
                                             "docto-frete.vl-base-calc-icms " STRING((docto-frete.vl-conhecimento - docto-frete.vl-pedagio)) SKIP
                                             "docto-frete.vl-icms           " "0"
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                     /*
                                     ASSIGN docto-frete.id-trib-icms        = 6
                                            docto-frete.aliquota-icms       = 0
                                            docto-frete.vl-base-calc-icms   = (docto-frete.vl-conhecimento - docto-frete.vl-pedagio) /*docto-frete.vl-conhecimento*/
                                            docto-frete.vl-icms             = 0.
                                     */       
                                 ELSE IF natur-oper.cd-trib-icm = 4 THEN DO: /*Reduzido*/

                                     /*Calcular base reduzida*/
                                     ASSIGN vAux = (100 - natur-oper.perc-red-icm) / 100.
                                       
                                     ASSIGN vBaseIcms = (docto-frete.vl-conhecimento * vAux).
    
                                     ASSIGN vVlrIcms = (vBaseIcms * docto-frete.aliquota-icms).
    
                                     MESSAGE "Reduzido" SKIP
                                             "docto-frete.id-trib-icms      " "1" SKIP
                                             "docto-frete.vl-base-calc-icms " vBaseIcms         SKIP
                                             "docto-frete.vl-icms           " (vVlrIcms / 100)
                                             VIEW-AS ALERT-BOX INFO BUTTONS OK.

                                     /*
                                     ASSIGN docto-frete.id-trib-icms        = 1
                                            docto-frete.vl-base-calc-icms   = vBaseIcms 
                                            docto-frete.vl-icms             = (vVlrIcms / 100).
                                     */
                                 END.
                                 ELSE IF natur-oper.cd-trib-icm = 5 THEN /*Diferido*/
                                     MESSAGE "Diferido" SKIP
                                            "docto-frete.id-trib-icms " "4"
                                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                                     /*ASSIGN docto-frete.id-trib-icms = 4.*/
                            END.
                
                         END.
                END.
                
                ASSIGN vAux      = 0
                       vBaseIcms = 0
                       vVlrIcms  = 0. 
            END.
            ELSE DO: /*Nota Fiscal de Servi‡o */
                
                /*Marcar a tributa‡Æo do ICMS para Isento*/
                MESSAGE "Marcar a tributa‡Æo do ICMS para Isento" SKIP
                        "docto-frete.id-trib-icms" " 5"
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                 /*ASSIGN docto-frete.id-trib-icms = 5.*/

                 /*Verificar se o transportador tem a mesma UF da Tortuga*/                
                IF LOOKUP(cCodEstabel,"01,10") > 0 AND cCidadeTransp = "SÆo Paulo" THEN /*Sto Amaro e Faria Lima*/
                    MESSAGE "docto-frete.cd-nat-oper " es-busca-natureza-frete-movto.natoper-frete-servicoSP
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-servicoSP.*/

                IF LOOKUP(cCodEstabel,"01,10") > 0 AND cCidadeTransp <> "SÆo Paulo" THEN /*Transp fora de SÆo Paulo*/
                    MESSAGE "docto-frete.cd-nat-oper " es-busca-natureza-frete-movto.natoper-frete-servicoforaSP 
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-servicoforaSP.*/

                IF cCodEstabel <> "01" OR cCodEstabel <> "10"  THEN /*Outras naturezas de Servi‡o*/
                    MESSAGE "docto-frete.cd-nat-oper" es-busca-natureza-frete-movto.natoper-frete-servico
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    /*ASSIGN docto-frete.cd-nat-oper = es-busca-natureza-frete-movto.natoper-frete-servico.*/
                
                FIND FIRST movtrp.docto-frete WHERE docto-frete.id-tp-docto = docto-frete-nf.id-tp-docto
                                         AND docto-frete.cnpj-emit   = docto-frete-nf.cnpj-emit
                                         AND docto-frete.serie       = docto-frete-nf.serie
                                         AND docto-frete.nr-documento= docto-frete-nf.nr-documento NO-ERROR.
                IF AVAIL movtrp.docto-frete THEN DO:
                    MESSAGE "docto-frete.cd-nat-oper " docto-frete.cd-nat-oper
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                     /*ASSIGN docto-frete.cd-nat-oper = docto-frete.cd-nat-oper.*/
                END.

            END.

        END.
        ELSE DO:
            MESSAGE "Natureza: " cNatOperNF  SKIP
                    "Estabel.: " cCodEstabel SKIP
                    "Estado..: " cUFNota     SKIP(2)
                    "NAO HA BUSCA DE NATUREZA PARA A NATUREZA/ESTABEL: " + cNatOperNF + "/" + cCodEstabel SKIP
                    "SOLICITAR CADASTRO DE BUSCA JUNTO AO DEPTO FISCAL"
                    VIEW-AS ALERT-BOX.
            RETURN "NOK".                                    
        END.

    END.
    ELSE DO:
        MESSAGE "Natureza: " cNatOperNF  SKIP
                "Estabel.: " cCodEstabel SKIP
                "Estado..: " cUFNota     SKIP(2)
                "NAO HA BUSCA CADASTRA PARA NATUREZA: " + cNatOperNF SKIP
                "SOLICITAR CADASTRO DE BUSCA JUNTO AO DEPTO FISCAL" VIEW-AS ALERT-BOX.
        RETURN "NOK".                
    END.   

END.
ELSE
    MESSAGE "Documento nao encontrado!"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.



