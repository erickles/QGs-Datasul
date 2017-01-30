/*
1 - Pendente
2 - Efetivado
*/

DEFINE VARIABLE kilagem AS DECIMAL     NO-UNDO.
OUTPUT TO "c:\pedidos_pendentes.txt".

FOR EACH ws-p-venda WHERE dt-implant = 03/26/2013
                      AND dt-canc    = ?
                      AND cod-tipo-oper = 1
                      AND ind-sit-ped = 1
                      AND STRING(hr-implant,"HH:MM:SS") <= "17:05:00"
                      NO-LOCK:

    PUT ws-p-venda.nr-pedcli STRING(hr-implant,"HH:MM:SS") SKIP.
    
    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
        kilagem = kilagem + ws-p-item.qt-pedida.
    END.

END.
PUT kilagem.
OUTPUT CLOSE.
