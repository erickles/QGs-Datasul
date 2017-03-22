DEFINE BUFFER bf_fornecedor FOR emsuni.fornecedor.

OUTPUT TO "C:\Temp\fornecs_AGR.csv".

PUT "Empresa;Codigo fornec" SKIP.

FOR EACH emsuni.fornecedor WHERE emsuni.fornecedor.cod_empresa = "TOR" NO-LOCK:

    FIND FIRST bf_fornecedor WHERE bf_fornecedor.cod_empresa <> emsuni.fornecedor.cod_empresa
                               AND bf_fornecedor.cdn_fornecedor = emsuni.fornecedor.cdn_fornecedor
                               NO-LOCK NO-ERROR.

    IF AVAIL bf_fornecedor THEN DO:
        PUT bf_fornecedor.cod_empresa   ";"
            bf_fornecedor.cdn_fornec    SKIP.
    END.

    /*
    DISP fornecedor.cod_id_feder
         fornecedor.nom_pessoa  
         fornecedor.cod_id_feder
         fornecedor.num_pessoa.
    */
    
END.

OUTPUT CLOSE.
