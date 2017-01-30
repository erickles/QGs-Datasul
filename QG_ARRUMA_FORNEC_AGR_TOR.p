FOR EACH emsuni.fornecedor WHERE emsuni.fornecedor.cdn_fornec = 110131 
                             AND emsuni.fornecedor.cod_empresa = "TOR":
    DISP "OK" emsuni.fornecedor.num_pessoa emsuni.fornecedor.cod_empresa emsuni.fornecedor.nom_abrev emsuni.fornecedor.nom_pessoa.    
    UPDATE emsuni.fornecedor.nom_pessoa.
END.
