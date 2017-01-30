DEFINE VARIABLE lFretado        AS LOGICAL              NO-UNDO.
DEFINE VARIABLE lValeTransporte AS LOGICAL              NO-UNDO.
DEFINE VARIABLE iCont           AS INTEGER              NO-UNDO.
DEFINE VARIABLE iFunc           AS INTEGER              NO-UNDO.

DEFINE VARIABLE val-unit        AS DECI EXTENT 7        NO-UNDO.
DEFINE VARIABLE d-acum-tot      AS DECI EXTENT 10       NO-UNDO.
DEFINE VARIABLE vr-func         AS DECIMAL INITIAL 0.

UPDATE iFunc LABEL "Funcionario".

FOR EACH val_unit_form_fp WHERE val_unit_form_fp.cdn_val_unit_fp >= 453 
                            AND val_unit_form_fp.cdn_val_unit_fp <= 455 NO-LOCK:

    IF val_unit_form_fp.cdn_val_unit_fp = 453 THEN     /*Salario <= 800,00*/
       val-unit[1] = val_unit_form_fp.val_calcul_efp.
    IF val_unit_form_fp.cdn_val_unit_fp = 454 THEN     /*Salario >= 801,00*/
       val-unit[2] = val_unit_form_fp.val_calcul_efp.
    IF val_unit_form_fp.cdn_val_unit_fp = 455 THEN     /*Salario >= 1500,00*/
       val-unit[3] = val_unit_form_fp.val_calcul_efp.

END.
/* 6497 - 03/2014 - desconta R$ 1 do fretado */
/* 6493 - 04/2014 - desconta R$ 1 do fretado */
/*  */
FIND FIRST funcionario WHERE funcionario.cdn_funcionario = iFunc
                         AND funcionario.cdn_estab = "5" NO-LOCK NO-ERROR.

IF AVAIL funcionario THEN DO:

    IF funcionario.val_salario_atual <= 800.00 THEN
        vr-func = val-unit[1].
    ELSE 
        IF funcionario.val_salario_atual >= 801.00 AND funcionario.val_salario_atual <= 1499.00 THEN
            vr-func = val-unit[2].
        ELSE
            IF funcionario.val_salario_atual >= 1500.00  THEN
                vr-func = val-unit[3].

    ASSIGN d-acum-tot[01] = vr-func.

    MESSAGE "Valor do fretado " + STRING(vr-func)
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
    FOR EACH movto_integr_benefic_fp WHERE movto_integr_benefic_fp.cdn_funcionario  = funciona.cdn_funcionario
                                       AND movto_integr_benefic_fp.num_ano_refer_fp = 2014
                                       AND movto_integr_benefic_fp.num_mes_refer_fp = 04
                                       AND movto_integr_benefic_fp.num_parc_calcula_movto_benefic = 9:
        iCont = iCont + 1.
        IF movto_integr_benefic_fp.cdn_beneficio = 1   OR  movto_integr_benefic_fp.cdn_beneficio = 2  OR
           movto_integr_benefic_fp.cdn_beneficio = 3   OR  movto_integr_benefic_fp.cdn_beneficio = 4  THEN DO:
            ASSIGN lValeTransporte = YES.
        END.
                
        IF movto_integr_benefic_fp.cdn_beneficio = 600  THEN DO:
            ASSIGN lFretado = YES.
        END.
    END.
    /*
    MESSAGE iCont
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
    IF lValeTransporte AND lFretado THEN DO:
        ASSIGN d-acum-tot[01] = 1.
    END.
    /*
    ELSE IF NOT lFretado AND lValeTransporte THEN DO:
        MESSAGE "5% do VT"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    ELSE
        MESSAGE "5% do Fretado"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    */
    MESSAGE "Valor do fretado " + STRING(d-acum-tot[01])    SKIP
            "VT " + STRING(lValeTransporte)                 SKIP
            "FR " + STRING(lFretado)                        SKIP
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
END.
