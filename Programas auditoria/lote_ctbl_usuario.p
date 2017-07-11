{include/i-buffer.i}
DEF STREAM str-cab.

DEFINE VARIABLE i-cont  AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-parametros AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-banco AS CHARACTER   NO-UNDO.

FOR EACH mgadm.bco-ext NO-LOCK WHERE mgadm.bco-ext.nom-logic-bco = "dthrpyc": /* parametros para conexao do banco hr */

    ASSIGN c-parametros = "-db " + mgadm.bco-ext.localiz-fisic-bco + " " + mgadm.bco-ext.param-conex-bco
           c-banco      = mgadm.bco-ext.nom-logic-bco.

    IF NOT CONNECTED( c-banco ) THEN CONNECT VALUE(c-parametros).
END.

OUTPUT STREAM str-cab TO VALUE("c:\temp\funcionarios.txt").

EXPORT STREAM str-cab DELIMITER "|"
    "cod_empresa"
    "cod_livre_1"
    "cod_livre_2"
    "cod_modul_dtsul"
    "cod_usuar_ult_atualiz"
    "dat_livre_1"
    "dat_livre_2"
    "dat_lote_ctbl"
    "dat_ult_atualiz"
    "des_lote_ctbl"
    "hra_ult_atualiz"
    "ind_sit_lote_ctbl"
    "log_estorn_lote_ctbl"
    "log_integr_ctbl_online"
    "log_livre_1"
    "log_livre_2"
    "num_livre_1"
    "num_livre_2"
    "num_lote_ctbl"
    "val_livre_1"
    "val_livre_2"
    SKIP.

FOR EACH lancto_ctbl NO-LOCK
   WHERE lancto_ctbl.cod_empresa = "TOR"
     AND lancto_ctbl.dat_lancto_ctbl >= 12/01/2014
     AND lancto_ctbl.dat_lancto_ctbl <= 12/31/201,
    EACH lote_ctbl OF lancto_ctbl BREAK BY lote_ctbl.cod_usuar_ult_atualiz:

    

        IF FIRST-OF(lote_ctbl.cod_usuar_ult_atualiz) THEN DO:

            FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = lote_ctbl.cod_usuar_ult_atualiz NO-LOCK NO-ERROR.
            IF AVAIL usuar_mestre THEN DO:
                /*
                FOR EACH funcionario NO-LOCK WHERE funcionario.cdn_funcionario = INTE(SUBSTRING(usuar_mestre.cod_usuario,4,4))
                ,
                FIRST rh_pessoa_fisic OF funcionario NO-LOCK
                ,
                LAST cargo OF funcionario NO-LOCK
                ,
                LAST unid_lotac OF funcionario NO-LOCK
                :
                */
                /*iContador = iContador + 1.*/
            
                PUT UNFORMATTED
                    lote_ctbl.cod_usuar_ult_atualiz ";"
                    lancto_ctbl.num_lancto_ctbl     ";"
                    lancto_ctbl.num_lote_ctbl       ";"
                    lancto_ctbl.dat_lancto_ctbl
                    /*
                    '"' funcionario.cdn_empresa '"'                       "|" /*empresa*/
                    '"' funcionario.cdn_estab '"'                         "|" /*filial*/
                    funcionario.cdn_funcionario                           "|" /*Matricula*/
                    '"' fn-free-accent(funcionario.nom_pessoa_fisic) '"'  "|" /*Nome*/
                    funcionario.dat_admis_func                            "|" /*Data admissÆo*/
                    '"' fn-free-accent(unid_lotac.des_unid_lotac) '"'     "|" /*Departamento*/
                    '"' fn-free-accent(cargo.des_cargo) '"'               "|" /*Descri‡Æo do cargo*/
                    '"' funcionario.cod_id_feder '"'                      "|" /*CPF*/  
                    '"' rh_pessoa_fisic.cod_id_estad_fisic '"'            "|" /*RG*/
                    rh_pessoa_fisic.dat_nascimento                        "|" /*Data de nascimento*/
                    '"' fn-free-accent(rh_pessoa_fisic.nom_ender_rh)  '"' "|" /*Endere‡o*/
                    '"' fn-free-accent(rh_pessoa_fisic.nom_cidad_rh)  '"' "|" /*Cidade*/
                    '"' fn-free-accent(rh_pessoa_fisic.nom_bairro_rh) '"' "|" /*Bairro*/
                    '"' rh_pessoa_fisic.cod_unid_federac_rh '"'           "|" /*Estado*/
                    '"' rh_pessoa_fisic.cod_cep_rh '"'                    "|" /*CEP*/
                    '"' rh_pessoa_fisic.num_telefone '"'                  "|" /**/
                    iContador
                    */
                    SKIP
                    .
                /*
                END.
                */    
                ASSIGN i-cont = i-cont + 1.
            
                EXPORT STREAM str-cab DELIMITER "|"
                    
                    SKIP.
    
            END.
        END.
    
END.

OUTPUT STREAM str-cab CLOSE.

FOR EACH mgadm.bco-ext NO-LOCK WHERE mgadm.bco-ext.nom-logic-bco = "dthrpyc": /* parametros para conexao ddo banco hr*/
    ASSIGN c-banco      = mgadm.bco-ext.nom-logic-bco.
    IF CONNECTED( c-banco ) THEN DISCONNECT VALUE(c-banco).
END.

MESSAGE "Funcionarios"                      SKIP
        "TOTAL Funcionarios: " i-cont              SKIP
        TODAY " - " STRING(TIME,"hh:mm:ss")
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
