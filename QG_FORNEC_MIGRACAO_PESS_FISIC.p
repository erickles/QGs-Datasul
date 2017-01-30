FOR EACH emsuni.fornecedor WHERE cdn_fornec = 109394
                             AND cod_empresa = "TOR":    
    
    DISP fornecedor.cod_id_feder
         fornecedor.nom_pessoa  
         fornecedor.cod_id_feder
         fornecedor.num_pessoa.

    FIND FIRST pessoa_fisic WHERE num_pessoa_fisic = 129470 NO-LOCK NO-ERROR.
    IF AVAIL pessoa_fisic THEN DO:

        DISP pessoa_fisic.cod_id_feder    
             pessoa_fisic.nom_pessoa      
             pessoa_fisic.cod_id_feder    
             pessoa_fisic.num_pessoa_fisic.

        
        ASSIGN fornecedor.cod_id_feder = pessoa_fisic.cod_id_feder
               fornecedor.nom_pessoa   = pessoa_fisic.nom_pessoa
               fornecedor.cod_id_feder = pessoa_fisic.cod_id_feder
               fornecedor.num_pessoa   = pessoa_fisic.num_pessoa_fisic.
        
    END.           
    
END.
