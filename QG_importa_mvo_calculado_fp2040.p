
DEFINE VARIABLE empresa                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE estab                  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE funcionario            AS INTEGER     NO-UNDO.
DEFINE VARIABLE evento                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE parcela                AS INTEGER     NO-UNDO.

DEFINE VARIABLE iCont AS INTEGER INIT 0 NO-UNDO.

INPUT FROM "c:\temp\previdencia.csv".

blk:
REPEAT:
    IMPORT DELIMITER ";" empresa
                         estab
                         funcionario.
                         
/* Atentar-se par ao evento */
FIND FIRST movto_fp_control_parc WHERE
                   movto_fp_control_parc.cdn_empresa                      = empresa       AND
                   movto_fp_control_parc.cdn_estab                        = estab         AND
                   movto_fp_control_parc.cdn_funcionario                  = funcionario   AND
                   movto_fp_control_parc.cdn_event_fp                     = "302"         AND       
                   movto_fp_control_parc.num_seq_movto_fp_control_parc    = 1             AND
                   movto_fp_control_parc.num_ano_inic_parc_pagto_fp       = 2015          AND
                   movto_fp_control_parc.num_mes_inic_movto_parcdo        = 12            AND
                   movto_fp_control_parc.qtd_unid_event_fp                = 0             AND
                   movto_fp_control_parc.val_calcul_efp                   = 0             AND
                   movto_fp_control_parc.cdn_val_unit_fp                  = 0             AND
                   movto_fp_control_parc.qti_parc_lancto_movto_parcdo     = 98            AND
                   movto_fp_control_parc.qti_parc_consdo_movto_parcdo     = 0            EXCLUSIVE-LOCK NO-ERROR.

IF NOT AVAIL movto_fp_control_parc THEN 
    CREATE movto_fp_control_parc.
    ASSIGN movto_fp_control_parc.cdn_empresa                         = empresa    
           movto_fp_control_parc.cdn_estab                           = estab      
           movto_fp_control_parc.cdn_funcionario                     = funcionario
           movto_fp_control_parc.cdn_event_fp                        = "302"      
           movto_fp_control_parc.num_seq_movto_fp_control_parc       = 1          
           movto_fp_control_parc.num_ano_inic_parc_pagto_fp          = 2015       
           movto_fp_control_parc.num_mes_inic_movto_parcdo           = 12         
           movto_fp_control_parc.qtd_unid_event_fp                   = 0          
           movto_fp_control_parc.val_calcul_efp                      = 0          
           movto_fp_control_parc.cdn_val_unit_fp                     = 0          
           movto_fp_control_parc.qti_parc_lancto_movto_parcdo        = 98         
           movto_fp_control_parc.qti_parc_consdo_movto_parcdo        = 0.          


           
iCont = iCont + 1.

END.

    
MESSAGE iCont

VIEW-AS ALERT-BOX INFO BUTTONS OK.

