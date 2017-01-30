DEFINE VARIABLE hHierarquia     AS HANDLE    NO-UNDO.
DEFINE VARIABLE listaGerente    AS CHARACTER NO-UNDO.
DEFINE VARIABLE listaSupervisor AS CHARACTER NO-UNDO.
DEFINE VARIABLE j               AS INTEGER   NO-UNDO.
define variable i               AS INTEger no-undo.
DEFINE VARIABLE cDestin         AS CHARACTER   NO-UNDO.

ASSIGN
    listaGerente    = ""
    listaSupervisor = ""
    j               = 0
    .

FIND FIRST ws-p-venda NO-LOCK
     WHERE ws-p-venda.nr-pedcli = '110346' NO-ERROR.

IF NOT VALID-HANDLE(hHierarquia) THEN
    RUN pdp/espd113.p PERSISTENT SET hHierarquia.

cDestin = "".
if valid-handle(hHierarquia) then do:
    RUN piGerenteSupervisor IN hHierarquia(INPUT ws-p-venda.nr-pedcli,
                                           INPUT ws-p-venda.nome-ab-reg,
                                           OUTPUT listaGerente,
                                           OUTPUT listaSupervisor).
    cDestin = if cDestin = "" then listaGerente + "," + listaSupervisor else cDestin + "," + listaGerente + "," + listaSupervisor.
END.

IF VALID-HANDLE(hHierarquia) THEN
    DELETE OBJECT hHierarquia NO-ERROR.

MESSAGE "Gerente:" listaGerente         SKIP
        "Supervisor:" listaSupervisor
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
