
DEFINE VARIABLE pcTableOrig     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE pcTableDest     AS CHARACTER   NO-UNDO.

DEFIN BUFFER buf-es-busca-preco FOR es-busca-preco.
DEFIN BUFFER new-es-busca-preco FOR es-busca-preco.

UPDATE pcTableOrig  LABEL "Origem"
       pcTableDest  LABEL "Destino"
       WITH ROW 3 SIDE-LABEL CENTERED. 

/* Elimina Regras das Tabelas de Destino */
FOR EACH es-busca-preco 
   WHERE es-busca-preco.nr-tabpre = pcTableDest:
   DELETE es-busca-preco. 
END.

FOR EACH es-busca-preco NO-LOCK 
   WHERE es-busca-preco.nr-tabpre = pcTableOrig:

/*    FIND FIRST buf-es-busca-preco NO-LOCK                                              */
/*          WHERE buf-es-busca-preco.acumula-valores   = es-busca-preco.acumula-valores  */
/*            AND buf-es-busca-preco.char-1            = es-busca-preco.char-1           */
/*            AND buf-es-busca-preco.char-2            = es-busca-preco.char-2           */
/*            AND buf-es-busca-preco.cidade            = es-busca-preco.cidade           */
/*            AND buf-es-busca-preco.cod-canal-venda   = ?                               */
/*            AND buf-es-busca-preco.cod-emitente      = es-busca-preco.cod-emitente     */
/*            AND buf-es-busca-preco.cod-estabel       = es-busca-preco.cod-estabel      */
/*            AND buf-es-busca-preco.cod-gr-cli        = es-busca-preco.cod-gr-cli       */
/*            AND buf-es-busca-preco.cod-grupo         = "Nutri‡Æo C"                    */
/*            AND buf-es-busca-preco.cod-refer         = ?                               */
/*            AND buf-es-busca-preco.cod-tipo-oper     = ?                               */
/*            AND buf-es-busca-preco.contribuinte      = es-busca-preco.contribuinte     */
/*            AND buf-es-busca-preco.dec-1             = es-busca-preco.dec-1            */
/*            AND buf-es-busca-preco.dec-2             = es-busca-preco.dec-2            */
/*            AND buf-es-busca-preco.fm-cod-com        = ?                               */
/*            AND buf-es-busca-preco.fm-codigo         = ?                               */
/*            AND buf-es-busca-preco.ge-codigo         = 43                              */
/*            AND buf-es-busca-preco.ind-tp-frete      = es-busca-preco.ind-tp-frete     */
/*            AND buf-es-busca-preco.int-1             = es-busca-preco.int-1            */
/*            AND buf-es-busca-preco.int-2             = es-busca-preco.int-2            */
/*            AND buf-es-busca-preco.it-codigo         = ?                               */
/*            AND buf-es-busca-preco.log-1             = es-busca-preco.log-1            */
/*            AND buf-es-busca-preco.log-2             = es-busca-preco.log-2            */
/*            AND buf-es-busca-preco.nome-ab-reg       = es-busca-preco.nome-ab-reg      */
/*            AND buf-es-busca-preco.nome-matriz       = es-busca-preco.nome-matriz      */
/*            AND buf-es-busca-preco.nome-mic-reg      = es-busca-preco.nome-mic-reg     */
/*            AND buf-es-busca-preco.nome-munic        = es-busca-preco.nome-munic       */
/*            AND buf-es-busca-preco.nr-tabpre         = pcTableDest                     */
/*            AND buf-es-busca-preco.qtidade-fim       = es-busca-preco.qtidade-fim      */
/*            AND buf-es-busca-preco.qtidade-ini       = es-busca-preco.qtidade-ini      */
/*            AND buf-es-busca-preco.qtidade-item-fim  = es-busca-preco.qtidade-item-fim */
/*            AND buf-es-busca-preco.qtidade-item-ini  = es-busca-preco.qtidade-item-ini */
/*            AND buf-es-busca-preco.uf-destino        = es-busca-preco.uf-destino       */
/*            NO-ERROR.                                                                  */
/*    IF AVAIL buf-es-busca-preco THEN NEXT.                                             */

   FIND LAST buf-es-busca-preco NO-LOCK NO-ERROR.

   CREATE new-es-busca-preco.
   BUFFER-COPY es-busca-preco EXCEPT nr-tabpre /*nr-busca  ge-codigo  it-codigo
                                     cod-grupo fm-codigo fm-cod-com*/ data-1
                                     data-2    /*cod-refer cod-canal-venda cod-tipo-oper*/
                                  TO new-es-busca-preco
                              ASSIGN new-es-busca-preco.nr-busca        = buf-es-busca-preco.nr-busca + 1
                                     new-es-busca-preco.nr-tabpre       = pcTableDest
