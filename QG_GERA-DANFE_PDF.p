{include/i-buffer.i}

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.

DEF TEMP-TABLE tt-param-aux
    FIELD destino              AS INTEGER
    FIELD destino-bloq         AS INTEGER
    FIELD arquivo              AS CHARACTER
    FIELD arquivo-bloq         AS CHARACTER
    FIELD usuario              AS CHARACTER
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD parametro            AS LOGICAL
    FIELD formato              AS INTEGER
    FIELD cod-layout           AS CHARACTER
    FIELD des-layout           AS CHARACTER
    FIELD log-impr-dados       AS LOGICAL  
    FIELD v_num_tip_aces_usuar AS INTEGER
    FIELD ep-codigo            LIKE empresa.ep-codigo
    FIELD c-cod-estabel        LIKE nota-fiscal.cod-estabel
    FIELD c-serie              LIKE nota-fiscal.serie
    FIELD c-nr-nota-fis-ini    LIKE nota-fiscal.nr-nota-fis
    FIELD c-nr-nota-fis-fim    LIKE nota-fiscal.nr-nota-fis
    FIELD i-cdd-embarq-ini    LIKE nota-fiscal.cdd-embarq
    FIELD i-cdd-embarq-fim    LIKE nota-fiscal.cdd-embarq
    FIELD da-dt-saida          LIKE nota-fiscal.dt-saida
    FIELD c-hr-saida           LIKE nota-fiscal.hr-confirma
    FIELD banco                AS INTEGER
    FIELD cod-febraban         AS INTEGER      
    FIELD cod-portador         AS INTEGER      
    FIELD prox-bloq            AS CHARACTER         
    FIELD c-instrucao          AS CHARACTER EXTENT 5
    FIELD imprime-bloq         AS LOGICAL
    FIELD rs-imprime           AS INTEGER
    FIELD impressora-so        AS CHARACTER
    FIELD impressora-so-bloq   AS CHARACTER
    FIELD nr-copias            AS INTEGER.

DEFINE TEMP-TABLE tt-log-danfe-xml NO-UNDO
    FIELD seq           AS INTE
    FIELD c-nr-nota-xml AS CHARACTER
    FIELD c-chave-xml   AS CHARACTER.

DEFINE NEW SHARED TEMP-TABLE tt-notas-impressas
    FIELD r-nota AS ROWID.

DEFINE VARIABLE rawParam        AS RAW         NO-UNDO.

FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis = "0002567"
                         AND nota-fiscal.cod-estabel = "23"
                         AND nota-fiscal.serie       = "1"
                         NO-LOCK NO-ERROR.   

    CREATE tt-param-aux.
    ASSIGN tt-param-aux.destino           = 4
           tt-param-aux.usuario           = 'super'
           tt-param-aux.rs-imprime        = 2
           tt-param-aux.c-cod-estabel     = nota-fiscal.cod-estabel
           tt-param-aux.c-serie           = nota-fiscal.serie
           tt-param-aux.c-nr-nota-fis-ini = nota-fiscal.nr-nota-fis
           tt-param-aux.c-nr-nota-fis-fim = nota-fiscal.nr-nota-fis
           tt-param-aux.i-cdd-embarq-ini = 0
           tt-param-aux.i-cdd-embarq-fim = 999999999
           tt-param-aux.nr-copias         = 1
           tt-param-aux.arquivo           = SESSION:TEMP-DIR   +
                                            "DANFE"         +
                                            nota-fiscal.cod-estabel +
                                            nota-fiscal.serie       +
                                            nota-fiscal.nr-nota-fis + ".doc".

    RAW-TRANSFER tt-param-aux TO rawParam.

    IF AVAIL nota-fiscal THEN DO:
        
        RUN ftp\esft0518rp.p (INPUT rawParam,
                                 INPUT TABLE tt-raw-digita,
                                 INPUT "C:\Datasul").
        
    END.
