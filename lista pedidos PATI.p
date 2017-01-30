DEFINE VARIABLE observ   AS CHARACTER FORMAT "x(600)" NO-UNDO.
DEFINE VARIABLE pedido   AS CHARACTER NO-UNDO.
DEFINE VARIABLE emitente AS CHARACTER NO-UNDO.
DEFINE VARIABLE nf       AS CHARACTER NO-UNDO.
DEFINE VARIABLE data     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAberto  AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-acomp  AS HANDLE    NO-UNDO.
DEFINE VARIABLE contador AS INTEGER   NO-UNDO.
DEFINE VARIABLE lAchou   AS LOGICAL  FORMAT "Sim/Nao"   NO-UNDO.
DEFINE VARIABLE cNrDocto AS CHARACTER NO-UNDO.

DEFINE BUFFER bnota-fiscal FOR nota-fiscal.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input "Processando...").

cAberto = "".

OUTPUT TO c:\temp\lista-pedidos-pati.csv.

PUT "PEDIDO"                 ";"
    "ESTABELECIMENTO-ORIGEM" ";"
    "NOTA FISCAL"            ";"
    "DEVOLVEU"               ";"
    "NF DEVOLUCAO"           ";"   
    "TIPO OPERACAO"          ";"
    "DESC.OPERACAO"          ";"
    "DATA IMPLANTACAO"       ";"
    "NOME CLIENTE-DESTINO"   ";"
    "OBSERVACOES" SKIP. 

blk_principal:
FOR EACH ws-p-venda NO-LOCK
    WHERE nr-pedcli BEGINS 'PATI'
    AND ind-sit-ped <> 22
    ,
    FIRST emitente NO-LOCK
    WHERE emitente.nome-abrev = ws-p-venda.nome-abrev
    ,
    FIRST nota-fiscal NO-LOCK
    WHERE nota-fiscal.nr-pedcli   = ws-p-venda.nr-pedcli
      AND nota-fiscal.cod-estabel = ws-p-venda.cod-estabel
      AND nota-fiscal.nome-ab-cli = ws-p-venda.nome-abrev
    ,
    FIRST es-tipo-operacao WHERE es-tipo-operacao.cod-tipo-oper = ws-p-venda.cod-tipo-oper NO-LOCK
    BY dt-implant DESC:

    contador = contador + 1.

    RUN pi-acompanhar IN h-acomp (INPUT "Nota Fiscal: " + STRING(nota-fiscal.nr-nota-fis) + "  -  Leia o Livro!!!").

   lAchou   = NO.
    cNrDocto = ''.
    blk_componente:
    FOR EACH componente NO-LOCK
         WHERE componente.serie-comp   = nota-fiscal.serie
           AND componente.nro-comp     = nota-fiscal.nr-nota-fis
           AND componente.cod-emitente = nota-fiscal.cod-emitente
           AND componente.nat-comp     = nota-fiscal.nat-operacao:

        ASSIGN 
            lAchou   = YES
            cNrDocto = componente.nro-docto.
        LEAVE blk_componente.
    END.


    
    FOR EACH ws-p-item OF ws-p-venda NO-LOCK:
        IF ws-p-item.dls-observacao <> "" THEN
            ASSIGN observ = replace(ws-p-item.dls-observacao,CHR(13)," / ")
                   observ = replace(ws-p-item.dls-observacao,CHR(10)," / ").
        ELSE
            ASSIGN  observ = replace(ws-p-venda.observacoes,CHR(13)," / ")
                    observ = REPLACE(ws-p-venda.observacoes,CHR(10)," / ").
    END.
    


    PUT ws-p-venda.nr-pedcl             ";"
        ws-p-venda.cod-estabel          ";"
        nota-fiscal.nr-nota-fis         ";"
        lAchou                          ";"
        cNrDocto                        ";"
        ws-p-venda.cod-tipo-oper        ";"
        es-tipo-operacao.des-tipo-oper  ";"
        ws-p-venda.dt-implant           ";"
        emitente.nome-emit              ";"
        observ                          SKIP.

 

END.

run pi-finalizar in h-acomp.

IF VALID-HANDLE(h-acomp) THEN
    DELETE OBJECT h-acomp NO-ERROR.

OUTPUT CLOSE.
