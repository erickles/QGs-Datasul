DEFINE VARIABLE c-UF LIKE  unid-feder.estado LABEL 'UF Origem'  NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE   NO-UNDO.
DEFINE VARIABLE c-arq-IN  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-arq-log AS CHARACTER     NO-UNDO.

ASSIGN  c-arq-log  = 'c:\temp\itens-importados.txt'
        c-arq-IN   = 'C:\temp\itens-perc.txt'.

DEFINE TEMP-TABLE TT NO-UNDO
    FIELD it-codigo AS CHARACTER
    FIELD perc      AS DECIMAL
    FIELD c-obs     AS CHARACTER
    INDEX ii it-codigo.

DO WHILE TRUE:
    UPDATE c-UF.
    ASSIGN  c-UF = CAPS(c-UF).
    DISP c-UF.

     IF  CAN-FIND (unid-feder WHERE unid-feder.pais   = 'brasil'
                                  AND  unid-feder.estado = c-UF     ) THEN LEAVE.
     ELSE DO:
         MESSAGE 'UF nao cadastrada'
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
         NEXT. 
     END.
END.
RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
run pi-inicializar in h-acomp (input  'Processando' ).

 
INPUT FROM VALUE(c-arq-IN). 
RUN pi-le-itens.
INPUT CLOSE.


FOR EACH TT WHERE TT.c-obs = '':
    RUN pi-grava-indice.
END.
 

OUTPUT TO  VALUE ( c-arq-log ).

PUT UNFORMATTED 'Item;perc;Obs' SKIP.
FOR EACH TT:
    PUT UNFORMATTED TT.it-codigo  ';'
                    TT.perc       ';'
                    TT.c-obs      ';' SKIP. 
END. 
OUTPUT CLOSE. 
RUN pi-finalizar IN h-acomp.
MESSAGE 'Processo Finalizado' SKIP 'Veja o arquivo ' c-arq-log    
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE pi-le-itens.
    DEFINE VARIABLE c-txt AS CHARACTER   NO-UNDO.

     DO WHILE TRUE ON ENDKEY UNDO, LEAVE: 
           PROCESS EVENTS.
           IMPORT UNFORMATTED c-txt.   
           IF c-txt = '' OR c-txt BEGINS ';;' OR c-txt BEGINS 'item;' THEN NEXT.
           CREATE TT.
           ASSIGN TT.it-codigo = ENTRY (1,c-txt,';') 
                  TT.perc      = DECIMAL (ENTRY (2,c-txt,';')). 

           IF NOT CAN-FIND  (  item WHERE item.it-codigo = TT.it-codigo) THEN
               ASSIGN TT.c-obs = 'item nao cadastrado Nao Foi importado'. 

           RUN pi-acompanhar IN h-acomp (INPUT  "Lendo - " + TT.it-codigo).  
     END.

END PROCEDURE.

DEFINE VARIABLE v-cod-indice AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-val-campo  AS DECIMAL     NO-UNDO.

PROCEDURE pi-grava-indice.
    
    FOR EACH unid-feder 
        WHERE unid-feder.pais   = 'brasil':
        PROCESS EVENTS.
        IF unid-feder.estado = c-UF OR unid-feder.estado = '' THEN NEXT. 

        v-cod-indice = TRIM (TT.it-codigo) + CHR(2) + c-UF + CHR(2) + TRIM (unid-feder.estado).   
    
        FIND FIRST inf-compl 
            WHERE inf-compl.cdn-identif = 5
            AND   inf-compl.cod-indice  = v-cod-indice 
            AND   inf-compl.num-campo   = 0 EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL inf-compl THEN DO:
            CREATE inf-compl.
            ASSIGN inf-compl.cdn-identif = 5
                   inf-compl.cod-indice  = v-cod-indice 
                   inf-compl.num-campo   = 0.
        END. 
        ASSIGN  inf-compl.log-campo     = NO           
                inf-compl.dat-campo     = TODAY        
                inf-compl.val-campo     = TT.perc       
                inf-compl.des-campo     = ''           
                inf-compl.cod-livre-1   = ''           
                inf-compl.cod-livre-2   = ''           
                inf-compl.num-livre-1   = 0            
                inf-compl.num-livre-2   = 0            
                inf-compl.dat-livre-1   = ?            
                inf-compl.dat-livre-2   = ?            
                inf-compl.log-livre-1   = NO           
                inf-compl.log-livre-2   = NO           
                inf-compl.val-livre-1   = 0            
                inf-compl.val-livre-2   = 0  .  

        RUN pi-acompanhar IN h-acomp (INPUT  "Gravando - " + TT.it-codigo + ' ' + unid-feder.estado).  
    END.

END PROCEDURE.
