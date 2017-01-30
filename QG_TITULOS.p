/**************************** INCLUDE PRINCIPAL *******************************
PROGRAMA.....:wsco24re.i
AUTOR........:B&T/Solusoft
DESCRICAO....:Consulta T≠tulos do Contas a Receber 
*******************************************************************************/
/*******************************************************************************
** 03/02/2011 - MVR - Utilizacao de index para leitura de titulos vencidos a vencer e baixados
** 13/09/2011 - Willams Santos - Ordenaªío dos titulos por representante
** 18/09/2013 - Willams/Erick  - Criaªío da Procedure HierarquiaRepresQG para permitir a leitura de titulos referentes a pedidos Mitsuisal e Nutriªío.
*******************************************************************************/
{include/i-buffer.i YES YES NO}
/*Trigger de FIND, permissoes de acesso*/
{utp/ut-glob.i}
&GLOBAL-DEFINE GatilhoAcessoPV FALSE
&GLOBAL-DEFINE GatilhoAcessoNF FALSE
&GLOBAL-DEFINE GatilhoAcessoDP TRUE

&GLOBAL-DEFINE AplicacaoWeb    TRUE
{include/i-es-permis.i}
/**/

DEFINE VARIABLE remitente                  AS ROWID NO-UNDO.
DEFINE VARIABLE epcodigoini                AS CHAR NO-UNDO.
DEFINE VARIABLE epcodigofim                AS CHAR NO-UNDO.
DEFINE VARIABLE matrizini                  AS CHAR NO-UNDO.
DEFINE VARIABLE matrizfim                  AS CHAR NO-UNDO.
DEFINE VARIABLE codestabelini              AS CHAR NO-UNDO.
DEFINE VARIABLE codestabelfim              AS CHAR NO-UNDO.
DEFINE VARIABLE codemitenteini             AS CHAR NO-UNDO.
DEFINE VARIABLE codemitentefim             AS CHAR NO-UNDO.
DEFINE VARIABLE codespini                  AS CHAR NO-UNDO.
DEFINE VARIABLE codespfim                  AS CHAR NO-UNDO.
DEFINE VARIABLE nrdoctoini                 AS CHAR NO-UNDO.
DEFINE VARIABLE nrdoctofim                 AS CHAR NO-UNDO.
DEFINE VARIABLE Dtemissaoini               AS CHAR NO-UNDO.
DEFINE VARIABLE Dtemissaofim               AS CHAR NO-UNDO.
DEFINE VARIABLE Dtvenctoini                AS CHAR NO-UNDO.
DEFINE VARIABLE Dtvenctofim                AS CHAR NO-UNDO.
DEFINE VARIABLE mocodigo                   AS CHAR NO-UNDO.
DEFINE VARIABLE codrepini                  AS CHAR NO-UNDO.
DEFINE VARIABLE codrepfim                  AS CHAR NO-UNDO.
DEFINE VARIABLE avencer                    AS CHAR NO-UNDO.
DEFINE VARIABLE nrdiasvencer               AS CHAR NO-UNDO.
DEFINE VARIABLE vencido                    AS CHAR NO-UNDO.
DEFINE VARIABLE vencimento                 AS CHAR NO-UNDO.
DEFINE VARIABLE nrdiasvencidos             AS INTE NO-UNDO.
DEFINE VARIABLE baixado                    AS CHAR NO-UNDO.
DEFINE VARIABLE aberto                     AS CHAR NO-UNDO.
DEFINE VARIABLE Dtbaixaini                 AS CHAR NO-UNDO.
DEFINE VARIABLE Dtbaixafim                 AS CHAR NO-UNDO.
DEFINE VARIABLE classificacao              AS CHAR NO-UNDO.
DEFINE VARIABLE vdtemissaoini              AS DATE NO-UNDO.
DEFINE VARIABLE vdtemissaofim              AS DATE NO-UNDO.
DEFINE VARIABLE vdtvenctoini               AS DATE NO-UNDO.
DEFINE VARIABLE vdtvenctofim               AS DATE NO-UNDO.
DEFINE VARIABLE vdtbaixaini                AS DATE NO-UNDO.
DEFINE VARIABLE vdtbaixafim                AS DATE NO-UNDO.
DEFINE VARIABLE v-avencer                  AS CHAR NO-UNDO.
DEFINE VARIABLE v-vencido                  AS CHAR NO-UNDO.
DEFINE VARIABLE v-vencimento               AS CHAR NO-UNDO.
DEFINE VARIABLE v-baixado                  AS CHAR NO-UNDO.
DEFINE VARIABLE de-vl-titulo               AS DEC NO-UNDO.
DEFINE VARIABLE de-tot-venc                AS DEC NO-UNDO.
DEFINE VARIABLE de-tot-titulo              AS DEC NO-UNDO.
DEFINE VARIABLE de-total-geral             AS DEC NO-UNDO.
DEFINE VARIABLE c-classif                  AS CHAR NO-UNDO.
DEFINE VARIABLE v-cont                     AS INT NO-UNDO.
DEFINE VARIABLE c-moeda                    AS CHAR NO-UNDO.
DEFINE VARIABLE c-confidencial             AS CHAR NO-UNDO.
DEFINE VARIABLE i-nr-dias-titulosavencer   AS INT NO-UNDO.
DEFINE VARIABLE i-nr-dias-titulosvencidos  AS INT NO-UNDO.
DEFINE VARIABLE i-nr-dias-titulosbaixados  AS INT NO-UNDO.
DEFINE VARIABLE i-primeiro-registro        AS INT NO-UNDO.
DEFINE VARIABLE i-ultimo-registro          AS INT NO-UNDO.
DEFINE VARIABLE da-primeiro-registro       AS DATE.
DEFINE VARIABLE da-ultimo-registro         AS DATE.
DEFINE VARIABLE l-possui-registro          AS LOGICAL INIT NO.
DEFINE VARIABLE l-primeira-vez             AS LOGICAL INIT NO.
DEFINE VARIABLE iRep                       AS INT NO-UNDO.
DEFINE VARIABLE especie                    LIKE titulo.cod-esp NO-UNDO.
DEFINE VARIABLE r-rowid                    AS ROWID       NO-UNDO.

DEFINE VARIABLE h-d01ad264     AS HANDLE      NO-UNDO.

/* Temp-Table titulo */
{prgesp\include\i-tt-ad490.i tt-titulo}

/* Temp-Table titulo */
{prgesp\include\i-tt-ad490.i tt-titulo-aux} 

lIntegracaoAcrEMS5 = CAN-FIND(funcao WHERE funcao.cd-funcao = "adm-acr-ems-5.00"
                                       AND funcao.ativo     = YES
                                       AND funcao.log-1     = YES).

lConnectedEms5  = CONNECTED('emsbas':U) AND CONNECTED('emsuni':U) AND CONNECTED('emsfin':U).

DEFINE BUFFER b-emitente        FOR emitente.
DEFINE BUFFER b2-emitente       FOR emitente.
DEFINE BUFFER titulo            FOR tt-titulo.
DEFINE BUFFER b-titulo          FOR tt-titulo.
DEFINE BUFFER bf-repres-comis   FOR es-repres-comis.
DEFINE BUFFER bf2-repres-comis  FOR es-repres-comis.
DEFINE BUFFER bf-repres         FOR repres.

{include/ws9002.i}
{include/ws9003.i}
{include/subs.i}

DEFINE VARIABLE iEmitente       AS INTEGER     NO-UNDO  INITIAL 999999999 FORMAT "999999999".
DEFINE VARIABLE cEpCodigoIni    AS CHARACTER   NO-UNDO  INITIAL "1".
DEFINE VARIABLE cEpCodigoFim    AS CHARACTER   NO-UNDO  INITIAL "1".
DEFINE VARIABLE cCodEstabelIni  AS CHARACTER   NO-UNDO  INITIAL "".
DEFINE VARIABLE cCodEstabelFim  AS CHARACTER   NO-UNDO  INITIAL "ZZZ".
DEFINE VARIABLE cCodEmitenteIni AS CHARACTER   NO-UNDO  FORMAT "000000000".
DEFINE VARIABLE cCodEmitenteFim AS CHARACTER   NO-UNDO  FORMAT "999999999".
DEFINE VARIABLE cCodEspIni      AS CHARACTER   NO-UNDO  INITIAL "".
DEFINE VARIABLE cCodEspFim      AS CHARACTER   NO-UNDO  INITIAL "ZZZ".
DEFINE VARIABLE cNroDoctoIni    AS CHARACTER   NO-UNDO  INITIAL "".
DEFINE VARIABLE cNroDoctoFim    AS CHARACTER   NO-UNDO  INITIAL "99999999".
DEFINE VARIABLE cDtEmissaoIni   AS CHARACTER   NO-UNDO  INITIAL "01/01/1900" FORMAT "X(10)".
DEFINE VARIABLE cDtEmissaoFim   AS CHARACTER   NO-UNDO  INITIAL "31/12/9999" FORMAT "X(10)".
DEFINE VARIABLE cDtVenctoIni    AS CHARACTER   NO-UNDO  INITIAL "01/01/2014" FORMAT "X(10)".
DEFINE VARIABLE cDtVenctoFim    AS CHARACTER   NO-UNDO  INITIAL "31/01/2014" FORMAT "X(10)".
DEFINE VARIABLE cCodRepIni      AS CHARACTER   NO-UNDO  INITIAL "1339".
DEFINE VARIABLE cCodRepFim      AS CHARACTER   NO-UNDO  INITIAL "1339".
DEFINE VARIABLE cMoCodigo       AS CHARACTER   NO-UNDO  INITIAL "1".
DEFINE VARIABLE cVencimento     AS CHARACTER   NO-UNDO  INITIAL FALSE.
DEFINE VARIABLE cVencer         AS CHARACTER   NO-UNDO  INITIAL "TRUE".
DEFINE VARIABLE cNrDiasVencer   AS CHARACTER   NO-UNDO  INITIAL 3.
DEFINE VARIABLE cVencido        AS CHARACTER   NO-UNDO  INITIAL "FALSE".
DEFINE VARIABLE cNrDiasVencidos AS INTEGER     NO-UNDO  INITIAL 3.
DEFINE VARIABLE cBaixado        AS CHARACTER   NO-UNDO  INITIAL "FALSE".
DEFINE VARIABLE cAberto         AS CHARACTER   NO-UNDO  INITIAL "FALSE".
DEFINE VARIABLE cDtBaixaIni     AS CHARACTER   NO-UNDO  INITIAL "01/01/2014" FORMAT "X(10)".
DEFINE VARIABLE cDtBaixafim     AS CHARACTER   NO-UNDO  INITIAL "31/01/2014" FORMAT "X(10)".
DEFINE VARIABLE cClassificacao  AS CHARACTER   NO-UNDO  INITIAL "1".
DEFINE VARIABLE cEspecie        AS CHARACTER   NO-UNDO  INITIAL "TODOS".
DEFINE VARIABLE cMatrizIni      AS CHARACTER   NO-UNDO  INITIAL "".
DEFINE VARIABLE cMatrizFim      AS CHARACTER   NO-UNDO  INITIAL "ZZZ".
DEFINE VARIABLE cTipoUsuario    AS CHARACTER   NO-UNDO  INITIAL "REP" FORMAT "X(3)".

UPDATE cTipoUsuario     LABEL "Tipo de Usuario"
       iEmitente        LABEL "Cod. Emitente"
       cEpCodigoIni     LABEL "Cod. Emp. Ini"
       cEpCodigoFim
       cCodEstabelIni
       cCodEstabelFim
       cCodEmitenteIni
       cCodEmitenteFim
       cNroDoctoIni
       cNroDoctoFim
       cDtEmissaoIni
       cDtEmissaoFim
       cMoCodigo
       cVencimento
       cVencer
       cNrDiasVencer
       cNrDiasVencidos
       cBaixado
       cAberto
       cDtBaixaIni
       cDtBaixafim
       cClassificacao
       cEspecie
       cMatrizIni
       cMatrizFim
       WITH 1 COL.

FIND FIRST emitente WHERE emitente.cod-emitente = iEmitente NO-LOCK NO-ERROR.

ASSIGN remitente      = ROWID(emitente)
       epcodigoini    = cEpCodigoIni
       epcodigofim    = cEpCodigoFim
       codestabelini  = cCodEstabelIni
       codestabelfim  = cCodEstabelFim
       codemitenteini = cCodEmitenteIni
       codemitentefim = cCodEmitenteFim
       codespini      = cCodEspIni
       codespfim      = cCodEspFim
       nrdoctoini     = cNroDoctoIni
       nrdoctofim     = cNroDoctoFim
       dtemissaoini   = cDtEmissaoIni
       dtemissaofim   = cDtEmissaoFim
       dtvenctoini    = cDtVenctoIni
       dtvenctofim    = cDtVenctoFim
       codrepini      = cCodRepIni
       codrepfim      = cCodRepFim
       mocodigo       = cMoCodigo
       vencimento     = cVencimento
       avencer        = cVencer
       nrdiasvencer   = cNrDiasVencer
       vencido        = cVencido
       nrdiasvencidos = cNrDiasVencidos
       baixado        = cBaixado
       aberto         = cAberto
       dtbaixaini     = cDtBaixaIni
       dtbaixafim     = cDtBaixafim
       classificacao  = cClassificacao
       especie        = cEspecie
       matrizini      = cMatrizIni
       matrizfim      = cMatrizFim.
   
RUN Substituir(INPUT cMatrizIni, OUTPUT matrizini).
RUN Substituir(INPUT cMatrizFim, OUTPUT matrizfim).

IF remitente <> ? THEN DO:
    FIND FIRST emitente WHERE ROWID(emitente) = remitente NO-LOCK NO-ERROR.
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL emitente THEN DO:

        ASSIGN epcodigoini    = STRING(param-global.empresa-prin)
               epcodigofim    = STRING(param-global.empresa-prin) 
               codestabelini  = ""                                 
               codestabelfim  = "ZZZ"                              
               codespini      = ""                                   
               codespfim      = "ZZ"                                  
               codemitenteini = STRING(emitente.cod-emitente)                  
               codemitentefim = STRING(emitente.cod-emitente)                   
               matrizini      = emitente.nome-matriz
               matrizfim      = emitente.nome-matriz
               nrdoctoini     = ""                       
               nrdoctofim     = "ZZZZZZZZZZZZZZZZ"                       
               dtemissaoini   = "01/01/1990" 
               dtemissaofim   = STRING(TODAY, "99/99/9999")                
               dtvenctoini    = "01/01/1990" 
               dtvenctofim    = STRING(TODAY, "99/99/9999")                  
               codrepini      = "0000"
               codrepfim      = "9999"                                       
               mocodigo       = "0"                                            
               vencimento     = "FALSE"
               avencer        = "TRUE"                                           
               nrdiasvencer   = "999"                                             
               nrdiasvencidos = 0
               vencido        = "TRUE"                                             
               baixado        = "FALSE"                                             
               classificacao  = "1".
    END.
END.
 
ASSIGN vdtemissaoini               = DATE(dtemissaoini)
       vdtemissaofim               = DATE(dtemissaofim)
       vdtvenctoini                = DATE(dtvenctoini)
       vdtvenctofim                = DATE(dtvenctofim)
       vdtbaixaini                 = DATE(dtbaixaini)
       vdtbaixafim                 = DATE(dtbaixafim)
       l-possui-registro           = NO
       de-vl-titulo                = 0
       de-tot-titulo               = 0 
       de-total-geral              = 0
       i-nr-dias-titulosavencer    = 0
       i-nr-dias-titulosvencidos   = 0
       i-nr-dias-titulosbaixados   = 0.

IF cTipoUsuario = "REP" OR cTipoUsuario = "USU" THEN DO:
    RUN HierarquiaRepresQG.
END.    
ELSE 
    IF cTipoUsuario = "EMI" THEN DO:
        FIND FIRST ws-param-global NO-ERROR.
        FIND FIRST emitente WHERE emitente.cod-emitente = iEmitente NO-LOCK NO-ERROR.
    
        IF emitente.ind-abrange-aval = 1 OR
           emitente.nome-abrev <> emitente.nome-matriz THEN DO: /*cliente*/
            ASSIGN codemitenteini = "0"
                   codemitentefim = "999999".
        END.
    END.
  
IF cTipoUsuario = "USU" THEN RUN Estabelec.

IF cTipoUsuario = "REP" AND NUM-ENTRIES(v-lista) = 1 THEN DO:
    
    ASSIGN codrepini = STRING(1339)
           codrepfim = STRING(1339).
