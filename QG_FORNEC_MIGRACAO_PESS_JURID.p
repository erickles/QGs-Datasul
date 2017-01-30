FOR EACH emsuni.fornecedor WHERE cdn_fornec = 110535
                             AND cod_empresa = "TOR":    
    
    DISP fornecedor.cod_id_feder
         fornecedor.nom_pessoa  
         fornecedor.cod_id_feder
         fornecedor.num_pessoa.

    FIND FIRST pessoa_jurid WHERE num_pessoa_jurid = 152365 NO-LOCK NO-ERROR.
    IF AVAIL pessoa_jurid THEN DO:
        
        ASSIGN fornecedor.cod_id_feder = pessoa_jurid.cod_id_feder
               fornecedor.nom_pessoa   = pessoa_jurid.nom_pessoa
               fornecedor.cod_id_feder = pessoa_jurid.cod_id_feder
               fornecedor.num_pessoa   = pessoa_jurid.num_pessoa_jurid.
        
    END.           
    
END.
