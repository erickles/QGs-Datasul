{include/i-buffer.i}

DEFINE VARIABLE cCidade       AS CHARACTER   NO-UNDO.

DEFINE VARIABLE iCont-cidade                            AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-es-cidade                         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-es-cidade-cics                    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-cidade-zf                         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-emitente                          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-emitente-cidade-cob               AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-loc-entr                          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-es-loc-entr                       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-es-loc-entr-cob                   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-estabelec                         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-transporte                        AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-transporte-tf                     AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-es-motorista                      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-nota-fiscal                       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-nota-fiscal-cif                   AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-agencia                           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-empresa                           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-es-busca-preco-cidade             AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-es-repres-end-cidade-cor          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-es-pedagio-cidade-cidade-pedagio  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iCont-repres                            AS INTEGER     NO-UNDO.

UPDATE cCidade LABEL "Cidade".

cCidade = CAPS(cCidade).

FOR EACH cidade WHERE cidade.cidade = cCidade NO-LOCK:
    iCont-cidade = iCont-cidade + 1.
END.

FOR EACH es-cidade WHERE es-cidade.cidade = cCidade NO-LOCK:
    iCont-es-cidade = iCont-es-cidade + 1.
END.

FOR EACH es-cidade WHERE es-cidade.cidade-cics = cCidade NO-LOCK:
    iCont-es-cidade-cics = iCont-es-cidade-cics + 1.
END.

FOR EACH cidade-zf WHERE cidade-zf.cidade = cCidade NO-LOCK:
    iCont-cidade-zf = iCont-cidade-zf + 1.
END.

FOR EACH emitente WHERE emitente.cidade = cCidade NO-LOCK:
    iCont-emitente = iCont-emitente + 1.

    
    FOR EACH nota-fiscal WHERE nota-fiscal.cidade-cif   = cCidade
                           AND nota-fiscal.cod-emitente = emitente.cod-emitente:
        iCont-nota-fiscal-cif = iCont-nota-fiscal-cif + 1.
    END.
    
    FOR EACH nota-fiscal WHERE nota-fiscal.cidade = cCidade
                           AND nota-fiscal.cod-emitente = emitente.cod-emitente:
        iCont-nota-fiscal = iCont-nota-fiscal + 1.
    END.

END.

FOR EACH emitente WHERE emitente.cidade-cob = cCidade NO-LOCK:
    iCont-emitente-cidade-cob = iCont-emitente-cidade-cob + 1.
END.

FOR EACH loc-entr WHERE loc-entr.cidade = cCidade NO-LOCK:
    iCont-loc-entr = iCont-loc-entr + 1.
END.

FOR EACH es-loc-entr WHERE es-loc-entr.cidade = cCidade NO-LOCK:
    iCont-es-loc-entr = iCont-es-loc-entr + 1.
END.

FOR EACH es-loc-entr WHERE es-loc-entr.cidade-cob = cCidade NO-LOCK:
    iCont-es-loc-entr-cob = iCont-es-loc-entr-cob + 1.
END.

FOR EACH estabelec WHERE estabelec.cidade = cCidade NO-LOCK:
    iCont-estabelec = iCont-estabelec + 1.
END.

FOR EACH transporte WHERE transporte.cidade = cCidade NO-LOCK:
    iCont-transporte = iCont-transporte + 1.
END.

FOR EACH transporte-tf WHERE transporte-tf.cidade = cCidade NO-LOCK:
    iCont-transporte-tf = iCont-transporte-tf + 1.
END.

FOR EACH es-motorista WHERE es-motorista.cidade = cCidade NO-LOCK:
    iCont-es-motorista = iCont-es-motorista + 1.
END.

FOR EACH agencia WHERE agencia.cidade = cCidade NO-LOCK:
    iCont-agencia = iCont-agencia + 1.
END.

FOR EACH empresa WHERE empresa.cidade = cCidade NO-LOCK:
    iCont-empresa = iCont-empresa + 1.
END.

FOR EACH es-busca-preco WHERE es-busca-preco.cidade = cCidade NO-LOCK:
    iCont-es-busca-preco-cidade = iCont-es-busca-preco-cidade + 1.
END.

FOR EACH es-repres-end WHERE es-repres-end.cidade-cor = cCidade NO-LOCK:
    iCont-es-repres-end-cidade-cor = iCont-es-repres-end-cidade-cor + 1.
END.

FOR EACH es-pedagio-cidade WHERE es-pedagio-cidade.cidade-pedagio = cCidade NO-LOCK:
    iCont-es-pedagio-cidade-cidade-pedagio = iCont-es-pedagio-cidade-cidade-pedagio + 1.
END.

FOR EACH repres WHERE repres.cidade = cCidade NO-LOCK:
    iCont-repres = iCont-repres + 1.
END.

MESSAGE "cidade:                            "   iCont-cidade                            SKIP
        "es-cidade:                         "   iCont-es-cidade                         SKIP
        "cidade-zf:                         "   iCont-cidade-zf                         SKIP
        "emitente:                          "   iCont-emitente                          SKIP
        "emitente.cidade-cob:               "   iCont-emitente-cidade-cob               SKIP
        "loc-entr:                          "   iCont-loc-entr                          SKIP
        "es-loc-entr:                       "   iCont-es-loc-entr                       SKIP
        "es-loc-entr-com:                   "   iCont-es-loc-entr-cob                   SKIP
        "es-cidade-cics:                    "   iCont-es-cidade-cics                    SKIP
        "estabelec:                         "   iCont-estabelec                         SKIP
        "transporte:                        "   iCont-transporte                        SKIP
        "transporte-tf:                     "   iCont-transporte-tf                     SKIP
        "es-motorista:                      "   iCont-es-motorista                      SKIP
        "nota-fiscal:                       "   iCont-nota-fiscal                       SKIP
        "nota-fiscal-cif:                   "   iCont-nota-fiscal-cif                   SKIP
        "agencia:                           "   iCont-agencia                           SKIP
        "empresa:                           "   iCont-empresa                           SKIP
        "es-busca-preco-cidade              "   iCont-es-busca-preco-cidade             SKIP
        "es-repres-end-cidade-cor           "   iCont-es-repres-end-cidade-cor          SKIP
        "es-pedagio-cidade-cidade-pedagio   "   iCont-es-pedagio-cidade-cidade-pedagio  SKIP
        "repres                             "   iCont-repres                            SKIP

        VIEW-AS ALERT-BOX INFO BUTTONS OK.

/*
es-rdv-rubrica.cidade
ped-venda.cidade-cif
ped-venda.cidade
pre-fatur.cidade
es-emitente-dis.cidade
es-cad-cli.cidade-entr
es-cad-cli.cidade-cobr
es-cad-cli.cidade-cobr-visita
loc-mr.cidade
es-coa-pend-aprov.cidade
es-cidade-rota.cidade
es-embarque-ordem.cidade
es-embarque-pedido.cidade
antt-viagem-docto-pessoa.cidade-nome
antt-viagem-docto-pessoa.cidade-ibge
es-sac-emit.cidade
es-nao-cliente.cidade
es-eventos.cidade
es-req-passagem.cidade-origem
es-req-passagem.cidade-destino
es-ocorrencia.cidade
es-bancos.cidade
es-bancos-ex.cidade
es-aeroporto.cidade
es-prazo-estab.cidade-destino
es-repres-ex.cidade
es-transp-ex.cidade
es-emitente-ex.cidade
es-emitente-ex.cidade-cob
wt-docto.cidade-cif
es-st-distancias.cidade
*/
