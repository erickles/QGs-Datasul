DEFINE TEMP-TABLE tt-comissao NO-UNDO
        FIELD r-rowid             AS ROWID
        FIELD pontos              AS INTEGER
        FIELD perc-comis          AS DECIMAL
        FIELD comis-emis          AS DECIMAL.

DEFINE VARIABLE pr-rowid      AS ROWID      NO-UNDO.

FIND ws-p-venda WHERE ws-p-venda.nr-pedcli = "3514w0006".

pr-rowid = ROWID(ws-p-venda).

RUN esp/espd1902.p (INPUT pr-rowid,
                    OUTPUT TABLE tt-comissao).

FOR EACH tt-comissao :
    
    FIND ws-p-item WHERE ROWID(ws-p-item) = tt-comissao.r-rowid NO-LOCK NO-ERROR.

    FIND FIRST ITEM WHERE ws-p-item.it-codigo = ITEM.it-codigo.

    DISPLAY
        ws-p-item.it-codigo
        tt-comissao.perc-comis
        tt-comissao.comis-emis
        SKIP(1)
        ITEM.ge-codigo
        ITEM.fm-codigo
        ITEM.fm-cod-com
        ws-p-venda.cod-canal-venda
        ws-p-venda.cod-gr-cli
        ws-p-venda.no-ab-reppri
        WITH 1 COLUMN.

END.
