def buffer b-es-dep-usuar for es-dep-usuar.
    
        
for each b-es-dep-usuar where b-es-dep-usuar.cod-usu = "egp55779".
    create es-dep-usuar.
    assign es-dep-usuar.cod-usu             = "ess55813"
           es-dep-usuar.char-1              = b-es-dep-usuar.char-1          
           es-dep-usuar.char-2              = b-es-dep-usuar.char-2          
           es-dep-usuar.cod-departamento    = b-es-dep-usuar.cod-departamento
           es-dep-usuar.data-1              = b-es-dep-usuar.data-1          
           es-dep-usuar.data-2              = b-es-dep-usuar.data-2          
           es-dep-usuar.dec-1               = b-es-dep-usuar.dec-1           
           es-dep-usuar.dec-2               = b-es-dep-usuar.dec-2           
           es-dep-usuar.e-mail              = b-es-dep-usuar.e-mail          
           es-dep-usuar.int-1               = b-es-dep-usuar.int-1           
           es-dep-usuar.int-2               = b-es-dep-usuar.int-2           
           es-dep-usuar.log-1               = b-es-dep-usuar.log-1           
           es-dep-usuar.log-2               = b-es-dep-usuar.log-2           
           es-dep-usuar.log-principal       = b-es-dep-usuar.log-principal.
end.
