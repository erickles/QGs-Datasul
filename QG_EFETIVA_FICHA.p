DEFINE VARIABLE iNrFicha AS INTEGER     NO-UNDO.

UPDATE iNrFicha.

FIND FIRST es-cad-cli WHERE es-cad-cli.nr-ficha = iNrFicha NO-ERROR.
/*
MESSAGE es-cad-cli.situacao
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
IF es-cad-cli.situacao = 1 THEN DO:
    ASSIGN es-cad-cli.situacao       = 2 /* Liberado */   
           es-cad-cli.data-atualiz   = TODAY
           es-cad-cli.hora-atualiz   = TIME /*STRING(TIME,"HH:MM")*/
           es-cad-cli.usuar-atualiz  = "repres"
           es-cad-cli.pais           = "Brasil"              
           es-cad-cli.cod-gr-cli     = IF es-cad-cli.cod-canal-venda = 10 /* Consumo */ then 2 /* grupo Consumo */ else 1. /* grupo Revenda */
           IF es-cad-cli.ins-estadual    = "0"  THEN assign es-cad-cli.ins-estadual    = "" NO-ERROR.
END.
