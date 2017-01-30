/*
1 - ACA
21 - NFE
22 - NFS
23 - NFT
*/

/*{ininc/i01in218.i 04 movto-estoq.tipo-trans}*/

/* Funcao para determinar se um texto eh diferente do outro, levando em consideracao o CASE-SENSITIVE */
FUNCTION fnTextoDiferente RETURNS LOGICAL (INPUT cTextoOri AS CHAR,
                                           INPUT cTextodes AS CHAR):

    DEFINE VARIABLE cTexto        AS CHARACTER        NO-UNDO.
    DEFINE VARIABLE i             AS INTEGER          NO-UNDO.

    ASSIGN cTexto    = "".

    DO i = 1 TO LENGTH(cTextoOri):
        ASSIGN cTexto = cTexto + STRING(ASC(SUBSTR(cTextoOri,i,1))).
    END.
    ASSIGN cTextoOri = cTexto
            cTexto     = "".

    DO i = 1 TO LENGTH(cTextoDes):
        ASSIGN cTexto = cTexto + STRING(ASC(SUBSTR(cTextoDes,i,1))).
    END.

    ASSIGN cTextoDes = cTexto.

    IF cTextoOri = cTextoDes THEN
        RETURN FALSE.
    ELSE
        RETURN TRUE.
    
END FUNCTION.

DEFINE VARIABLE cLote AS CHARACTER CASE-SENSITIVE  NO-UNDO.

FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis = "0069980"
                         AND nota-fiscal.dt-emis     = 09/11/2012
                         AND nota-fiscal.cod-estabel = "22"
                         AND nota-fiscal.serie       = "2" 
                         NO-LOCK NO-ERROR.

FOR EACH it-nota-fisc OF nota-fiscal,
    EACH ITEM WHERE ITEM.it-codigo = it-nota-fisc.it-codigo.

    FIND FIRST fat-ser-lote OF it-nota-fisc NO-LOCK NO-ERROR.
    
    IF AVAIL fat-ser-lote THEN DO:

        ASSIGN cLote = fat-ser-lote.nr-serlote.

        FOR EACH movto-estoq WHERE movto-estoq.it-codigo   = it-nota-fisc.it-codigo
                               AND movto-estoq.lote        = cLote
                               /*AND NOT fnTextoDiferente(movto-estoq.lote,cLote)*/
                               AND movto-estoq.tipo-trans  = 1
                               AND (movto-estoq.esp-docto  = 21 OR movto-estoq.esp-docto = 23) NO-LOCK:
            
            FIND FIRST item-doc-est WHERE item-doc-est.it-codigo = movto-estoq.it-codigo
                                      AND item-doc-est.nro-docto = movto-estoq.nro-docto
                                      AND item-doc-est.serie-docto = movto-estoq.serie-docto
                                      NO-LOCK NO-ERROR.
        
            IF AVAIL item-doc-est THEN DO:

                FIND FIRST docum-est OF item-doc-est NO-LOCK NO-ERROR.

                DISP nota-fiscal.cod-estabel 
                     nota-fiscal.serie 
                     nota-fiscal.nr-nota-fis 
                     nota-fiscal.dt-emis 
                     nota-fiscal.nat-operacao 
                     it-nota-fisc.it-codigo
                     ITEM.descricao-1
                     it-nota-fisc.qt-faturada[1]
                     ITEM.un
                     IF AVAIL fat-ser-lote THEN fat-ser-lote.nr-serlote ELSE ""
                     it-nota-fisc.vl-tot-item
                     {ininc/i01in218.i 04 movto-estoq.tipo-trans}
                     docum-est.cod-estabel
                     docum-est.serie-docto
                     docum-est.nro-docto
                     docum-est.dt-emissao
                     docum-est.nat-operacao
                     movto-estoq.lote
                     item-doc-est.quantidade
                     item-doc-est.preco-total[1]
                     item-doc-est.valor-icm[1]
                     item-doc-est.valor-icm[1] / item-doc-est.quantidade
                     (item-doc-est.valor-icm[1] / item-doc-est.quantidade) * it-nota-fisc.qt-faturada[1]
                     WITH 1 COL.
            END.
        END.
    END.
END.
