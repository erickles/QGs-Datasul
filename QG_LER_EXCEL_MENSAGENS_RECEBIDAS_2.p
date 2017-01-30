
    DEFINE VARIABLE chExcel AS  COM-HANDLE.
    DEFINE VARIABLE chLivro AS  COM-HANDLE.
    DEFINE VARIABLE chFolha AS  COM-HANDLE.

    DEFINE VARIABLE x-linha     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE x-posicao   AS CHARACTER FORMAT "X(60)"  NO-UNDO.

    DEFINE TEMP-TABLE tt-planilha NO-UNDO
        FIELD nome-usuario  AS CHAR FORMAT "X(12)"
        FIELD remetente     AS CHAR FORMAT "X(12)"
        FIELD mensagem      AS CHAR FORMAT "X(60)"
        FIELD data-hora     AS CHAR FORMAT "X(20)"
        FIELD lida          AS CHAR FORMAT "X(3)".

    DEFINE TEMP-TABLE tt-remetente NO-UNDO
        FIELD nome-usuario  AS CHAR FORMAT "X(12)"
        FIELD remetente     AS CHAR FORMAT "X(12)"
        FIELD mensagem      AS CHAR FORMAT "X(60)"
        FIELD data-hora     AS CHAR FORMAT "X(20)"
        FIELD lida          AS CHAR FORMAT "X(3)"
        FIELD cod-emitente  LIKE emitente.cod-emitente
        FIELD nome-emit     LIKE emitente.nome-emit.

    /* ABRE A APLICA€ÇO EXCEL */
    CREATE "Excel.Application" chExcel NO-ERROR.

    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:

        MESSAGE "NÆo foi poss¡vel abrir a aplica‡Æo Excel"
                VIEW-AS ALERT-BOX ERROR.

        RETURN.
    END.

    /* ESCONDE O EXCEL */
    chExcel:VISIBLE = FALSE.

    /* ABRE O FICHEIRO EXCEL */
    chLivro = chExcel:Workbooks:OPEN("C:\Exemplo_msg.xlsx") NO-ERROR.

    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:

        MESSAGE "NÆo foi poss¡vel abrir o livro"
                VIEW-AS ALERT-BOX ERROR.
        RETURN.

    END.

    /* SELECCIONA O LIVRO */
    chFolha = chLivro:Sheets:ITEM(1).
    
    EMPTY TEMP-TABLE tt-planilha.

    DO x-linha = 6 TO (chFolha:UsedRange:Rows:COUNT) - 1:
        
        CREATE tt-planilha.
        ASSIGN tt-planilha.nome-usuario = chFolha:Range("A" + STRING(x-linha)):VALUE
               tt-planilha.remetente    = chFolha:Range("B" + STRING(x-linha)):VALUE
               tt-planilha.remetente    = REPLACE(SUBSTRING(tt-planilha.remetente,3,LENGTH(tt-planilha.remetente))," ","")
               tt-planilha.mensagem     = chFolha:Range("C" + STRING(x-linha)):VALUE
               tt-planilha.mensagem     = REPLACE(tt-planilha.mensagem,"?","")
               tt-planilha.data-hora    = chFolha:Range("D" + STRING(x-linha)):VALUE
               tt-planilha.lida         = chFolha:Range("E" + STRING(x-linha)):VALUE.

    END.

    chLivro:SAVE.
    chLivro:CLOSE.
    chExcel:QUIT.

    RELEASE OBJECT chExcel.      
    RELEASE OBJECT chLivro.
    RELEASE OBJECT chFolha.

    FOR EACH tt-planilha NO-LOCK:

        FIND FIRST emitente WHERE emitente.telefone[1] = tt-planilha.remetente NO-LOCK NO-ERROR.
        IF AVAIL emitente THEN DO:        
            CREATE tt-remetente.
            ASSIGN tt-remetente.nome-usuario    = tt-planilha.nome-usuario
                   tt-remetente.remetente       = tt-planilha.remetente   
                   tt-remetente.mensagem        = REPLACE(tt-planilha.mensagem,";","")
                   tt-remetente.data-hora       = tt-planilha.data-hora   
                   tt-remetente.lida            = tt-planilha.lida        
                   tt-remetente.cod-emitente    = emitente.cod-emitente
                   tt-remetente.nome-emit       = emitente.nome-emit.
        END.
    END.
        
OUTPUT TO "c:\sms_respondido.csv".

FOR EACH tt-remetente NO-LOCK:

    PUT tt-remetente.nome-usuario   ";"
        tt-remetente.remetente      ";"
        tt-remetente.mensagem       ";"
        tt-remetente.data-hora      ";"
        tt-remetente.lida           ";"
        tt-remetente.cod-emitente   ";"
        tt-remetente.nome-emit      SKIP.


END.

OUTPUT CLOSE.
