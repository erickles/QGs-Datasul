define buffer b-es-permis-acess for es-permis-acess.


for each es-permis-acess where es-permis-acess.cod_usuario = "rym45487":
    create b-es-permis-acess.
    assign b-es-permis-acess.cdn-follow-up      = es-permis-acess.cdn-follow-up   
           b-es-permis-acess.char-1             = es-permis-acess.char-1         
           b-es-permis-acess.char-2             = es-permis-acess.char-2         
           b-es-permis-acess.cod-canal-venda    = es-permis-acess.cod-canal-venda
           b-es-permis-acess.cod-emitente       = es-permis-acess.cod-emitente   
           b-es-permis-acess.cod-estabel        = es-permis-acess.cod-estabel    
           b-es-permis-acess.cod-gr-cli         = es-permis-acess.cod-gr-cli     
           b-es-permis-acess.cod-tipo-oper      = es-permis-acess.cod-tipo-oper  
           b-es-permis-acess.cod_usuario        = "ess55813"
           b-es-permis-acess.data-1             = es-permis-acess.data-1         
           b-es-permis-acess.data-2             = es-permis-acess.data-2         
           b-es-permis-acess.dec-1              = es-permis-acess.dec-1          
           b-es-permis-acess.dec-2              = es-permis-acess.dec-2          
           b-es-permis-acess.ind-tp-follow      = es-permis-acess.ind-tp-follow  
           b-es-permis-acess.int-1              = es-permis-acess.int-1          
           b-es-permis-acess.int-2              = es-permis-acess.int-2          
           b-es-permis-acess.int-tp-aprov       = es-permis-acess.int-tp-aprov   
           b-es-permis-acess.log-1              = es-permis-acess.log-1          
           b-es-permis-acess.log-2              = es-permis-acess.log-2          
           b-es-permis-acess.nome-ab-reg        = es-permis-acess.nome-ab-reg    
           b-es-permis-acess.nome-mic-reg       = es-permis-acess.nome-mic-reg   
           b-es-permis-acess.nr-sequencia       = es-permis-acess.nr-sequencia.
end.
