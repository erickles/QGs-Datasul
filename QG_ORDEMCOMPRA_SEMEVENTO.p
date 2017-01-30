DEFINE VARIABLE iCont       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iContTotal  AS INTEGER     NO-UNDO.
DEFINE BUFFER bf-ev-integr-desp FOR es-ev-integr-desp.
{include/i-buffer.i}
OUTPUT TO "c:\ordem-compra.csv".

PUT "Pedido Compra;Ordem Compra; Conta Contabil; Cod Evento; Ano Evento;Usuario;Usuario Nome;Preco Unit;Qtd Solic" SKIP.

FOR EACH ordem-compra WHERE (ordem-compra.usuario = "caf54557"  OR 
                             ordem-compra.usuario = "pbs62134"  OR 
                             ordem-compra.usuario = "ccb63634"  OR 
                             ordem-compra.usuario = "msg63801"  OR 
                             ordem-compra.usuario = "apc52524"  OR 
                             ordem-compra.usuario = "esm59697") AND 
                             YEAR(ordem-compra.data-emissao) = 2012
                             NO-LOCK:

    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = ordem-compra.usuario NO-LOCK NO-ERROR.        

    FIND FIRST pedido-compr OF ordem-compra NO-LOCK NO-ERROR.

    FIND FIRST es-ev-integr-desp WHERE es-ev-integr-desp.numero-ordem = ordem-compra.numero-ordem NO-LOCK NO-ERROR.
    IF NOT AVAIL es-ev-integr-desp THEN            
        iCont = iCont + 1.

    iContTotal = iContTotal + 1.

    PUT IF AVAIL pedido-compr THEN pedido-compr.num-pedido                  ELSE 0      ";"
        ordem-compra.numero-ordem                                                       ";"
        ordem-compra.conta-contabil                                                     ";"
        IF AVAIL es-ev-integr-desp THEN es-ev-integr-desp.cod-evento        ELSE 0      ";"
        IF AVAIL es-ev-integr-desp THEN es-ev-integr-desp.ano-refer         ELSE 0      ";"
        ordem-compra.usuario                                                            ";"
        IF AVAIL usuar_mestre THEN STRING(usuar_mestre.nom_usuario,"X(60)") ELSE ""     ";"
        ordem-compra.preco-unit                                                         ";"
        ordem-compra.qt-solic                                                           SKIP.

END.

DISP iCont iContTotal.
