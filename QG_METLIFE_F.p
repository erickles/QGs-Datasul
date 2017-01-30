/*
Kleber Sotte - DSM/TORTUGA
Arquivos integraá∆o MULTIPREV - Dependentes dos empregados
*/

{include/i-freeac.i}
SESSION:NUMERIC-FORMAT = "AMERICAN".

DEFINE VARIABLE cMes AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAno AS CHARACTER   NO-UNDO.

UPDATE cMes cAno.

RUN pi-tortuga(INPUT cAno, INPUT cMes).
RUN pi-DSM(INPUT cAno, INPUT cMes).

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

    DEFINE VARIABLE iContarRegistros   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dcSomatorioVerbas  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE iSeqDependente     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dtInicioBeneficio  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dtTerminoBeneficio AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iRepeteZero        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iTipoParticipante  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iTempoBeneficio    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cArquivoSaida      AS CHARACTER   NO-UNDO.
    
    cArquivoSaida = "c:\temp\multiprev\F_189_" + pMes + ".txt".

    OUTPUT TO VALUE (cArquivoSaida).
    
    PUT UNFORMATTED
        "H"                                        FORMAT "X(1)"     CHR(9) 
        SUBSTRING(CAPS(empresa.razao-social),1,30) FORMAT "X(30)"    CHR(9) 
        "F"                                        FORMAT "X(1)"     CHR(9) 
        189                                        FORMAT "999"      CHR(9) 
        DAY(TODAY)                                 FORMAT "99"       CHR(9) 
        MONTH(TODAY)                               FORMAT "99"    ""        
        YEAR(TODAY)                                FORMAT "9999"  "" CHR(9) 
        pMes                                       FORMAT "99"       CHR(9) 
        iContarRegistros                           FORMAT "99999"           
        SKIP.

    FOR EACH funcionario NO-LOCK,
        FIRST movto_calcul_func OF funcionario NO-LOCK
        WHERE STRING(movto_calcul_func.num_ano_refer_fp) = pAno
          AND STRING(movto_calcul_func.num_mes_refer_fp) = pMes
          BREAK BY funcionario.cdn_funcionario:
        
        /* Arquivo de integraá∆o Tortuga */
        IF funcionario.cdn_estab = "01" THEN NEXT.
        /* Arquivo de integraá∆o Tortuga */
        
        FIND FIRST benefic_func OF funcionario 
             WHERE benefic_func.cdn_beneficio = 101 NO-LOCK NO-ERROR.

        IF NOT AVAIL benefic_func THEN
            FIND LAST benefic_func OF funcionario NO-LOCK NO-ERROR.
        
        iSeqDependente = iSeqDependente + 1.
        
        IF AVAIL benefic_func THEN DO:
            /*
            IF benefic_func.dat_inic_benefic = ? THEN 
                dtInicioBeneficio = "". 
            ELSE DO:                
                dtInicioBeneficio = STRING(DAY(benefic_func.dat_inic_benefic),"99")    +
                                    STRING(MONTH(benefic_func.dat_inic_benefic),"99")  +
                                    STRING(YEAR(benefic_func.dat_inic_benefic),"9999").
            END.
            */
            IF benefic_func.dat_inic_benefic = ? THEN 
                dtInicioBeneficio = "". 
            ELSE DO:

                IF funcionario.dat_admis_func = ? THEN
                    dtInicioBeneficio = STRING(DAY(benefic_func.dat_inic_benefic),"99")    +
                                        STRING(MONTH(benefic_func.dat_inic_benefic),"99")  +
                                        STRING(YEAR(benefic_func.dat_inic_benefic),"9999").
                ELSE
                    dtInicioBeneficio = STRING(DAY(funcionario.dat_admis_func),"99")    +
                                        STRING(MONTH(funcionario.dat_admis_func),"99")  +
                                        STRING(YEAR(funcionario.dat_admis_func),"9999").

            END.
            
            /*IF benefic_func.dat_term_benefic = ? THEN dtTerminoBeneficio = "". ELSE DO :*/
            IF benefic_func.dat_term_benefic = ? OR YEAR(benefic_func.dat_term_benefic) = 9999 THEN dtTerminoBeneficio = "00000000". ELSE DO :
                dtTerminoBeneficio =  STRING(DAY(benefic_func.dat_term_benefic),"99")    +
                                      STRING(MONTH(benefic_func.dat_term_benefic),"99")  +
                                      STRING(YEAR(benefic_func.dat_term_benefic),"9999").
            END.
        END.
        ELSE DO:
            ASSIGN 
                dtInicioBeneficio  = "99999999"
                dtTerminoBeneficio = "99999999".
        END.
        
        iRepeteZero = 13 - (LENGTH(STRING(funcionario.cdn_funcionario)) + 
                            LENGTH(STRING(189))).
        
        /*definindo tipo de particpante: 001 para funcion†rio com desconto em folha e 002 para funcion†rio sem desconto em folha*/
        IF NOT AVAIL benefic_func THEN
            iTipoParticipante = 0.
        ELSE IF benefic_func.cdn_beneficio = 101 THEN
            iTipoParticipante = 1.
        ELSE
            iTipoParticipante = 2.
        /*definindo tipo de particpante: 001 para funcion†rio com desconto em folha e 002 para funcion†rio sem desconto em folha*/

            
        /*tempo de contribuiá∆o*/
        IF NOT AVAIL benefic_func THEN 
            iTempoBeneficio = 0.
        ELSE DO:
            iTempoBeneficio = INTERVAL(TODAY, benefic_func.dat_inic_benefic, "month").
        END.
        /*tempo de contribuiá∆o*/

         
        PUT UNFORMATTED
            "189" + FILL("0",iRepeteZero) + STRING(funcionario.cdn_funcionario) FORMAT "9999999999999" CHR(9)
            189                                                                 FORMAT "999"           CHR(9)
            INT(dtInicioBeneficio)                                              FORMAT "99999999"      CHR(9)
            INT(dtTerminoBeneficio)                                             FORMAT "99999999"      CHR(9)
            iTipoParticipante                                                   FORMAT "999"           CHR(9) /* 001 empregado contribuinte e 002 empregado n∆o contribuinte */
            1                                                                   FORMAT "999"           CHR(9) 
            iTempoBeneficio                                                     FORMAT "999"
            SKIP.
        
        IF LAST-OF(funcionario.cdn_funcionario) THEN
            iSeqDependente = 0.

    END.

    OUTPUT CLOSE.

