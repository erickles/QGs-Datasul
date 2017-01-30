/*ATUALIZA O CAMPO "REPRESENTANTES PEDMOBILE QUE FOI CRIADO NO CD0705*/
DEFINE VARIABLE i-cod-rep AS CHARACTER LABEL "Cod. Repres"  NO-UNDO.

/*DEFINIÄ«O DE VARIµVEIS*/
DEFINE TEMP-TABLE tt-tabelas
    FIELD nr-tabpre   LIKE ws-p-item.nr-tabpre
    FIELD cod-rep     LIKE ws-p-venda.no-ab-reppri
    INDEX IDX_tabela IS PRIMARY nr-tabpre.
EMPTY TEMP-TABLE tt-tabelas. 

/*DIGITE AQUI O C‡DIGO DO REPRESENTANTE E PRESSIONE F2 PARA EXECUTAR*/
UPDATE i-cod-rep LABEL "Informe o codigo de representante".
/*======================================*/

FOR EACH ws-p-venda NO-LOCK
    WHERE no-ab-reppri = i-cod-rep,
    EACH es-loc-entr WHERE es-loc-entr.cod-entrega = ws-p-venda.cod-entrega
                       AND es-loc-entr.nome-abrev  = ws-p-venda.nome-abrev:

    IF es-loc-entr.cod-repres = int(ws-p-venda.no-ab-reppri) THEN NEXT.

    IF es-loc-entr.char-1 = "" THEN DO:
        ASSIGN es-loc-entr.char-1 = es-loc-entr.char-1 + "," + ws-p-venda.no-ab-reppri.
    END.
    ELSE DO:
        IF LOOKUP(ws-p-venda.no-ab-reppri,es-loc-entr.char-1) = 0 THEN
            ASSIGN es-loc-entr.char-1 = es-loc-entr.char-1 + ',' + ws-p-venda.no-ab-reppri.
    END.
END.

/*LEIO TODOS OS REPRESENTANTES CADASTRADOS NO PEDMOBILE E CRIO UMA TEMP-TABLE COM TODAS AS TABELAS QUE O REPRESENTANTE Jµ USOU NA TORTUGA*/
FOR EACH pm-rep-param NO-LOCK WHERE pm-rep-param.cod_rep = INTE(i-cod-rep),
    FIRST repres WHERE repres.cod-rep = pm-rep-param.cod_rep NO-LOCK,
    EACH ws-p-venda NO-LOCK WHERE ws-p-venda.no-ab-reppri = STRING(pm-rep-param.cod_rep)
                              AND ws-p-venda.dt-implant >= 01/01/2003,
                              EACH ws-p-item OF ws-p-venda NO-LOCK WHERE NOT ws-p-item.nr-tabpre BEGINS 'TRA':
                              
    
    IF NOT CAN-FIND(FIRST tt-tabelas WHERE tt-tabelas.nr-tabpre = ws-p-item.nr-tabpre
                                       AND tt-tabelas.cod-rep   = ws-p-venda.no-ab-reppri) THEN DO:
        CREATE tt-tabelas.
        ASSIGN tt-tabelas.cod-rep   = STRING(pm-rep-param.cod_rep)
               tt-tabelas.nr-tabpre = ws-p-item.nr-tabpre.
    END.    
END.


/*Verifica se as tabelas que ser∆o vinculadas ao representante est∆o v†lidas*/
FOR EACH tt-tabelas:
    FIND FIRST tb-preco WHERE tt-tabelas.nr-tabpre = tb-preco.nr-tabpre NO-LOCK NO-ERROR.
    IF AVAIL tb-preco THEN DO:
        IF tb-preco.situacao <> 1 OR tb-preco.dt-fimval < TODAY THEN
            DELETE tt-tabelas.
    END.
END.

/*Procura tabelas relacionadas (tabelas filho) para incluir tambÇm para o cliente*/
DEFINE BUFFER bf-tt-tabelas FOR tt-tabelas.
FOR EACH bf-tt-tabelas,
    EACH es-tab-preco-rel NO-LOCK
    WHERE es-tab-preco-rel.nr-tabpre = bf-tt-tabelas.nr-tabpre:

    IF NOT CAN-FIND(FIRST tt-tabelas WHERE tt-tabelas.nr-tabpre = es-tab-preco-rel.nr-tabfilho) THEN DO:
        CREATE tt-tabelas.
        ASSIGN tt-tabelas.cod-rep   = bf-tt-tabelas.cod-rep
               tt-tabelas.nr-tabpre = es-tab-preco-rel.nr-tabfilho.
    END.
END.
/**/

/*TRANSFERINDO DADOS DA TEMP-TABLE PARA A TABELA F÷SICA*/
FOR EACH tt-tabelas:
    FIND FIRST repres NO-LOCK WHERE STRING(repres.cod-rep) = STRING(tt-tabelas.cod-rep) NO-ERROR.
        
        CREATE es-tab-preco-repres.
        ASSIGN es-tab-preco-repres.cod-rep    = INTE(tt-tabelas.cod-rep)
               es-tab-preco-repres.nome-abrev = repres.nome-abrev
               es-tab-preco-repres.nr-tabpre  = tt-tabelas.nr-tabpre.

END.
