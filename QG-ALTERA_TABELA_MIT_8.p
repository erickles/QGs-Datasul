output to c:\tabela_mit_8.txt.

for each es-tab-preco-rel WHERE Lookup(es-tab-preco-rel.nr-tabFilho,"MIT06MG3") > 0:
/*     Lookup(es-busca-preco.nr-tabpre,"MIT6MA1P,MIT6MA2P,MIT6PIP,MIT6SEP,MIT6BA1P,MIT6BA2P,MIT6BA3P,MIT6BA4P,MIT6TOP") > 0: */

    disp es-tab-preco-rel.nr-tabpre.

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

end.
