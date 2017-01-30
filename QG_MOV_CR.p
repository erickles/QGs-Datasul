{include/i-buffer.i}
DEFINE VARIABLE deValor AS DECIMAL     NO-UNDO FORMAT ">,>>>,>>>,>>9.99".
OUTPUT TO "c:\tmp\DEPOSITOS_N_IDENT.CSV".

PUT "DT MOVTO;"
    "NR DOCTO EMP;"
    "NR DOCTO BANCO;"
    "ORIGEM;"
    "VALOR MOVTO;"
    "CLIENTE;"
    "ESPECIE;"
    "VALOR ORIGINAL;"
    "VALOR LIQUIDO;"
    "VALOR JUROS;"
    "VALOR DESP. BANCARIA;"
    "VALOR ABATIMENTO;"
    "VALOR BAIXA;"
    "VALOR TOTAL;"
    "COD ESTABEL;"
    "NRO TITULO;"
    "PARCELA;"
    "REFERENCIA;"
    "SERIE;"
    "TRANSACAO;"
    "USUARIO"
    SKIP.

FOR EACH movto-banco WHERE movto-banco.banco        = 888
                       AND movto-banco.cta-corrente = "888"
                       AND movto-banco.Agencia      = "888"
                       AND movto-banco.origem       = 6
                       
                       AND movto-banco.dt-movto     >= 01/01/2012
                       AND movto-banco.dt-movto     <= 12/31/2012
                       /*
                       AND movto-banco.dt-movto     >= 01/02/2012
                       AND movto-banco.dt-movto     <= 01/02/2012
                       
                       AND movto-banco.nr-docto-banco = "140"
                       AND movto-banco.nr-docto-emp   = "140"
                       */
                       NO-LOCK,
                        EACH mov-tit WHERE mov-tit.ep-codigo    = 01
                                        AND mov-tit.banco        = movto-banco.banco
                                        AND mov-tit.agencia      = movto-banco.agencia
                                        AND mov-tit.cta-corrente = movto-banco.cta-corrente
                                        AND mov-tit.nr-docto-emp = movto-banco.nr-docto-emp
                                        AND mov-tit.dt-trans     = movto-banco.dt-movto
                                        NO-LOCK BY movto-banco.dt-movto
                                                BY movto-banco.nr-docto-emp
                                                BY mov-tit.nome-abrev:

    deValor = 0.

    IF mov-tit.vl-liquido = 0 THEN
        deValor = mov-tit.vl-original.
    ELSE
        deValor = mov-tit.vl-baixa - mov-tit.vl-abatimen.

    FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = mov-tit.usuario NO-LOCK NO-ERROR.
        
    PUT UNFORM movto-banco.dt-movto            ";"
               movto-banco.nr-docto-emp        ";"
               movto-banco.nr-docto-banco      ";"
               movto-banco.origem              ";"
               movto-banco.valor-movto         ";"
               mov-tit.cod-emitente            ";"
               mov-tit.cod-esp                 ";"
               mov-tit.vl-original             ";"
               mov-tit.vl-liquido              ";"
               mov-tit.vl-juros-rec            ";"
               mov-tit.vl-desp-banc            ";"
               mov-tit.vl-abatimen             ";"
               mov-tit.vl-baixa                ";"
               deValor + mov-tit.vl-juros-rec - mov-tit.vl-desp-banc ";"
               mov-tit.cod-estabel             ";"
               mov-tit.nr-docto                ";"
               mov-tit.parcela                 ";"
               mov-tit.referencia              ";"
               mov-tit.serie                   ";"
               mov-tit.transacao               ";"
               mov-tit.usuario + " - " + IF AVAIL usuar_mestre THEN usuar_mestre.nom_usuario ELSE ""
               SKIP.
    
    /*DISP mov-tit WITH WIDTH 300 1 COL.*/
    
END.

OUTPUT CLOSE.
