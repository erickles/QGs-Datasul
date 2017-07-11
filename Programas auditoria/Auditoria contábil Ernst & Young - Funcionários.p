
/*
Kleber Sotte - 11/12/2013 -Dados para auditoria Ernst & Young
- Balancete / Plano de Contas (estrutura similar)
*/

DEFINE VARIABLE iContador AS INTEGER     NO-UNDO.

DEFINE VARIABLE cHorarioInicio AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cHorarioFim    AS CHARACTER   NO-UNDO.

cHorarioInicio = STRING(TIME,"hh:mm:ss").
       
{include/i-freeac.i}

OUTPUT TO c:\temp\Funcionarios.txt NO-CONVERT.

PUT
    '"' "Empresa"           '"' "|"
    '"' "Filial"            '"' "|"
    '"' "Matricula"         '"' "|"
    '"' "Nome"              '"' "|"
    '"' "DataAdmissao"      '"' "|"
    '"' "Cargo"             '"' "|"
    '"' "CPF"               '"' "|"
    '"' "RG"                '"' "|"
    '"' "DataDeNascimento"  '"' "|"
    '"' "Endereco"          '"' "|"
    '"' "Cidade"            '"' "|"
    '"' "Bairro"            '"' "|"
    '"' "Estado"            '"' "|"
    '"' "CEP"               '"' "|"
    '"' "Contagem"          '"' "|"
    SKIP.

FOR EACH funcionario NO-LOCK,
    FIRST rh_pessoa_fisic OF funcionario NO-LOCK,
    LAST cargo OF funcionario NO-LOCK,
    LAST unid_lotac OF funcionario NO-LOCK:

    iContador = iContador + 1.

    PUT UNFORMATTED                                  
        '"' TRIM(funcionario.cdn_empresa)                       '"' "|" /*empresa*/
        '"' TRIM(funcionario.cdn_estab)                         '"' "|" /*filial*/
        '"' STRING(funcionario.cdn_funcionario)                 '"' "|" /*Matricula*/
        '"' fn-free-accent(TRIM(funcionario.nom_pessoa_fisic))  '"' "|" /*Nome*/
        '"' STRING(funcionario.dat_admis_func,"99/99/9999")     '"' "|" /*Data admissÆo*/
        '"' fn-free-accent(unid_lotac.des_unid_lotac)           '"' "|" /*Departamento*/
        '"' fn-free-accent(TRIM(cargo.des_cargo))               '"' "|" /*Descri‡Æo do cargo*/
        '"' TRIM(funcionario.cod_id_feder)                      '"' "|" /*CPF*/  
        '"' TRIM(rh_pessoa_fisic.cod_id_estad_fisic)            '"' "|" /*RG*/
        '"' STRING(rh_pessoa_fisic.dat_nascimento,"99/99/9999") '"' "|" /*Data de nascimento*/
        '"' fn-free-accent(TRIM(rh_pessoa_fisic.nom_ender_rh))  '"' "|" /*Endere‡o*/
        '"' fn-free-accent(TRIM(rh_pessoa_fisic.nom_cidad_rh))  '"' "|" /*Cidade*/
        '"' fn-free-accent(TRIM(rh_pessoa_fisic.nom_bairro_rh)) '"' "|" /*Bairro*/
        '"' rh_pessoa_fisic.cod_unid_federac_rh                 '"' "|" /*Estado*/
        '"' rh_pessoa_fisic.cod_cep_rh                          '"' "|" /*CEP*/
        '"' rh_pessoa_fisic.num_telefone                        '"' "|" /*Telefone*/
        '"' iContador                                           '"'
        SKIP.

END.
                    
OUTPUT CLOSE.

cHorarioFIM = STRING(TIME,"hh:mm:ss").

MESSAGE "Funcionarios"                              SKIP
        "N£mero de registros lidos => " iContador   SKIP
        "Horario Inicio => " cHorarioInicio         SKIP
        "Horario Fim => " cHorarioFim
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