END.
 
IF aberto = 'FALSE' THEN DO:
    ASSIGN avencer  = "FALSE"
           aberto   = "TRUE".
END.
ELSE 
    ASSIGN vencido   = "TRUE".

IF classificacao = "0" THEN
    ASSIGN c-classif = "CΩdigo Cliente".
ELSE
    IF classificacao = "1" THEN
        ASSIGN c-classif = "Razío Social".
ELSE
    IF classificacao = "2" THEN
        ASSIGN c-classif = "Representante".

RUN dbo\d01ad264.p PERSISTENT SET h-d01ad264.

IF cTipoUsuario = "REP" AND NUM-ENTRIES(v-lista) > 1 THEN DO:
   DO iRep = 1 TO NUM-ENTRIES(v-lista):
      IF INT(ENTRY(iRep,v-lista)) < INT(codrepini) OR 
         INT(ENTRY(iRep,v-lista)) > INT(codrepfim) THEN NEXT.
      
      RUN piOpenQuery (INPUT INT(ENTRY(iRep,v-lista))).
   END.
END.
ELSE DO:
   IF codrepini = codrepfim THEN DO:
      RUN piOpenQuery (INPUT INT(codrepini)).
   END.
   ELSE DO:
      RUN piOpenQuery (INPUT 0).
   END.
END.

DELETE PROCEDURE h-d01ad264.

/* Verifica Permissao de Acesso */
FOR EACH tt-titulo:
    MESSAGE tt-titulo.ep-codigo
            tt-titulo.cod-esp
            tt-titulo.cod-estab
            tt-titulo.nr-docto
            /*
            tt-titulo.cod_ser_docto  
            tt-titulo.cod_estab      
            tt-titulo.cod_espec_docto
            tt-titulo.cod_tit_acr    
            tt-titulo.cod_parcela    
            */
            tt-titulo.cod-rep
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RUN piPermissao.

    IF RETURN-VALUE = "NOK" THEN DO:
        DELETE tt-titulo.
    END.
        
END.

ASSIGN GA-fullAcess = TRUE.

/* Geracao do arquivo relatorio */
OUTPUT TO "c:\TITULOS.csv".

/*********** TITULOS A VENCER ****************/