/*                                      new-es-busca-preco.cod-canal-venda = ?            */
/*                                      new-es-busca-preco.cod-tipo-oper   = ?            */
/*                                      new-es-busca-preco.it-codigo       = ?            */
/*                                      new-es-busca-preco.ge-codigo       = 44           */
/*                                      new-es-busca-preco.cod-grupo       = "Nutri‡Æo C" */
/*                                      new-es-busca-preco.fm-codigo       = ?            */
/*                                      new-es-busca-preco.fm-cod-com      = ?            */
/*                                      new-es-busca-preco.cod-refer       = ?            */
                                     new-es-busca-preco.data-1          = DATE(05,15,2010)
                                     new-es-busca-preco.data-2          = DATE(12,31,9999).

   ASSIGN es-busca-preco.data-1 = DATE(05,15,2010).


END.

/*
FOR EACH es-busca-preco NO-LOCK 
   WHERE es-busca-preco.nr-tabpre = "MA02-P":

    FIND FIRST buf-es-busca-preco NO-LOCK
         WHERE buf-es-busca-preco.acumula-valores   = es-busca-preco.acumula-valores  
           AND buf-es-busca-preco.char-1            = es-busca-preco.char-1           
           AND buf-es-busca-preco.char-2            = es-busca-preco.char-2           
           AND buf-es-busca-preco.cidade            = es-busca-preco.cidade           
           AND buf-es-busca-preco.cod-canal-venda   = ? 
           AND buf-es-busca-preco.cod-emitente      = es-busca-preco.cod-emitente     
           AND buf-es-busca-preco.cod-estabel       = es-busca-preco.cod-estabel      
           AND buf-es-busca-preco.cod-gr-cli        = es-busca-preco.cod-gr-cli       
           AND buf-es-busca-preco.cod-grupo         = "Nutri‡Æo C" 
           AND buf-es-busca-preco.cod-refer         = ? 
           AND buf-es-busca-preco.cod-tipo-oper     = ?
           AND buf-es-busca-preco.contribuinte      = es-busca-preco.contribuinte     
           AND buf-es-busca-preco.dec-1             = es-busca-preco.dec-1            
           AND buf-es-busca-preco.dec-2             = es-busca-preco.dec-2            
           AND buf-es-busca-preco.fm-cod-com        = ?
           AND buf-es-busca-preco.fm-codigo         = ?
           AND buf-es-busca-preco.ge-codigo         = 44
           AND buf-es-busca-preco.ind-tp-frete      = es-busca-preco.ind-tp-frete     
           AND buf-es-busca-preco.int-1             = es-busca-preco.int-1            
           AND buf-es-busca-preco.int-2             = es-busca-preco.int-2            
           AND buf-es-busca-preco.it-codigo         = ? 
           AND buf-es-busca-preco.log-1             = es-busca-preco.log-1            
           AND buf-es-busca-preco.log-2             = es-busca-preco.log-2            
           AND buf-es-busca-preco.nome-ab-reg       = es-busca-preco.nome-ab-reg      
           AND buf-es-busca-preco.nome-matriz       = es-busca-preco.nome-matriz      
           AND buf-es-busca-preco.nome-mic-reg      = es-busca-preco.nome-mic-reg     
           AND buf-es-busca-preco.nome-munic        = es-busca-preco.nome-munic       
           AND buf-es-busca-preco.nr-tabpre         = "MA2-N-P" 
           AND buf-es-busca-preco.qtidade-fim       = es-busca-preco.qtidade-fim      
           AND buf-es-busca-preco.qtidade-ini       = es-busca-preco.qtidade-ini      
           AND buf-es-busca-preco.qtidade-item-fim  = es-busca-preco.qtidade-item-fim 
           AND buf-es-busca-preco.qtidade-item-ini  = es-busca-preco.qtidade-item-ini 
           AND buf-es-busca-preco.uf-destino        = es-busca-preco.uf-destino       
           NO-ERROR.
   IF AVAIL buf-es-busca-preco THEN NEXT.

   FIND LAST buf-es-busca-preco NO-LOCK NO-ERROR.

   CREATE new-es-busca-preco.
   BUFFER-COPY es-busca-preco EXCEPT nr-tabpre nr-busca  ge-codigo  it-codigo
                                     cod-grupo fm-codigo fm-cod-com data-1
                                     data-2    cod-refer cod-canal-venda cod-tipo-oper
                                  TO new-es-busca-preco
                              ASSIGN new-es-busca-preco.nr-busca        = buf-es-busca-preco.nr-busca + 1
                                     new-es-busca-preco.nr-tabpre       = "MA2-N-P"
                                     new-es-busca-preco.cod-canal-venda = ?
                                     new-es-busca-preco.cod-tipo-oper   = ?
                                     new-es-busca-preco.it-codigo       = ?
                                     new-es-busca-preco.ge-codigo       = 44
                                     new-es-busca-preco.cod-grupo       = "Nutri‡Æo C"
                                     new-es-busca-preco.fm-codigo       = ?
                                     new-es-busca-preco.fm-cod-com      = ?
                                     new-es-busca-preco.cod-refer       = ?
                                     new-es-busca-preco.data-1          = DATE(05,15,2010)
                                     new-es-busca-preco.data-2          = DATE(12,31,9999).

END.


*/
