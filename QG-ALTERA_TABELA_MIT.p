OUTPUT TO c:\tabela_mit.txt.

FOR EACH es-busca-preco WHERE es-busca-preco.nr-tabpre = "MIT6PA1P"
                          AND es-busca-preco.nr-busca   = 32446:
    
    /*     disp es-busca-preco.nr-tabpre.  */

    /*     export delimiter ";" es-busca-preco. */

    /*     if es-busca-preco.nr-tabpre = "MIT06MA1" then assign es-busca-preco.nr-tabpre = "MIT6MA1P". */
    /*     if es-busca-preco.nr-tabpre = "MIT06MA2" then assign es-busca-preco.nr-tabpre = "MIT6MA2P". */
    /*     if es-busca-preco.nr-tabpre = "MIT06TO"  then assign es-busca-preco.nr-tabpre = "MIT6TOP".  */
    /*     if es-busca-preco.nr-tabpre = "MIT06PI"  then assign es-busca-preco.nr-tabpre = "MIT6PIP".  */
    /*     if es-busca-preco.nr-tabpre = "MIT06SE"  then assign es-busca-preco.nr-tabpre = "MIT6SEP".  */
    /*     if es-busca-preco.nr-tabpre = "MIT06BA1" then assign es-busca-preco.nr-tabpre = "MIT6BA1P". */
    /*     if es-busca-preco.nr-tabpre = "MIT06BA2" then assign es-busca-preco.nr-tabpre = "MIT6BA2P". */
    /*     if es-busca-preco.nr-tabpre = "MIT06BA3" then assign es-busca-preco.nr-tabpre = "MIT6BA3P". */
    /*     if es-busca-preco.nr-tabpre = "MIT06BA4" then assign es-busca-preco.nr-tabpre = "MIT6BA4P". */
     
    
    CREATE es-tab-preco-rel.
    ASSIGN es-tab-preco-rel.comis-emis  = 0
           es-tab-preco-rel.nr-tabFilho = "MIT8PA1P"
           es-tab-preco-rel.nr-tabpre   = es-busca-preco.nr-tabpre
           es-tab-preco-rel.sequencia   = es-busca-preco.sequencia
           es-tab-preco-rel.perc-comis  = 8.
           
    
    
END.

OUTPUT CLOSE.
