/************************************************************************************
**  Programa : ESPD1911
** Descricao : Busca Automatica de Usuarios de Aprovacao
**     Autor : Datasul Metropolitana
**      Data : 26/08/2003
**    Versao : EMS204E
*************************************************************************************
*************************************************************************************
** HISTORICO:
** 26/08/2003 - Desenvolvimento Incial.
************************************************************************************/
    
/** Converter Strings Acentuadas **/
{include/i-freeac.i}                                 

/** Definicao de Tabelas Temporarias **/    
      
DEFINE TEMP-TABLE tt-permissao NO-UNDO
    FIELD cod_usuario          AS CHAR
    FIELD r-rowid-ped-venda    AS ROWID
    FIELD r-rowid-permissao    AS ROWID
    FIELD pontos               AS INTEGER.

/** Definicao de Parametros de Entrada **/

/*DEFINE INPUT  PARAMETER pr-rowid      AS ROWID      NO-UNDO.
DEFINE INPUT  PARAMETER pr-bloqueio   AS ROWID      NO-UNDO.
DEFINE INPUT  PARAMETER l-aprov       AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR tt-permissao.*/

/** Definicao de Variaveis **/
DEFINE VARIABLE i-pontos             AS   INTEGER                      NO-UNDO.
DEFINE VARIABLE l-aprov AS LOGICAL     NO-UNDO.

/** Localiza Pedido de Venda **/
FIND ws-p-venda WHERE ws-p-venda.nr-pedcli = '3736w0038' NO-LOCK NO-ERROR.
IF NOT AVAIL ws-p-venda THEN DO: 
    RETURN 'nok':U.
END.

/* Localiza Motivo de Bloqueio */
FIND es-follow-up WHERE es-follow-up.cdn-follow-up = 9 NO-LOCK NO-ERROR.
IF NOT AVAIL es-follow-up THEN DO: 
    RETURN 'nok':U.
END.
 
/** Cria Possibilidades para os Dados do Pedido de Venda  **/

FIND FIRST emitente WHERE emitente.nome-abrev = '240361' NO-LOCK NO-ERROR.
IF NOT AVAIL emitente THEN DO: 
    RETURN 'nok':U.
END.

FIND repres WHERE repres.nome-abrev = '3736' NO-LOCK NO-ERROR.
IF NOT AVAIL repres THEN DO: 
    RETURN 'nok':U.
END.

/** Seleciona Registro mais Adequado **/

FOR EACH es-permis-acess NO-LOCK 
   WHERE es-permis-acess.cdn-follow-up = es-follow-up.cdn-follow-up 
     AND es-permis-acess.ind-tp-follow = es-follow-up.ind-tp-follow:

   RUN pi-ConstraintRecord IN THIS-PROCEDURE.

   IF RETURN-VALUE = 'NOK':U THEN DO: 
      NEXT.
   END.

   RUN pi-pontuacao IN THIS-PROCEDURE.

   RUN pi-criaRegistro IN THIS-PROCEDURE.


END.

FOR EACH es-permis-acess NO-LOCK 
   WHERE es-permis-acess.cdn-follow-up = ? 
     AND es-permis-acess.ind-tp-follow = es-follow-up.ind-tp-follow:

   RUN pi-ConstraintRecord IN THIS-PROCEDURE.

   IF RETURN-VALUE = 'NOK':U THEN DO: 
       NEXT.
   END.

   RUN pi-pontuacao IN THIS-PROCEDURE.

   RUN pi-criaRegistro IN THIS-PROCEDURE.


END.

RETURN "OK":U.

PROCEDURE pi-ConstraintRecord:

    IF es-permis-acess.cod-estabel <> ? AND 
       es-permis-acess.cod-estabel <> ws-p-venda.cod-estabel THEN 
       RETURN 'NOK':U.

    IF es-permis-acess.cod-tipo-oper <> ? AND
       es-permis-acess.cod-tipo-oper <> ws-p-venda.cod-tipo-oper THEN
       RETURN 'NOK':U.

    IF es-permis-acess.nome-ab-reg <> ? AND
       es-permis-acess.nome-ab-reg <> repres.nome-ab-reg THEN
       RETURN 'NOK':U.

    IF es-permis-acess.nome-mic-reg <> ? AND
       es-permis-acess.nome-mic-reg <> ws-p-venda.micro-reg THEN
       RETURN 'NOK':U.

    IF es-permis-acess.cod-emitente <> ? AND
       es-permis-acess.cod-emitente <> emitente.cod-emitente THEN
       RETURN 'NOK':U.

    IF es-permis-acess.cod-gr-cli <> ? AND
       es-permis-acess.cod-gr-cli <> emitente.cod-gr-cli THEN
       RETURN 'NOK':U.

    IF es-permis-acess.cod-canal-venda <> ? AND
       es-permis-acess.cod-canal-venda <> emitente.cod-canal-venda THEN
       RETURN 'NOK':U.

    IF es-permis-acess.int-tp-aprov <> l-aprov /* Aprovador Alternativo */ THEN
       RETURN 'NOK':U.

    RETURN 'OK':U.

END PROCEDURE.

PROCEDURE pi-pontuacao :

  i-pontos = 0.
  
  ASSIGN
      i-pontos = IF es-permis-acess.cod-estabel     = ? THEN i-pontos ELSE i-pontos + 3200
      i-pontos = IF es-permis-acess.cod-tipo-oper   = ? THEN i-pontos ELSE i-pontos + 1500
      i-pontos = IF es-permis-acess.nome-ab-reg     = ? THEN i-pontos ELSE i-pontos + 700
      i-pontos = IF es-permis-acess.nome-mic-reg    = ? THEN i-pontos ELSE i-pontos + 330 
      i-pontos = IF es-permis-acess.cod-emitente    = ? THEN i-pontos ELSE i-pontos + 160  
      i-pontos = IF es-permis-acess.cod-gr-cli      = ? THEN i-pontos ELSE i-pontos + 80
      i-pontos = IF es-permis-acess.cod-canal-venda = ? THEN i-pontos ELSE i-pontos + 40
      .

END PROCEDURE.

PROCEDURE pi-criaRegistro :

    FIND tt-permissao WHERE
         tt-permissao.cod_usuario = es-permis-acess.cod_usuario 
         NO-LOCK NO-ERROR.
    IF NOT AVAIL tt-permissao THEN DO:
       CREATE tt-permissao.
       ASSIGN                                                   
           tt-permissao.cod_usuario = es-permis-acess.cod_usuario .
    END.
    IF tt-permissao.pontos <= i-pontos THEN DO:
        ASSIGN
            r-rowid-ped-venda = ROWID(ws-p-venda)
            r-rowid-permissao = ROWID(es-permis-acess)
            pontos            = i-pontos
            .

        DISP tt-permissao.cod_usuario WITH 1 COL.


    END.    

END PROCEDURE.



         

