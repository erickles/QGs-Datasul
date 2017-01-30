DEFINE VARIABLE strRetorno AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-cgc       LIKE loc-entr.cgc          LABEL "CGC"  NO-UNDO.
DEFINE VARIABLE v-uf        LIKE loc-entr.estado       LABEL "UF"   NO-UNDO.
DEFINE VARIABLE v-natureza  LIKE emitente.natureza     NO-UNDO.
DEFINE VARIABLE v-inscricao LIKE loc-entr.ins-estadual LABEL "INSCRICAO"    NO-UNDO.
DEFINE VARIABLE tipo-pesquisa AS CHARACTER   NO-UNDO.

DEFINE VARIABLE Audicon /*chFuncao*/ AS COM-HANDLE NO-UNDO.

DEFINE VAR strUf                AS CHAR NO-UNDO.
DEFINE VAR strTipoPesquisa      AS CHAR NO-UNDO.
DEFINE VAR strCnpjCpf           AS CHAR NO-UNDO.
DEFINE VAR strInscricaoEstadual AS CHAR NO-UNDO.
DEFINE VAR strTipodeRetorno     AS CHAR NO-UNDO.
DEFINE VAR strUsuario           AS CHAR NO-UNDO.
DEFINE VAR strSenha             AS CHAR NO-UNDO.
DEFINE VAR i                    AS INT INITIAL 0 NO-UNDO.

UPDATE v-cgc
       v-inscricao
       v-uf.

ASSIGN strRetorno = v-cgc + "|" + v-inscricao + "|" + "||||||||" + v-uf + "||||||".

DO i = 1 TO NUM-ENTRIES(strRetorno,"|").

    IF i = 11  THEN ASSIGN v-uf        = ENTRY(i,strRetorno,"|").
    IF i = 1   THEN ASSIGN v-cgc       = ENTRY(i,strRetorno,"|").
    IF i = 2   THEN ASSIGN v-inscricao = ENTRY(i,strRetorno,"|").
    
END.

IF TRIM(REPLACE(REPLACE(v-inscricao,".",""),"-","")) = "" THEN DO:
    IF v-natureza = 1 THEN tipo-pesquisa = "F".
    ELSE IF v-natureza = 2 THEN tipo-pesquisa = "J".
END.   
ELSE tipo-pesquisa = "I".

/*Seta os par³metros*/                          
ASSIGN strUf                = v-uf
       strTipoPesquisa      = tipo-pesquisa
       strCnpjCpf           = v-cgc
       strInscricaoEstadual = TRIM(REPLACE(REPLACE(v-inscricao,".",""),"-","")) /*v-inscricao*/  /*È necessÿrio informar a Inscri»’o Estadual ?*/
       strTipodeRetorno     = IF v-uf = "SP" THEN "3" ELSE "1" /*Descobrir qual o tipo de retorno que deve ser setado ?*/
       strUsuario           = ""  /*Saber se precisa de usuÿrio ?*/
       strSenha             = ""  /*Saber se precisa de senha ?*/
       strRetorno           = "".

/* Se for produtor rural, tipo de pesquisa sera letra P */
IF  SUBSTR(v-inscricao,1,2) = "95" AND 
    strUf                   = "PR" THEN 
    ASSIGN strTipoPesquisa  = "P"
           strTipodeRetorno = "2"
           strCnpjCpf       = "".

IF strUf = "RS" THEN DO:
      CREATE "FuncaoRobo.clsAudicon" Audicon /*chFuncao*/ . /*Inst³ncia da DLL*/
      ASSIGN strRetorno = Audicon:Pesquisar(strUf,
                                            strTipoPesquisa,
                                            strCnpjCpf,
                                            strInscricaoEstadual,
                                            "2",
                                            "56992951000491",
                                            "T3885354"). /*Chamada da Funcao Pesquisa dentro da DLL*/
END.
ELSE DO:
    IF  strInscricaoEstadual BEGINS "95" AND 
        strUf                = "PR" THEN DO:
        CREATE "FuncaoRobo.clsAudicon" Audicon /*chFuncao*/ . /*Inst³ncia da DLL*/
        ASSIGN strRetorno = Audicon:Pesquisar(strUf,
                                              "P",
                                              "",
                                              strInscricaoEstadual,
                                              "2",
                                              strUsuario,                                              
                                              strSenha). /*Chamada da Funcao Pesquisa dentro da DLL*/ 
    END.
    ELSE DO:
        CREATE "FuncaoRobo.clsAudicon" Audicon /*chFuncao*/ . /*Inst³ncia da DLL*/
        ASSIGN strRetorno = Audicon:Pesquisar(strUf,
                                              strTipoPesquisa,
                                              strCnpjCpf,
                                              strInscricaoEstadual,
                                              strTipodeRetorno,
                                              strUsuario,                                              
                                              strSenha). /*Chamada da Funcao Pesquisa dentro da DLL*/ 
    END.
END.

RELEASE OBJECT Audicon.

MESSAGE strRetorno
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