IF avencer = "TRUE" THEN DO:

    ASSIGN l-possui-registro    = NO 
           l-primeira-vez       = YES 
           i-primeiro-registro  = 0
           i-ultimo-registro    = 0
           da-primeiro-registro = ?
           da-ultimo-registro   = ?
           de-vl-titulo         = 0
           de-tot-titulo        = 0
           de-tot-venc          = 0.    

    IF  INTE(epcodigoini) = INTE(epcodigofim) AND
        codestabelini    = codestabelfim      AND
        codespini        = codespfim          AND
        (nrdoctoini <> "" OR nrdoctofim <> 'ZZZZZZZZZZZZZZZZ') THEN DO:
        
        FOR EACH titulo NO-LOCK WHERE titulo.ep-codigo   = INTE(epcodigofim)
                                  AND titulo.cod-estabel = codestabelfim
                                  AND titulo.cod-esp     = codespfim
                                  AND titulo.nr-docto    >= nrdoctoini
                                  AND titulo.nr-docto     <= nrdoctofim,
                FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente,
                FIRST repres WHERE titulo.cod-rep = repres.cod-rep
                BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                  ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                      ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
        
            /*SD 2428/09 - Novo filtro de titulo por especie*/
            IF especie <> "TODOS" THEN
                IF titulo.cod-esp <> especie THEN NEXT.
                  
            IF LOOKUP(TRIM(STRING(titulo.cod-rep)),v-lista) = 0 THEN NEXT.
       
            IF cTipoUsuario = "USU" THEN DO:
                IF c-lista <> "*" THEN
                    IF LOOKUP(TRIM(STRING(titulo.cod-estabel)),c-lista) = 0 THEN          
                        NEXT.
            END.
                      
            IF titulo.cod-rep < int(codrepini)     OR
               titulo.cod-rep > int(codrepfim)     OR
               titulo.dt-emissao   < vdtemissaoini OR
               titulo.dt-emissao   > vdtemissaofim THEN
                NEXT.
   
            FIND FIRST ws-param-global NO-ERROR.
            IF cTipoUsuario = "EMI" THEN DO:
                IF emitente.ind-abrange-aval = 2 THEN DO: /*MATRIZ*/
                    FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                    FIND FIRST b-emitente WHERE b-emitente.cod-emitente = iEmitente NO-ERROR.
                    IF emitente.nome-matriz <> b-emitente.nome-matriz THEN
                        NEXT.
                END.
            END.
            ELSE DO:
                FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                IF AVAIL emitente THEN DO:
                    IF emitente.nome-matriz  < matrizini OR
                       emitente.nome-matriz  > matrizfim THEN
                        NEXT.
                END.        
            END.

            FIND LAST b-titulo WHERE b-titulo.ep-codigo   = titulo.ep-codigo
                                 AND b-titulo.serie       = titulo.serie
                                 AND b-titulo.cod-estabel = titulo.cod-estabel
                                 AND b-titulo.cod-esp     = titulo.cod-esp
                                 AND b-titulo.nr-docto    = titulo.nr-docto
                                 NO-LOCK NO-ERROR.

            RUN titulosavencer.
        END.
    END.
    ELSE 
        /********** CLIENTE **********/
        IF INTE(codemitenteini) <> 000000000 OR INTE(codemitentefim) <> 999999999 THEN DO:
            
            FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini)
                                       AND empresa.ep-codigo <= INT(epcodigofim),
                                       EACH titulo USE-INDEX vencimento NO-LOCK WHERE titulo.ep-codigo = empresa.ep-codigo
                                                                                  AND titulo.dt-vencimen  > TODAY - 1
                                                                                  AND titulo.cod-emitente >= INTE(codemitenteini)
                                                                                  AND titulo.cod-emitente <= INTE(codemitentefim),
                                                                                  FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                                  BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                                    ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                                        ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
                
                IF especie <> "TODOS" THEN
                    IF titulo.cod-esp <> especie THEN NEXT.

                IF titulo.ep-codigo   < INTE(epcodigoini)   OR
                   titulo.ep-codigo   > INTE(epcodigofim)   OR
                   titulo.dt-emissao  < vdtemissaoini       OR
                   titulo.dt-emissao  > vdtemissaofim       OR
                   titulo.cod-estabel < codestabelini       OR
                   titulo.cod-estabel > codestabelfim       OR
                   titulo.cod-esp     < codespini           OR
                   titulo.cod-esp     > codespfim           OR
                   titulo.nr-docto    < nrdoctoini          OR
                   titulo.nr-docto    > nrdoctofim          THEN 
                    NEXT.

                IF cTipoUsuario = "USU" THEN DO:
                    IF c-lista <> "*" THEN
                        IF LOOKUP(TRIM(STRING(titulo.cod-estabel)),c-lista) = 0 THEN
                            NEXT.
                END.
       
                IF LOOKUP(TRIM(STRING(titulo.cod-rep)),v-lista) = 0 THEN NEXT.
       
                IF titulo.cod-rep < INTE(codrepini) OR
                   titulo.cod-rep > INTE(codrepfim) THEN
                    NEXT.

                FIND FIRST ws-param-global NO-ERROR.
                IF cTipoUsuario = "EMI" THEN DO:
                    IF emitente.ind-abrange-aval = 2 THEN DO: /*MATRIZ*/
                        FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                        FIND FIRST b-emitente WHERE b-emitente.cod-emitente = iEmitente NO-ERROR.
                        IF emitente.nome-matriz <> b-emitente.nome-matriz THEN
                            NEXT.
                    END.
                END.
                ELSE DO:
                    FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                    IF AVAIL emitente THEN DO:
                        IF emitente.nome-matriz  < matrizini OR
                           emitente.nome-matriz  > matrizfim THEN
                            NEXT.
                    END.        
                END.

                FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                    AND b-titulo.serie        = titulo.serie     
                                    AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                    AND b-titulo.cod-esp      = titulo.cod-esp
                                    AND b-titulo.nr-docto     = titulo.nr-docto   
                                    NO-LOCK NO-ERROR.

                RUN titulosavencer.
            END.
        END.
        ELSE
            /********** REPRESENTANTE **********/            
            IF INTE(codrepini) <> 0  OR INTE(codrepfim) <> 99999 THEN DO:
                
                FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini)
                                           AND empresa.ep-codigo <= INT(epcodigofim),
                                           EACH titulo USE-INDEX vencimento NO-LOCK WHERE titulo.ep-codigo = empresa.ep-codigo
                                                                                      AND titulo.dt-vencimen > TODAY - 1
                                                                                      AND titulo.cod-rep     >= INTE(codrepini)
                                                                                      AND titulo.cod-rep     <= INTE(codrepfim),
                                                                                     FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                                    BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                                        ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                                        ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:                        
        
                    IF LOOKUP(TRIM(STRING(titulo.cod-rep)),v-lista) = 0 THEN
                        NEXT.
       
                    IF titulo.cod-rep < INTE(codrepini) OR
                       titulo.cod-rep > INTE(codrepfim) THEN
                        NEXT.

                    /*SD 2428/09 - Novo filtro de titulo por especie*/
                    IF especie <> "TODOS" THEN
                        IF titulo.cod-esp <> especie THEN NEXT.
        
                    IF titulo.cod-emitente < INTE(codemitenteini) OR 
                       titulo.cod-emitente > INTE(codemitentefim) OR
                       titulo.dt-emissao   < vdtemissaoini        OR
                       titulo.dt-emissao   > vdtemissaofim        OR
                       titulo.cod-estabel  < codestabelini        OR
                       titulo.cod-estabel  > codestabelfim        OR
                       titulo.cod-esp      < codespini            OR
                       titulo.cod-esp      > codespfim            OR
                       titulo.nr-docto     < nrdoctoini           OR
                       titulo.nr-docto     > nrdoctofim           THEN
                        NEXT.
              
                    IF cTipoUsuario = "USU" THEN DO:
                        IF c-lista <> "*" THEN
                            IF LOOKUP(TRIM(STRING(titulo.cod-estabel)),c-lista) = 0 THEN
                                NEXT.
                    END.

                    FIND FIRST ws-param-global NO-ERROR.
                    IF cTipoUsuario = "EMI" THEN DO:
                        IF emitente.ind-abrange-aval = 2 THEN DO: /*MATRIZ*/
                            FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                            FIND FIRST b-emitente WHERE b-emitente.cod-emitente = iEmitente NO-ERROR.
                            IF emitente.nome-matriz <> b-emitente.nome-matriz THEN
                                NEXT.
                        END.
                    END.
                    ELSE DO:
                        FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                        IF AVAIL emitente THEN DO:
                            IF emitente.nome-matriz  < matrizini OR
                               emitente.nome-matriz  > matrizfim THEN
                                NEXT.
                        END.        
                    END.

                    FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                         AND b-titulo.serie        = titulo.serie     
                                         AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                         AND b-titulo.cod-esp      = titulo.cod-esp
                                         AND b-titulo.nr-docto     = titulo.nr-docto   
                                         NO-LOCK NO-ERROR.

                    RUN titulosavencer.
                END.
            END.
            ELSE IF cTipoUsuario = "REP" AND num-entries(v-lista) > 1 THEN DO: /* mfo SD 80/05*/
          
                /*DO iRep = 1 TO num-entries(v-lista):*/
                FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INTE(epcodigoini)
                                            AND empresa.ep-codigo <= INTE(epcodigofim),
                                            EACH titulo USE-INDEX vencimento NO-LOCK WHERE titulo.ep-codigo = empresa.ep-codigo
                                                                                        AND titulo.dt-vencimen  > TODAY - 1
                                                                                        AND LOOKUP(STRING(titulo.cod-rep),v-lista) > 0,
                                                                                        FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                                            BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                                            ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                                                ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
          
                    IF LOOKUP(TRIM(STRING(titulo.cod-rep)),v-lista) = 0 THEN
                        NEXT.
          
                    IF titulo.cod-rep < INTE(codrepini) OR
                        titulo.cod-rep > INTE(codrepfim) THEN
                        NEXT.

                    /*SD 2428/09 - Novo filtro de titulo por especie*/
                    IF especie <> "TODOS" THEN
                        IF titulo.cod-esp <> especie THEN NEXT.

                    IF titulo.cod-emitente < INTE(codemitenteini) OR
                        titulo.cod-emitente > INTE(codemitentefim) OR
                        titulo.dt-emissao   < vdtemissaoini        OR
                        titulo.dt-emissao   > vdtemissaofim        OR
                        titulo.cod-estabel  < codestabelini        OR
                        titulo.cod-estabel  > codestabelfim        OR
                        titulo.cod-esp      < codespini            OR
                        titulo.cod-esp      > codespfim            OR
                        titulo.nr-docto     < nrdoctoini           OR
                        titulo.nr-docto     > nrdoctofim           THEN
                        NEXT.

                    IF cTipoUsuario = "USU" THEN DO:
                        IF c-lista <> "*" THEN
                            IF LOOKUP(TRIM(STRING(titulo.cod-estabel)),c-lista) = 0 THEN
                                NEXT.
                    END.

                    find first ws-param-global no-error.
                    if cTipoUsuario = "EMI" then do:
                        if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                            find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                            find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                            if emitente.nome-matriz <> b-emitente.nome-matriz then 
                                next.
                        end.    
                    end.
                    ELSE DO:
                        FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                        IF AVAIL emitente THEN DO:
                            IF emitente.nome-matriz  < matrizini OR
                                emitente.nome-matriz  > matrizfim THEN
                                NEXT.
                        END.        
                    END.

                    FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                        AND b-titulo.serie        = titulo.serie     
                                        AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                        AND b-titulo.cod-esp      = titulo.cod-esp
                                        AND b-titulo.nr-docto     = titulo.nr-docto   
                                        NO-LOCK NO-ERROR.

                    RUN titulosavencer.
                END.
            END.
            else do:
                /****************** OUTROS ***************/
                FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini) 
                                            AND empresa.ep-codigo <= INT(epcodigofim), 
                                            EACH titulo USE-INDEX vencimento NO-LOCK WHERE titulo.ep-codigo    = empresa.ep-codigo
                                                                                        AND titulo.dt-vencimen  > today - 1
                                                                                        AND titulo.dt-emissao   >= vdtemissaoini       
                                                                                        AND titulo.dt-emissao   <= vdtemissaofim       
                                                                                        AND titulo.cod-estabel  >= codestabelini       
                                                                                        AND titulo.cod-estabel  <= codestabelfim       
                                                                                        AND titulo.cod-esp      >= codespini           
                                                                                        AND titulo.cod-esp      <= codespfim           
                                                                                        AND titulo.nr-docto     >= nrdoctoini     
                                                                                        AND titulo.nr-docto     <= nrdoctofim,
                                                                                        FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                                            BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                                                ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                                                    ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
                  
                    if titulo.cod-emitente < int(codemitenteini) or 
                        titulo.cod-emitente > int(codemitentefim) then 
                        next.
       
                    /*SD 2428/09 - Novo filtro de titulo por especie*/
                    IF especie <> "TODOS" THEN
                        IF titulo.cod-esp <> especie THEN NEXT.

                    if cTipoUsuario = "USU" then do:
                        if c-lista <> "*" then
                            if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then          
                                next.
                    end.
       
                    if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 then
                        next.
       
                    if titulo.cod-rep < int(codrepini) or
                        titulo.cod-rep > int(codrepfim) then
                        next.

                    find first ws-param-global no-error.
                    if cTipoUsuario = "EMI" then do:
                        if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                            find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                            find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                            if emitente.nome-matriz <> b-emitente.nome-matriz then 
                                next.
                        end.    
                    end.
                    ELSE DO:
                        FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                        IF AVAIL emitente THEN DO:
                            IF emitente.nome-matriz  < matrizini OR
                            emitente.nome-matriz  > matrizfim THEN 
                            NEXT.
                    END.        
                END.

                FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                    AND b-titulo.serie        = titulo.serie     
                                    AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                    AND b-titulo.cod-esp      = titulo.cod-esp
                                    AND b-titulo.nr-docto     = titulo.nr-docto   
                                    NO-LOCK NO-ERROR.

                run titulosavencer.
            end.
    end.
    
    IF l-possui-registro = YES THEN DO:
        IF classificacao = "0" OR classificacao = "1" THEN DO:
            /*
            {&out}
            skip(1)
            */
            PUT "Tot. Aberto por Cliente " SKIP
            "..................................................................................... "
            FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo FORMAT "->>>>,>>>,>>9.99"
            SKIP(1).

            ASSIGN de-tot-titulo = 0.
        END. /*cliente*/
        ELSE IF classificacao = "2" THEN DO:
            /*
            {&out}
            skip(1)
            */            
            PUT "Tot. Aberto por Representante " SKIP
            ".................................................................................... "
            FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo FORMAT "->>>>,>>>,>>9.99"
            SKIP(1).

            ASSIGN de-tot-titulo = 0.

        END. /* Representante*/
        ELSE IF classificacao = "3" THEN DO:
            /*
            {&out}
            skip(1)
            */
            PUT "Tot. Aberto por Dt.Vencto " SKIP
            ".................................................................................... "
            FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo FORMAT "->>>>,>>>,>>9.99"
            SKIP(1).

            ASSIGN de-tot-titulo = 0.
    END. /*vencto*/

    {&out}
    PUT "Sub-total a vencer " SKIP
    ".......................................................................................... " 
    FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-venc FORMAT "->>>>,>>>,>>9.99"
    SKIP(1).
      
    ASSIGN de-tot-venc = 0.

    if vencido = "false" then do:
        /*
        {&out} 
        */
        PUT "Total Geral " SKIP
        ".................................................................................................. "
        FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-total-geral format "->>>>,>>>,>>9.99" SKIP(2).

        /* assign de-total-geral = 0. */
    end.
   end.
 end. /*AVENCER = "true"*/

    /*********** TITULOS VENCIDOS ****************/
    if vencido = "true" then do:

        ASSIGN l-possui-registro    = NO
               l-primeira-vez       = YES
               i-primeiro-registro  = 0
               i-ultimo-registro    = 0
               da-primeiro-registro = ?
               da-ultimo-registro   = ?
               de-vl-titulo         = 0
               de-tot-titulo        = 0
               de-tot-venc          = 0.
    
        if classificacao = "0" then 
            assign c-classif = "CΩdigo Cliente".
        else 
            if classificacao = "1" then 
                assign c-classif = "Razío Social".
            ELSE
                IF classificacao = "2" THEN
                    ASSIGN c-classif = "Representante".

        if codrepini = codrepfim then do:

            FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini)
                                       AND empresa.ep-codigo <= INT(epcodigofim),
                                       EACH titulo USE-INDEX vencimento NO-LOCK WHERE titulo.ep-codigo = empresa.ep-codigo
                                                                                  AND titulo.dt-vencimen   < TODAY - nrdiasvencidos
                                                                                  AND titulo.cod-rep       = int(codrepini),
                                                                                  FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                                    BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                                        ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                                            ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
       
                if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 then
                    next.
       
                IF titulo.cod-estabel  < codestabelini       OR
                   titulo.cod-estabel  > codestabelfim       OR
                   titulo.cod-esp      < codespini           OR
                   titulo.cod-esp      > codespfim           OR
                   titulo.nr-docto     < nrdoctoini          OR
                   titulo.nr-docto     > nrdoctofim          OR
                   titulo.dt-emissao   < vdtemissaoini       or
                   titulo.dt-emissao   > vdtemissaofim       or
                   titulo.cod-emitente < int(codemitenteini) or 
                   titulo.cod-emitente > int(codemitentefim) then 
                    next.

                if cTipoUsuario = "USU" then do:
                    if c-lista <> "*" then
                        if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then          
                            next.
                end. 

                find first ws-param-global no-error.
                if cTipoUsuario = "EMI" then do:
                    if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                        find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                        find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                        if emitente.nome-matriz <> b-emitente.nome-matriz then 
                            next.
                    end.    
                end.
                ELSE DO:
                    FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                    IF AVAIL emitente THEN DO:
                        IF emitente.nome-matriz  < matrizini OR
                           emitente.nome-matriz  > matrizfim THEN 
                            NEXT.
                    END.        
                END.

                FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                    AND b-titulo.serie        = titulo.serie     
                                    AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                    AND b-titulo.cod-esp      = titulo.cod-esp
                                    AND b-titulo.nr-docto     = titulo.nr-docto   
                                    NO-LOCK NO-ERROR.

                run titulosvencidos.
            end. /*for each*/
        end. /* codrepini = codrepfin */ 
        ELSE
            IF cTipoUsuario = "REP" AND num-entries(v-lista) > 1 THEN DO: /* mfo SD 80/05*/
                
                FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini) 
                                            AND empresa.ep-codigo <= INT(epcodigofim),
                                            EACH titulo USE-INDEX vencimento NO-LOCK WHERE titulo.ep-codigo = empresa.ep-codigo
                                                                                        AND titulo.dt-vencimen   < TODAY - nrdiasvencidos
                                                                                        AND LOOKUP(STRING(titulo.cod-rep),v-lista) > 0,
                                                                                        FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                                            BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                                                ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                                                    ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:                 

                    if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 then
                        next.
               
                    if titulo.cod-rep < int(codrepini) or
                       titulo.cod-rep > int(codrepfim) then
                        next.

                    IF titulo.cod-estabel  < codestabelini        OR
                        titulo.cod-estabel  > codestabelfim       OR
                        titulo.cod-esp      < codespini           OR
                        titulo.cod-esp      > codespfim           OR
                        titulo.nr-docto     < nrdoctoini          OR
                        titulo.nr-docto     > nrdoctofim          OR
                        titulo.dt-emissao   < vdtemissaoini       or
                        titulo.dt-emissao   > vdtemissaofim       or
                        titulo.cod-emitente < int(codemitenteini) or 
                        titulo.cod-emitente > int(codemitentefim) then 
                        next.
        
                    if cTipoUsuario = "USU" then do:
                        if c-lista <> "*" then
                            if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then          
                                next.
                    end. 
        
                    find first ws-param-global no-error.
                    if cTipoUsuario = "EMI" then do:
                        if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                            find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                            find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                            if emitente.nome-matriz <> b-emitente.nome-matriz then 
                                next.
                        end.    
                    end.
                    ELSE DO:
                        FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                        IF AVAIL emitente THEN DO:
                            IF emitente.nome-matriz  < matrizini OR
                               emitente.nome-matriz  > matrizfim THEN 
                                NEXT.
                        END.        
                    END.
        
                    FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                        AND b-titulo.serie        = titulo.serie     
                                        AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                        AND b-titulo.cod-esp      = titulo.cod-esp
                                        AND b-titulo.nr-docto     = titulo.nr-docto   
                                        NO-LOCK NO-ERROR.
        
                    run titulosvencidos.
                end. /*for each*/
            end. /* cTipoUsuario = "REP" */ 
            /********** CLIENTE **********/
            ELSE 
                if INTE(codemitenteini) <> 0  or int(codemitentefim) <> 999999999 then do:
                    FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini)
                                                AND empresa.ep-codigo <= INT(epcodigofim),
                                                EACH titulo NO-LOCK WHERE titulo.ep-codigo     = empresa.ep-codigo
                                                                        AND titulo.cod-emitente >= int(codemitenteini) 
                                                                        AND titulo.cod-emitente <= int(codemitentefim),
                                                                        FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                        BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                            ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                                ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
          
                        if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 then
                            next.
         
                        IF titulo.cod-estabel   < codestabelini               OR
                            titulo.cod-estabel   > codestabelfim              OR
                            titulo.cod-esp       < codespini                  OR
                            titulo.cod-esp       > codespfim                  OR
                            titulo.nr-docto      < nrdoctoini                 OR
                            titulo.nr-docto      > nrdoctofim                 OR
                            titulo.dt-emissao    < vdtemissaoini              or
                            titulo.dt-emissao    > vdtemissaofim              or
                            titulo.dt-vencimen  >=  TODAY - nrdiasvencidos    then next.

                        if cTipoUsuario = "USU" then do:
                            if c-lista <> "*" then
                                if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then          
                                    next.
                        end.

                        if titulo.cod-rep < int(codrepini) or
                            titulo.cod-rep > int(codrepfim) then
                            next.

                        find first ws-param-global no-error.
                        if cTipoUsuario = "EMI" then do:
                            if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                                find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                                find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                                if emitente.nome-matriz <> b-emitente.nome-matriz then 
                                    next.
                            end.    
                        end.
                        ELSE DO:
                            FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                            IF AVAIL emitente THEN DO:
                                IF emitente.nome-matriz  < matrizini OR
                                   emitente.nome-matriz  > matrizfim THEN 
                                    NEXT.
                            END.        
                        END.

                        FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                            AND b-titulo.serie        = titulo.serie     
                                            AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                            AND b-titulo.cod-esp      = titulo.cod-esp
                                            AND b-titulo.nr-docto     = titulo.nr-docto   
                                            NO-LOCK NO-ERROR.

                        run titulosvencidos.
                    end. /*for each*/
                END.
                ELSE DO:
                    FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini) 
                                                AND empresa.ep-codigo <= INT(epcodigofim),
                                                EACH titulo USE-INDEX vencimento NO-LOCK WHERE titulo.ep-codigo     = empresa.ep-codigo  
                                                                                            AND titulo.dt-emissao   >= vdtemissaoini      
                                                                                            AND titulo.dt-emissao   <= vdtemissaofim      
                                                                                            AND titulo.dt-vencimen   < TODAY - nrdiasvencidos,
                                                                                            FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                                            BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                                                ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                                                    ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
        
                        if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 then
                            next.
                                                                       
                        IF titulo.cod-estabel  < codestabelini         OR
                            titulo.cod-estabel  > codestabelfim        OR
                            titulo.cod-esp      < codespini            OR
                            titulo.cod-esp      > codespfim            OR
                            titulo.nr-docto     < nrdoctoini           OR 
                            titulo.nr-docto     > nrdoctofim           OR
                            titulo.cod-emitente < INTE(codemitenteini) OR 
                            titulo.cod-emitente > INTE(codemitentefim) THEN NEXT.
                    
                        if cTipoUsuario = "USU" then do:
                            if c-lista <> "*" then
                                if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then next.
                        end.

                        if titulo.cod-rep < INTE(codrepini) OR
                           titulo.cod-rep > INTE(codrepfim) THEN next.
       
                        find first ws-param-global no-error.
                        if cTipoUsuario = "EMI" then do:
                            if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                                find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                                find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                                if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                            end.
                        end.
                        ELSE DO:
                            FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                            IF AVAIL emitente THEN DO:
                                IF emitente.nome-matriz  < matrizini OR
                                   emitente.nome-matriz  > matrizfim THEN NEXT.
                            END.        
                        END.
       
                        FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                            AND b-titulo.serie        = titulo.serie     
                                            AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                            AND b-titulo.cod-esp      = titulo.cod-esp
                                            AND b-titulo.nr-docto     = titulo.nr-docto   
                                            NO-LOCK NO-ERROR.

                        run titulosvencidos.
                    end. /*for each*/
                END.

                if l-possui-registro = yes then DO:
                    if classificacao = "0" OR classificacao = "1" then do:
                    /*
                    {&out}
                    skip(1)
                    */
                    PUT "Tot. Aberto por Cliente " SKIP
                    "..................................................................................... "
                    FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                    skip(1).

                    assign de-tot-titulo = 0.
                end. /*cliente*/
                ELSE IF classificacao = "2" THEN DO:
                    /*
                    {&out}
                    skip(1)
                    */       
                    PUT "Tot. Aberto por Representante " SKIP
                    ".................................................................................... "
                    FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                    skip(1).

                    ASSIGN de-tot-titulo = 0.

                END. /* Representante*/
                ELSE IF classificacao = "3" THEN DO:
                    /*
                    {&out}
                    skip(1)
                    */
                    PUT "Tot. Aberto por Dt.Vencto " SKIP
                    "................................................................................... "
                    FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                    SKIP(1).

                    ASSIGN de-tot-titulo = 0.
                END. /*vencto*/
                /*
                {&out}
                */
                PUT "Sub-total vencido " SKIP
                "........................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-venc format "->>>>,>>>,>>9.99"
                skip(1).
      
                ASSIGN de-tot-venc = 0.

                /*{&out} */
                PUT "Total Geral " SKIP
                "................................................................................................. "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-total-geral format "->>>>,>>>,>>9.99" SKIP(2).

            end.
    end. /*AVENCIDOS = "true"*/

    /*********** TITULOS COM VENCIMENTO ****************/
    IF vencimento = "TRUE" THEN DO:

        ASSIGN l-possui-registro    = NO
               l-primeira-vez       = YES
               i-primeiro-registro  = 0
               i-ultimo-registro    = 0
               da-primeiro-registro = ?
               da-ultimo-registro   = ?
               de-vl-titulo         = 0
               de-tot-titulo        = 0
               de-tot-venc          = 0.
    
        IF classificacao = "0" THEN
            ASSIGN c-classif = "C¢digo Cliente".
        ELSE
            IF classificacao = "1" THEN
                ASSIGN c-classif = "Raz∆o Social".
            ELSE
                IF classificacao = "2" THEN
                    ASSIGN c-classif = "Representante".

        IF INTE(codrepini) <> 00000 OR INTE(codrepfim) <> 99999 THEN DO:
            FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INTE(epcodigoini)
                                        AND empresa.ep-codigo <= INT(epcodigofim),
                                        EACH titulo NO-LOCK WHERE titulo.ep-codigo = empresa.ep-codigo
                                                            AND titulo.cod-rep   = INTE(codrepini)
                                                            AND titulo.dt-vencimen  >= DATE(dtvenctoini) 
                                                            AND titulo.dt-vencimen  <= DATE(dtvenctofim),
                                                            FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                            BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                    ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:

        
                IF LOOKUP(TRIM(STRING(titulo.cod-rep)),v-lista) = 0 THEN NEXT.
       
                IF titulo.cod-estabel  < codestabelini         OR
                    titulo.cod-estabel  > codestabelfim        OR
                    titulo.cod-esp      < codespini            OR
                    titulo.cod-esp      > codespfim            OR
                    titulo.nr-docto     < nrdoctoini           OR
                    titulo.nr-docto     > nrdoctofim           OR
                    titulo.dt-emissao   < vdtemissaoini        OR
                    titulo.dt-emissao   > vdtemissaofim        OR
                    titulo.cod-emitente < INTE(codemitenteini) OR
                    titulo.cod-emitente > INTE(codemitentefim) THEN NEXT.

                if cTipoUsuario = "USU" then do:
                    if c-lista <> "*" then
                        if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then NEXT.
                end.
       
                if titulo.cod-rep < int(codrepini) or
                   titulo.cod-rep > int(codrepfim) THEN next.

                find first ws-param-global no-error.
                if cTipoUsuario = "EMI" then do:
                    if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                        find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                        find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                        if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                    end.    
                end.
                ELSE DO:
                    FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                    IF AVAIL emitente THEN DO:
                        IF emitente.nome-matriz  < matrizini OR
                           emitente.nome-matriz  > matrizfim THEN NEXT.
                    END.        
                END.

                FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                    AND b-titulo.serie        = titulo.serie     
                                    AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                    AND b-titulo.cod-esp      = titulo.cod-esp
                                    AND b-titulo.nr-docto     = titulo.nr-docto   
                                    NO-LOCK NO-ERROR.

                run titulosvencimento.
            end. /*for each*/
        end. /* codrepini = codrepfin */
        ELSE
            IF cTipoUsuario = "REP" AND num-entries(v-lista) > 1 THEN DO: /* mfo SD 80/05*/
                DO iRep = 1 TO num-entries(v-lista):
                    FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini) 
                                            AND empresa.ep-codigo <= INT(epcodigofim),
                                            EACH titulo NO-LOCK WHERE titulo.ep-codigo    = empresa.ep-codigo
                                                                AND titulo.cod-rep      = int(entry(iRep,v-lista))
                                                                AND titulo.dt-vencimen  >= DATE(dtvenctoini) 
                                                                AND titulo.dt-vencimen  <= DATE(dtvenctofim),
                                                                FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                    ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                        ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
         
                        if titulo.cod-rep < int(codrepini) or
                            titulo.cod-rep > int(codrepfim) THEN next.
          
                        if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 THEN next.

                        IF  titulo.cod-estabel  < codestabelini       OR
                            titulo.cod-estabel  > codestabelfim       OR
                            titulo.cod-esp      < codespini           OR
                            titulo.cod-esp      > codespfim           OR
                            titulo.nr-docto     < nrdoctoini          OR
                            titulo.nr-docto     > nrdoctofim          OR
                            titulo.dt-emissao   < vdtemissaoini       or
                            titulo.dt-emissao   > vdtemissaofim       or
                            titulo.cod-emitente < int(codemitenteini) or 
                            titulo.cod-emitente > int(codemitentefim) then next.
    
                        if cTipoUsuario = "USU" then do:
                            if c-lista <> "*" then
                                if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then next.
                        end.
           
                        if titulo.cod-rep < int(codrepini) or
                            titulo.cod-rep > int(codrepfim) THEN next.
    
                        find first ws-param-global no-error.
                        if cTipoUsuario = "EMI" then do:
                            if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                                find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                                find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                                if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                            end.    
                        end.
                        ELSE DO:
                            FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                            IF AVAIL emitente THEN DO:
                                IF emitente.nome-matriz  < matrizini OR
                                    emitente.nome-matriz  > matrizfim THEN NEXT.
                            END.        
                        END.
    
                        FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                            AND b-titulo.serie        = titulo.serie     
                                            AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                            AND b-titulo.cod-esp      = titulo.cod-esp
                                            AND b-titulo.nr-docto     = titulo.nr-docto   
                                            NO-LOCK NO-ERROR.
    
                        run titulosvencimento.
                    end. /*for each*/
                END. /* do */
            end. /* cTipoUsuario = "REP" */
            /********** CLIENTE **********/
            ELSE 
                if INTE(codemitenteini) <> 0  or int(codemitentefim) <> 999999999 then do:
                    FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini)
                                                AND empresa.ep-codigo <= INT(epcodigofim),
                                                EACH titulo NO-LOCK WHERE titulo.ep-codigo     = empresa.ep-codigo
                                                AND titulo.cod-emitente >= int(codemitenteini) 
                                                AND titulo.cod-emitente <= int(codemitentefim),
                                                FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                    ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                        ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
          
                        if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 THEN next.
            
                        IF titulo.cod-estabel  < codestabelini      OR
                            titulo.cod-estabel  > codestabelfim     OR
                            titulo.cod-esp      < codespini         OR
                            titulo.cod-esp      > codespfim         OR
                            titulo.nr-docto     < nrdoctoini        OR
                            titulo.nr-docto     > nrdoctofim        OR
                            titulo.dt-emissao   < vdtemissaoini     or
                            titulo.dt-emissao   > vdtemissaofim     or
                            titulo.dt-vencimen  < DATE(dtvenctoini) or 
                            titulo.dt-vencimen  > DATE(dtvenctofim) then next.

                        if cTipoUsuario = "USU" then do:
                            if c-lista <> "*" then
                                if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then next.
                        end.

                        if titulo.cod-rep < int(codrepini) or
                           titulo.cod-rep > int(codrepfim) THEN next.

                        find first ws-param-global no-error.
                        if cTipoUsuario = "EMI" then do:
                            if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                                find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                                find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                                if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                            end.    
                        end.
                        ELSE DO:
                            FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                            IF AVAIL emitente THEN DO:
                                IF emitente.nome-matriz  < matrizini OR
                                    emitente.nome-matriz  > matrizfim THEN NEXT.
                            END.        
                        END.

                        FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                            AND b-titulo.serie        = titulo.serie     
                                            AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                            AND b-titulo.cod-esp      = titulo.cod-esp
                                            AND b-titulo.nr-docto     = titulo.nr-docto   
                                            NO-LOCK NO-ERROR.

                        run titulosvencimento.
                    end. /*for each*/
                END.
                ELSE DO:
                    FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini) 
                                                AND empresa.ep-codigo <= INT(epcodigofim),
                                                EACH titulo NO-LOCK WHERE titulo.ep-codigo    = empresa.ep-codigo  
                                                                    AND titulo.dt-vencimen  >= DATE(dtvenctoini) 
                                                                    AND titulo.dt-vencimen  <= DATE(dtvenctofim),
                                                                    FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                    BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                        ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                            ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
        
                        if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 THEN next.
       
                        IF  titulo.cod-estabel  < codestabelini       OR
                            titulo.cod-estabel  > codestabelfim       OR
                            titulo.cod-esp      < codespini           OR
                            titulo.cod-esp      > codespfim           OR
                            titulo.nr-docto     < nrdoctoini          OR
                            titulo.nr-docto     > nrdoctofim          OR
                            titulo.dt-emissao   < vdtemissaoini       or
                            titulo.dt-emissao   > vdtemissaofim       or
                            titulo.cod-emitente < int(codemitenteini) or 
                            titulo.cod-emitente > int(codemitentefim) then next.
                    
                        if cTipoUsuario = "USU" then do:
                            if c-lista <> "*" then
                                if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 THEN next.
                        end.
                          
                        if titulo.cod-rep < int(codrepini) or
                            titulo.cod-rep > int(codrepfim) THEN next.
       
                        find first ws-param-global no-error.
                        if cTipoUsuario = "EMI" then do:
                            if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                                find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                                find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                                if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                            end.
                        end.
                        ELSE DO:
                        FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                        IF AVAIL emitente THEN DO:
                            IF  emitente.nome-matriz  < matrizini OR
                                emitente.nome-matriz  > matrizfim THEN NEXT.
                        END.        
                    END.
       
                    FIND LAST b-titulo WHERE b-titulo.ep-codigo    = titulo.ep-codigo
                                        AND b-titulo.serie        = titulo.serie     
                                        AND b-titulo.cod-estabel  = titulo.cod-estabel   
                                        AND b-titulo.cod-esp      = titulo.cod-esp
                                        AND b-titulo.nr-docto     = titulo.nr-docto   
                                        NO-LOCK NO-ERROR.

                    run titulosvencimento.
                end. /*for each*/
            END.

            if l-possui-registro = yes then DO:
                if classificacao = "0" OR classificacao = "1" then do:
                    /*
                    {&out}
                    skip(1)
                    */
                    PUT "Tot. Aberto por Cliente " SKIP
                    "..................................................................................... "
                    FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                    skip(1).

                    assign de-tot-titulo = 0.
                end. /*cliente*/
                ELSE IF classificacao = "2" THEN DO:
                    /*
                    {&out}
                    skip(1)
                    */
                    PUT "Tot. Aberto por Representante " SKIP
                    ".................................................................................... "
                    FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                    skip(1).

                    assign de-tot-titulo = 0.

                END. /* Representante*/
                else if classificacao = "3" then do:
                    /*
                    {&out}
                    skip(1)
                    */
                    PUT "Tot. Aberto por Dt.Vencto " SKIP
                    "................................................................................... "
                    FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                    skip(1).

                    assign de-tot-titulo = 0.
                end. /*vencto*/
                /*
                {&out}
                */
                PUT "Sub-total a vencer " SKIP
                ".......................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-venc format "->>>>,>>>,>>9.99"
                SKIP(1).
      
                ASSIGN de-tot-venc = 0.
                /*
                {&out} 
                */
                PUT "Total Geral " SKIP
                "................................................................................................. "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-total-geral format "->>>>,>>>,>>9.99" SKIP(2).
      
                
            end.
    end. /*AVENCIDOS = "true"*/
    /*********** TITULOS BAIXADOS ****************/

    IF baixado = "true" THEN DO:

        ASSIGN  l-possui-registro    = NO
                l-primeira-vez       = YES
                i-primeiro-registro  = 0
                i-ultimo-registro    = 0
                da-primeiro-registro = ?
                da-ultimo-registro   = ?
                de-vl-titulo         = 0
                de-tot-titulo        = 0
                de-total-geral       = 0.
   
        IF classificacao = "0" THEN ASSIGN c-classif = "CΩdigo Cliente".
            ELSE if classificacao = "1" THEN ASSIGN c-classif = "Razío Social".
                ELSE IF classificacao = "2" THEN ASSIGN c-classif = "Representante".

        /****************** TITULO ***************/
        IF  INTE(epcodigoini) = INTE(epcodigofim)   AND
            codestabelini     = codestabelfim       AND
            codespini         = codespfim           AND
            (nrdoctoini <> '' or nrdoctofim <> "ZZZZZZZZZZZZZZZZ") THEN DO:

            FOR EACH titulo NO-LOCK WHERE titulo.ep-codigo    = int(epcodigofim)    
                                    AND titulo.cod-estabel  = codestabelfim         
                                    AND titulo.cod-esp      = codespfim           
                                    AND titulo.nr-docto     >= nrdoctoini         
                                    AND titulo.nr-docto     <= nrdoctofim,
                                    FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                    BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                        ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                            ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:

                /*SD 2428/09 - Novo filtro de titulo por especie*/
                IF especie <> "TODOS" THEN
                    IF titulo.cod-esp <> especie THEN NEXT.

                if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 THEN next.
         
                if cTipoUsuario = "USU" then do:
                    if c-lista <> "*" then
                        if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then next.
                end.
                      
                IF  titulo.cod-rep      < INTE(codrepini) OR
                    titulo.cod-rep      > INTE(codrepfim) OR
                    titulo.dt-emissao   < vdtemissaoini   OR
                    titulo.dt-emissao   > vdtemissaofim THEN next.

                /**** MATRIZ ****/
                find first ws-param-global no-error.
                if cTipoUsuario = "EMI" then do:
                    if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                        /*** LE EMITENTE DO PED-VENDA ****/
                        find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                        /*** LE EMITENTE QUE ENTROU NO SISTEMA ****/
                        find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                        if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                    end.
                end.
                ELSE DO:
                    FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                    IF AVAIL emitente THEN DO:
                        IF  emitente.nome-matriz  < matrizini OR
                            emitente.nome-matriz  > matrizfim THEN NEXT.
                    END.        
                END.
         
                IF YEAR(titulo.dt-ult-pagto) <= 2012  THEN DO:

                    FOR each mov-tit no-lock where mov-tit.ep-codigo   = titulo.ep-codigo   
                                                and mov-tit.cod-estabel = titulo.cod-estabel 
                                                and mov-tit.cod-esp     = titulo.cod-esp     
                                                AND mov-tit.serie       = titulo.serie 
                                                and mov-tit.nr-docto    = titulo.nr-docto    
                                                and mov-tit.parcela     = titulo.parcela     
                                                and mov-tit.dt-trans   >= vdtbaixaini        
                                                and mov-tit.dt-trans   <= vdtbaixafim:

                        run titulosbaixados.
                    end.

                END.
                ELSE DO:
                    FOR EACH movto_tit_acr WHERE movto_tit_acr.cod_estab      = titulo.cod-estabel
                                            AND movto_tit_acr.num_id_tit_acr = titulo.num-id-titulo-cr
                                            AND movto_tit_acr.dat_transacao >= vdtbaixaini 
                                            AND movto_tit_acr.dat_transacao <= vdtbaixafim NO-LOCK.

                        IF  movto_tit_acr.ind_trans_acr BEGINS "LIQ" AND 
                            movto_tit_acr.log_movto_estordo = NO THEN DO:

                            run titulosbaixados.

                        END.

                    END.
                END.
            end.
        end.
        else 
        /********** CLIENTE **********/
            if INTE(codemitenteini) <> 0  or int(codemitentefim) <> 999999999 then do:

                FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini) 
                                            AND empresa.ep-codigo <= INT(epcodigofim),
                                            EACH titulo  NO-LOCK WHERE titulo.ep-codigo     = empresa.ep-codigo
                                                                    AND titulo.dt-ult-pagto > vdtbaixaini - 1 
                                                                    AND titulo.cod-emitente >= int(codemitenteini) 
                                                                    AND titulo.cod-emitente <= int(codemitentefim),
                                                                    FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                    BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                    ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                        ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
      
                    if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 THEN next.
         
                    if  titulo.ep-codigo    < int(epcodigoini)    or
                        titulo.ep-codigo    > int(epcodigofim)    or
                        titulo.dt-emissao   < vdtemissaoini       or
                        titulo.dt-emissao   > vdtemissaofim       or
                        titulo.cod-estabel  < codestabelini       or
                        titulo.cod-estabel  > codestabelfim       or
                        titulo.cod-esp      < codespini           or
                        titulo.cod-esp      > codespfim           or
                        titulo.nr-docto     < nrdoctoini          or
                        titulo.nr-docto     > nrdoctofim          then next.

                    if cTipoUsuario = "USU" then do:
                        if c-lista <> "*" then
                            if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then next.
                    end.
                      
                    if titulo.cod-rep < int(codrepini) or
                        titulo.cod-rep > int(codrepfim) THEN next.

                    /**** MATRIZ ****/
                    find first ws-param-global no-error.
                    if cTipoUsuario = "EMI" then do:
                        if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                            /*** LE EMITENTE DO PED-VENDA ****/
                            find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                            /*** LE EMITENTE QUE ENTROU NO SISTEMA ****/
                            find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                            if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                        end.    
                    end.
                    ELSE DO:
                        FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                        IF AVAIL emitente THEN DO:
                            IF  emitente.nome-matriz  < matrizini OR
                                emitente.nome-matriz  > matrizfim THEN NEXT.
                        END.        
                    END.
                    IF year(titulo.dt-ult-pagto) <= 2012  THEN DO:

                    FOR each mov-tit no-lock where mov-tit.ep-codigo   = titulo.ep-codigo   
                                                and mov-tit.cod-estabel = titulo.cod-estabel 
                                                and mov-tit.cod-esp     = titulo.cod-esp     
                                                AND mov-tit.serie       = titulo.serie 
                                                and mov-tit.nr-docto    = titulo.nr-docto    
                                                and mov-tit.parcela     = titulo.parcela     
                                                and mov-tit.dt-trans   >= vdtbaixaini        
                                                and mov-tit.dt-trans   <= vdtbaixafim:
                        run titulosbaixados.
                    end.
                END.
                ELSE DO:
                    FOR EACH movto_tit_acr WHERE movto_tit_acr.cod_estab      = titulo.cod-estabel
                                            AND movto_tit_acr.num_id_tit_acr = titulo.num-id-titulo-cr
                                            AND movto_tit_acr.dat_transacao >= vdtbaixaini 
                                            AND movto_tit_acr.dat_transacao <= vdtbaixafim NO-LOCK.

                        IF movto_tit_acr.ind_trans_acr BEGINS "LIQ" AND 
                            movto_tit_acr.log_movto_estordo = NO THEN DO:

                            run titulosbaixados.
                        END.

                    END.
                END.
            end.
        end.
        else
            /********** REPRESENTANTE **********/
            if int(codrepini) <> 0  or int(codrepfim) <> 99999 then do:

                FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini) 
                                         AND empresa.ep-codigo <= INT(epcodigofim) :

                    FOR EACH titulo  NO-LOCK WHERE titulo.ep-codigo    = empresa.ep-codigo    
                                                AND titulo.dt-ult-pagto > vdtbaixaini - 1      
                                                AND titulo.cod-rep      >= int(codrepini)      
                                                AND titulo.cod-rep      <= int(codrepfim),
                                                FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                    ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                        ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:

                        /*SD 2428/09 - Novo filtro de titulo por especie*/
                        IF especie <> "TODOS" THEN
                            IF titulo.cod-esp <> especie THEN NEXT.

                        if cTipoUsuario = "USU" then do:
                            if c-lista <> "*" then
                                if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then next.
                        end.
                    
                        if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 THEN next.
         
                        if  titulo.cod-rep < int(codrepini) or
                            titulo.cod-rep > int(codrepfim) THEN NEXT.

                        if  titulo.cod-emitente < INTE(codemitenteini)  OR
                            titulo.cod-emitente > INTE(codemitentefim)  or
                            titulo.dt-emissao   < vdtemissaoini         or
                            titulo.dt-emissao   > vdtemissaofim         or
                            titulo.cod-estabel  < codestabelini         or
                            titulo.cod-estabel  > codestabelfim         or
                            titulo.cod-esp      < codespini             or
                            titulo.cod-esp      > codespfim             or
                            titulo.nr-docto     < nrdoctoini            or
                            titulo.nr-docto     > nrdoctofim            then next.

                        /**** MATRIZ ****/
                        find first ws-param-global no-error.
                            if cTipoUsuario = "EMI" then do:
                                if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                                    /*** LE EMITENTE DO PED-VENDA ****/
                                    find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                                    /*** LE EMITENTE QUE ENTROU NO SISTEMA ****/
                                    find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                                    if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                                end.    
                            end.
                            ELSE DO:
                                FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                                IF AVAIL emitente THEN DO:
                                    IF emitente.nome-matriz  < matrizini OR
                                        emitente.nome-matriz  > matrizfim THEN NEXT.
                                END.        
                            END.
                            IF year(titulo.dt-ult-pagto) <= 2012  THEN DO:

                                FOR each mov-tit no-lock where mov-tit.ep-codigo   = titulo.ep-codigo   
                                                        and mov-tit.cod-estabel = titulo.cod-estabel 
                                                        and mov-tit.cod-esp     = titulo.cod-esp     
                                                        AND mov-tit.serie       = titulo.serie 
                                                        and mov-tit.nr-docto    = titulo.nr-docto    
                                                        and mov-tit.parcela     = titulo.parcela     
                                                        and mov-tit.dt-trans   >= vdtbaixaini        
                                                        and mov-tit.dt-trans   <= vdtbaixafim:

                                    run titulosbaixados.
                                end.
                            END.
                        ELSE DO:
                            FOR EACH movto_tit_acr WHERE movto_tit_acr.cod_estab      = titulo.cod-estabel
                                                    AND movto_tit_acr.num_id_tit_acr = titulo.num-id-titulo-cr
                                                    AND movto_tit_acr.dat_transacao >= vdtbaixaini 
                                                    AND movto_tit_acr.dat_transacao <= vdtbaixafim NO-LOCK.

                                IF movto_tit_acr.ind_trans_acr BEGINS "LIQ" AND 
                                    movto_tit_acr.log_movto_estordo = NO THEN DO:
                                    run titulosbaixados.
                                END.
                            END.
                        END.
                    END.
                END.
            END.
            ELSE
                IF cTipoUsuario = "REP" AND num-entries(v-lista) > 1 THEN DO: /* mfo SD 80/05*/

                    FOR EACH empresa NO-LOCK WHERE empresa.ep-codigo >= INT(epcodigoini) 
                                            AND empresa.ep-codigo <= INT(epcodigofim),
                                            EACH titulo  NO-LOCK WHERE titulo.ep-codigo    = empresa.ep-codigo    
                                                                AND titulo.dt-ult-pagto > vdtbaixaini - 1      
                                                                AND LOOKUP(STRING(titulo.cod-rep),v-lista) > 0,
                                                                FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                                BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                                    ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                                        ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:
          
                        if cTipoUsuario = "USU" then do:
                            if c-lista <> "*" then
                                if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 then next.
                        end.
             
                        if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 THEN next.
             
                        if titulo.cod-rep < int(codrepini) or
                            titulo.cod-rep > int(codrepfim) THEN NEXT.
    
                        if  titulo.cod-emitente < INTE(codemitenteini)  or 
                            titulo.cod-emitente > INTE(codemitentefim)  or
                            titulo.dt-emissao   < vdtemissaoini         or
                            titulo.dt-emissao   > vdtemissaofim         or
                            titulo.cod-estabel  < codestabelini         or
                            titulo.cod-estabel  > codestabelfim         or
                            titulo.cod-esp      < codespini             or
                            titulo.cod-esp      > codespfim             or
                            titulo.nr-docto     < nrdoctoini            or
                            titulo.nr-docto     > nrdoctofim            then next.
    
                        /**** MATRIZ ****/
                        find first ws-param-global no-error.
                        if cTipoUsuario = "EMI" then do:
                            if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                                /*** LE EMITENTE DO PED-VENDA ****/
                                find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                                /*** LE EMITENTE QUE ENTROU NO SISTEMA ****/
                                find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                                if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                            end.    
                        end.
                        ELSE DO:
                            FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                            IF AVAIL emitente THEN DO:
                                IF  emitente.nome-matriz  < matrizini OR
                                    emitente.nome-matriz  > matrizfim THEN NEXT.
                            END.        
                        END.

                        IF year(titulo.dt-ult-pagto) <= 2012  THEN DO:

                            FOR each mov-tit no-lock where mov-tit.ep-codigo   = titulo.ep-codigo   
                                                        and mov-tit.cod-estabel = titulo.cod-estabel 
                                                        and mov-tit.cod-esp     = titulo.cod-esp     
                                                        AND mov-tit.serie       = titulo.serie 
                                                        and mov-tit.nr-docto    = titulo.nr-docto    
                                                        and mov-tit.parcela     = titulo.parcela     
                                                        and mov-tit.dt-trans   >= vdtbaixaini        
                                                        and mov-tit.dt-trans   <= vdtbaixafim:

                                run titulosbaixados.
                            end.
                        END.
                        ELSE DO:
                            FOR EACH movto_tit_acr WHERE movto_tit_acr.cod_estab      = titulo.cod-estabel
                                                    AND movto_tit_acr.num_id_tit_acr = titulo.num-id-titulo-cr
                                                    AND movto_tit_acr.dat_transacao >= vdtbaixaini 
                                                    AND movto_tit_acr.dat_transacao <= vdtbaixafim NO-LOCK.

                                IF movto_tit_acr.ind_trans_acr BEGINS "LIQ" AND 
                                    movto_tit_acr.log_movto_estordo = NO THEN DO:
                                    RUN titulosbaixados.
                                END.
                            END.
                        END.
                    end. /* for each */
                end. /* cTipoUsuario = "REP" */
                else do: 
                    /****************** OUTROS ***************/

                    FOR EACH titulo  NO-LOCK WHERE titulo.ep-codigo    = INT(epcodigoini) 
                                                AND titulo.dt-ult-pagto > vdtbaixaini - 1  
                                                AND titulo.dt-emissao   >= vdtemissaoini   
                                                AND titulo.dt-emissao   <= vdtemissaofim   
                                                AND titulo.cod-estabel  >= codestabelini   
                                                AND titulo.cod-estabel  <= codestabelfim   
                                                AND titulo.cod-esp      >= codespini       
                                                AND titulo.cod-esp      <= codespfim       
                                                AND titulo.nr-docto     >= nrdoctoini       
                                                AND titulo.nr-docto     <= nrdoctofim,
                                                FIRST b2-emitente WHERE b2-emitente.cod-emitente = titulo.cod-emitente
                                                    BREAK BY (IF classificacao = "0" THEN STRING(titulo.cod-emitente,"999999")
                                                        ELSE IF classificacao = "1" THEN b2-emitente.nome-emit
                                                            ELSE STRING(titulo.cod-rep))/*Ordenar por representante*/:

                        /*SD 2428/09 - Novo filtro de titulo por especie*/
                        IF especie <> "TODOS" THEN
                            IF titulo.cod-esp <> especie THEN NEXT.

                        if cTipoUsuario = "USU" then do:
                            if c-lista <> "*" then
                                if lookup(trim(string(titulo.cod-estabel)),c-lista) = 0 THEN next.
                        end.
         
                        if lookup(trim(string(titulo.cod-rep)),v-lista) = 0 THEN next.
         
                        if (titulo.cod-emitente < INTE(codemitenteini)  OR
                            titulo.cod-emitente > INTE(codemitentefim)) THEN next.

                        if  titulo.cod-rep < int(codrepini) or
                            titulo.cod-rep > int(codrepfim) THEN next.

                        /**** MATRIZ ****/
                        find first ws-param-global no-error.
                        if cTipoUsuario = "EMI" then do:
                            if emitente.ind-abrange-aval = 2 then do: /*MATRIZ*/
                                /*** LE EMITENTE DO PED-VENDA ****/
                                find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.
                                /*** LE EMITENTE QUE ENTROU NO SISTEMA ****/
                                find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.
                                if emitente.nome-matriz <> b-emitente.nome-matriz then next.
                            end.    
                        end.
                        ELSE DO:
                            FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.
                            IF AVAIL emitente THEN DO:
                                IF  emitente.nome-matriz  < matrizini OR
                                    emitente.nome-matriz  > matrizfim THEN NEXT.
                            END.        
                        END.

                        IF year(titulo.dt-ult-pagto) <= 2012  THEN DO:

                        FOR each mov-tit no-lock where mov-tit.ep-codigo   = titulo.ep-codigo   
                                                    and mov-tit.cod-estabel = titulo.cod-estabel 
                                                    and mov-tit.cod-esp     = titulo.cod-esp     
                                                    AND mov-tit.serie       = titulo.serie 
                                                    and mov-tit.nr-docto    = titulo.nr-docto    
                                                    and mov-tit.parcela     = titulo.parcela     
                                                    and mov-tit.dt-trans   >= vdtbaixaini        
                                                    and mov-tit.dt-trans   <= vdtbaixafim:

                            run titulosbaixados.
                        end.
                    END.
                    ELSE DO:
                        FOR EACH movto_tit_acr WHERE movto_tit_acr.cod_estab      = titulo.cod-estabel
                                                AND movto_tit_acr.num_id_tit_acr = titulo.num-id-titulo-cr
                                                AND movto_tit_acr.dat_transacao >= vdtbaixaini 
                                                AND movto_tit_acr.dat_transacao <= vdtbaixafim NO-LOCK.

                            IF  movto_tit_acr.ind_trans_acr BEGINS "LIQ" AND 
                                movto_tit_acr.log_movto_estordo = NO THEN DO:

                                run titulosbaixados.

                            END.
                        END.
                    END.
                END.
            END.  

            if l-possui-registro = yes then DO:
                if classificacao = "0" OR classificacao = "1" then do:
                /*
                {&out}
                skip(1)
                */
                PUT "Total Baixas por Cliente " SKIP
                "............................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                skip(1).

                assign de-tot-titulo = 0.
            end. /*cliente*/
            ELSE IF classificacao = "2" THEN DO:
                /*
                {&out}
                skip(1)
                */
                PUT "Tot. Aberto por Representante " SKIP
                ".................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                skip(1).

                ASSIGN de-tot-titulo = 0.

            END. /* Representante*/
            else if classificacao = "3" then do:
                /*
                {&out}
                skip(1)
                */
                PUT "Total Baixas por Dt.Vencto " SKIP
                "............................................................................................. "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                skip(1).

                assign de-tot-titulo = 0.
            end. /*vencto*/

            /*
            {&out} 
            */
            PUT "Total Geral " SKIP
            "............................................................................................................ "
            FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-total-geral format "->>>>,>>>,>>9.99" skip(2).                  
        END.
 end. /*baixado = "true"*/

