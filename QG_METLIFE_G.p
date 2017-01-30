/*
Kleber Sotte - DSM/TORTUGA
Arquivos integra»’o MULTIPREV - Dependentes dos empregados
*/

{include/i-freeac.i}

DEFINE VARIABLE cMes AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAno AS CHARACTER   NO-UNDO.

UPDATE cMes cAno.

RUN pi-Tortuga(INPUT cAno, INPUT cMes).
RUN pi-DSM(INPUT cAno, INPUT cMes).

SESSION:NUMERIC-FORMAT = "AMERICAN".


PROCEDURE gerarArquivo:
    
    DEFINE INPUT PARAMETER pAno AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pMes AS CHARACTER NO-UNDO.

    RUN pi-Tortuga (input pAno, input pMes).
    RUN pi-DSM     (input pAno, input pMes).

END PROCEDURE.

PROCEDURE pi-Tortuga:
    
    FIND FIRST empresa NO-LOCK NO-ERROR.
    
    DEFINE INPUT PARAMETER pAno AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pMes AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE iContarRegistros     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dcSomatorioVerbas    AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dcValorVerbaFichaFin AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE cEventos             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDtUltimoDiaMes      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodVerba            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i                    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE lConsideraRegistro   AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE dcValorMovto         AS DECIMAL   FORMAT "->>>>9.99" NO-UNDO.
    DEFINE VARIABLE lMovtoSalario        AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cVaorMovto           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cArquivoSaida        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cValorMovto          AS CHARACTER   NO-UNDO FORMAT "X(16)".

    DEFINE VARIABLE lFuncionarioEvento_001 AS LOGICAL NO-UNDO INITIAL NO.
    DEFINE VARIABLE lFuncionarioEvento_221 AS LOGICAL NO-UNDO INITIAL NO.

    cArquivoSaida = "c:\temp\multiprev\G_189_" + pMes + ".txt".
    
    ASSIGN cEventos = "001,302,303,304,390,395,396,495,496,394,221". /* 394 = evento expatriado, 221 = F‚rias normais*/ /*lpl55780 - requisi‡Æo 5800, incluido os eventos 395 e 396*/
                                                                     /* lpl55780 - requisi‡Æo 7048 - Eventos 302 = Previdencia Privada 13o - 303 = Previdencia Privada 13o - Empr*/

    OUTPUT TO VALUE (cArquivoSaida).
    
    PUT UNFORMATTED
        "H"                                        FORMAT "X(1)"     CHR(9) 
        SUBSTRING(CAPS(empresa.razao-social),1,30) FORMAT "X(30)"    CHR(9) 
        "G"                                        FORMAT "X(1)"     CHR(9) 
        189                                        FORMAT "999"      CHR(9) 
        DAY(TODAY)                                 FORMAT "99"       CHR(9) 
        MONTH(TODAY)                               FORMAT "99"    ""        
        YEAR(TODAY)                                FORMAT "9999"  "" CHR(9) 
        pMes                                       FORMAT "99"       CHR(9) 
        iContarRegistros                           FORMAT "99999"           
        SKIP.
    
    blk_Funcionario:
    FOR EACH funcionario NO-LOCK WHERE funcionario.cdn_estab   >= "01" 
                                   AND funcionario.cdn_estab   <= "99"
                                   AND funcionario.cdn_estab   <> "01"
                                   AND funcionario.cdn_empresa = "1"
                                   
        /*
        ,
        FIRST benefic_func OF funcionario NO-LOCK
        WHERE benefic_func.cdn_beneficio = 101
        */
        ,
        EACH movto_calcul_func OF funcionario NO-LOCK WHERE movto_calcul_func.num_ano_refer_fp = INTE(pAno)
                                                        AND movto_calcul_func.num_mes_refer_fp = INTE(pMes)
                                                        AND movto_calcul_func.idi_tip_fp      <> 3
                                                        BREAK BY funcionario.cdn_funcionario:
        
        /*Arquivo de integracao Tortuga*/
        /*
        IF funcionario.cdn_empresa = "1" AND funcionario.cdn_estab = "01" THEN NEXT.
        IF funcionario.cdn_empresa = "3" AND funcionario.cdn_estab = "01" THEN NEXT.
        */
        /*Arquivo de integracao Tortuga*/
        
        lMovtoSalario = NO.
        
        DO i = 1 TO 30:

            IF LOOKUP(movto_calcul_func.cdn_event_fp[i],cEventos) > 0 THEN DO:

                /* Quanto houver 2 eventos no mesmo mes, de f²rias e salÿrio normal, considero apenas 1 */
                IF NOT lFuncionarioEvento_001 THEN
                    lFuncionarioEvento_001 = (movto_calcul_func.cdn_event_fp[i] = "001").

                IF NOT lFuncionarioEvento_221 THEN
                    lFuncionarioEvento_221 = (movto_calcul_func.cdn_event_fp[i] = "221").

                IF movto_calcul_func.cdn_event_fp[i] = "001" AND lFuncionarioEvento_221 THEN DO: 
                    IF LAST-OF(funcionario.cdn_funcionario) THEN
                        ASSIGN lFuncionarioEvento_001 = NO
                               lFuncionarioEvento_221 = NO.
                    NEXT.
                END.
                
                IF movto_calcul_func.cdn_event_fp[i] = "221" AND lFuncionarioEvento_001 THEN DO: 
                    IF LAST-OF(funcionario.cdn_funcionario) THEN
                        ASSIGN lFuncionarioEvento_001 = NO
                               lFuncionarioEvento_221 = NO.
                    NEXT.
                END.
                /* Quanto houver 2 eventos no mesmo m¼s, de f²rias e salÿrio normal, considero apenas 1 */

                lMovtoSalario = (movto_calcul_func.cdn_event_fp[i] = "001").
                
                FIND FIRST rh_pessoa_fisic WHERE rh_pessoa_fisic.num_pessoa_fisic = funcionario.num_pessoa_fisic NO-LOCK NO-ERROR.
                FIND FIRST empresa WHERE empresa.ep-codigo = movto_calcul_func.cdn_empresa NO-LOCK NO-ERROR.
                FIND FIRST unid_lotac OF funcionario NO-LOCK NO-ERROR.

                IF NOT AVAIL funcionario THEN DO:
                    MESSAGE "Funcionario: " + STRING(funcionario.cdn_funcionario) + " nÆo localizado!" SKIP
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.
                
                IF NOT AVAIL rh_pessoa_fisic THEN DO:
                    MESSAGE "Pessoa fisica do funcionÿrio: " + STRING(funcionario.cdn_funcionario) + "nÆo localizada!" SKIP
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.
                
                IF NOT AVAIL empresa THEN DO:
                    MESSAGE "Empresa do funcinario: " + STRING(funcionario.cdn_funcionario) + "nÆo localizada!" SKIP
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.
                
                IF NOT AVAIL unid_lotac THEN DO:
                    MESSAGE "Unidade de lotacao do funcionario: " + STRING(funcionario.cdn_funcionario) + "nÆo localizado"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.

                /*ASSIGN cEventos = "001,390,495,496,394,221". /*394 = evento expatriado, 221 = F²rias normais*/*/
                /*lpl55780 - requisi‡Æo 7048 - Eventos 302 = Previdencia Privada 13o - 303 = Previdencia Privada 13o - Empr*/

                cCodVerba = "".
                CASE INTE(movto_calcul_func.cdn_event_fp[i]):
                    /*
                    WHEN   1 THEN cCodVerba = "00001".
                    WHEN 221 THEN cCodVerba = "00001".
                    WHEN 302 THEN cCodVerba = "40700". /*lpl55780 - Requisi‡Æo 7048*/
                    WHEN 303 THEN cCodVerba = "40706". /*lpl55780 - Requisi‡Æo 7048*/
                    WHEN 304 THEN cCodVerba = "40703".
                    WHEN 390 THEN cCodVerba = "40700".
                    WHEN 394 THEN cCodVerba = "40700".
                    WHEN 395 THEN cCodVerba = "40700". /*lpl55780 - Requisi‡Æo 5800*/
                    WHEN 396 THEN cCodVerba = "40706". /*lpl55780 - Requisi‡Æo 5800*/
                    WHEN 495 THEN cCodVerba = "40706".
                    WHEN 496 THEN cCodVerba = "40703".
                    */
                    WHEN   1 THEN cCodVerba = "00001".
                    WHEN 221 THEN cCodVerba = "00001".
                    WHEN 302 THEN cCodVerba = "07500". /*lpl55780 - Requisi‡Æo 7048*/
                    WHEN 303 THEN cCodVerba = "07509". /*lpl55780 - Requisi‡Æo 7048*/
                    WHEN 304 THEN cCodVerba = "07503".
                    WHEN 390 THEN cCodVerba = "07500".
                    WHEN 394 THEN cCodVerba = "07500".
                    WHEN 395 THEN cCodVerba = "07500". /*lpl55780 - Requisi‡Æo 5800*/
                    WHEN 396 THEN cCodVerba = "07509". /*lpl55780 - Requisi‡Æo 5800*/
                    WHEN 495 THEN cCodVerba = "07509".
                    WHEN 496 THEN cCodVerba = "07503".

                    OTHERWISE cCodVerba = "".
                END CASE.
                
                cDtUltimoDiaMes = STRING(DAY(ADD-INTERVAL(TODAY,0,"months")   - DAY(TODAY)),"99")   + 
                                  STRING(MONTH(ADD-INTERVAL(TODAY,0,"months") - DAY(TODAY)),"99")   + 
                                  STRING(YEAR(ADD-INTERVAL(TODAY,0,"months")  - DAY(TODAY)),"9999") .

                CASE INT(movto_calcul_func.cdn_event_fp[i]):
                    WHEN 1 OR WHEN 221 THEN dcValorMovto = funcionario.val_salario_atual.
                    /*
                    WHEN 390 THEN dcValorMovto = movto_calcul_func.val_calcul_efp[i].
                    WHEN 495 THEN dcValorMovto = movto_calcul_func.val_calcul_efp[i].
                    WHEN 496 THEN dcValorMovto = movto_calcul_func.val_calcul_efp[i].
                    */
                    OTHERWISE DO:
                        dcValorMovto = movto_calcul_func.val_calcul_efp[i].
                        /*
                        MESSAGE "Erro ao definir valor do motimento!"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        */
                    END.
                END CASE.

                ASSIGN cValorMovto = ""
                       cValorMovto = REPLACE(STRING(dcValorMovto,"9999999999999.99"),",",".").
                
                PUT UNFORMATTED
                    189                                     FORMAT "999"        CHR(9)
                    funcionario.cdn_funcionario             FORMAT "9999999999" CHR(9)
                    INT(cCodVerba)                          FORMAT "99999"      CHR(9)
                    pAno                                    FORMAT "9999"       CHR(9)
                    pMes                                    FORMAT "99"         CHR(9)
                    /*dcValorMovto                            FORMAT "->>>>9.99"           CHR(9)*/
                    cValorMovto                             FORMAT "X(16)"      CHR(9)
                    pAno                                    FORMAT "9999"       CHR(9)
                    pMes                                    FORMAT "99"         CHR(9)
                    INT(cDtUltimoDiaMes)                    FORMAT "99999999"   SKIP.

                END.

                IF LAST-OF(funcionario.cdn_funcionario) THEN
                    ASSIGN lFuncionarioEvento_001 = NO
                           lFuncionarioEvento_221 = NO.
        END.

    END.

    OUTPUT CLOSE.

