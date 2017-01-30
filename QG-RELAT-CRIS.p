DEFINE VARIABLE usu-sin AS CHARACTER   FORMAT "X(20)"   NO-UNDO.                               
DEFINE VARIABLE usu-rec AS CHARACTER   FORMAT "X(20)"   NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE                       NO-UNDO.

{include/i-freeac.i}

OUTPUT TO "c:\pedidos.csv".

PUT "NR PEDIDO"     ";"
    "CPF\CNPJ"      ";"
    "INSCRICAO EST" ";"
    "DT IMPLANT"    ";"
    "DT FATURAM"    ";"
    "SINTEGRA"      ";"
    "RECEITA"       ";"
    SKIP.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp(INPUT RETURN-VALUE).

FOR EACH nota-fiscal NO-LOCK WHERE nota-fiscal.dt-emis-nota >= 01/01/2011
                               AND nota-fiscal.dt-emis-nota <= 12/31/2011
                               AND nota-fiscal.emite-duplic 
                               AND nota-fiscal.estado <> "EX"
                               BY nota-fiscal.dt-emis-nota:
    
    ASSIGN usu-sin = ""
           usu-rec = "".

    FIND FIRST ws-p-venda   WHERE ws-p-venda.nr-pedcli  = nota-fiscal.nr-pedcli NO-LOCK NO-ERROR.
    IF NOT AVAIL ws-p-venda THEN NEXT.

    /**/
    FIND LAST movto-sintegra WHERE movto-sintegra.cod-emitente = nota-fiscal.cod-emitente
                               AND movto-sintegra.data-consulta = nota-fiscal.dt-emis-nota
                               NO-LOCK NO-ERROR.
    
    IF NOT AVAIL movto-sintegra THEN DO:
        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = TRIM(SUBSTRING(ws-p-venda.char-1,332,10)) NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN
            usu-sin = usuar_mestre.nom_usuario.
    END.
    
    /**/

    /**/
    FIND LAST movto-receita WHERE movto-receita.cod-emitente  = nota-fiscal.cod-emitente
                              AND movto-receita.data-pesquisa  = nota-fiscal.dt-emis-nota
                              NO-LOCK NO-ERROR.
    
    IF NOT AVAIL movto-receita THEN DO:
        FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = TRIM(SUBSTRING(ws-p-venda.char-1,358,10)) NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN
            usu-rec = usuar_mestre.nom_usuario.                
    END.
    
    /**/

    RUN pi-acompanhar IN h-acomp (INPUT STRING("Dt. Emis: " + STRING(nota-fiscal.dt-emis-nota))).

    FIND FIRST emitente     WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-LOCK NO-ERROR.

    PUT UNFORMATTED ws-p-venda.nr-pedcli                                                                    ";"
                    emitente.cgc                                                                            ";"
                    emitente.ins-estadual                                                                   ";"
                    IF AVAIL ws-p-venda THEN ws-p-venda.dt-implant ELSE nota-fiscal.dt-emis-nota            ";"
                    nota-fiscal.dt-emis-nota                                                                ";"
                    IF AVAIL movto-sintegra THEN fn-free-accent(movto-sintegra.situacao)    ELSE usu-sin    ";"
                    IF AVAIL movto-receita  THEN fn-free-accent(movto-receita.situacao-s)   ELSE usu-rec    SKIP.            
    
END.

OUTPUT CLOSE.

RUN pi-finalizar IN h-acomp.