OUTPUT CLOSE.
/*************** IMPRESSAO DOS TITULOS A VENCER ********************/
PROCEDURE titulosavencer:
    
    IF titulo.vl-saldo <= 0 THEN NEXT.
    IF titulo.dt-vencimen < TODAY THEN NEXT.
    IF titulo.dt-vencimen - TODAY > INTE(nrdiasvencer) THEN NEXT.

    /*SD 2428/09 - Novo filtro de titulo por especie*/
    IF especie <> "TODOS" THEN
        IF titulo.cod-esp <> especie THEN NEXT.
         
    IF l-primeira-vez = yes then do:

        IF cTipoUsuario = "REP" THEN DO:
            FIND repres WHERE repres.cod-rep = iEmitente no-lock NO-ERROR.
            ASSIGN c-confidencial = IF AVAIL repres THEN repres.nome ELSE "".
        END.
    
        IF cTipoUsuario = "EMI" THEN DO:
            FIND emitente WHERE emitente.cod-emitente = iEmitente no-lock NO-ERROR.
            ASSIGN c-confidencial = IF AVAIL emitente THEN emitente.nome-emit ELSE "".
        END.

        IF cTipoUsuario = "USU" THEN DO:
            
            PUT "T÷TULOS A VENCER " SKIP
                "Cliente;"
                "Razao Social;"
                "Matriz;"
                "Representante;"
                "Emp;"
                "Est;"
                "Esp;"
                "Docto/Parcela;"
                "Port-M;"
                "Dt.Emiss∆o;"
                "Dt.Vencto;"
                "Saldo(R$);"
                "Dias;"
                "Hist.Negoc.;"
                SKIP.
        END.
        ELSE DO:            
            PUT 'Confidencial para o CNPJ/CPF: ' " " + 
                STRING(c-seg-usuario, IF LENGTH(TRIM(c-seg-usuario)) > 11 THEN  "99.999.999/9999-99" ELSE  "999.999.999-99")
                   " " c-confidencial SKIP.
            
            PUT "T÷TULOS A VENCER"  SKIP            
            "Cliente;"
            "Razao Social;"
            "Emp;"
            "Est;"
            "Esp;"
            "Docto;"
            "Port-M;"
            "Dt.Emiss∆o;"
            "Dt.Vencto;"
            "Saldo(R$);"
            "Dias;"
            "Representante;"
            "Hist.Negoc.;"
            SKIP.
        END.
        
        assign l-primeira-vez = NO.

        IF classificacao = "0" OR classificacao = "1" THEN 
            ASSIGN i-ultimo-registro = titulo.cod-emitente.
        ELSE IF classificacao = "3" THEN 
            ASSIGN da-ultimo-registro = titulo.dt-vencimen.
        ELSE IF classificacao = "2" THEN 
            ASSIGN i-ultimo-registro = titulo.cod-rep.
    END.                                                    

     IF classificacao = "0" OR classificacao = "1" then 
         ASSIGN i-primeiro-registro = titulo.cod-emitente.
     ELSE IF classificacao = "3" 
          THEN ASSIGN da-primeiro-registro = titulo.dt-vencimen.
     ELSE IF classificacao = "2"
          THEN ASSIGN i-primeiro-registro = titulo.cod-rep.

    IF classificacao = "0" OR classificacao = "1" THEN DO:
        IF i-primeiro-registro <> i-ultimo-registro THEN DO:
            /*            
            {&out}
            skip(1)
            */

            PUT "Tot. Aberto por Cliente " SKIP
            "..................................................................................... "
            FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
            SKIP.

            ASSIGN de-tot-titulo = 0.
    
            ASSIGN i-ultimo-registro = titulo.cod-emitente.
        END. /*ultimo da quebra*/
    END. /*cliente*/
    ELSE IF classificacao = "2" THEN DO:
        IF i-primeiro-registro <> i-ultimo-registro THEN DO:
            /*
            {&out}
            */
            PUT "Tot. Aberto por Representante " SKIP
            ".................................................................................... "
            FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
            SKIP.

            ASSIGN de-tot-titulo = 0.
            ASSIGN i-ultimo-registro = titulo.cod-rep.
        END.
    END. /* Representante*/
    ELSE IF classificacao = "3" then do:
        IF da-primeiro-registro <> da-ultimo-registro THEN DO:
            /*
            {&out}
            */            
            PUT "Tot. Aberto por Dt.Vencto " SKIP
            "................................................................................... "
            FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
            SKIP.

            ASSIGN de-tot-titulo        = 0
                   da-ultimo-registro   = titulo.dt-vencimen.
        END. /*ultimo da quebra*/
    END. /*vencto*/

    ASSIGN i-nr-dias-titulosavencer = titulo.dt-vencimen - TODAY.

    FIND FIRST repres WHERE repres.cod-rep = titulo.cod-rep NO-LOCK NO-ERROR.

    /****** CONVERTE VALOR P/ MOEDA SOLICITADA ********/
    RUN tortuga/wssr010.p (0, input int(mocodigo), input titulo.vl-saldo, input today, output de-vl-titulo).

    find first emitente where emitente.cod-emitente = titulo.cod-emitente no-lock no-error.

    if cTipoUsuario = "EMI" then
        find first b-emitente where b-emitente.cod-emitente = iEmitente no-error.

    FIND FIRST relac_movto_cobr_tit_acr WHERE relac_movto_cobr_tit_acr.cod_estab      = titulo.cod-estabel
                                          AND relac_movto_cobr_tit_acr.num_id_tit_acr = titulo.num-id-titulo-cr NO-LOCK NO-ERROR.

    FIND FIRST his-tit OF titulo WHERE SUBSTRING(his-tit.char-2,77,3) = "SIM" NO-LOCK NO-ERROR.

    RUN piGetRowId.

    IF cTipoUsuario = "USER" THEN DO:
        PUT titulo.cod-emitente FORMAT ">>>>>>>>9".
    END.
    ELSE
        PUT titulo.cod-emitente FORMAT ">>>>>>>>9".
     
     PUT emitente.nome-emit FORMAT "X(40)" " ".

     IF cTipoUsuario = "USU" THEN DO:
        PUT emitente.nome-matriz FORMAT "x(12)" " ".
     END.

     IF AVAIL repres  THEN DO:
         IF cTipoUsuario = "USU" THEN DO:
           PUT repres.nome-abrev FORMAT "X(16)" " ".
        end.         
    END.

    PUT STRING(titulo.ep-codigo)                                ";"
        STRING(titulo.cod-estabel)                              ";"
        STRING(titulo.cod-esp)                                  ";"
        STRING(titulo.nr-docto) +   "/" +                       ";"
        STRING(titulo.parcela)  +   "-" +   STRING(b-titulo.parcela)    ";"
        STRING(titulo.cod-port)       + ";"
        STRING(titulo.modalidade)     + ";"
        STRING(titulo.dt-emissao)     + ";"
        STRING(titulo.dt-vencimen)    + ";"
        STRING(de-vl-titulo)          + "-" STRING(i-nr-dias-titulosavencer) ";".

    IF NOT cTipoUsuario = "REP" OR NOT AVAIL repres THEN DO:
        /*
        IF AVAIL his-tit OR AVAIL relac_movto_cobr_tit_acr THEN DO: 
             {&out} '<a href="#."' skip.
             {&out} "onclick=".
             {&out} '"AbreHistorico'.
             {&out} "('" STRING(r-rowid) "') ".
             {&out} '"'.
             {&out} "'>".
             {&out} "<b>".
             {&out} "SIM" FORMAT "x(3)".
             {&out} "</b>".
             {&out} "</a>"  SKIP(1).
         END.
         ELSE {&out} " " SKIP(1).
         */
    END.
    ELSE IF cTipoUsuario = "REP" AND AVAIL repres THEN DO:
        PUT repres.nome-abrev format "x(15)" SKIP. 
        IF AVAIL his-tit OR AVAIL relac_movto_cobr_tit_acr THEN DO:
            /*
            {&out} '<a href="#."' skip.
            {&out} "onclick=".
            {&out} '"AbreHistorico'.
            {&out} "('" STRING(r-rowid) "') ".
            {&out} '"'.
            {&out} "'>".
            {&out} "<b>".
            {&out} "SIM" FORMAT "x(3)".
            {&out} "</b>".
            {&out} "</a>"  SKIP(1).
            */
        END.
        /*ELSE {&out} " " SKIP(1).*/
     END.
     /*ELSE {&out} " " SKIP.*/

     if titulo.tipo = 2
     then assign de-tot-titulo  = de-tot-titulo  - de-vl-titulo
                 de-tot-venc    = de-tot-venc    - de-vl-titulo
                 de-total-geral = de-total-geral - de-vl-titulo.
     else assign de-tot-titulo  = de-tot-titulo  + de-vl-titulo
                 de-tot-venc    = de-tot-venc    + de-vl-titulo
                 de-total-geral = de-total-geral + de-vl-titulo.

     assign l-possui-registro = yes.
