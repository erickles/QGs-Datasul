FIND FIRST es-aprov-pedido WHERE                                                                   
           es-aprov-pedido.cod-usuario   = 'usuario'       AND                          
           es-aprov-pedido.nome-abrev    = 'cliente'      AND                          
           es-aprov-pedido.nr-pedcli     = 'pedido'       AND                          
           es-aprov-pedido.cdn-follow-up = 9 NO-LOCK NO-ERROR.            
IF NOT AVAIL es-aprov-pedido THEN DO:
    CREATE es-aprov-pedido.                                                                        
    ASSIGN es-aprov-pedido.cod-usuario   = 'usuario'                                   
           es-aprov-pedido.nome-abrev    = 'cliente'                                  
           es-aprov-pedido.nr-pedcli     = 'pedido'                                   
           es-aprov-pedido.cdn-follow-up = 9                             
           es-aprov-pedido.ind-tp-follow = 3                              
           es-aprov-pedido.ind-aprovador = NO.                                                     
END.           

