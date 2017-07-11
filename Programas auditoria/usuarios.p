{include/i-buffer.i}
/*
Erick Souza - extracao de usuarios
*/

DEFINE VARIABLE iContador AS INTEGER     NO-UNDO.

DEFINE VARIABLE cHorarioInicio AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cHorarioFim    AS CHARACTER   NO-UNDO.

cHorarioInicio = STRING(TIME,"hh:mm:ss").
       
{include/i-freeac.i}

OUTPUT TO c:\temp\usuarios.txt NO-CONVERT.

PUT '"' "cod-repres"                '"' "|"
    '"' "char-2"                    '"' "|"
    '"' "check-sum"                 '"' "|"
    '"' "cod_dialeto"               '"' "|"
    '"' "cod_e_mail_celular"        '"' "|"
    '"' "cod_e_mail_local"          '"' "|"
    '"' "cod_idiom_orig"            '"' "|"
    '"' "cod_senha"                 '"' "|"
    '"' "cod_servid_exec"           '"' "|"
    '"' "cod_usuario"               '"' "|"
    '"' "data-1"                    '"' "|"
    '"' "data-2"                    '"' "|"
    '"' "dat_fim_valid"             '"' "|"
    '"' "dat_inic_valid"            '"' "|"
    '"' "dat_ult_erro_tentat_aces"  '"' "|"
    '"' "dat_valid_senha"           '"' "|"
    '"' "dec-1"                     '"' "|"
    '"' "dec-2"                     '"' "|"
    '"' "des_cod_perf_usuar"        '"' "|"
    '"' "hra_ult_erro_tentat_aces"  '"' "|"
    '"' "ind_tip_usuar"             '"' "|"
    '"' "perfil"                    '"' "|"
    '"' "int-2"                     '"' "|"
    '"' "acesso-todas-superv"       '"' "|"
    '"' "excessao-hierarquia-rdv"   '"' "|"
    '"' "log_mostra_framework"      '"' "|"
    '"' "log_segur_uhr_atlzdo"      '"' "|"
    '"' "log_servid_exec_obrig"     '"' "|"
    '"' "log_usuar_atlzdo_ged"      '"' "|"
    '"' "log_usuar_wap"             '"' "|"
    '"' "nom_dir_spool"             '"' "|"
    '"' "nom_subdir_spool"          '"' "|"
    '"' "nom_subdir_spool_rpw"      '"' "|"
    '"' "nom_usuario"               '"' "|"
    '"' "num_dias_valid_senha"      '"' "|"
    '"' "num_perf_usuar"            '"' "|"
    '"' "num_pessoa"                '"' "|"
    '"' "qtd_erro_tentat_aces"      '"' "|"
    '"' "contador"                  '"' SKIP.

FOR EACH usuar_mestre WHERE NOT usuar_mestre.nom_usuario BEGINS "DESATIV" NO-LOCK:

    iContador = iContador + 1.

    PUT UNFORMATTED
        '"' usuar_mestre.char-1                     '"' "|"
        '"' usuar_mestre.char-2                     '"' "|"
        '"' usuar_mestre.check-sum                  '"' "|"
        '"' usuar_mestre.cod_dialeto                '"' "|"
        '"' usuar_mestre.cod_e_mail_celular         '"' "|"
        '"' usuar_mestre.cod_e_mail_local           '"' "|"
        '"' usuar_mestre.cod_idiom_orig             '"' "|"
        '"' usuar_mestre.cod_senha                  '"' "|"
        '"' usuar_mestre.cod_servid_exec            '"' "|"
        '"' usuar_mestre.cod_usuario                '"' "|"
        '"' usuar_mestre.data-1                     '"' "|"
        '"' usuar_mestre.data-2                     '"' "|"
        '"' usuar_mestre.dat_fim_valid              '"' "|"
        '"' usuar_mestre.dat_inic_valid             '"' "|"
        '"' usuar_mestre.dat_ult_erro_tentat_aces   '"' "|"
        '"' usuar_mestre.dat_valid_senha            '"' "|"
        '"' usuar_mestre.dec-1                      '"' "|"
        '"' usuar_mestre.dec-2                      '"' "|"
        '"' usuar_mestre.des_cod_perf_usuar         '"' "|"
        '"' usuar_mestre.hra_ult_erro_tentat_aces   '"' "|"
        '"' usuar_mestre.ind_tip_usuar              '"' "|"
        '"' usuar_mestre.int-1                      '"' "|"
        '"' usuar_mestre.int-2                      '"' "|"
        '"' usuar_mestre.log-1                      '"' "|"
        '"' usuar_mestre.log-2                      '"' "|"
        '"' usuar_mestre.log_mostra_framework       '"' "|"
        '"' usuar_mestre.log_segur_uhr_atlzdo       '"' "|"
        '"' usuar_mestre.log_servid_exec_obrig      '"' "|"
        '"' usuar_mestre.log_usuar_atlzdo_ged       '"' "|"
        '"' usuar_mestre.log_usuar_wap              '"' "|"
        '"' usuar_mestre.nom_dir_spool              '"' "|"
        '"' usuar_mestre.nom_subdir_spool           '"' "|"
        '"' usuar_mestre.nom_subdir_spool_rpw       '"' "|"
        '"' usuar_mestre.nom_usuario                '"' "|"
        '"' usuar_mestre.num_dias_valid_senha       '"' "|"
        '"' usuar_mestre.num_perf_usuar             '"' "|"
        '"' usuar_mestre.num_pessoa                 '"' "|"
        '"' usuar_mestre.qtd_erro_tentat_aces       '"' "|"
        '"' iContador                               '"'
        SKIP.    

END.

OUTPUT CLOSE.

cHorarioFIM = STRING(TIME,"hh:mm:ss").

MESSAGE "Usuarios"                                  SKIP
        "N£mero de registros lidos => " iContador   SKIP
        "Horario Inicio => " cHorarioInicio         SKIP
        "Horario Fim => " cHorarioFim
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