end PROCEDURE.

/*************** IMPRESSAO DOS TITULOS VENCIDOS ********************/
PROCEDURE titulosvencidos:
     
    if titulo.vl-saldo <= 0 then next.

    /*SD 2428/09 - Novo filtro de titulo por especie*/
    IF especie <> "TODOS" THEN
        IF titulo.cod-esp <> especie THEN NEXT.
     
    IF l-primeira-vez = YES THEN DO:
        IF cTipoUsuario = "USU" THEN DO:
            PUT "TITULOS VENCIDOS  "  /*"A MAIS DE " string(nrdiasvencidos) " DIAS "*/  SKIP.
            
            PUT "Cliente;"
                "Razao Social;"
                "Matriz;"
                "Representante;"
                "Emp;"
                "Est;"
                "Esp;"
                "Docto/Parcela;"
                "Port-M;"
                "Dt.Emiss∆o;"
                "Dt.Vencto;"
                "Saldo(R$);"
                "Dias;"
                "Hist.Negoc."
                SKIP.
        END.
        ELSE DO:
            PUT "TITULOS VENCIDOS" SKIP.
            
            PUT "Cliente;"
                "Razao Social;"
                "Emp;"
                "Est;"
                "Esp;"
                "Docto/Parcela;"
                "Port-M;"
                "Dt.Emiss∆o;"
                "Dt.Vencto;"
                "Saldo(R$);"
                "Dias;"
                "Representante;"
                "Hist.Negoc.;"
                SKIP.

        END.
        
        ASSIGN l-primeira-vez = no.

        IF classificacao = "0" OR classificacao = "1" THEN
            ASSIGN i-ultimo-registro = titulo.cod-emitente.
        ELSE IF classificacao = "3" THEN
            ASSIGN da-ultimo-registro = titulo.dt-vencimen.
        ELSE IF classificacao = "2" THEN 
            ASSIGN i-ultimo-registro = titulo.cod-rep.
    END.

    IF classificacao = "0" OR classificacao = "1" THEN
        ASSIGN i-primeiro-registro = titulo.cod-emitente.
    ELSE if classificacao = "3" THEN
        ASSIGN da-primeiro-registro = titulo.dt-vencimen.
        ELSE IF classificacao = "2"
          THEN ASSIGN i-primeiro-registro = titulo.cod-rep.

    IF classificacao = "0" OR classificacao = "1" THEN DO:
        IF i-primeiro-registro <> i-ultimo-registro THEN DO:
            /*
            {&out}
            skip(1)
            */
            PUT "Tot. Aberto por Cliente " SKIP
                "..................................................................................... "
            FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
            SKIP.

            ASSIGN de-tot-titulo = 0 
                   i-ultimo-registro = titulo.cod-emitente.

        END. /*ultimo da quebra*/
    END. /*cliente*/
    ELSE IF classificacao = "2" THEN DO:
        IF i-primeiro-registro <> i-ultimo-registro then do:
            /*
            {&out}
            skip(1)
            */
            PUT "Tot. Aberto por Representante " SKIP
            ".................................................................................... "
            FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
            SKIP.

            ASSIGN de-tot-titulo = 0
                   i-ultimo-registro = titulo.cod-rep.
        END.
    END. /* Representante*/
    ELSE IF classificacao = "3" THEN DO:
        IF da-primeiro-registro <> da-ultimo-registro THEN DO:
            /*
            {&out}
            skip(1)
            */
            PUT "Tot. Aberto por Dt.Vencto "
                 "................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                SKIP.

            ASSIGN de-tot-titulo = 0   
                   da-ultimo-registro = titulo.dt-vencimen.
        END. /*ultimo da quebra*/
    END. /*vencto*/

    ASSIGN i-nr-dias-titulosvencidos = TODAY - titulo.dt-vencimen. /*SD. 1566 - Diogo Arado*/

    FIND FIRST repres WHERE repres.cod-rep = titulo.cod-rep NO-LOCK NO-ERROR.

    /****** CONVERTE VALOR P/ MOEDA SOLICITADA ********/
    RUN tortuga/wssr010.p (0, input int(mocodigo), input titulo.vl-saldo, INPUT TODAY, OUTPUT de-vl-titulo).

    find first emitente where emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.

    IF cTipoUsuario = "EMI" THEN
       FIND FIRST b-emitente WHERE b-emitente.cod-emitente = iEmitente NO-ERROR.

    FIND FIRST relac_movto_cobr_tit_acr WHERE relac_movto_cobr_tit_acr.cod_estab      = titulo.cod-estabel
                                          AND relac_movto_cobr_tit_acr.num_id_tit_acr = titulo.num-id-titulo-cr NO-LOCK NO-ERROR.
     
    FIND FIRST his-tit OF titulo WHERE SUBSTRING(his-tit.char-2,77,3) = "SIM" NO-LOCK NO-ERROR.

    RUN piGetRowId.
    /*    
    IF cTipoUsuario = "USER" THEN DO:
        {&out} '<a href="#."' skip.
        {&out} "onclick=".
        {&out} '"AbreMenuCliente'.
        {&out} "('" STRING(r-rowid) "') ".
        {&out} '"'.
        {&out} "'>".
        {&out} titulo.cod-emitente format ">>>>>>>>9".
        {&out} "</a>".
     END.
     ELSE
        {&out} titulo.cod-emitente format ">>>>>>>>9".
    */
    PUT titulo.cod-emitente     ";"
        emitente.nome-emit      ";"
        emitente.nome-matriz    ";".
     
    IF AVAIL repres  THEN DO:
        PUT repres.nome-abrev   ";".
    END.

    PUT titulo.ep-codigo        ";"
        titulo.cod-estabel      ";"
        titulo.cod-esp          ";".
    /*
    if titulo.cod-esp = 'DP' AND ((cTipoUsuario = "EMI" and iEmitente = emitente.cod-emit) OR
        (cTipoUsuario = "EMI" and emitente.nome-matriz = b-emitente.nome-matriz and emitente.ind-abrange-aval = 2) or
        (cTipoUsuario = "REP" and lookup(trim(string(titulo.cod-rep)),v-lista) <> 0) or 
         cTipoUsuario = "USU") then do:

        {&out} '<a href="#."' skip.
        {&out} "onclick=".
        {&out} '"ChamaBoleto'.
        {&out} "('" STRING(r-rowid) "','" mocodigo "') ".
        {&out} '"'.
        {&out} "'>".
        {&out} titulo.nr-docto FORMAT "x(11)".       
        {&out} "</a>".
    END.
    ELSE
    */
    PUT titulo.nr-docto +
        "/"             +
        titulo.parcela              "-"
        b-titulo.parcela            "   ;"
        titulo.cod-port             "-"
        titulo.modalidade           ";"
        titulo.dt-emissao           ";"
        titulo.dt-vencimen          ";"
        de-vl-titulo                ";"
        i-nr-dias-titulosvencidos format ">>>9" " ".

    IF cTipoUsuario = "REP" AND AVAIL repres THEN DO:
        PUT repres.nome-abrev ";".
     END.
     
     IF titulo.tipo = 2 then 
         ASSIGN de-tot-titulo  = de-tot-titulo  - de-vl-titulo
                de-tot-venc    = de-tot-venc    - de-vl-titulo
                de-total-geral = de-total-geral - de-vl-titulo.
     ELSE ASSIGN de-tot-titulo  = de-tot-titulo  + de-vl-titulo
                 de-tot-venc    = de-tot-venc    + de-vl-titulo
                 de-total-geral = de-total-geral + de-vl-titulo.

     ASSIGN l-possui-registro = yes.
