{include/i-freeac.i}
SESSION:NUMERIC-FORMAT = "AMERICAN".

DEFINE VARIABLE cMes AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAno AS CHARACTER   NO-UNDO.

UPDATE cMes cAno.

RUN pi-DSM(INPUT cAno, INPUT cMes).

RUN pi-Tortuga(INPUT cAno, INPUT cMes).

PROCEDURE pi-DSM:

    FIND FIRST empresa NO-LOCK.
    
    DEFINE INPUT PARAMETER pAno AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pMes AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE cEventos            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i                   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iContarRegistros    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dcSomatorioVerbas   AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE cDtNascimento       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDtDesligamento     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDtAdmissao         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDtExpCartIdent     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodMotivDeslig     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lConsideraRegistro  AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cEstabel            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cArquivoSaida       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cEndereco           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cValorSalario       AS CHARACTER NO-UNDO FORMAT "X(19)".

    ASSIGN cEventos      = "390,496"
           cArquivoSaida = "c:\temp\multiprev\A_098_" + pMes + ".txt".

    OUTPUT TO VALUE (cArquivoSaida).

    PUT UNFORMATTED
        "H"                                        FORMAT "x(01)"         
        CAPS(SUBSTRING(empresa.razao-social,1,30)) FORMAT "x(30)"  CHR(9) 
        "A"                                        FORMAT "x(01)"  CHR(9) 
        "098"                                      FORMAT "999"    CHR(9) 
        STRING(DAY(TODAY))                         FORMAT "99"     ""     
        STRING(MONTH(TODAY))                       FORMAT "99"     ""     
        STRING(YEAR(TODAY))                        FORMAT "9999"   CHR(9) 
        pMes                                       FORMAT "99"     CHR(9) 
        STRING(iContarRegistros )                  FORMAT "99999"  CHR(9) 
        SKIP.

    
    blk_Funcionario:
    FOR EACH funcionario NO-LOCK,
        FIRST movto_calcul_func OF funcionario NO-LOCK
        WHERE STRING(movto_calcul_func.num_ano_refer_fp) = pAno
          AND STRING(movto_calcul_func.num_mes_refer_fp) = pMes:
        
        /* Este arquivo ‚ apenas dos funcion rios da DSM */
        IF movto_calcul_func.cdn_estab <> "01" THEN NEXT.
        /* Este arquivo ‚ apenas dos funcion rios da DSM */

        IF (YEAR(funcionario.dat_desligto_func) <> INTE(cAno) OR MONTH(funcionario.dat_desligto_func) <> INTE(cMes)) AND funcionario.dat_desligto_func <> ? THEN
            NEXT.

        FIND FIRST rh_pessoa_fisic WHERE rh_pessoa_fisic.num_pessoa_fisic = funcionario.num_pessoa_fisic NO-LOCK NO-ERROR.
        FIND FIRST rh_pais WHERE rh_pais.cod_pais = rh_pessoa_fisic.cod_pais_nasc NO-LOCK NO-ERROR.
        FIND FIRST empresa
             WHERE empresa.ep-codigo = movto_calcul_func.cdn_empresa NO-LOCK NO-ERROR.
        FIND FIRST unid_lotac OF funcionario NO-LOCK NO-ERROR.

        IF rh_pessoa_fisic.dat_nascimento = ? THEN cDtNascimento = "". ELSE DO:
            ASSIGN cDtNascimento = STRING(DAY(rh_pessoa_fisic.dat_nascimento),"99")    +
                                   STRING(MONTH(rh_pessoa_fisic.dat_nascimento),"99")  +
                                   STRING(YEAR(rh_pessoa_fisic.dat_nascimento),"9999") .
        END.

        IF funcionario.dat_desligto_func = ? THEN cDtDesligamento = "". ELSE DO:
            ASSIGN cDtDesligamento = STRING(DAY(funcionario.dat_desligto_func),"99")    +
                                     STRING(MONTH(funcionario.dat_desligto_func),"99")  +
                                     STRING(YEAR(funcionario.dat_desligto_func),"9999") .
        END.

        IF funcionario.dat_admis_func = ? THEN cDtAdmissao = "". ELSE DO:
            ASSIGN cDtAdmissao = STRING(DAY(funcionario.dat_admis_func),"99")    +
                                 STRING(MONTH(funcionario.dat_admis_func),"99")  +
                                 STRING(YEAR(funcionario.dat_admis_func),"9999") .
        END.

        IF rh_pessoa_fisic.dat_emis_id_estad_fisic = ? THEN cDtExpCartIdent = "". ELSE DO:
            ASSIGN cDtExpCartIdent = STRING(DAY(rh_pessoa_fisic.dat_emis_id_estad_fisic),"99")    +
                                     STRING(MONTH(rh_pessoa_fisic.dat_emis_id_estad_fisic),"99")  +
                                     STRING(YEAR(rh_pessoa_fisic.dat_emis_id_estad_fisic),"9999") .
        END.

        cCodMotivDeslig = "".

        FIND LAST sit_afast_func OF funcionario NO-LOCK NO-ERROR.
        IF AVAIL sit_afast_func THEN DO:

            CASE sit_afast_func.cdn_sit_afast_func:

                WHEN 00  THEN cCodMotivDeslig = "01".
                WHEN 80  THEN cCodMotivDeslig = "10".
                WHEN 81  THEN cCodMotivDeslig = "11".
                WHEN 87  THEN cCodMotivDeslig = "12".
                WHEN 82  THEN cCodMotivDeslig = "20".
                WHEN 83  THEN cCodMotivDeslig = "21".
                WHEN 00  THEN cCodMotivDeslig = "30".
                WHEN 00  THEN cCodMotivDeslig = "31".
                WHEN 00  THEN cCodMotivDeslig = "40".
                WHEN 25  THEN cCodMotivDeslig = "50".
                WHEN 84  THEN cCodMotivDeslig = "60".
                WHEN 84  THEN cCodMotivDeslig = "60".
                WHEN 84  THEN cCodMotivDeslig = "60".
                WHEN 85  THEN cCodMotivDeslig = "72".
                WHEN 85  THEN cCodMotivDeslig = "72".
                WHEN 85  THEN cCodMotivDeslig = "72".
                WHEN 85  THEN cCodMotivDeslig = "72".
                WHEN 85  THEN cCodMotivDeslig = "72".
                WHEN 85  THEN cCodMotivDeslig = "72".
                WHEN 85  THEN cCodMotivDeslig = "72".
                WHEN 85  THEN cCodMotivDeslig = "72".
                WHEN 85  THEN cCodMotivDeslig = "72".

            END CASE.
        END.

        IF LENGTH(STRING(funcionario.cdn_estab)) = 1 THEN
            cEstabel = "00" + STRING(funcionario.cdn_estab).
        ELSE IF LENGTH(STRING(funcionario.cdn_estab)) = 2 THEN
            cEstabel = "0" + STRING(funcionario.cdn_estab).

        IF INT(SUBSTRING(rh_pessoa_fisic.cod_livre_1,66,8)) > 0 THEN
            ASSIGN cEndereco = rh_pessoa_fisic.nom_ender_rh + "," + STRING(INT(SUBSTRING(rh_pessoa_fisic.cod_livre_1,66,8))).
        ELSE
            ASSIGN cEndereco = rh_pessoa_fisic.nom_ender_rh.

        /* Ajuste do salario de acordo com o layout */
        ASSIGN cValorSalario = ""
               cValorSalario = REPLACE(STRING(funcionario.val_salario_atual,"99999999999999.9999"),",",".").

        PUT UNFORMATTED
            2                                                                                       FORMAT "99999999"       CHR(9)
            98                                                                                      FORMAT "999"            CHR(9)
            funcionario.cdn_funcionario                                                             FORMAT "9999999999"     CHR(9)
            funcionario.num_digito_verfdor_func                                                     FORMAT "9"              CHR(9)
            0                                                                                       FORMAT "9999999999999"  CHR(9)
            cEstabel                                                                                FORMAT "999"            CHR(9)
            "098"    + cEstabel + "02" + STRING(fn-free-accent(unid_lotac.cod_unid_lotac))          FORMAT "X(16)"          CHR(9)
            fn-free-accent(STRING(funcionario.nom_pessoa_fisic))                                    FORMAT "X(50)"          CHR(9)
            IF funcionario.idi_sexo = 1 THEN "M" ELSE "F"                                           FORMAT "X(1)"           CHR(9)
            INT(cDtNascimento)                                                                      FORMAT "99999999"       CHR(9)
            INT(cDtDesligamento)                                                                    FORMAT "99999999"       CHR(9)
            INT(cDtAdmissao)                                                                        FORMAT "99999999"       CHR(9)
            IF INTE(cCodMotivDeslig) = 0 THEN 0     ELSE INTE(cDtDesligamento)                      FORMAT "99999999"       CHR(9)
            IF INT(cCodMotivDeslig) = 0 THEN "  " ELSE cCodMotivDeslig                              FORMAT "99"             CHR(9)
            99                                                                                      FORMAT "99999999"       CHR(9)
            "Trabalhadores nao classificados sob outras epigraf"                                    FORMAT "X(50)"          CHR(9)
            rh_pessoa_fisic.idi_estado_civil                                                        FORMAT "9"              CHR(9)
            rh_pessoa_fisic.nom_naturalidade                                                        FORMAT "X(30)"          CHR(9)
            rh_pais.nom_pais                                                                        FORMAT "X(30)"          CHR(9)
            rh_pessoa_fisic.cod_id_feder                                                            FORMAT "99999999999"    CHR(9)
            rh_pessoa_fisic.cod_id_estad_fisic                                                      FORMAT "X(15)"          CHR(9)
            rh_pessoa_fisic.cod_orgao_emis_id_estad                                                 FORMAT "X(6)"           CHR(9)
            rh_pessoa_fisic.cod_unid_federac_emis_estad                                             FORMAT "X(2)"           CHR(9)
            INTE(cDtExpCartIdent)                                                                   FORMAT "99999999"       CHR(9)
            cEndereco                                                                               FORMAT "X(80)"          CHR(9)
            /*
            rh_pessoa_fisic.nom_ender_rh + "," + 
            STRING(INT(SUBSTRING(rh_pessoa_fisic.cod_livre_1,66,8)))   FORMAT "X(80)"                CHR(9) /*esta linha foi inclu¡da pq na DSM o n£mero da casa est  separado do endere‡o*/
            */
            rh_pessoa_fisic.nom_pto_refer                                                           FORMAT "X(50)"          CHR(9)
            rh_pessoa_fisic.nom_bairro_rh                                                           FORMAT "X(25)"          CHR(9)
            rh_pessoa_fisic.nom_cidad_rh                                                            FORMAT "X(40)"          CHR(9)
            rh_pessoa_fisic.cod_unid_federac_rh                                                     FORMAT "X(20)"          CHR(9)
            rh_pessoa_fisic.cod_pais                                                                FORMAT "X(30)"          CHR(9)
            INT(rh_pessoa_fisic.cod_cep_rh)                                                         FORMAT "99999999"       CHR(9)
            "0"                                                                                     FORMAT "X(7)"           CHR(9)
            STRING(rh_pessoa_fisic.num_ddd)                                                         FORMAT "X(4)"           CHR(9)
            STRING(rh_pessoa_fisic.num_telefone)                                                    FORMAT "X(20)"          CHR(9)
            0                                                                                       FORMAT "99999999"       CHR(9)
            0                                                                                       FORMAT "99999999"       CHR(9)
            0                                                                                       FORMAT "9999"           CHR(9)
            0                                                                                       FORMAT "99999"          CHR(9)
            rh_pessoa_fisic.nom_e_mail                                                              FORMAT "X(50)"          CHR(9)
            INT(funcionario.cdn_bco_liq)                                                            FORMAT "999"            CHR(9)
            INT(funcionario.cdn_agenc_bcia_liq)                                                     FORMAT "9999999"        CHR(9)
            STRING(funcionario.cdn_cta_corren)                                                      FORMAT "X(15)"          CHR(9)
            IF funcionario.dat_desligto_func <> ? THEN
               INTERVAL(funcionario.dat_desligto_func, funcionario.dat_admis_func, "month") ELSE
               INTERVAL(TODAY, funcionario.dat_admis_func, "month")                                 FORMAT "9999"           CHR(9)
            /*funcionario.val_salario_atual                                                         FORMAT "->>,>>9.9999"       */
            cValorSalario                                                                           FORMAT "X(19)"          CHR(9)
            SUBSTRING(rh_pessoa_fisic.nom_mae_pessoa_fisic,1,50)                                    FORMAT "X(50)"          CHR(9)
            SUBSTRING(rh_pessoa_fisic.nom_pai_pessoa_fisic,1,50)                                    FORMAT "X(50)"          CHR(9)
            ""                                                                                      FORMAT "X(100)"         SKIP.

    END.

