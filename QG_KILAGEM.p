DEFINE VARIABLE vArq            AS CHAR EXTENT 3.
DEFINE VARIABLE v_mem           AS MEMPTR       NO-UNDO.
DEFINE VARIABLE v_dados         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE v_cont          AS INTEGER      NO-UNDO.
DEFINE VARIABLE cLinha          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cFile           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE kilagem         AS DECIMAL      NO-UNDO.
DEFINE VARIABLE cTipoRegistro   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iCont           AS INTEGER      NO-UNDO.
DEFINE VARIABLE diretorio       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE arquivo         AS CHARACTER    NO-UNDO FORMAT "X(60)".
DEFINE STREAM s-entrada.

DEF TEMP-TABLE tt-arquivos
    FIELD nome          AS CHAR FORMAT "x(50)"
    FIELD caminho       AS CHAR FORMAT "x(50)"
    FIELD tipo          AS CHAR FORMAT "x(4)"
    FIELD criacao       AS DATE
    FIELD modificacao   AS DATE
    FIELD tamanho       AS DEC FORMAT "->>>,>>>,>>>,>>>,>>9.99".

ASSIGN diretorio = "H:\Arquivos 1_4_2013".

INPUT FROM OS-DIR(diretorio).
    REPEAT:

        IMPORT vArq.
        
        IF vArq[3] = "F" THEN DO:

            CREATE tt-arquivos.        
            IMPORT tt-arquivos.            
            ASSIGN FILE-INFO:FILE-NAME = tt-arquivos.caminho.
            ASSIGN tt-arquivos.criacao = DATE(FILE-INFO:FILE-CREATE-DATE).
            ASSIGN tt-arquivos.modificacao = DATE(FILE-INFO:FILE-MOD-DATE).
            ASSIGN tt-arquivos.tamanho = FILE-INFO:FILE-SIZE.

        END.

   END.

INPUT CLOSE.

FOR EACH tt-arquivos NO-LOCK:

    cFile = tt-arquivos.caminho.

    IF SEARCH(cFile) <> ? THEN DO:
  
        INPUT STREAM s-entrada FROM VALUE(cFile).

        REPEAT:

            IMPORT STREAM s-entrada UNFORMATTED cLinha.
            
            ASSIGN cTipoRegistro = SUBSTRING(cLinha,1,1).
            
            IF cTipoRegistro = "2" THEN                
                kilagem = kilagem + (DECIMAL(SUBSTRING(cLinha,634,13)) / 10000).
                      
        END.
        
    END.
    
END.

DISP kilagem.