END PROCEDURE.

/*************** IMPRESSAO DOS TITULOS VENCIDOS ********************/
PROCEDURE titulosvencimento:

    /*SD 2428/09 - Novo filtro de titulo por especie*/
    IF especie <> "TODOS" THEN
        IF titulo.cod-esp <> especie THEN NEXT.
     
    IF l-primeira-vez = YES THEN DO:
        
        PUT "TITULOS COM VENCIMENTO " + STRING(DATE(dtvenctoini), "99/99/9999") + " ATê» " + STRING(DATE(dtvenctofim), "99/99/9999")  SKIP.

        IF cTipoUsuario = "USU" THEN DO:
            PUT "Cliente;"
                "Razao Social;"
                "Matriz;"
                "Representante;"
                "Emp;"
                "Est;"
                "Esp;"
                "Docto      /Parcela;"
                " Port-M;"
                "Dt.Emiss∆o;"
                "Dt.Vencto;"
                "     Saldo(R$);"
                "Dias;"
                "Hist.Negoc.;" SKIP.
        END.
        ELSE DO:
            PUT "Cliente;"
                "Razao Social;"
                "Emp;"
                "Est;"
                "Esp;"
                "Docto      /Parcela;"
                " Port-M;"
                "Dt.Emissao;"
                "Dt.Vencto;"
                "     Saldo(R$);"
                "Dias;"
                "Hist.Negoc.;" SKIP.
        END.
        
        ASSIGN l-primeira-vez = NO.

        IF classificacao = "0" OR classificacao = "1" THEN 
            ASSIGN i-ultimo-registro = titulo.cod-emitente.
        ELSE IF classificacao = "3" THEN 
            ASSIGN da-ultimo-registro = titulo.dt-vencimen.
        ELSE IF classificacao = "2" THEN 
            ASSIGN i-ultimo-registro = titulo.cod-rep.
    END.

    IF classificacao = "0" OR classificacao = "1" THEN 
        ASSIGN i-primeiro-registro = titulo.cod-emitente.
    ELSE IF classificacao = "3" THEN 
        ASSIGN da-primeiro-registro = titulo.dt-vencimen.
    ELSE IF classificacao = "2" THEN 
        ASSIGN i-primeiro-registro = titulo.cod-rep.

    if classificacao = "0" OR classificacao = "1" then do:
        if i-primeiro-registro <> i-ultimo-registro then do:
            PUT "Tot. Aberto por Cliente " SKIP
                "..................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                SKIP.

            assign de-tot-titulo = 0
                   i-ultimo-registro = titulo.cod-emitente.
        END. /*ultimo da quebra*/
    END. /*cliente*/
    ELSE IF classificacao = "2" THEN DO:
        if i-primeiro-registro <> i-ultimo-registro then do:
            PUT "Tot. Aberto por Representante " SKIP
                ".................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                SKIP.

            ASSIGN de-tot-titulo = 0
                   i-ultimo-registro = titulo.cod-emitente.
        END.
    END. /* Representante*/
    ELSE IF classificacao = "3" THEN DO:
        IF da-primeiro-registro <> da-ultimo-registro then do:
            PUT "Tot. Aberto por Dt.Vencto " SKIP
                ".................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                SKIP.

                ASSIGN de-tot-titulo = 0
                       da-ultimo-registro = titulo.dt-vencimen.
        END. /*ultimo da quebra*/
    END. /*vencto*/

    ASSIGN i-nr-dias-titulosvencidos = TODAY - titulo.dt-vencimen. /*SD. 1566 - Diogo Arado*/

    FIND first repres WHERE repres.cod-rep = titulo.cod-rep NO-LOCK NO-ERROR.

    /****** CONVERTE VALOR P/ MOEDA SOLICITADA ********/
    RUN tortuga/wssr010.p (0, INPUT INTE(mocodigo), INPUT titulo.vl-saldo, INPUT TODAY, OUTPUT de-vl-titulo).

    FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.

    IF cTipoUsuario = "EMI" THEN
        FIND FIRST b-emitente WHERE b-emitente.cod-emitente = iEmitente NO-ERROR.

    FIND FIRST relac_movto_cobr_tit_acr 
          WHERE relac_movto_cobr_tit_acr.cod_estab      = titulo.cod-estabel
            AND relac_movto_cobr_tit_acr.num_id_tit_acr = titulo.num-id-titulo-cr NO-LOCK NO-ERROR.
     
    FIND FIRST his-tit OF titulo
         WHERE SUBSTRING(his-tit.char-2,77,3) = "SIM" NO-LOCK NO-ERROR.

    RUN piGetRowId.

    PUT titulo.cod-emitente     ";"
        emitente.nome-emit      ";"
        emitente.nome-matriz    ";".

    IF AVAIL repres  THEN DO:
        IF cTipoUsuario = "USU" THEN DO:
            PUT repres.nome-abrev ";".
        END.
    END.
      
    PUT titulo.ep-codigo            ";"
        titulo.cod-estabel          ";"
        titulo.cod-esp              ";"
        titulo.nr-docto     
        "/"                 
        titulo.parcela       "-" 
        b-titulo.parcela      " "
        titulo.cod-port        "-"
        titulo.modalidade           ";"
        titulo.dt-emissao           ";"
        titulo.dt-vencimen          ";"
        de-vl-titulo                ";"
        i-nr-dias-titulosvencidos   ";".
     
    IF titulo.tipo = 2 THEN
         ASSIGN de-tot-titulo  = de-tot-titulo  - de-vl-titulo
                de-tot-venc    = de-tot-venc    - de-vl-titulo
                de-total-geral = de-total-geral - de-vl-titulo.
    ELSE
        ASSIGN de-tot-titulo  = de-tot-titulo  + de-vl-titulo
               de-tot-venc    = de-tot-venc    + de-vl-titulo
               de-total-geral = de-total-geral + de-vl-titulo.

     ASSIGN l-possui-registro = YES.

END PROCEDURE.

