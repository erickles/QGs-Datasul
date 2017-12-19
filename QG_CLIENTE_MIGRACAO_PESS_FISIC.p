
FOR EACH emsuni.cliente WHERE cdn_cliente = 109708
                             AND cod_empresa = "TOR":
    
    DISP cliente.cod_empresa 
         cliente.nom_pessoa 
         cliente.num_pessoa.
    
    FIND FIRST pessoa_fisic WHERE num_pessoa_fisic = 72580 NO-LOCK NO-ERROR.
    IF AVAIL pessoa_fisic THEN DO:

        DISP pessoa_fisic.cod_id_feder    
             pessoa_fisic.nom_pessoa      
             pessoa_fisic.cod_id_feder    
             pessoa_fisic.num_pessoa_fisic.
        
        ASSIGN /*fornecedor.cod_id_feder  = pessoa_fisic.cod_id_feder*/
               cliente.nom_pessoa   = pessoa_fisic.nom_pessoa
               cliente.num_pessoa   = pessoa_fisic.num_pessoa_fisic.
        
    END.           
    
END.