END PROCEDURE.

PROCEDURE pi-DSM:

    FIND FIRST empresa NO-LOCK NO-ERROR.

    DEFINE INPUT PARAMETER pAno AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pMes AS CHARACTER NO-UNDO.

    DEFINE VARIABLE iContarRegistros   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dcSomatorioVerbas  AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE iSeqDependente     AS INTEGER     NO-UNDO.
    DEFINE VARIABLE dtInicioBeneficio  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE dtTerminoBeneficio AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iRepeteZero        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iTipoParticipante  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iTempoBeneficio    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE cArquivoSaida      AS CHARACTER   NO-UNDO.
    
    cArquivoSaida = "c:\temp\multiprev\F_098_" + pMes + ".txt".

    OUTPUT TO VALUE (cArquivoSaida).
    
    PUT UNFORMATTED
        "H"                                        FORMAT "X(1)"     CHR(9) 
        SUBSTRING(CAPS(empresa.razao-social),1,30) FORMAT "X(30)"    CHR(9) 
        "F"                                        FORMAT "X(1)"     CHR(9) 
        98                                         FORMAT "999"      CHR(9) 
        DAY(TODAY)                                 FORMAT "99"       CHR(9) 
        MONTH(TODAY)                               FORMAT "99"    ""        
        YEAR(TODAY)                                FORMAT "9999"  "" CHR(9) 
        pMes                                       FORMAT "99"       CHR(9) 
        iContarRegistros                           FORMAT "99999"           
        SKIP.

    FOR EACH funcionario NO-LOCK
        ,
        FIRST movto_calcul_func OF funcionario NO-LOCK
        WHERE STRING(movto_calcul_func.num_ano_refer_fp) = pAno
          AND STRING(movto_calcul_func.num_mes_refer_fp) = pMes
        BREAK BY funcionario.cdn_funcionario
        :
        
        /*Arquivo de integraá∆o Tortuga*/
        IF funcionario.cdn_estab <> "01" THEN NEXT.
        /*Arquivo de integraá∆o Tortuga*/

        
        FIND FIRST benefic_func OF funcionario 
             WHERE benefic_func.cdn_beneficio = 101 NO-LOCK NO-ERROR.

        IF NOT AVAIL benefic_func THEN
            FIND LAST benefic_func OF funcionario NO-LOCK NO-ERROR.
        
        iSeqDependente = iSeqDependente + 1.
        
        IF AVAIL benefic_func THEN DO:
            /*
            IF benefic_func.dat_inic_benefic = ? THEN dtInicioBeneficio = "". ELSE DO:
                dtInicioBeneficio = STRING(DAY(benefic_func.dat_inic_benefic),"99")    +
                                    STRING(MONTH(benefic_func.dat_inic_benefic),"99")  +
                                    STRING(YEAR(benefic_func.dat_inic_benefic),"9999").
            END.
            */
            IF benefic_func.dat_inic_benefic = ? THEN dtInicioBeneficio = "". ELSE DO:

                IF funcionario.dat_admis_func = ? THEN
                    dtInicioBeneficio = STRING(DAY(benefic_func.dat_inic_benefic),"99")    +
                                        STRING(MONTH(benefic_func.dat_inic_benefic),"99")  +
                                        STRING(YEAR(benefic_func.dat_inic_benefic),"9999").
                ELSE
                    dtInicioBeneficio = STRING(DAY(funcionario.dat_admis_func),"99")    +
                                        STRING(MONTH(funcionario.dat_admis_func),"99")  +
                                        STRING(YEAR(funcionario.dat_admis_func),"9999").
            END.
            
            IF benefic_func.dat_term_benefic = ? OR YEAR(benefic_func.dat_term_benefic) = 9999 THEN dtTerminoBeneficio = "00000000". ELSE DO :
                dtTerminoBeneficio =  STRING(DAY(benefic_func.dat_term_benefic),"99")    +
                                      STRING(MONTH(benefic_func.dat_term_benefic),"99")  +
                                      STRING(YEAR(benefic_func.dat_term_benefic),"9999").
            END.

        END.
        ELSE DO:
            ASSIGN 
                dtInicioBeneficio  = "99999999"
                dtTerminoBeneficio = "99999999".
        END.
        
        iRepeteZero = 13 - (LENGTH(STRING(funcionario.cdn_funcionario)) + 
                            LENGTH(STRING(189))).
        
        /*definindo tipo de particpante: 001 para funcion†rio com desconto em folha e 002 para funcion†rio sem desconto em folha*/
        IF NOT AVAIL benefic_func THEN
            iTipoParticipante = 0.
        ELSE IF benefic_func.cdn_beneficio = 101 THEN
            iTipoParticipante = 1.
        ELSE
            iTipoParticipante = 2.
        /*definindo tipo de particpante: 001 para funcion†rio com desconto em folha e 002 para funcion†rio sem desconto em folha*/
            
        /*tempo de contribuiá∆o*/
        IF NOT AVAIL benefic_func THEN 
            iTempoBeneficio = 0.
        ELSE DO:
            iTempoBeneficio = INTERVAL(TODAY, benefic_func.dat_inic_benefic, "month").
        END.
        /*tempo de contribuiá∆o*/
        
        PUT UNFORMATTED
            "098" + FILL("0",iRepeteZero) + STRING(funcionario.cdn_funcionario) FORMAT "9999999999999"  CHR(9)
            98                                                                  FORMAT "999"            CHR(9)
            INT(dtInicioBeneficio)                                              FORMAT "99999999"       CHR(9)
            INT(dtTerminoBeneficio)                                             FORMAT "99999999"       CHR(9)
            iTipoParticipante                                                   FORMAT "999"            CHR(9) /* 001 empregado contribuinte e 002 empregado n∆o contribuinte */
            1                                                                   FORMAT "999"            CHR(9)
            iTempoBeneficio                                                     FORMAT "999"            SKIP.

        IF LAST-OF(funcionario.cdn_funcionario) THEN
            iSeqDependente = 0.

    END.

    OUTPUT CLOSE.

END PROCEDURE.

SESSION:NUMERIC-FORMAT = "EUROPEAN".

RETURN "OK".
