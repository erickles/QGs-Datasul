FOR EACH es-his-tit WHERE es-his-tit.cod_estab       = "19"
                      AND es-his-tit.cod_espec_docto = "PC"
                      AND es-his-tit.cod_tit_ap      = "0000011"  
                      /*AND es-his-tit.cdn_fornecedor  = 269387*/
                      AND es-his-tit.cod_parcela     = "1"
                      /*AND cod_ser_docto   = ""
                      
                      */
                      /*AND sequencia       = */
                      /*AND cod_tit_ap      =*/
                      :
    ASSIGN es-his-tit.sequencia = 2.
    DISP "OK" SKIP
         es-his-tit.cod_tit_ap
         es-his-tit.cod_tit_acr
         es-his-tit.sequencia
         es-his-tit.cdn_fornecedor.
END.
