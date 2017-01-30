DEFINE VARIABLE c-UF LIKE  unid-feder.estado LABEL 'UF Origem'  NO-UNDO.
DEFINE VARIABLE h-acomp AS HANDLE   NO-UNDO.
DEFINE VARIABLE c-arq-IN  AS CHARACTER     NO-UNDO.
DEFINE VARIABLE c-arq-log AS CHARACTER     NO-UNDO.

ASSIGN  c-arq-log  = 'c:\temp\itens-importadosReg6.txt'
        c-arq-IN   = 'C:\temp\itens-Reg6.txt'.

DEFINE TEMP-TABLE TT NO-UNDO
    FIELD tipo          AS INTEGER
    FIELD cod-estabel   AS CHARACTER 
    FIELD it-codigo     AS CHARACTER
    FIELD dt-Afericao   AS DATE
    FIELD Vlr-Importado AS DECIMAL
    FIELD Vlr-Saida     AS DECIMAL
    FIELD perc-Conteudo AS DECIMAL
    FIELD Nro-FCI       AS INTEGER 
    FIELD c-obs         AS CHARACTER 
    INDEX ii tipo          
             cod-estabel   
             it-codigo     
             dt-Afericao. 

MESSAGE 'Confirme Carga de Reg 6'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL 
    TITLE "Confirme" UPDATE l-processa AS LOGICAL.

IF  l-processa <> YES  THEN RETURN. 

 
RUN utp/ut-acomp.p PERSISTENT SET h-acomp. 
run pi-inicializar in h-acomp (input  'Processando' ).

 
INPUT FROM VALUE(c-arq-IN). 
RUN pi-le-itens.
INPUT CLOSE.


FOR EACH TT WHERE TT.c-obs = '':
    RUN pi-grava-indice.
END.
 

OUTPUT TO  VALUE ( c-arq-log ).

PUT UNFORMATTED 'tipo;estabel;it-codigo;dt-Afericao;Vlr-Importado;Vlr Saida;perc-Conteudo;Nro-FCI' SKIP.
FOR EACH TT:
    PUT UNFORMATTED TT.tipo           ';'
                    TT.cod-estabel    ';'
                    TT.it-codigo      ';'
                    TT.dt-Afericao    ';'
                    TT.Vlr-Importado  ';'
                    TT.Vlr-Saida      ';'
                    TT.perc-Conteudo  ';'
                    TT.Nro-FCI        ';'
                    TT.c-obs          ';'  SKIP. 
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
           IF c-txt = '' OR c-txt BEGINS ';;' OR  c-txt BEGINS 'tipo;estab' THEN NEXT.
           CREATE TT.
           ASSIGN TT.tipo          = INTEGER (ENTRY (1,c-txt,';')) 
                  TT.cod-estabel   = ENTRY (2,c-txt,';') 
                  TT.it-codigo     = ENTRY (3,c-txt,';') 
                  TT.dt-Afericao   = DATE (ENTRY (4,c-txt,';') )
                  TT.Vlr-Importado = DECIMAL (ENTRY (5,c-txt,';')) 
                  TT.Vlr-Saida     = DECIMAL (ENTRY (6,c-txt,';'))
                  TT.perc-Conteudo = DECIMAL (ENTRY (7,c-txt,';'))
                  TT.Nro-FCI       = INTEGER (ENTRY (8,c-txt,';')) . 

           IF NOT CAN-FIND  (  item WHERE item.it-codigo = TT.it-codigo) THEN
               ASSIGN TT.c-obs = 'item nao cadastrado Nao Foi importado'. 

           IF TT.tipo <> 1 AND TT.tipo <> 2 THEN
               ASSIGN TT.c-obs = 'Tipo Invalido'. 

           RUN pi-acompanhar IN h-acomp (INPUT  "Lendo - " + TT.it-codigo).  
     END.

END PROCEDURE.

DEFINE VARIABLE v-cod-indice AS CHARACTER   NO-UNDO.
DEFINE VARIABLE v-val-campo  AS DECIMAL     NO-UNDO.

PROCEDURE pi-grava-indice.
                              

        v-cod-indice = TRIM (TT.cod-estabel) + CHR(2) + TRIM (TT.it-codigo)  + CHR(2) +  
                       STRING(YEAR (TT.dt-Afericao),'9999') +  
                       STRING(MONTH(TT.dt-Afericao),'99')   +  
                       STRING(DAY  (TT.dt-Afericao),'99').  
    
        FIND FIRST inf-compl 
            WHERE inf-compl.cdn-identif = 6
            AND   inf-compl.cod-indice  = v-cod-indice 
            AND   inf-compl.num-campo   = 0 EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAIL inf-compl THEN DO:
            CREATE inf-compl.
            ASSIGN inf-compl.cdn-identif = 6
                   inf-compl.cod-indice  = v-cod-indice 
                   inf-compl.num-campo   = 0.
        END. 
        ASSIGN  inf-compl.log-campo     = NO           
                inf-compl.dat-campo     = TODAY        
                inf-compl.val-campo     = TT.Vlr-Importado        
                inf-compl.des-campo     = ''           
                inf-compl.cod-livre-1   = ''           
                inf-compl.cod-livre-2   = ''           
                inf-compl.num-livre-1   = TT.Nro-FCI             
                inf-compl.num-livre-2   = TT.tipo            
                inf-compl.dat-livre-1   = ?            
                inf-compl.dat-livre-2   = ?            
                inf-compl.log-livre-1   = NO           
                inf-compl.log-livre-2   = NO           
                inf-compl.val-livre-1   = TT.Vlr-Saida                
                inf-compl.val-livre-2   = TT.perc-Conteudo  .  

        RUN pi-acompanhar IN h-acomp (INPUT  "Gravando - " + TT.it-codigo  ).  
  

END PROCEDURE.
