
                                                   
/* 1.a execucao: Verificar se realmente local de entrega da nota ‚ o padrao ou proximo desse
   2.a execucao: retirar comentario do assign e corrigir dados
   3.a execucao: executar programa ftp/ft0910.r ataves do ctrl_alt_x  par reenvio do xml
   
   
*/ 

FIND FIRST nota-fiscal 
     WHERE nota-fiscal.cod-estabel = '19'  
       AND nota-fiscal.serie       = '4'     
       AND nota-fiscal.nr-nota-fis = '0216508'.
DISP nota-fiscal.cod-entrega.
FIND emitente WHERE emitente.cod-emitente = nota-fiscal.cod-emitente. 
DISP nota-fiscal.cod-entrega 
    nota-fiscal.endereco 
    emitente.endereco
    nota-fiscal.bairro
    emitente.bairro
    nota-fiscal.cgc
    emitente.cgc
    nota-fiscal.estado 
    emitente.estado
    nota-fiscal.ins-estadual
    emitente.ins-estadual
    nota-fiscal.cidade
    emitente.cidade
    nota-fiscal.cep
    emitente.cep
    WITH FRAME SIDE-LABEL 1 COL. 

     
                                                             

/*  ASSIGN  nota-fiscal.endereco     = emitente.endere‡o      */
/*          nota-fiscal.bairro       = emitente.bairro        */
/*          nota-fiscal.ins-estadual = emitente.ins-estadual  */
/*          nota-fiscal.cgc          = emitente.cgc           */
/*          nota-fiscal.estado       = emitente.estado        */
/*          nota-fiscal.cep          = emitente.cep           */
/*          nota-fiscal.cidade       = emitente.cidade.       */

/* UPDATE nota-fiscal.ins-estadual.  */

