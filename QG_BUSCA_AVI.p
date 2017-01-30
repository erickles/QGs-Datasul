DEFINE BUFFER bf-busca-preco FOR es-busca-preco.
DEFINE BUFFER la-busca-preco FOR es-busca-preco.
DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO EXTENT 10.
DEFINE VARIABLE idx AS INTEGER     NO-UNDO.
DEFINE VARIABLE i-nr-busca AS INTEGER     NO-UNDO.

UPDATE i-nr-busca.

ASSIGN c-cod-estabel[1]     = "01"
       c-cod-estabel[2]     = "05"
       c-cod-estabel[3]     = "09"
       c-cod-estabel[4]     = "24"
       c-cod-estabel[5]     = "06"
       c-cod-estabel[6]     = "22"
       c-cod-estabel[7]     = "18"
       c-cod-estabel[8]     = "26"
       c-cod-estabel[9]     = "38"
       c-cod-estabel[10]    = "12".

DO idx = 1 TO 12:

    FIND FIRST es-busca-preco WHERE es-busca-preco.nr-busca = i-nr-busca NO-LOCK NO-ERROR.
    FIND LAST la-busca-preco NO-LOCK.

    FIND FIRST bf-busca-preco WHERE bf-busca-preco.cidade           = es-busca-preco.cidade
                                AND bf-busca-preco.uf-destino       = es-busca-preco.uf-destino
                                AND bf-busca-preco.cod-estabel      = c-cod-estabel[idx]
                                AND bf-busca-preco.ind-tp-frete     = es-busca-preco.ind-tp-frete
                                AND bf-busca-preco.cod-emitente     = es-busca-preco.cod-emitente
                                AND bf-busca-preco.contribuinte     = es-busca-preco.contribuinte
                                AND bf-busca-preco.cod-canal-venda  = es-busca-preco.cod-canal-venda
                                AND bf-busca-preco.cod-gr-cli       = es-busca-preco.cod-gr-cli
                                AND bf-busca-preco.nome-ab-reg      = es-busca-preco.nome-ab-reg
                                AND bf-busca-preco.nome-matriz      = es-busca-preco.nome-matriz
                                AND bf-busca-preco.it-codigo        = es-busca-preco.it-codigo
                                AND bf-busca-preco.cod-refer        = es-busca-preco.cod-refer
                                AND bf-busca-preco.fm-cod-com       = es-busca-preco.fm-cod-com      
                                AND bf-busca-preco.fm-codigo        = es-busca-preco.fm-codigo       
                                AND bf-busca-preco.ge-codigo        = es-busca-preco.ge-codigo
                                AND bf-busca-preco.cod-grupo        = es-busca-preco.cod-grupo
                                NO-ERROR.

    IF NOT AVAIL bf-busca-preco THEN DO:
    
        CREATE bf-busca-preco.
    
        ASSIGN bf-busca-preco.cod-estabel = c-cod-estabel[idx]
               bf-busca-preco.nr-busca    = la-busca-preco.nr-busca + 1.
            
        ASSIGN bf-busca-preco.acumula-valores  = es-busca-preco.acumula-valores 
               bf-busca-preco.char-1           = es-busca-preco.char-1          
               bf-busca-preco.char-2           = es-busca-preco.char-2          
               bf-busca-preco.check-sum        = es-busca-preco.check-sum       
               bf-busca-preco.cidade           = es-busca-preco.cidade
               bf-busca-preco.cod-canal-venda  = es-busca-preco.cod-canal-venda
               bf-busca-preco.cod-emitente     = es-busca-preco.cod-emitente
               bf-busca-preco.cod-gr-cli       = es-busca-preco.cod-gr-cli
               bf-busca-preco.cod-grupo        = es-busca-preco.cod-grupo
               bf-busca-preco.cod-refer        = es-busca-preco.cod-refer
               bf-busca-preco.cod-tipo-oper    = es-busca-preco.cod-tipo-oper   
               bf-busca-preco.contribuinte     = es-busca-preco.contribuinte
               bf-busca-preco.data-1           = es-busca-preco.data-1          
               bf-busca-preco.data-2           = es-busca-preco.data-2          
               bf-busca-preco.dec-1            = es-busca-preco.dec-1           
               bf-busca-preco.dec-2            = es-busca-preco.dec-2           
               bf-busca-preco.fm-cod-com       = es-busca-preco.fm-cod-com      
               bf-busca-preco.fm-codigo        = es-busca-preco.fm-codigo       
               bf-busca-preco.ge-codigo        = es-busca-preco.ge-codigo       
               bf-busca-preco.ind-tp-frete     = es-busca-preco.ind-tp-frete
               bf-busca-preco.int-1            = es-busca-preco.int-1           
               bf-busca-preco.int-2            = es-busca-preco.int-2           
               bf-busca-preco.it-codigo        = es-busca-preco.it-codigo
               bf-busca-preco.log-1            = es-busca-preco.log-1           
               bf-busca-preco.log-2            = es-busca-preco.log-2           
               bf-busca-preco.nome-ab-reg      = es-busca-preco.nome-ab-reg     
               bf-busca-preco.nome-matriz      = es-busca-preco.nome-matriz     
               bf-busca-preco.nome-mic-reg     = es-busca-preco.nome-mic-reg    
               bf-busca-preco.nome-munic       = es-busca-preco.nome-munic      
               bf-busca-preco.nr-tabpre        = es-busca-preco.nr-tabpre       
               bf-busca-preco.qtidade-fim      = es-busca-preco.qtidade-fim     
               bf-busca-preco.qtidade-ini      = es-busca-preco.qtidade-ini     
               bf-busca-preco.qtidade-item-fim = es-busca-preco.qtidade-item-fim
               bf-busca-preco.qtidade-item-ini = es-busca-preco.qtidade-item-ini
               bf-busca-preco.sequencia        = es-busca-preco.sequencia       
               bf-busca-preco.uf-destino       = es-busca-preco.uf-destino.
            
            MESSAGE bf-busca-preco.nr-busca
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

    END.
END.
