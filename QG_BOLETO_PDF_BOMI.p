{include/i-buffer.i}
{utp/ut-glob.i}
/* Definicao da tt-boleto */
{esp/escr015.i}

FIND FIRST nota-fiscal WHERE nota-fiscal.nr-nota-fis = "0019607"
                         AND nota-fiscal.serie       = "3"
                         AND nota-fiscal.cod-estabel = "01".

IF AVAIL nota-fiscal THEN
    RUN enviaBoletoPdfBOMI(ROWID(nota-fiscal)).

PROCEDURE enviaBoletoPdfBOMI:

    DEFINE INPUT PARAMETER row-nota AS ROWID.

    DEFINE VARIABLE cArquivoTXT AS CHARACTER   NO-UNDO.
    
    FIND FIRST nota-fiscal WHERE ROWID(nota-fiscal) = row-nota NO-LOCK NO-ERROR.
    IF AVAIL nota-fiscal THEN DO:
        
        IF nota-fiscal.dt-cancel <> ? OR nota-fiscal.cod-estabel = "70" THEN NEXT.
        
        FIND portador NO-LOCK
            WHERE portador.ep-codigo    = i-ep-codigo-usuario
              AND portador.cod-portador = nota-fiscal.cod-port
              AND portador.modalidade   = nota-fiscal.modalidade NO-ERROR.
        
        IF NOT AVAIL portador THEN NEXT.
        
        /* Verifica Bancos Disponiveis */
        IF portador.cod-febraban <> 001 AND  /*** BANCO DO BRASIL    ***/
           portador.cod-febraban <> 004 AND  /*** BANCO DO NORDESTE  ***/
           portador.cod-febraban <> 237 AND  /*** BANCO BRADESCO     ***/
           portador.cod-febraban <> 399 AND  /*** HSBC               ***/
           portador.cod-febraban <> 341 THEN /*** BANCO ITAU         ***/ 
           NEXT.
        
        /* Verifica se Emitente Emite Boleto */
        FIND emitente NO-LOCK WHERE emitente.cod-emitente = nota-fiscal.cod-emitente NO-ERROR.
        IF NOT emitente.emite-bloq THEN NEXT.
        
        /* verifica se o boleto vai com a nota */
        FIND FIRST es-loc-entr NO-LOCK
            WHERE es-loc-entr.nome-abrev = emitente.nome-abrev 
              AND es-loc-entr.cod-entrega = nota-fiscal.cod-entrega NO-ERROR.

        IF NOT AVAIL es-loc-entr THEN NEXT.
        
        /* Verifica Faturas da Nota Fiscal */
        FOR EACH fat-duplic NO-LOCK
            WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel 
            AND fat-duplic.serie         = nota-fiscal.serie       
            AND fat-duplic.nr-fatura     = nota-fiscal.nr-fatura:
            
            FIND FIRST es-fat-duplic NO-LOCK 
                WHERE es-fat-duplic.cod-estabel = fat-duplic.cod-estabel 
                  AND es-fat-duplic.serie       = fat-duplic.serie
                  AND es-fat-duplic.nr-fatura   = fat-duplic.nr-fatura
                  AND es-fat-duplic.parcela     = fat-duplic.parcela NO-ERROR.            
            
            IF AVAIL es-fat-duplic THEN                
                    RUN esp/esbl0001.p (INPUT ROWID(es-fat-duplic),
                                        INPUT ROWID(fat-duplic),
                                        INPUT ROWID(nota-fiscal),
                                        INPUT-OUTPUT TABLE tt-boleto).            
            ELSE                
                RUN esp/esapi015.p (INPUT portador.cod-febraban,
                                    INPUT ROWID(fat-duplic),
                                    INPUT ROWID(nota-fiscal),
                                    INPUT-OUTPUT TABLE tt-boleto).
        END.

    END.
          
    FOR EACH tt-boleto:
        
        ASSIGN tt-boleto.caminho = "T:/estacao/spool/boleto" + STRING(RECID(es-fat-duplic)) + ".pcl".

        RUN esp/escr015gfl.p (INPUT "PDF",
                              INPUT TABLE tt-boleto). /* Emite boleto de todos os bancos */
        
        FIND FIRST es-fat-duplic NO-LOCK WHERE es-fat-duplic.cod-estabel = tt-boleto.cod-estabel
                                           AND es-fat-duplic.serie       = tt-boleto.serie
                                           AND es-fat-duplic.nr-fatura   = tt-boleto.nr-docto
                                           AND es-fat-duplic.parcela     = tt-boleto.parcela NO-ERROR.
    
        IF AVAIL es-fat-duplic THEN DO:
            
            cArquivoTXT = "T:/estacao/spool/boleto" + STRING(RECID(es-fat-duplic)) + ".txt".
            
            RUN piAlteraExtensaoArquivo IN THIS-PROCEDURE (INPUT cArquivoTXT).
    
            RUN H:/esp/geraBoletoPDFBomi.p (INPUT "T:/estacao/spool/",
                                            INPUT "boleto" + (STRING(RECID(es-fat-duplic)) + ".pcl")  ,
                                            INPUT "T:/estacao/spool/Bomi/"  ,
                                            INPUT ("boleto" + STRING(RECID(es-fat-duplic)) + ".pdf")).
    
        END.

    END.    
    
END.

PROCEDURE piAlteraExtensaoArquivo :

    DEFINE INPUT PARAMETER cPathArquivo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cPathArquivoDestino AS CHARACTER   NO-UNDO.
    cPathArquivoDestino = REPLACE(cPathArquivo,".TXT",".PCL").

    OS-RENAME VALUE(cPathArquivo) VALUE(cPathArquivoDestino). 

END PROCEDURE.
