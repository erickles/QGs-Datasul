OUTPUT TO C:\temp\substitui25-03-10.txt. 

/* achou a nota de venda a partir da substituicao */
/* QG - Lista Nota Venda X Nota Substitui‡Æo Tributaria */

DEF VAR c-natureza AS CHAR NO-UNDO.

DEFINE TEMP-TABLE tt-nota-fiscal
    FIELD cod-estabel  LIKE nota-fiscal.cod-estabel 
    FIELD nr-nota-fis  LIKE nota-fiscal.nr-nota-fis 
    FIELD serie        LIKE nota-fiscal.serie       
    FIELD nat-operacao LIKE nota-fiscal.nat-operacao
    FIELD dt-emis-nota LIKE nota-fiscal.dt-emis-nota
    FIELD cidade-cif   LIKE nota-fiscal.cidade-cif  
    FIELD c-natureza   AS CHAR            
    FIELD estado       LIKE transporte.estado
    FIELD cod-estabel-st LIKE nota-fiscal.cod-estabel 
    FIELD nr-nota-fis-st LIKE nota-fiscal.nr-nota-fis 
    FIELD serie-st       LIKE nota-fiscal.serie.       


FOR EACH nota-fiscal  NO-LOCK WHERE dt-emis-nota >= 01/01/2010 and
                                    dt-emis-nota <= 01/31/2010 AND
                                    serie = "4":

      FIND FIRST transporte WHERE transporte.nome-abrev = nota-fiscal.nome-trans NO-LOCK NO-ERROR.

       CASE transporte.natureza:
            WHEN 1 THEN ASSIGN c-natureza = "Pessoa Fisica".
            WHEN 2 THEN ASSIGN c-natureza = "Pessoa Juridica".
            WHEN 3 THEN ASSIGN c-natureza = "Estrangeiro".
            OTHERWISE   ASSIGN c-natureza = "Trading".
       END CASE.
      
       CREATE tt-nota-fiscal.
       ASSIGN tt-nota-fiscal.cod-estabel  = nota-fiscal.cod-estabel  
              tt-nota-fiscal.nr-nota-fis  = nota-fiscal.nr-nota-fis 
              tt-nota-fiscal.serie        = nota-fiscal.serie       
              tt-nota-fiscal.nat-operacao = nota-fiscal.nat-operacao
              tt-nota-fiscal.dt-emis-nota = nota-fiscal.dt-emis-nota
              tt-nota-fiscal.cidade-cif   = nota-fiscal.cidade-cif  
              tt-nota-fiscal.c-natureza   = c-natureza              
              tt-nota-fiscal.estado       = transporte.estado
              tt-nota-fiscal.cod-estabel-st = "" 
              tt-nota-fiscal.nr-nota-fis-st = ""
              tt-nota-fiscal.serie-st       = "".   


/*                 DISP tt-nota-fiscal.cod-estabel                 */
/*                      tt-nota-fiscal.nr-nota-fis                 */
/*                      tt-nota-fiscal.serie                       */
/*                      tt-nota-fiscal.nat-operacao                */
/*                      tt-nota-fiscal.dt-emis-nota                */
/*                      tt-nota-fiscal.cidade-cif                  */
/*                      tt-nota-fiscal.c-natureza  FORMAT "x(20)"  */
/*                      tt-nota-fiscal.estado      WITH WIDTH 300. */
END.


FOR EACH tt-nota-fiscal:

     FIND FIRST docum-est WHERE docum-est.cod-estabel               = tt-nota-fiscal.cod-estabel           AND
                                docum-est.serie                     = "5"                                  AND
                                SUBSTRING(docum-est.observacao,20,7)= tt-nota-fiscal.nr-nota-fis  NO-LOCK NO-ERROR.

     IF AVAIL docum-est THEN DO:
           ASSIGN tt-nota-fiscal.cod-estabel-st = docum-est.cod-estabel 
                  tt-nota-fiscal.nr-nota-fis-st = docum-est.nro-docto       
                  tt-nota-fiscal.serie-st       = docum-est.serie. 
     END.
     ELSE DO:
           ASSIGN tt-nota-fiscal.cod-estabel-st = ""
                  tt-nota-fiscal.nr-nota-fis-st = ""      
                  tt-nota-fiscal.serie-st       = "".
     END.

     DISP tt-nota-fiscal.cod-estabel                
          tt-nota-fiscal.nr-nota-fis                
          tt-nota-fiscal.serie                      
          tt-nota-fiscal.nat-operacao               
          tt-nota-fiscal.dt-emis-nota               
          tt-nota-fiscal.cidade-cif                 
          tt-nota-fiscal.c-natureza  FORMAT "x(20)" 
          tt-nota-fiscal.estado      
          tt-nota-fiscal.cod-estabel-st
          tt-nota-fiscal.nr-nota-fis-st
          tt-nota-fiscal.serie-st       WITH WIDTH 300.

END.


        
/*            
FOR EACH nota-fiscal  NO-LOCK WHERE dt-emis-nota >= 01/01/2010 and
                                    dt-emis-nota <= 01/31/2010:

    
        FIND FIRST docum-est WHERE docum-est.cod-estabel = nota-fiscal.cod-estabel AND
                                   docum-est.serie      = nota-fiscal.serie        AND
                                   docum-est.nro-docto  = nota-fiscal.nr-nota-fis  NO-LOCK NO-ERROR.


DISP    SUBSTRING(docum-est.observacao,20,7) 
        SUBSTRING(docum-est.observacao,34,1) 
        docum-est.serie-docto  
        docum-est.nro-docto    
        docum-est.cod-emitente 
        docum-est.nat-operacao 
        docum-est.cod-estabel  
        docum-est.estab-fisc   
        docum-est.conta-transit
        docum-est.dt-emissao   
        docum-est.dt-trans     
        docum-est.usuario      
        docum-est.uf           
        docum-est.via-transp   
        docum-est.mod-frete    
        docum-est.nff          
        docum-est.tot-peso     
        docum-est.tot-desconto 
        docum-est.valor-frete  
        docum-est.valor-seguro 
        docum-est.valor-embal  
        docum-est.valor-outras 
        docum-est.valor-mercad 
        docum-est.dt-venc-ipi  
        docum-est.dt-venc-icm  
        docum-est.tot-valor    
        docum-est.observacao   
        docum-est.cotacao-dia  
        docum-est.esp-docto    
        docum-est.rec-fisico   
        docum-est.origem       
        docum-est.pais-origem  WITH WIDTH 300 1 COL.
         

END.
*/