OUTPUT CLOSE.

END PROCEDURE.

PROCEDURE pi-Tortuga:

    DEFINE INPUT PARAMETER pAno AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pMes AS CHARACTER NO-UNDO.
    
    FIND FIRST empresa NO-LOCK.
    
    DEFINE VARIABLE cEventos            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i                   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iContarRegistros    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dcSomatorioVerbas   AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE cDtNascimento       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDtDesligamento     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDtAdmissao         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDtExpCartIdent     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cCodMotivDeslig     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lConsideraRegistro  AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cEstabel            AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cArquivoSaida       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cEndereco           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cValorSalario       AS CHARACTER    NO-UNDO FORMAT "X(19)".

    ASSIGN cEventos      = "390,496,394" /*394 = evento do expratiado*/
           cArquivoSaida = "c:\temp\multiprev\A_189_" + pMes + ".txt".

    OUTPUT TO VALUE (cArquivoSaida).

    PUT UNFORMATTED
        "H"                                        FORMAT "x(01)"         
        CAPS(SUBSTRING(empresa.razao-social,1,30)) FORMAT "x(30)"  CHR(9) 
        "A"                                        FORMAT "x(01)"  CHR(9) 
        "189"                                      FORMAT "999"    CHR(9) 
        STRING(DAY(TODAY))                         FORMAT "99"     ""     
        STRING(MONTH(TODAY))                       FORMAT "99"     ""     
        STRING(YEAR(TODAY))                        FORMAT "9999"   CHR(9) 
        pMes                                       FORMAT "99"     CHR(9) 
        STRING(iContarRegistros )                  FORMAT "99999"  CHR(9) 
        SKIP.

    
    blk_Funcionario:
    FOR EACH funcionario NO-LOCK
        /*
        ,
        FIRST benefic_func OF funcionario NO-LOCK
        WHERE benefic_func.cdn_beneficio = 101
        */
        ,
        FIRST movto_calcul_func OF funcionario NO-LOCK
        WHERE STRING(movto_calcul_func.num_ano_refer_fp) = pAno
          AND STRING(movto_calcul_func.num_mes_refer_fp) = pMes
        :
        
        /*Este arquivo ‚ apenas dos funcion rios da Tortuga*/
        IF movto_calcul_func.cdn_estab = "01" THEN NEXT.
        /*Este arquivo ‚ apenas dos funcion rios da Tortuga*/

        /*
        lConsideraRegistro = NO.
        DO i = 1 TO 30:
            IF LOOKUP(movto_calcul_func.cdn_event_fp[i],cEventos) > 0 THEN 
                lConsideraRegistro = YES.
        END.
        
        IF NOT lConsideraRegistro THEN
            NEXT blk_Funcionario.
        */

        IF (YEAR(funcionario.dat_desligto_func) <> INTE(cAno) OR MONTH(funcionario.dat_desligto_func) <> INTE(cMes)) AND funcionario.dat_desligto_func <> ? THEN
            NEXT.
        
        FIND FIRST rh_pessoa_fisic WHERE rh_pessoa_fisic.num_pessoa_fisic = funcionario.num_pessoa_fisic NO-LOCK NO-ERROR.
        FIND FIRST rh_pais WHERE rh_pais.cod_pais = rh_pessoa_fisic.cod_pais_nasc NO-LOCK NO-ERROR.
        FIND FIRST empresa
             WHERE empresa.ep-codigo = movto_calcul_func.cdn_empresa NO-LOCK NO-ERROR.
        FIND FIRST unid_lotac OF funcionario NO-LOCK NO-ERROR.

        IF rh_pessoa_fisic.dat_nascimento = ? THEN cDtNascimento = "". ELSE DO:
            ASSIGN
                cDtNascimento = STRING(DAY(rh_pessoa_fisic.dat_nascimento),"99")    + 
                                STRING(MONTH(rh_pessoa_fisic.dat_nascimento),"99")  + 
                                STRING(YEAR(rh_pessoa_fisic.dat_nascimento),"9999") .
        END.
        
        IF funcionario.dat_desligto_func = ? THEN cDtDesligamento = "". ELSE DO:
            ASSIGN
                cDtDesligamento = STRING(DAY(funcionario.dat_desligto_func),"99")    +
                                  STRING(MONTH(funcionario.dat_desligto_func),"99")  +
                                  STRING(YEAR(funcionario.dat_desligto_func),"9999") .
        END.
        
        IF funcionario.dat_admis_func = ? THEN cDtAdmissao = "". ELSE DO:
            ASSIGN
                cDtAdmissao = STRING(DAY(funcionario.dat_admis_func),"99")    +
                              STRING(MONTH(funcionario.dat_admis_func),"99")  +  
                              STRING(YEAR(funcionario.dat_admis_func),"9999") . 
        END.

        IF rh_pessoa_fisic.dat_emis_id_estad_fisic = ? THEN cDtExpCartIdent = "". ELSE DO:
            ASSIGN
                cDtExpCartIdent = STRING(DAY(rh_pessoa_fisic.dat_emis_id_estad_fisic),"99")    +
                                  STRING(MONTH(rh_pessoa_fisic.dat_emis_id_estad_fisic),"99")  +  
                                  STRING(YEAR(rh_pessoa_fisic.dat_emis_id_estad_fisic),"9999") . 
        END.
        
        cCodMotivDeslig = "".
        FIND LAST sit_afast_func OF funcionario NO-LOCK NO-ERROR.
        IF AVAIL sit_afast_func THEN DO:
            
            CASE sit_afast_func.cdn_sit_afast_func:
                WHEN 00  THEN cCodMotivDeslig = "01".
                WHEN 80  THEN cCodMotivDeslig = "10".
                WHEN 81  THEN cCodMotivDeslig = "11".
                WHEN 87  THEN cCodMotivDeslig = "12".
                WHEN 82  THEN cCodMotivDeslig = "20".
                WHEN 83  THEN cCodMotivDeslig = "21".
                WHEN 00  THEN cCodMotivDeslig = "30".
                WHEN 00  THEN cCodMotivDeslig = "31".
                WHEN 00  THEN cCodMotivDeslig = "40".
                WHEN 25  THEN cCodMotivDeslig = "50".
                WHEN 84  THEN cCodMotivDeslig = "60".
                WHEN 85  THEN cCodMotivDeslig = "72".
            END CASE.
        END.

        IF LENGTH(STRING(funcionario.cdn_estab)) = 1 THEN
            cEstabel = "00" + STRING(funcionario.cdn_estab).
        ELSE IF LENGTH(STRING(funcionario.cdn_estab)) = 2 THEN
            cEstabel = "0" + STRING(funcionario.cdn_estab).

        IF INT(SUBSTRING(rh_pessoa_fisic.cod_livre_1,66,8)) > 0 THEN
            ASSIGN 
                cEndereco = rh_pessoa_fisic.nom_ender_rh + ", " + STRING(INT(SUBSTRING(rh_pessoa_fisic.cod_livre_1,66,8))).
        ELSE
            ASSIGN 
                cEndereco = rh_pessoa_fisic.nom_ender_rh.
                    
        /* Ajuste do salario de acordo com o layout */
        ASSIGN cValorSalario = ""
               cValorSalario = REPLACE(STRING(funcionario.val_salario_atual,"99999999999999.9999"),",",".").
        
        PUT UNFORMATTED
            2                                                                           FORMAT "99999999"       CHR(9)
            189                                                                         FORMAT "999"            CHR(9)
            funcionario.cdn_funcionario                                                 FORMAT "9999999999"     CHR(9)
            funcionario.num_digito_verfdor_func                                         FORMAT "9"              CHR(9)
            0                                                                           FORMAT "9999999999999"  CHR(9)
            cEstabel                                                                    FORMAT "999"            CHR(9)
            "189" + cEstabel + "02" + STRING(fn-free-accent(unid_lotac.cod_unid_lotac)) FORMAT "X(16)"          CHR(9)
            fn-free-accent(STRING(funcionario.nom_pessoa_fisic))                        FORMAT "X(50)"          CHR(9)
            IF funcionario.idi_sexo = 1 THEN "M" ELSE "F"                               FORMAT "X(1)"           CHR(9)
            INT(cDtNascimento)                                                          FORMAT "99999999"       CHR(9)
            INT(cDtDesligamento)                                                        FORMAT "99999999"       CHR(9)
            INT(cDtAdmissao)                                                            FORMAT "99999999"       CHR(9)
            IF INTE(cCodMotivDeslig) = 0 THEN 0     ELSE INTE(cDtDesligamento)          FORMAT "99999999"       CHR(9)
            IF INTE(cCodMotivDeslig) = 0 THEN "  "  ELSE cCodMotivDeslig                FORMAT "99"             CHR(9)
            99                                                                          FORMAT "99999999"       CHR(9)
            "Trabalhadores nao classificados sob outras epigraf"                        FORMAT "X(50)"          CHR(9)
            rh_pessoa_fisic.idi_estado_civil                                            FORMAT "9"              CHR(9)
            rh_pessoa_fisic.nom_naturalidade                                            FORMAT "X(30)"          CHR(9)
            rh_pais.nom_pais                                                            FORMAT "X(30)"          CHR(9)
            rh_pessoa_fisic.cod_id_feder                                                FORMAT "99999999999"    CHR(9)
            rh_pessoa_fisic.cod_id_estad_fisic                                          FORMAT "X(15)"          CHR(9)
            rh_pessoa_fisic.cod_orgao_emis_id_estad                                     FORMAT "X(6)"           CHR(9)
            rh_pessoa_fisic.cod_unid_federac_emis_estad                                 FORMAT "X(2)"           CHR(9)
            INT(cDtExpCartIdent)                                                        FORMAT "99999999"       CHR(9)
            cEndereco                                                                   FORMAT "X(80)"          CHR(9)
            rh_pessoa_fisic.nom_pto_refer                                               FORMAT "X(50)"          CHR(9)
            rh_pessoa_fisic.nom_bairro_rh                                               FORMAT "X(25)"          CHR(9)
            rh_pessoa_fisic.nom_cidad_rh                                                FORMAT "X(40)"          CHR(9)
            rh_pessoa_fisic.cod_unid_federac_rh                                         FORMAT "X(20)"          CHR(9)
            rh_pessoa_fisic.cod_pais                                                    FORMAT "X(30)"          CHR(9)
            INT(rh_pessoa_fisic.cod_cep_rh)                                             FORMAT "99999999"       CHR(9)
            "0"                                                                         FORMAT "X(7)"           CHR(9)
            STRING(rh_pessoa_fisic.num_ddd)                                             FORMAT "X(4)"           CHR(9)
            STRING(rh_pessoa_fisic.num_telefone)                                        FORMAT "X(20)"          CHR(9)
            0                                                                           FORMAT "99999999"       CHR(9)
            0                                                                           FORMAT "99999999"       CHR(9)
            0                                                                           FORMAT "9999"           CHR(9)
            0                                                                           FORMAT "99999"          CHR(9)
            rh_pessoa_fisic.nom_e_mail                                                  FORMAT "X(50)"          CHR(9)
            INT(funcionario.cdn_bco_liq)                                                FORMAT "999"            CHR(9)
            INT(funcionario.cdn_agenc_bcia_liq)                                         FORMAT "9999999"        CHR(9)
            STRING(funcionario.cdn_cta_corren)                                          FORMAT "X(15)"          CHR(9)
            IF funcionario.dat_desligto_func <> ? THEN
               INTERVAL(funcionario.dat_desligto_func, funcionario.dat_admis_func, "month") ELSE
               INTERVAL(TODAY, funcionario.dat_admis_func, "month")
                                                                                        FORMAT "9999"           CHR(9)
            /*funcionario.val_salario_atual                                               FORMAT "->>,>>9.9999"   CHR(9)*/
            cValorSalario                                                               FORMAT "X(19)"          CHR(9)
            SUBSTRING(rh_pessoa_fisic.nom_mae_pessoa_fisic,1,50)                        FORMAT "X(50)"          CHR(9)
            SUBSTRING(rh_pessoa_fisic.nom_pai_pessoa_fisic,1,50)                        FORMAT "X(50)"          CHR(9)
            ""                                                                          FORMAT "X(100)"         SKIP.

    END.

    OUTPUT CLOSE.

END PROCEDURE.