/*************** IMPRESSAO DOS TITULOS BAIXADOS ********************/
PROCEDURE titulosbaixados.
    
    FIND LAST b-titulo WHERE b-titulo.ep-codigo  = titulo.ep-codigo
                        AND b-titulo.serie        = titulo.serie
                        AND b-titulo.cod-estabel  = titulo.cod-estabel
                        AND b-titulo.cod-esp      = titulo.cod-esp
                        AND b-titulo.nr-docto     = titulo.nr-docto
                        NO-LOCK NO-ERROR.

    IF NOT ((titulo.vl-saldo = 0 OR titulo.vl-saldo <> titulo.vl-original) AND titulo.dt-ult-pagto <> ?) THEN
        NEXT.

    FIND FIRST fat-duplic NO-LOCK WHERE fat-duplic.cod-estabel = titulo.cod-estabel
                                    AND fat-duplic.serie       = titulo.serie
                                    AND fat-duplic.nr-fatura   = titulo.nr-docto
                                    AND fat-duplic.parcela     = titulo.parcela NO-ERROR.

    IF NOT AVAIL fat-duplic THEN NEXT.

    /*SD 2428/09 - Novo filtro de titulo por especie*/
    IF especie <> "TODOS" THEN
        IF titulo.cod-esp <> especie THEN NEXT.

    IF YEAR(titulo.dt-ult-baixa) <= 2012  THEN DO:
        IF mov-tit.transacao <> 2 THEN NEXT.
    END.

    IF l-primeira-vez = YES THEN DO:

        IF cTipoUsuario = "REP" THEN DO:
            FIND repres WHERE repres.cod-rep = iEmitente no-lock NO-ERROR.
            ASSIGN c-confidencial = IF AVAIL repres THEN repres.nome ELSE "".
        END.
    
        IF cTipoUsuario = "EMI" THEN DO:
            FIND emitente WHERE emitente.cod-emitente = iEmitente no-lock NO-ERROR.
            ASSIGN c-confidencial = IF AVAIL emitente THEN emitente.nome-emit ELSE "".
        END.

        IF cTipoUsuario = "USU" THEN DO:
            PUT "T÷TULOS BAIXADOS DE " VDTBAIXAINI FORMAT "99/99/9999" " AT» " VDTBAIXAFIM FORMAT "99/99/9999" SKIP.

            PUT "Cliente;"
                "Razao Social;"
                "Matriz;"
                "Representante;"
                "Emp;"
                "Esp;"
                "Docto      /Parcela;"
                " Port-M;"
                "Dt.Emiss∆o;"
                "Dt.Vencto;"
                "Dt.Pagto;"
                "      Vl.Baixa;"
                "  Dias;"
                "Hist.Negoc.;"
                SKIP.
        END.
        ELSE DO:

            PUT 'Confidencial para o CNPJ/CPF: ' " "
                STRING(c-seg-usuario, IF LENGTH(TRIM(c-seg-usuario)) > 11 THEN  "99.999.999/9999-99" ELSE  "999.999.999-99")
                " " c-confidencial SKIP.

            PUT "T÷TULOS BAIXADOS DE " VDTBAIXAINI format "99/99/9999" " AT» " 
                                   VDTBAIXAFIM format "99/99/9999" SKIP.
            
            
            PUT "Cliente;"
                "Razao Social;"
                "Emp;"
                "Est;"
                "Esp;"
                "Docto      /Parcela;"
                " Port-M;"
                "Dt.Emissao;"
                "Dt.Vencto;"
                "Dt.Pagto;"
                "      Vl.Baixa;"
                "  Dias;"
                "   Representante;"
                " Hist.Negoc.;"
                SKIP.
        END.
        
        ASSIGN l-primeira-vez = NO.

        IF classificacao = "0" OR classificacao = "1" THEN 
            ASSIGN i-ultimo-registro = titulo.cod-emitente.
        ELSE IF classificacao = "3" THEN
            ASSIGN da-ultimo-registro = titulo.dt-vencimen.
        ELSE IF classificacao = "2" THEN 
            ASSIGN i-ultimo-registro = titulo.cod-rep.

     END.

     IF classificacao = "0" OR classificacao = "1" THEN
         ASSIGN i-primeiro-registro = titulo.cod-emitente.
     ELSE IF classificacao = "3" THEN
         ASSIGN da-primeiro-registro = titulo.dt-vencimen.
     ELSE IF classificacao = "2" THEN
         ASSIGN i-primeiro-registro = titulo.cod-rep.

    IF classificacao = "0" OR classificacao = "1" THEN DO:
        IF i-primeiro-registro <> i-ultimo-registro THEN DO:
            PUT "Total Baixas por Cliente " SKIP
                "............................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo FORMAT "->>>>,>>>,>>9.99"
                SKIP.

            ASSIGN de-tot-titulo = 0
                   i-ultimo-registro = titulo.cod-emitente.
        END. /*ultimo da quebra*/
    END. /*cliente*/
    ELSE IF classificacao = "2" THEN DO:
        IF i-primeiro-registro <> i-ultimo-registro THEN DO:
            PUT "Tot. Aberto por Representante " SKIP
                ".................................................................................... "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                SKIP.

            assign de-tot-titulo = 0
                   i-ultimo-registro = titulo.cod-rep.
        END.
    END. /* Representante*/
    ELSE IF classificacao = "3" THEN DO:
        IF da-primeiro-registro <> da-ultimo-registro THEN DO:
            PUT "Total Baixas por Dt.Vencto "
                "............................................................................................. "
                FILL(" ", IF cTipoUsuario = "USU" THEN 28 ELSE 2) de-tot-titulo format "->>>>,>>>,>>9.99"
                SKIP.

            ASSIGN de-tot-titulo = 0    
                   da-ultimo-registro = titulo.dt-vencimen.
        END. /*ultimo da quebra*/
    END. /*vencto*/

    IF year(titulo.dt-ult-pagto) <= 2012  THEN DO:
        assign i-nr-dias-titulosbaixados = mov-tit.dt-baixa - titulo.dt-vencimen.
    END.
    ELSE DO:
        ASSIGN i-nr-dias-titulosbaixados = movto_tit_acr.dat_transacao - titulo.dt-vencimen.
    END.

    FIND FIRST repres WHERE repres.cod-rep = titulo.cod-rep NO-LOCK NO-ERROR.

    /****** CONVERTE VALOR P/ MOEDA SOLICITADA ********/
    IF YEAR(titulo.dt-ult-pagto) <= 2012  THEN 
        RUN tortuga/wssr010.p (INPUT 0, INPUT INTE(mocodigo), mov-tit.vl-baixa, INPUT TODAY, OUTPUT de-vl-titulo).
    ELSE 
        ASSIGN de-vl-titulo = movto_tit_acr.val_movto_tit_acr.
       
    FIND FIRST emitente WHERE emitente.cod-emitente = titulo.cod-emitente NO-LOCK NO-ERROR.

    IF cTipoUsuario = "EMI" THEN
        FIND FIRST b-emitente WHERE b-emitente.cod-emitente = iEmitente NO-ERROR.

    FIND FIRST relac_movto_cobr_tit_acr 
          WHERE relac_movto_cobr_tit_acr.cod_estab      = titulo.cod-estabel
            AND relac_movto_cobr_tit_acr.num_id_tit_acr = titulo.num-id-titulo-cr NO-LOCK NO-ERROR.
     
    FIND FIRST his-tit OF titulo WHERE SUBSTRING(his-tit.char-2,77,3) = "SIM" NO-LOCK NO-ERROR.

    RUN piGetRowId.

    PUT titulo.cod-emitente     ";"
        emitente.nome-emit      ";"
        emitente.nome-matriz    ";"     
        titulo.ep-codigo        ";"
        titulo.cod-estabel      ";"
        titulo.cod-esp          ";"
        titulo.nr-docto              
        "/"
        titulo.parcela
        "      "
        titulo.cod-port
        "-"
        titulo.modalidade       ";"
        titulo.dt-emissao       ";"
        titulo.dt-vencimen      ";".

    IF year(titulo.dt-ult-pagto) <= 2012  THEN DO:
        PUT mov-tit.dt-baixa    ";".
     END.
     ELSE DO:
        PUT movto_tit_acr.dat_transacao ";".
     END.

     PUT de-vl-titulo               ";"
         i-nr-dias-titulosbaixados  ";".

    IF AVAIL repres THEN DO:
        PUT repres.nome-abrev ";".
     END.

    IF titulo.tipo = 2 THEN
         ASSIGN de-tot-titulo  = de-tot-titulo  - de-vl-titulo
                de-total-geral = de-total-geral - de-vl-titulo.
    ELSE
        ASSIGN de-tot-titulo  = de-tot-titulo  + de-vl-titulo
               de-total-geral = de-total-geral + de-vl-titulo.

    ASSIGN l-possui-registro = YES.

END PROCEDURE.

PROCEDURE piPermissao:

    DEFINE BUFFER bf-titulo  FOR titulo.
    DEFINE BUFFER bf_titulo  FOR tit_acr.

    r-rowid = ?.

    /* EMS2 */
    IF tt-titulo.vl-saldo = 0 AND tt-titulo.dt-liq < DATE(01,01,2013) THEN DO:

       FIND FIRST bf-titulo 
            WHERE bf-titulo.ep-codigo   = tt-titulo.ep-codigo
              AND bf-titulo.serie       = tt-titulo.serie     
              AND bf-titulo.cod-estabel = tt-titulo.cod-estabel   
              AND bf-titulo.cod-esp     = tt-titulo.cod-esp
              AND bf-titulo.nr-docto    = tt-titulo.nr-docto 
              AND bf-titulo.parcela     = tt-titulo.parcela NO-LOCK NO-ERROR.

       r-rowid = IF AVAIL bf-titulo THEN ROWID(bf-titulo) ELSE ?.

       IF AVAIL bf-titulo THEN RETURN "OK".
       
    END.
    ELSE DO:

       /* EMS5 */
       FIND FIRST bf_titulo 
            WHERE bf_titulo.cod_ser_docto   = tt-titulo.serie     
              AND bf_titulo.cod_estab       = tt-titulo.cod-estabel   
              AND bf_titulo.cod_espec_docto = tt-titulo.cod-esp
              AND bf_titulo.cod_tit_acr     = tt-titulo.nr-docto 
              AND bf_titulo.cod_parcela     = tt-titulo.parcela NO-LOCK NO-ERROR.

       r-rowid = IF AVAIL bf_titulo THEN ROWID(bf_titulo) ELSE ?.

       IF AVAIL bf_titulo THEN RETURN "OK".

    END.
    
    RETURN "NOK".

END PROCEDURE.

PROCEDURE piGetRowId:

    DEFINE BUFFER bf-titulo  FOR titulo.
    DEFINE BUFFER bf_titulo  FOR tit_acr.

    r-rowid = ?.

    /* EMS2 */
    IF titulo.vl-saldo = 0 AND titulo.dt-liq < DATE(01,01,2013) THEN DO:

       FIND FIRST bf-titulo 
            WHERE bf-titulo.ep-codigo   = titulo.ep-codigo
              AND bf-titulo.serie       = titulo.serie     
              AND bf-titulo.cod-estabel = titulo.cod-estabel   
              AND bf-titulo.cod-esp     = titulo.cod-esp
              AND bf-titulo.nr-docto    = titulo.nr-docto 
              AND bf-titulo.parcela     = titulo.parcela NO-LOCK NO-ERROR.

       r-rowid = IF AVAIL bf-titulo THEN ROWID(bf-titulo) ELSE ?.

       IF AVAIL bf-titulo THEN RETURN "OK".
       
    END.
    ELSE DO:

       /* EMS5 */
       FIND FIRST bf_titulo 
            WHERE bf_titulo.cod_ser_docto   = titulo.serie     
              AND bf_titulo.cod_estab       = titulo.cod-estabel   
              AND bf_titulo.cod_espec_docto = titulo.cod-esp
              AND bf_titulo.cod_tit_acr     = titulo.nr-docto 
              AND bf_titulo.cod_parcela     = titulo.parcela NO-LOCK NO-ERROR.

       r-rowid = IF AVAIL bf_titulo THEN ROWID(bf_titulo) ELSE ?.

       IF AVAIL bf_titulo THEN RETURN "OK".

    END.
    
    RETURN "NOK".

END PROCEDURE.


PROCEDURE piOpenQuery:

    DEFINE INPUT  PARAMETER pi-cod-rep   AS INTEGER     NO-UNDO.

    IF aberto = "TRUE" THEN DO:

        RUN setConstraintPeriodoParameter  IN h-d01ad264 (INPUT  YES,       
                                                          INPUT  YES,       
                                                          INPUT  YES /*l-log-normal*/,   
                                                          INPUT  YES /*l-log-antecip*/,  
                                                          INPUT  YES /*l-log-prev*/,     
                                                          INPUT  YES /*l-log-nota-db*/,  
                                                          INPUT  YES /*l-log-cheq*/,     
                                                          INPUT  YES /*l-log-nota-cr*/,  
                                                          INPUT  YES /*l-log-aviso-db*/, 
                                                          INPUT  YES /* baixado = "FALSE" mfo antes = no */,       
                                                          INPUT  YES /* Aberto */,         
                                                          INPUT  YES).         
        
        RUN setConstraintRepres       IN h-d01ad264 (INPUT pi-cod-rep). 
        
        ASSIGN codemitenteini   = "0"
               codemitentefim   = "999999".

        RUN setConstraintPeriodoRange IN h-d01ad264 (INPUT vdtemissaoini,
                                                     INPUT vdtemissaofim,
                                                     INPUT vdtbaixaini,
                                                     INPUT vdtbaixafim,
                                                     INPUT codestabelini,
                                                     INPUT codestabelfim,
                                                     INPUT nrdoctoini,
                                                     INPUT nrdoctofim,
                                                     INPUT "",          
                                                     INPUT "ZZ",          
                                                     INPUT "",            
                                                     INPUT "ZZZZZ",       
                                                     INPUT codemitenteini,
                                                     INPUT codemitentefim,
                                                     INPUT matrizini, 
                                                     INPUT matrizfim, 
                                                     INPUT vdtemissaoini, 
                                                     INPUT vdtemissaofim, 
                                                     INPUT vdtvenctoini,  
                                                     INPUT vdtvenctofim,  
                                                     INPUT 0,     
                                                     INPUT 999999999,     
                                                     INPUT 0,    
                                                     INPUT 999999999).
        
        RUN openQueryPeriodo IN  h-d01ad264.
        
        RUN getRecordTitulo  IN h-d01ad264 (OUTPUT TABLE tt-titulo-aux).
        
        FOR EACH tt-titulo-aux:
            CREATE tt-titulo.
            BUFFER-COPY tt-titulo-aux TO tt-titulo.
        END.
    
    END.
    
    IF baixado = "TRUE" THEN DO:
    
        RUN setConstraintPeriodoParameter  IN h-d01ad264 (INPUT  YES,                   
                                                          INPUT  YES,                   
                                                          INPUT  YES /*l-log-normal*/,                   
                                                          INPUT  YES /*l-log-antecip*/,                   
                                                          INPUT  YES /*l-log-prev*/,                   
                                                          INPUT  YES /*l-log-nota-db*/,                   
                                                          INPUT  YES /*l-log-cheq*/,                   
                                                          INPUT  YES /*l-log-nota-cr*/,                   
                                                          INPUT  YES /*l-log-aviso-db*/,                   
                                                          INPUT  YES /* Baixado */,                   
                                                          INPUT  NO /* Aberto */,                   
                                                          INPUT  YES).         
        
        RUN setConstraintRepres       IN h-d01ad264 (INPUT pi-cod-rep). 

        RUN setConstraintPeriodoRange IN h-d01ad264 (INPUT vdtemissaoini,       
                                                     INPUT vdtemissaofim,       
                                                     INPUT vdtbaixaini,        
                                                     INPUT vdtbaixafim,        
                                                     INPUT codestabelini,        
                                                     INPUT codestabelfim,        
                                                     INPUT nrdoctoini,         
                                                     INPUT nrdoctofim,         
                                                     INPUT "",          
                                                     INPUT "ZZ",          
                                                     INPUT "",            
                                                     INPUT "ZZZZZ",            
                                                     INPUT codemitenteini,      
                                                     INPUT codemitentefim,      
                                                     INPUT matrizini, 
                                                     INPUT matrizfim, 
                                                     INPUT vdtemissaoini,        
                                                     INPUT vdtemissaofim,          
                                                     INPUT vdtvenctoini,      
                                                     INPUT vdtvenctofim,       
                                                     INPUT 0,     
                                                     INPUT 99999,     
                                                     INPUT 0,    
                                                     INPUT 9).
        
        RUN openQueryPeriodo IN  h-d01ad264.
        
        RUN getRecordTitulo  IN h-d01ad264 (OUTPUT TABLE tt-titulo-aux).
    
        FOR EACH tt-titulo-aux:

            FIND FIRST tt-titulo 
                 WHERE tt-titulo.ep-codigo   = tt-titulo-aux.ep-codigo
                   AND tt-titulo.serie       = tt-titulo-aux.serie     
                   AND tt-titulo.cod-estabel = tt-titulo-aux.cod-estabel   
                   AND tt-titulo.cod-esp     = tt-titulo-aux.cod-esp
                   AND tt-titulo.nr-docto    = tt-titulo-aux.nr-docto 
                   AND tt-titulo.parcela     = tt-titulo-aux.parcela NO-LOCK NO-ERROR.
            IF AVAIL tt-titulo THEN NEXT.

            FIND tit_acr WHERE tit_acr.num_id_tit_acr = tt-titulo-aux.num-id-titulo-cr NO-LOCK NO-ERROR.

            IF AVAIL tit_acr AND  tit_acr.ind_sit_tit_acr BEGINS "PERDAS DEDUT" THEN NEXT.

            CREATE tt-titulo.
            BUFFER-COPY tt-titulo-aux TO tt-titulo.

        END.
    
    END.
    
    RETURN "OK".

