DEFINE TEMP-TABLE tt-cfop NO-UNDO
    FIELD r-rowid-item    AS ROWID
    FIELD r-rowid-cfop    AS ROWID
    FIELD pontos          AS INTEGER.

DEFINE VARIABLE pr-rowid      AS ROWID      NO-UNDO.

FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis = "0066394"
                         AND nota-fiscal.cod-estabel = "19"
                         AND nota-fiscal.serie       = "4".

ASSIGN pr-rowid = ROWID(nota-fiscal).

RUN c:\users\ess55813\Documents\QGs\QG-BUSCA-NATUREZA-NF.p(INPUT pr-rowid, OUTPUT TABLE tt-cfop).

FOR EACH tt-cfop :
    
    FIND it-nota-fisc WHERE
         ROWID(it-nota-fisc) = tt-cfop.r-rowid-item
         NO-LOCK NO-ERROR.

    FIND es-cfop NO-LOCK WHERE ROWID (es-cfop) = tt-cfop.r-rowid-cfop NO-ERROR.

    FIND ITEM WHERE ITEM.it-codigo = it-nota-fisc.it-codigo NO-ERROR.

    DISPLAY it-nota-fisc.it-codigo
            es-cfop.nat-operacao-interna
            es-cfop.cod-tipo-oper
            es-cfop.cod-mensagem-interna
            SKIP(1)
            ITEM.ge-codigo
            ITEM.fm-codigo
            ITEM.fm-cod-com
            WITH 1 COLUMN.

END.
