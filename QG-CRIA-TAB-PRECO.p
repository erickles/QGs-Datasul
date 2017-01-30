DEFINE BUFFER bf-tab-preco FOR es-tab-preco.
FIND FIRST es-tab-preco-linha WHERE es-tab-preco-linha.sequencia = 4.

FIND LAST bf-tab-preco WHERE bf-tab-preco.tipo-linha = es-tab-preco-linha.linha.
CREATE es-tab-preco.
ASSIGN es-tab-preco.it-codigo  = "42010731"
       es-tab-preco.cod-abrev  = SUBSTRING(es-tab-preco.it-codigo,4,4)
       es-tab-preco.com-rev    = 
       es-tab-preco.com-cons   = 
       es-tab-preco.com-cobr   = 
       es-tab-preco.sequencia  = 
       es-tab-preco.tipo-linha = es-tab-preco-linha.linha.