END PROCEDURE.

PROCEDURE pi-DSM:
    
    FIND FIRST empresa NO-LOCK NO-ERROR.
    
    DEFINE INPUT PARAMETER pAno AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pMes AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE iContarRegistros     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dcSomatorioVerbas    AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE dcValorVerbaFichaFin AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE cEventos             AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cDtUltimoDiaMes      AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cCodVerba            AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i                    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lConsideraRegistro   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE dcValorMovto         AS DECIMAL     FORMAT "->>>>9.99" NO-UNDO.
    DEFINE VARIABLE lMovtoSalario        AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE cVaorMovto           AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cArquivoSaida        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cValorMovto          AS CHARACTER   NO-UNDO FORMAT "X(16)".

    DEFINE VARIABLE lFuncionarioEvento_001 AS LOGICAL NO-UNDO INITIAL NO.
    DEFINE VARIABLE lFuncionarioEvento_102 AS LOGICAL NO-UNDO INITIAL NO.
    DEFINE VARIABLE lFuncionarioEvento_221 AS LOGICAL NO-UNDO INITIAL NO.

    cArquivoSaida = "c:\temp\multiprev\G_098_" + pMes + ".txt".
    
    ASSIGN cEventos = "001,302,303,304,390,394,395,396,495,496,221,102". /* 394 = evento expatriado, 102 = salÿrio n’o residente*/ /*lpl55780 - requisi»’o 5800, incluido os eventos 395 e 396 */
                                                                        /* lpl55780 - requisi‡Æo 7048 - Eventos 302 = Previdencia Privada 13o - 303 = Previdencia Privada 13o - Empr */

    OUTPUT TO VALUE (cArquivoSaida).
    
    PUT UNFORMATTED
        "H"                                        FORMAT "X(1)"     CHR(9) 
        SUBSTRING(CAPS(empresa.razao-social),1,30) FORMAT "X(30)"    CHR(9) 
        "G"                                        FORMAT "X(1)"     CHR(9) 
        98                                         FORMAT "999"      CHR(9) 
        DAY(TODAY)                                 FORMAT "99"       CHR(9) 
        MONTH(TODAY)                               FORMAT "99"    ""        
        YEAR(TODAY)                                FORMAT "9999"  "" CHR(9) 
        pMes                                       FORMAT "99"       CHR(9) 
        iContarRegistros                           FORMAT "99999"           
        SKIP.
    
    blk_Funcionario:
    FOR EACH funcionario NO-LOCK WHERE funcionario.cdn_empresa  = "1"
                                   AND funcionario.cdn_estab    = "01"
        /*
        ,
        FIRST benefic_func OF funcionario NO-LOCK
        WHERE benefic_func.cdn_beneficio = 101
        */
        ,
        EACH movto_calcul_func OF funcionario NO-LOCK WHERE movto_calcul_func.num_ano_refer_fp = INTE(pAno)
                                                        AND movto_calcul_func.num_mes_refer_fp = INTE(pMes)
                                                        AND movto_calcul_func.idi_tip_fp      <> 3
                                                        BREAK BY funcionario.cdn_funcionario:

        /*Arquivo de integra»’o Tortuga*/
        /*IF funcionario.cdn_estab <> "01" THEN NEXT.*/
        /*Arquivo de integra»’o Tortuga*/

        lMovtoSalario = NO.
        
        DO i = 1 TO 30:
            
            IF LOOKUP(movto_calcul_func.cdn_event_fp[i],cEventos) > 0 THEN DO:

                /*quanto houver 2 eventos no mesmo mˆs, de f‚rias e sal rio normal, considero apenas 1*/
                IF NOT lFuncionarioEvento_001 THEN
                    lFuncionarioEvento_001 = (movto_calcul_func.cdn_event_fp[i] = "001").

                IF NOT lFuncionarioEvento_221 THEN
                    lFuncionarioEvento_221 = (movto_calcul_func.cdn_event_fp[i] = "221").

                IF movto_calcul_func.cdn_event_fp[i] = "001" AND lFuncionarioEvento_221 THEN DO: 
                    IF LAST-OF(funcionario.cdn_funcionario) THEN
                        ASSIGN lFuncionarioEvento_001 = NO
                               lFuncionarioEvento_221 = NO.
                    NEXT.
                END.
                
                IF movto_calcul_func.cdn_event_fp[i] = "221" AND lFuncionarioEvento_001 THEN DO: 
                    IF LAST-OF(funcionario.cdn_funcionario) THEN
                        ASSIGN lFuncionarioEvento_001 = NO
                               lFuncionarioEvento_221 = NO.
                    NEXT.
                END.

                /* Quanto houver 2 eventos no mesmo m¼s, de f²rias e salÿrio normal, considero apenas 1 */

                /* EXPATRIADO - quanto houver 2 eventos no mesmo m¼s, de f²rias e salÿrio normal, considero apenas 1*/
                IF NOT lFuncionarioEvento_102 THEN
                    lFuncionarioEvento_102 = (movto_calcul_func.cdn_event_fp[i] = "102").

                IF NOT lFuncionarioEvento_221 THEN
                    lFuncionarioEvento_221 = (movto_calcul_func.cdn_event_fp[i] = "221").

                IF movto_calcul_func.cdn_event_fp[i] = "102" AND lFuncionarioEvento_221 THEN DO: 
                    IF LAST-OF(funcionario.cdn_funcionario) THEN
                        ASSIGN lFuncionarioEvento_102 = NO
                               lFuncionarioEvento_221 = NO.
                    NEXT.
                END.
                
                IF movto_calcul_func.cdn_event_fp[i] = "221" AND lFuncionarioEvento_102 THEN DO: 
                    IF LAST-OF(funcionario.cdn_funcionario) THEN
                        ASSIGN lFuncionarioEvento_102 = NO
                               lFuncionarioEvento_221 = NO.
                    NEXT.
                END.
                /*EXPATRIADO quanto houver 2 eventos no mesmo m¼s, de f²rias e salÿrio normal, considero apenas 1*/

                lMovtoSalario = (movto_calcul_func.cdn_event_fp[i] = "001").
                
                FIND FIRST rh_pessoa_fisic WHERE rh_pessoa_fisic.num_pessoa_fisic = funcionario.num_pessoa_fisic NO-LOCK NO-ERROR.
                FIND FIRST empresa WHERE empresa.ep-codigo = movto_calcul_func.cdn_empresa NO-LOCK NO-ERROR.
                FIND FIRST unid_lotac OF funcionario NO-LOCK NO-ERROR.
                
                IF NOT AVAIL funcionario THEN DO:
                    MESSAGE "Funcionÿrio: " + STRING(funcionario.cdn_funcionario) + "nÆo localizado!" SKIP
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.
                
                IF NOT AVAIL rh_pessoa_fisic THEN DO:
                    MESSAGE "Pessoa fisica do funcionario: " + STRING(funcionario.cdn_funcionario) + "nÆo localizada!" SKIP
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.
                
                IF NOT AVAIL empresa THEN DO:
                    MESSAGE "Empresa do funcinario: " + STRING(funcionario.cdn_funcionario) + "nÆo localizada!" SKIP
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.
                
                IF NOT AVAIL unid_lotac THEN DO:
                    MESSAGE "Unidade de lotacao do funcionario: " + STRING(funcionario.cdn_funcionario) + "nÆo localizado"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    NEXT.
                END.
                
                /*ASSIGN cEventos = "001,390,495,496,394,221". /*394 = evento expatriado, 221 = F²rias normais*/*/
                 /*lpl55780 - requisi‡Æo 7048 - Eventos 302 = Previdencia Privada 13o - 303 = Previdencia Privada 13o - Empr*/

                cCodVerba = "".
                CASE INTE(movto_calcul_func.cdn_event_fp[i]):
                    /*
                    WHEN 001 OR 
                    WHEN 102 THEN cCodVerba = "00001".
                    WHEN 221 THEN cCodVerba = "00001".
                    WHEN 302 THEN cCodVerba = "40700". /*lpl55780 - Requisi‡Æo 7048*/
                    WHEN 303 THEN cCodVerba = "40706". /*lpl55780 - Requisi‡Æo 7048*/
                    WHEN 304 THEN cCodVerba = "40703".
                    WHEN 390 THEN cCodVerba = "40700".
                    WHEN 394 THEN cCodVerba = "40700".
                    WHEN 395 THEN cCodVerba = "40700". /* lpl55780 - Requisi‡Æo 5800 */
                    WHEN 396 THEN cCodVerba = "40706". /* lpl55780 - Requisi‡Æo 5800 */
                    WHEN 495 THEN cCodVerba = "40706".
                    WHEN 496 THEN cCodVerba = "40703".
                    */

                    /*teste*/
                    WHEN 001 OR
                    WHEN 102 THEN cCodVerba = "00001".
                    WHEN 221 THEN cCodVerba = "00001".
                    WHEN 302 THEN cCodVerba = "07500". /*lpl55780 - Requisi‡Æo 7048*/
                    WHEN 303 THEN cCodVerba = "07509". /*lpl55780 - Requisi‡Æo 7048*/
                    WHEN 304 THEN cCodVerba = "07503".
                    WHEN 390 THEN cCodVerba = "07500".
                    WHEN 394 THEN cCodVerba = "07500".
                    WHEN 395 THEN cCodVerba = "07500". /* lpl55780 - Requisi‡Æo 5800 */
                    WHEN 396 THEN cCodVerba = "07509". /* lpl55780 - Requisi‡Æo 5800 */
                    WHEN 495 THEN cCodVerba = "07509".
                    WHEN 496 THEN cCodVerba = "07503".

                    OTHERWISE cCodVerba = "".
                END CASE.

                cDtUltimoDiaMes = STRING(DAY(ADD-INTERVAL(TODAY,0,"months") - DAY(TODAY)),"99")    +
                                  STRING(MONTH(ADD-INTERVAL(TODAY,0,"months") - DAY(TODAY)),"99")  +
                                  STRING(YEAR(ADD-INTERVAL(TODAY,0,"months") - DAY(TODAY)),"9999") .

                CASE INT(movto_calcul_func.cdn_event_fp[i]):
                    WHEN 1 OR WHEN 221 OR WHEN 102 THEN dcValorMovto = funcionario.val_salario_atual. /*salÿrio e f²rias*/
                    /*
                    WHEN 390 THEN dcValorMovto = movto_calcul_func.val_calcul_efp[i].
                    WHEN 495 THEN dcValorMovto = movto_calcul_func.val_calcul_efp[i].
                    WHEN 496 THEN dcValorMovto = movto_calcul_func.val_calcul_efp[i].
                    */
                    OTHERWISE DO:
                        dcValorMovto = movto_calcul_func.val_calcul_efp[i].
                        /*
                        MESSAGE "Erro ao definir valor do motimento!"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                        */
                    END.
                END CASE.

                ASSIGN cValorMovto = ""
                       cValorMovto = REPLACE(STRING(dcValorMovto,"9999999999999.99"),",",".").

                PUT UNFORMATTED
                    98                                      FORMAT "999"                CHR(9)
                    funcionario.cdn_funcionario             FORMAT "9999999999"         CHR(9)
                    INT(cCodVerba)                          FORMAT "99999"              CHR(9)
                    pAno                                    FORMAT "9999"               CHR(9)
                    pMes                                    FORMAT "99"                 CHR(9)
                    cValorMovto                             FORMAT "X(16)"              CHR(9)
                    pAno                                    FORMAT "9999"               CHR(9)
                    pMes                                    FORMAT "99"                 CHR(9)
                    INT(cDtUltimoDiaMes)                    FORMAT "99999999"           SKIP.

            END.
            
            IF LAST-OF(funcionario.cdn_funcionario) THEN
                ASSIGN lFuncionarioEvento_001 = NO
                       lFuncionarioEvento_221 = NO
                       lFuncionarioEvento_102 = NO.
        END.

    END.

    OUTPUT CLOSE.

END PROCEDURE.

SESSION:NUMERIC-FORMAT = "EUROPEAN".

RETURN "OK".