END PROCEDURE.

/* PROCEDURE QUEBRA GALHO */
PROCEDURE HierarquiaRepresQG:
  
    ASSIGN v-lista          = STRING(iEmitente)
           v-lista2         = ""
           v-lista-linharep = "".

    /* Cria Tabelas de Apoio */
    EMPTY TEMP-TABLE tt-es-repres-comis NO-ERROR.
    FOR EACH es-repres-comis NO-LOCK: 
        CREATE tt-es-repres-comis.
        BUFFER-COPY es-repres-comis TO tt-es-repres-comis.
    END.

    EMPTY TEMP-TABLE tt-rep-micro NO-ERROR.
    FOR EACH rep-micro NO-LOCK: 
        CREATE tt-rep-micro.
        BUFFER-COPY rep-micro TO tt-rep-micro.
    END.
  
    /* MVR - Verifica linhas de produto para os codigos do representante */
    RUN pi-check-linha-repres-QG (INPUT iEmitente).
    
    /* Lista de Subordinados do PedWeb */
    DO i-cont2 = 1 TO NUM-ENTRIES(v-lista):
        FIND ws-repres WHERE ws-repres.cod-rep = INTE(ENTRY(i-cont2,v-lista)) NO-LOCK NO-ERROR.
        IF AVAIL ws-repres AND ws-repres.subordinado <> "" THEN DO:
            DO i-cont1 = 1 TO NUM-ENTRIES(ws-repres.subordinado):
                IF LOOKUP(TRIM(ENTRY(i-cont1,ws-repres.subordinado)),v-lista) = 0 THEN
                    ASSIGN v-lista = v-lista + "," + trim(entry(i-cont1,ws-repres.subordinado)).
            END.
        END.
    END.

  /* MVR - Verifica se e Representante */
  IF cTipoUsuario = "REP" THEN DO:
      FIND tt-es-repres-comis WHERE tt-es-repres-comis.cod-rep = iEmitente NO-LOCK NO-ERROR.
      IF AVAIL tt-es-repres-comis THEN DO:
         /* MVR - Verifica se e Gerente - Valida ESPD007 apenas se for Gerente - Nao le mais ESPD007 */
         /*IF LOOKUP(tt-es-repres-comis.u-char-2,"GERENTE")> 0 THEN DO:
            RUN pi-check-super.
         END.*/
         /* Verifica se e Supervisor ou Gerente */
         IF INDEX(TRIM(tt-es-repres-comis.u-char-2),"GERENTE")    > 0 OR
            INDEX(TRIM(tt-es-repres-comis.u-char-2),"SUPERVISOR") > 0 THEN DO:
            /* MVR - Possibilita Visualizar os representantes de acordo com o RepMicro (Gerente e Supervisor ) */
            RUN pi-check-repmicro-QG (INPUT iEmitente).
            
         END.
      END.
  END.
  ELSE DO:
     RUN pi-check-super-QG.
  END.
  
  /* MVR - Possibilita Visualizar Todos os Codigos do Representante */
  RUN pi-check-unificado-QG.
  
  /* Atualiza Lista de Apelidos dos Representantes */
  do i-cont2 = 1 to num-entries(v-lista) :
     find first repres where repres.cod-rep = int(entry(i-cont2,v-lista)) no-lock no-error. 
     if avail repres then 
        if v-lista2 = " " then
           v-lista2 = repres.nome-abrev.
        else
           v-lista2 = v-lista2 + "," + trim(repres.nome-abrev).    
  end.
  
end procedure.

PROCEDURE pi-check-super-QG.

    /* MVR - Se nao tem registro tem acesso a tudo */
    FIND FIRST es-usuario-ger 
         WHERE es-usuario-ger.cod_usuario = c-seg-usuario NO-LOCK NO-ERROR.
    IF NOT AVAIL es-usuario-ger THEN DO:
        FOR EACH regiao:
           FOR EACH tt-rep-micro NO-LOCK WHERE tt-rep-micro.nome-ab-reg = regiao.nome-ab-reg
                                    BREAK BY tt-rep-micro.nome-ab-rep
                                          BY tt-rep-micro.nome-ab-reg:
               IF FIRST-OF(tt-rep-micro.nome-ab-rep) THEN  DO:
                  FIND FIRST repres WHERE repres.nome-abrev = tt-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                  IF AVAIL repres THEN DO:
                     IF LOOKUP(STRING(repres.cod-rep),v-lista) = 0 THEN 
                        ASSIGN v-lista = IF v-lista = "" THEN string(repres.cod-rep) ELSE v-lista + "," + STRING(repres.cod-rep).
                  END.
               END.            
           END.       
        END.
    END.
    ELSE DO:
        FOR EACH es-usuario-ger NO-LOCK WHERE es-usuario-ger.cod_usuario = c-seg-usuario:
            FOR EACH tt-rep-micro NO-LOCK WHERE tt-rep-micro.nome-ab-reg = es-usuario-ger.nome-ab-reg
                                    BREAK BY tt-rep-micro.nome-ab-rep
                                          BY tt-rep-micro.nome-ab-reg:
                IF FIRST-OF(tt-rep-micro.nome-ab-rep) THEN  DO:
                    FIND FIRST repres WHERE repres.nome-abrev = tt-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                    IF AVAIL repres THEN DO:
                        IF LOOKUP(STRING(repres.cod-rep),v-lista) = 0 THEN 
                           ASSIGN v-lista = IF v-lista = "" THEN string(repres.cod-rep) ELSE v-lista + "," + STRING(repres.cod-rep).
                    END.
                END.            
            END.
        END.
    END.

END PROCEDURE.

PROCEDURE pi-check-unificado-QG:

    DEFINE VARIABLE piCodEmitente AS INTEGER     NO-UNDO.

    DO i-cont2 = 1 TO NUM-ENTRIES(v-lista):
       FIND FIRST tt-es-repres-comis 
            WHERE tt-es-repres-comis.cod-rep = INT(ENTRY(i-cont2,v-lista)) NO-LOCK NO-ERROR. 
       IF AVAIL tt-es-repres-comis AND tt-es-repres-comis.cod-emitente > 0 THEN DO:
          piCodEmitente = tt-es-repres-comis.cod-emitente.
          FOR EACH tt-es-repres-comis NO-LOCK 
             WHERE tt-es-repres-comis.cod-emitente = piCodEmitente:
             /* Verifica se repres e da mesma linha do principal */
             IF LOOKUP(STRING(tt-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                IF LOOKUP(STRING(tt-es-repres-comis.cod-rep),v-lista) = 0 THEN
                   v-lista = IF v-lista = '' THEN STRING(tt-es-repres-comis.cod-rep)
                             ELSE v-lista + "," + STRING(tt-es-repres-comis.cod-rep).
             END.
          END.
       END.

    END.

END PROCEDURE.

PROCEDURE pi-check-repmicro-QG:

    DEFINE INPUT  PARAMETER pi-cod-rep AS INTEGER     NO-UNDO.

    DEFINE VARIABLE piCodEmitente AS INTEGER     NO-UNDO.

    DEFINE BUFFER b-repres          FOR repres.
    DEFINE BUFFER b-rep-micro       FOR tt-rep-micro.
    DEFINE BUFFER b-es-repres-comis FOR tt-es-repres-comis.

    FIND tt-es-repres-comis WHERE 
         tt-es-repres-comis.cod-rep = pi-cod-rep NO-LOCK NO-ERROR.
    IF AVAIL tt-es-repres-comis THEN DO:
      /* Verifica se e Unificado - nao precisa ver todos os codigos - Regioes serao relacionadas ao codigo principal */
      /*IF tt-es-repres-comis.cod-emitente > 0 THEN DO:
          piCodEmitente = tt-es-repres-comis.cod-emitente.
          FOR EACH tt-es-repres-comis NO-LOCK 
             WHERE tt-es-repres-comis.cod-emitente = piCodEmitente,
             FIRST repres WHERE
                   repres.cod-rep = tt-es-repres-comis.cod-rep NO-LOCK,
              EACH tt-rep-micro NO-LOCK 
                   WHERE tt-rep-micro.nome-ab-rep = repres.nome-abrev:
                /* Se gerente le todos representantes da regiao relacionada */
                IF LOOKUP(tt-es-repres-comis.u-char-2,"GERENTE") > 0 THEN DO:
                    FOR EACH b-rep-micro NO-LOCK 
                       WHERE b-rep-micro.nome-ab-reg = tt-rep-micro.nome-ab-reg
                       BREAK BY b-rep-micro.nome-ab-rep:
                        IF FIRST-OF(b-rep-micro.nome-ab-rep) THEN DO:
                            FIND FIRST b-repres WHERE 
                                       b-repres.nome-abrev = b-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                            IF AVAIL b-repres THEN DO:
                                FIND b-es-repres-comis 
                                    WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                                IF AVAIL b-es-repres-comis THEN DO:
                                    /* Verifica se repres e da mesma linha do principal */
                                    IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                                       IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                                          ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                                    END.
                                END.
                            END.
                        END.                                        
                    END.                        
                END.
                ELSE DO:
                    /* Se supervisor le todas da RepMicro */
                    FOR EACH b-rep-micro NO-LOCK 
                       WHERE b-rep-micro.nome-ab-reg  = tt-rep-micro.nome-ab-reg
                         AND b-rep-micro.nome-mic-reg = tt-rep-micro.nome-mic-reg
                       BREAK BY b-rep-micro.nome-ab-rep:
                        IF FIRST-OF(b-rep-micro.nome-ab-rep) THEN  DO:
                            FIND FIRST b-repres WHERE 
                                       b-repres.nome-abrev = b-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                            IF AVAIL b-repres THEN DO:
                                FIND b-es-repres-comis 
                                    WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                                IF AVAIL b-es-repres-comis THEN DO:
                                    /* Verifica se repres e da mesma linha do principal */
                                    IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                                       IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                                          ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                                    END.
                                END.
                            END.
                        END.                                        
                    END.
                END.                 
          END.
      END.
      ELSE DO:*/
          FOR FIRST repres WHERE
                    repres.cod-rep = tt-es-repres-comis.cod-rep NO-LOCK,
               EACH tt-rep-micro NO-LOCK 
                    WHERE tt-rep-micro.nome-ab-rep = repres.nome-abrev:
                /* Se gerente le todos representantes da regiao relacionada */
                IF INDEX(SUBSTRING(TRIM(tt-es-repres-comis.u-char-2),1,29),"GERENTE") > 0 THEN DO:
                    FOR EACH b-rep-micro NO-LOCK 
                       WHERE b-rep-micro.nome-ab-reg = tt-rep-micro.nome-ab-reg
                       BREAK BY b-rep-micro.nome-ab-rep:
                        IF FIRST-OF(b-rep-micro.nome-ab-rep) THEN DO:
                            FIND FIRST b-repres WHERE 
                                       b-repres.nome-abrev = b-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                            IF AVAIL b-repres THEN DO:
                                FIND b-es-repres-comis 
                                    WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                                IF AVAIL b-es-repres-comis THEN DO:
                                    /* Verifica se repres e da mesma linha do principal */
                                    IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                                       IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                                          ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                                    END.
                                END.
                            END.
                        END.                                        
                    END.                        
                END.
                ELSE DO:
                    /* Se supervisor le todas da RepMicro */
                    FOR EACH b-rep-micro NO-LOCK 
                       WHERE b-rep-micro.nome-ab-reg  = tt-rep-micro.nome-ab-reg
                         AND b-rep-micro.nome-mic-reg = tt-rep-micro.nome-mic-reg
                       BREAK BY b-rep-micro.nome-ab-rep:
                        IF FIRST-OF(b-rep-micro.nome-ab-rep) THEN  DO:
                            FIND FIRST b-repres WHERE 
                                       b-repres.nome-abrev = b-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                            IF AVAIL b-repres THEN DO:
                                FIND b-es-repres-comis 
                                    WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                                IF AVAIL b-es-repres-comis THEN DO:
                                    /* Verifica se repres e da mesma linha do principal */
                                    IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                                       IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                                          ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                                    END.
                                END.
                            END.
                        END.                                        
                    END.
                END.                
          END.
      /*END.*/

    END.

    /* Verifica Acesso as Regioes - Gerente e Supervisor */
    FOR EACH es-usuario-ger NO-LOCK WHERE es-usuario-ger.cod_usuario = c-seg-usuario:
        FOR EACH tt-rep-micro NO-LOCK WHERE tt-rep-micro.nome-ab-reg = es-usuario-ger.nome-ab-reg
                                BREAK BY tt-rep-micro.nome-ab-rep
                                      BY tt-rep-micro.nome-ab-reg:
            IF FIRST-OF(tt-rep-micro.nome-ab-rep) THEN  DO:
                FIND FIRST b-repres WHERE 
                           b-repres.nome-abrev = tt-rep-micro.nome-ab-rep NO-LOCK NO-ERROR.
                IF AVAIL b-repres THEN DO:
                    FIND b-es-repres-comis 
                        WHERE b-es-repres-comis.cod-rep = b-repres.cod-rep NO-LOCK NO-ERROR.
                    IF AVAIL b-es-repres-comis THEN DO:
                        /* Verifica se repres e da mesma linha do principal */
                        IF LOOKUP(STRING(b-es-repres-comis.u-int-1),v-lista-linharep) > 0 THEN DO:
                           IF LOOKUP(STRING(b-repres.cod-rep),v-lista) = 0 THEN 
                              ASSIGN v-lista = IF v-lista = "" THEN string(b-repres.cod-rep) ELSE v-lista + "," + STRING(b-repres.cod-rep).
                        END.
                    END.
                END.
            END.            
        END.
    END.
    
END PROCEDURE.

PROCEDURE pi-check-linha-repres-QG:

     DEFINE INPUT  PARAMETER piCodRep    AS INTEGER     NO-UNDO.

     DEFINE VARIABLE i-cod-emitente      AS INTEGER     NO-UNDO.

     /* MVR - Compoe Linhas do Repres */
     FIND tt-es-repres-comis WHERE
          tt-es-repres-comis.cod-rep = piCodRep NO-LOCK NO-ERROR.
     IF AVAIL tt-es-repres-comis THEN DO:

       IF tt-es-repres-comis.cod-emitente <> 0 THEN DO:
          ASSIGN i-cod-emitente = tt-es-repres-comis.cod-emitente.
          FOR EACH tt-es-repres-comis NO-LOCK 
             WHERE tt-es-repres-comis.cod-emitente = i-cod-emitente,
             FIRST repres NO-LOCK
             WHERE repres.cod-rep = tt-es-repres-comis.cod-rep:
             IF LOOKUP(STRING(tt-es-repres-comis.u-int-1),v-lista-linharep) = 0 THEN
                ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN STRING(tt-es-repres-comis.u-int-1)
                                           ELSE v-lista-linharep + "," + STRING(tt-es-repres-comis.u-int-1).                 
          END.
       END.
       ELSE DO:
          IF LOOKUP(STRING(tt-es-repres-comis.u-int-1),v-lista-linharep) = 0 THEN
             ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN STRING(tt-es-repres-comis.u-int-1)
                                       ELSE v-lista-linharep + "," + STRING(tt-es-repres-comis.u-int-1).              
       END.
           
     END.

     /* Grava Linhas Qdo representante e Nutricao e Saude */
     IF LOOKUP('3',v-lista-linharep) > 0 THEN DO:
         IF LOOKUP("1",v-lista-linharep) = 0 THEN ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN "1" ELSE v-lista-linharep + "," + "1".
         IF LOOKUP("2",v-lista-linharep) = 0 THEN ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN "2" ELSE v-lista-linharep + "," + "2".
     END.

     /* Se Nutricao ou Saude tambem enxerga representantes Nutricao e Saude */
     IF LOOKUP('1',v-lista-linharep) > 0 OR LOOKUP('2',v-lista-linharep) > 0 THEN DO:
        ASSIGN v-lista-linharep = IF v-lista-linharep = '' THEN "1" ELSE v-lista-linharep + "," + "3".
     END.

     ASSIGN v-lista-linharep = "1,3,4".

END PROCEDURE.
