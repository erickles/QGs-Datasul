{include/i-freeac.i}

DEFINE VARIABLE desc-hierarquia AS CHARACTER EXTENT 5  NO-UNDO.

DEFINE TEMP-TABLE tt-solicitacoes
    FIELD ano-historico-1               LIKE   es-solic-mkt.ano-historico[1]            
    FIELD ano-historico-2               LIKE   es-solic-mkt.ano-historico[2]            
    FIELD ano-historico-3               LIKE   es-solic-mkt.ano-historico[3]            
    FIELD anos-anter                    AS LOGICAL FORMAT "Sim/Nao"
    FIELD cod-emitente                  LIKE   es-solic-mkt.cod-emitente                
    FIELD descr-emitente                AS CHAR FORMAT "X(50)"
    FIELD cod-emitente-remessa          LIKE es-solic-mkt.cod-emitente-remessa        
    FIELD descr-emit-rem                AS CHAR FORMAT "X(50)"
    FIELD cod-evento                    LIKE es-solic-mkt.cod-evento                  
    FIELD cod-segmento                  LIKE es-solic-mkt.cod-segmento                
    FIELD descr-segmento                AS CHAR FORMAT "X(50)"
    FIELD cod-usu-reprova               LIKE es-solic-mkt.cod-usu-reprova             
    FIELD nome-usu-reprova              AS CHAR FORMAT "X(50)"
    FIELD cod-usuario                   LIKE es-solic-mkt.cod-usuario                 
    FIELD nome-usuario                  AS CHAR FORMAT "X(50)"
    FIELD desc-despesas                 LIKE es-solic-mkt.desc-despesas               
    FIELD desc-serv                     LIKE es-solic-mkt.desc-serv                   
    FIELD descr-evento                  LIKE es-solic-mkt.descr-evento                
    FIELD descr-motivo-retorno          LIKE es-solic-mkt.descr-motivo-retorno        
    FIELD dest-material                 LIKE es-solic-mkt.dest-material               
    FIELD dest-remessa                  LIKE es-solic-mkt.dest-remessa                
    FIELD dt-aprovacao                  LIKE es-solic-mkt.dt-aprovacao                
    FIELD dt-criacao                    LIKE es-solic-mkt.dt-criacao                  
    FIELD envio-mater-endereco          LIKE es-solic-mkt.envio-mater-endereco        
    FIELD envio-mater-nome              LIKE es-solic-mkt.envio-mater-nome            
    FIELD fim-evento                    LIKE es-solic-mkt.fim-evento                  
    FIELD ini-evento                    LIKE es-solic-mkt.ini-evento                  
    FIELD dias-restantes                AS INTE
    FIELD it-codigo-bri-1               LIKE es-solic-mkt.it-codigo-bri[1]            
    FIELD it-codigo-bri-2               LIKE es-solic-mkt.it-codigo-bri[2]            
    FIELD it-codigo-bri-3               LIKE es-solic-mkt.it-codigo-bri[3]            
    FIELD it-codigo-bri-4               LIKE es-solic-mkt.it-codigo-bri[4]            
    FIELD it-codigo-bri-5               LIKE es-solic-mkt.it-codigo-bri[5]            
    FIELD it-codigo-bri-6               LIKE es-solic-mkt.it-codigo-bri[6]            
    FIELD it-codigo-bri-7               LIKE es-solic-mkt.it-codigo-bri[7]            
    FIELD it-codigo-bri-8               LIKE es-solic-mkt.it-codigo-bri[8]            
    FIELD it-codigo-bri-9               LIKE es-solic-mkt.it-codigo-bri[9]            
    FIELD it-codigo-bri-10              LIKE es-solic-mkt.it-codigo-bri[10]           
    FIELD it-codigo-bri-11              LIKE es-solic-mkt.it-codigo-bri[11]           
    FIELD it-codigo-rem-1               LIKE es-solic-mkt.it-codigo-rem[1]            
    FIELD descr-rem-1                   AS CHAR FORMAT "X(50)"
    FIELD it-codigo-rem-2               LIKE es-solic-mkt.it-codigo-rem[2]            
    FIELD descr-rem-2                   AS CHAR FORMAT "X(50)"
    FIELD it-codigo-rem-3               LIKE es-solic-mkt.it-codigo-rem[3]            
    FIELD descr-rem-3                   AS CHAR FORMAT "X(50)"
    FIELD it-codigo-rem-4               LIKE es-solic-mkt.it-codigo-rem[4]            
    FIELD descr-rem-4                   AS CHAR FORMAT "X(50)"
    FIELD local-evento                  LIKE es-solic-mkt.local-evento                
    FIELD log-cliente                   LIKE es-solic-mkt.log-cliente                 
    FIELD log-palestrante               LIKE es-solic-mkt.log-palestrante             
    FIELD nivel-hierarquia              LIKE es-solic-mkt.nivel-hierarquia
    FIELD desc-hierarquia               AS CHAR FORMAT "X(50)"
    FIELD nome-ab-reg                   LIKE es-solic-mkt.nome-ab-reg                 
    FIELD nome-cliente-entidade         LIKE es-solic-mkt.nome-cliente-entidade       
    FIELD nome-mic-reg                  LIKE es-solic-mkt.nome-mic-reg                
    FIELD nome-palestrante              LIKE es-solic-mkt.nome-palestrante            
    FIELD nome-regiao                   LIKE es-solic-mkt.nome-regiao                 
    FIELD nr-ordem                      LIKE es-solic-mkt.nr-ordem                    
    FIELD nr-seq                        LIKE es-solic-mkt.nr-seq                      
    FIELD qtd-bri-1                     LIKE es-solic-mkt.qtd-bri[1]                  
    FIELD qtd-bri-2                     LIKE es-solic-mkt.qtd-bri[2]                  
    FIELD qtd-bri-3                     LIKE es-solic-mkt.qtd-bri[3]                  
    FIELD qtd-bri-4                     LIKE es-solic-mkt.qtd-bri[4]                  
    FIELD qtd-bri-5                     LIKE es-solic-mkt.qtd-bri[5]                  
    FIELD qtd-bri-6                     LIKE es-solic-mkt.qtd-bri[6]                  
    FIELD qtd-bri-7                     LIKE es-solic-mkt.qtd-bri[7]                  
    FIELD qtd-bri-8                     LIKE es-solic-mkt.qtd-bri[8]                  
    FIELD qtd-bri-9                     LIKE es-solic-mkt.qtd-bri[9]                  
    FIELD qtd-bri-10                    LIKE es-solic-mkt.qtd-bri[10]                 
    FIELD qtd-bri-11                    LIKE es-solic-mkt.qtd-bri[11]                 
    FIELD qtd-particip                  LIKE es-solic-mkt.qtd-particip                
    FIELD qtd-rem-1                     LIKE es-solic-mkt.qtd-rem[1]                  
    FIELD qtd-rem-2                     LIKE es-solic-mkt.qtd-rem[2]                  
    FIELD qtd-rem-3                     LIKE es-solic-mkt.qtd-rem[3]                  
    FIELD qtd-rem-4                     LIKE es-solic-mkt.qtd-rem[4]                  
    FIELD remessa-12-meses              LIKE es-solic-mkt.remessa-12-meses            
    FIELD resp-despesas                 LIKE es-solic-mkt.resp-despesas
    FIELD nome-resp-desp                AS CHAR FORMAT "X(50)"
    FIELD segmento                      LIKE es-solic-mkt.segmento                    
    FIELD super-resp                    LIKE es-solic-mkt.super-resp                  
    FIELD usu-aprov-mkt                 LIKE es-solic-mkt.usu-aprov-mkt
    FIELD nome-aprov-mkt                AS CHAR FORMAT "X(50)"
    FIELD val-historico-1               LIKE es-solic-mkt.val-historico[1]            
    FIELD val-historico-2               LIKE es-solic-mkt.val-historico[2]            
    FIELD val-historico-3               LIKE es-solic-mkt.val-historico[3]            
    FIELD vlr-adiantamento              LIKE es-solic-mkt.vlr-adiantamento            
    FIELD vlr-agua                      LIKE es-solic-mkt.vlr-agua                    
    FIELD vlr-coffee                    LIKE es-solic-mkt.vlr-coffee                  
    FIELD vlr-cop                       LIKE es-solic-mkt.vlr-cop                     
    FIELD vlr-desloc                    LIKE es-solic-mkt.vlr-desloc                  
    FIELD vlr-desp-reme                 LIKE es-solic-mkt.vlr-desp-reme               
    FIELD vlr-equip                     LIKE es-solic-mkt.vlr-equip                   
    FIELD vlr-espaco                    LIKE es-solic-mkt.vlr-espaco                  
    FIELD vlr-estag                     LIKE es-solic-mkt.vlr-estag                   
    FIELD vlr-garcom                    LIKE es-solic-mkt.vlr-garcom                  
    FIELD vlr-hospedagem                LIKE es-solic-mkt.vlr-hospedagem              
    FIELD vlr-impress                   LIKE es-solic-mkt.vlr-impress                 
    FIELD vlr-internet                  LIKE es-solic-mkt.vlr-internet                
    FIELD vlr-limpeza                   LIKE es-solic-mkt.vlr-limpeza                 
    FIELD vlr-liq-rps                   LIKE es-solic-mkt.vlr-liq-rps                 
    FIELD vlr-orcam-1                   LIKE es-solic-mkt.vlr-orcam-1                 
    FIELD vlr-orcam-2                   LIKE es-solic-mkt.vlr-orcam-2                 
    FIELD vlr-orcam-3                   LIKE es-solic-mkt.vlr-orcam-3                 
    FIELD vlr-promo                     LIKE es-solic-mkt.vlr-promo                   
    FIELD vlr-recep                     LIKE es-solic-mkt.vlr-recep                   
    FIELD vlr-refeicao                  LIKE es-solic-mkt.vlr-refeicao                
    FIELD vlr-refri                     LIKE es-solic-mkt.vlr-refri                   
    FIELD vlr-rem-1                     LIKE es-solic-mkt.vlr-rem[1]                  
    FIELD vlr-rem-2                     LIKE es-solic-mkt.vlr-rem[2]                  
    FIELD vlr-rem-3                     LIKE es-solic-mkt.vlr-rem[3]                  
    FIELD vlr-rem-4                     LIKE es-solic-mkt.vlr-rem[4]                  
    FIELD vlr-salga                     LIKE es-solic-mkt.vlr-salga                   
    FIELD vlr-seg                       LIKE es-solic-mkt.vlr-seg                     
    FIELD vlr-serv                      LIKE es-solic-mkt.vlr-serv                    
    FIELD vlr-stand                     LIKE es-solic-mkt.vlr-stand                   
    FIELD vlr-tel                       LIKE es-solic-mkt.vlr-tel                     
    FIELD vol-historico-1               LIKE es-solic-mkt.vol-historico[1]            
    FIELD vol-historico-2               LIKE es-solic-mkt.vol-historico[2]
    FIELD vol-historico-3               LIKE es-solic-mkt.vol-historico[3]
    FIELD vlr-desp-rem                  LIKE es-solic-mkt.vlr-refri.

OUTPUT TO "C:\ESFT081.csv".

PUT "Ano historico 1"                   ";"
    "Ano historico 2"                   ";"
    "Ano historico 3"                   ";"
    "Tortuga em anos anteriores"        ";"
    "Cod Cliente"                       ";"
    "Nome Cliente"                      ";"
    "Cod Cliente Remessa"               ";"
    "Nome Cliente Remessa"              ";"
    "Cod Evento"                        ";"
    "Cod Segmento"                      ";"
    "Segmento"                          ";"
    "Cod Usuario Reprovacao"            ";"
    "Usuario Reprov."                   ";"
    "Cod Usuario"                       ";"
    "Usuario"                           ";"
    "Desc.Despesas"                     ";"
    "Descricao Servico"                 ";"
    "Descricao Evento"                  ";"
    "Descr.Mot.Retorno"                 ";"
    "Dest.Material"                     ";"
    "Dest.Remessa"                      ";"
    "Dt.Aprovacao"                      ";"
    "Dt.Criacao"                        ";"
    "End.Envio.Mater"                   ";"
    "RemetenteEnvioMater"               ";"
    "Dt.FimEvento"                      ";"
    "Dt.IniEvento"                      ";"
    "Dias para o Evento"                ";"
    "Brinde 1"                          ";"
    "Brinde 2"                          ";"
    "Brinde 3"                          ";"
    "Brinde 4"                          ";"
    "Brinde 5"                          ";"
    "Brinde 6"                          ";"
    "Brinde 7"                          ";"
    "Brinde 8"                          ";"
    "Brinde 9"                          ";"
    "Brinde 10"                         ";"
    "Brinde 11"                         ";"
    "Cod.Item.Remessa 1"                ";"
    "Desc.Item Rem. 1"                  ";"
    "Cod.Item.Remessa 2"                ";"
    "Desc.Item Rem. 2"                  ";"
    "Cod.Item.Remessa 3"                ";"
    "Desc.Item Rem. 3"                  ";"
    "Cod.Item.Remessa 4"                ";"
    "Desc.Item Rem. 4"                  ";"
    "Local Evento"                      ";"
    "Cliente?"                          ";"
    "Possui Palestrante"                ";"
    "Nivel Hierarquia"                  ";"
    "Status Aprovacao"                  ";"
    "Supervisao"                        ";"
    "Cliente Entidade"                  ";"
    "MicroRegiao"                       ";"
    "Palestrante"                       ";"
    "Gerencia"                          ";"
    "Nr Ordem"                          ";"
    "Sequencia"                         ";"
    "Qts.Brinde 1"                      ";"
    "Qts.Brinde 2"                      ";"
    "Qts.Brinde 3"                      ";"
    "Qts.Brinde 4"                      ";"
    "Qts.Brinde 5"                      ";"
    "Qts.Brinde 6"                      ";"
    "Qts.Brinde 7"                      ";"
    "Qts.Brinde 8"                      ";"
    "Qts.Brinde 9"                      ";"
    "Qts.Brinde 10"                     ";"
    "Qts.Brinde 11"                     ";"
    "Qtd.Particpantes"                  ";"
    "Qtd.Remessa 1"                     ";"
    "Qtd.Remessa 2"                     ";"
    "Qtd.Remessa 3"                     ";"
    "Qtd.Remessa 4"                     ";"
    "Remessa ult. 12 meses"             ";"
    "Cod. Resp Despesas"                ";"
    "Resp. Despesas"                    ";"
    "Supervisor Responsavel"            ";"
    "Usu Aprovador MKT"                 ";"
    "Aprovador MKT"                     ";"
    "Val. Historico 1"                  ";"
    "Val. Historico 2"                  ";"
    "Val. Historico 3"                  ";"
    "Vlr. Adiantamento"                 ";"
    "Vlr. Agua"                         ";"
    "Vlr. CoffeeBreak"                  ";"
    "Vlr. Copeira"                      ";"
    "Vlr. Deslocamento"                 ";"
    "Vlr. Desp. Remessa"                ";"
    "Vlr. Equipamentos"                 ";"
    "Vlr. Espaco"                       ";"
    "Vlr. Palestrante"                  ";"
    "Vlr. Garcom"                       ";"
    "Vlr. Hospedagem"                   ";"
    "Vlr. Impressao"                    ";"
    "Vlr. Internet"                     ";"
    "Vlr. Mat.limpeza"                  ";"
    "Vlr. Liq. RPS"                     ";"
    "Vlr. Orcamento 1"                  ";"
    "Vlr. Orcamento 2"                  ";"
    "Vlr. Orcamento 3"                  ";"
    "Vlr. Promo"                        ";"
    "Vlr. Recepcionista"                ";"
    "Vlr. Refeicao"                     ";"
    "Vlr. Refrigerante"                 ";"
    "Vlr. Remessa 1"                    ";"
    "Vlr. Remessa 2"                    ";"
    "Vlr. Remessa 3"                    ";"
    "Vlr. Remessa 4"                    ";"
    "Vlr. Frios/Salgados"               ";"
    "Vlr. Seguranca"                    ";"
    "Vlr. Serv"                         ";"
    "Vlr. Stand"                        ";"
    "Vlr. Telefone"                     ";"
    "Vol. Historico 1"                  ";"
    "Vol. Historico 2"                  ";"
    "Vol. Historico 3"                  ";"
    "Vlr.Desp.Rem"                      SKIP.
    
FOR EACH es-solic-mkt NO-LOCK:

    CREATE tt-solicitacoes.
    ASSIGN tt-solicitacoes.ano-historico-1          = es-solic-mkt.ano-historico[1]         
           tt-solicitacoes.ano-historico-2          = es-solic-mkt.ano-historico[2]      
           tt-solicitacoes.ano-historico-3          = es-solic-mkt.ano-historico[3]      
           tt-solicitacoes.anos-anter               = es-solic-mkt.anos-anter
           tt-solicitacoes.cod-emitente             = es-solic-mkt.cod-emitente          
           tt-solicitacoes.descr-emitente           = "" /**/                                
           tt-solicitacoes.cod-emitente-remessa     = es-solic-mkt.cod-emitente-remessa  
           tt-solicitacoes.descr-emit-rem           = "" /**/                                
           tt-solicitacoes.cod-evento               = es-solic-mkt.cod-evento            
           tt-solicitacoes.cod-segmento             = es-solic-mkt.cod-segmento          
           tt-solicitacoes.descr-segmento           = "" /**/                                
           tt-solicitacoes.cod-usu-reprova          = es-solic-mkt.cod-usu-reprova       
           tt-solicitacoes.nome-usu-reprova         = "" /**/                                
           tt-solicitacoes.cod-usuario              = es-solic-mkt.cod-usuario           
           tt-solicitacoes.nome-usuario             = "" /**/
           tt-solicitacoes.desc-despesas            = fn-free-accent(es-solic-mkt.desc-despesas)
           tt-solicitacoes.desc-serv                = fn-free-accent(es-solic-mkt.desc-serv)
           tt-solicitacoes.descr-evento             = fn-free-accent(es-solic-mkt.descr-evento)
           tt-solicitacoes.descr-motivo-retorno     = fn-free-accent(es-solic-mkt.descr-motivo-retorno)
           tt-solicitacoes.dest-material            = fn-free-accent(es-solic-mkt.dest-material)
           tt-solicitacoes.dest-remessa             = fn-free-accent(es-solic-mkt.dest-remessa)
           tt-solicitacoes.dt-aprovacao             = es-solic-mkt.dt-aprovacao
           tt-solicitacoes.dt-criacao               = es-solic-mkt.dt-criacao
           tt-solicitacoes.envio-mater-endereco     = fn-free-accent(es-solic-mkt.envio-mater-endereco)
           tt-solicitacoes.envio-mater-nome         = es-solic-mkt.envio-mater-nome      
           tt-solicitacoes.fim-evento               = es-solic-mkt.fim-evento            
           tt-solicitacoes.ini-evento               = es-solic-mkt.ini-evento            
           tt-solicitacoes.dias-restantes           = IF tt-solicitacoes.dt-aprovacao <> ? THEN
                                                        tt-solicitacoes.ini-evento - tt-solicitacoes.dt-aprovacao
                                                      ELSE
                                                        tt-solicitacoes.ini-evento - tt-solicitacoes.dt-criacao
           tt-solicitacoes.it-codigo-bri-1          = es-solic-mkt.it-codigo-bri[1]      
           tt-solicitacoes.it-codigo-bri-2          = es-solic-mkt.it-codigo-bri[2]      
           tt-solicitacoes.it-codigo-bri-3          = es-solic-mkt.it-codigo-bri[3]      
           tt-solicitacoes.it-codigo-bri-4          = es-solic-mkt.it-codigo-bri[4]      
           tt-solicitacoes.it-codigo-bri-5          = es-solic-mkt.it-codigo-bri[5]      
           tt-solicitacoes.it-codigo-bri-6          = es-solic-mkt.it-codigo-bri[6]      
           tt-solicitacoes.it-codigo-bri-7          = es-solic-mkt.it-codigo-bri[7]      
           tt-solicitacoes.it-codigo-bri-8          = es-solic-mkt.it-codigo-bri[8]      
           tt-solicitacoes.it-codigo-bri-9          = es-solic-mkt.it-codigo-bri[9]      
           tt-solicitacoes.it-codigo-bri-10         = es-solic-mkt.it-codigo-bri[10]     
           tt-solicitacoes.it-codigo-bri-11         = es-solic-mkt.it-codigo-bri[11]     
           tt-solicitacoes.it-codigo-rem-1          = es-solic-mkt.it-codigo-rem[1]      
           tt-solicitacoes.descr-rem-1              = "" /**/                                 
           tt-solicitacoes.it-codigo-rem-2          = es-solic-mkt.it-codigo-rem[2]      
           tt-solicitacoes.descr-rem-2              = "" /**/                                
           tt-solicitacoes.it-codigo-rem-3          = es-solic-mkt.it-codigo-rem[3]      
           tt-solicitacoes.descr-rem-3              = "" /**/                                
           tt-solicitacoes.it-codigo-rem-4          = es-solic-mkt.it-codigo-rem[4]      
           tt-solicitacoes.descr-rem-4              = "" /**/                                
           tt-solicitacoes.local-evento             = fn-free-accent(es-solic-mkt.local-evento)
           tt-solicitacoes.log-cliente              = es-solic-mkt.log-cliente           
           tt-solicitacoes.log-palestrante          = es-solic-mkt.log-palestrante       
           tt-solicitacoes.nivel-hierarquia         = es-solic-mkt.nivel-hierarquia      
           tt-solicitacoes.nome-ab-reg              = es-solic-mkt.nome-ab-reg           
           tt-solicitacoes.nome-cliente-entidade    = es-solic-mkt.nome-cliente-entidade 
           tt-solicitacoes.nome-mic-reg             = es-solic-mkt.nome-mic-reg          
           tt-solicitacoes.nome-palestrante         = fn-free-accent(es-solic-mkt.nome-palestrante)
           tt-solicitacoes.nome-regiao              = fn-free-accent(es-solic-mkt.nome-regiao)
           tt-solicitacoes.nr-ordem                 = es-solic-mkt.nr-ordem              
           tt-solicitacoes.nr-seq                   = es-solic-mkt.nr-seq                
           tt-solicitacoes.qtd-bri-1                = es-solic-mkt.qtd-bri[1]            
           tt-solicitacoes.qtd-bri-2                = es-solic-mkt.qtd-bri[2]            
           tt-solicitacoes.qtd-bri-3                = es-solic-mkt.qtd-bri[3]            
           tt-solicitacoes.qtd-bri-4                = es-solic-mkt.qtd-bri[4]            
           tt-solicitacoes.qtd-bri-5                = es-solic-mkt.qtd-bri[5]            
           tt-solicitacoes.qtd-bri-6                = es-solic-mkt.qtd-bri[6]            
           tt-solicitacoes.qtd-bri-7                = es-solic-mkt.qtd-bri[7]            
           tt-solicitacoes.qtd-bri-8                = es-solic-mkt.qtd-bri[8]            
           tt-solicitacoes.qtd-bri-9                = es-solic-mkt.qtd-bri[9]            
           tt-solicitacoes.qtd-bri-10               = es-solic-mkt.qtd-bri[10]           
           tt-solicitacoes.qtd-bri-11               = es-solic-mkt.qtd-bri[11]           
           tt-solicitacoes.qtd-particip             = es-solic-mkt.qtd-particip          
           tt-solicitacoes.qtd-rem-1                = es-solic-mkt.qtd-rem[1]            
           tt-solicitacoes.qtd-rem-2                = es-solic-mkt.qtd-rem[2]            
           tt-solicitacoes.qtd-rem-3                = es-solic-mkt.qtd-rem[3]            
           tt-solicitacoes.qtd-rem-4                = es-solic-mkt.qtd-rem[4]            
           tt-solicitacoes.remessa-12-meses         = es-solic-mkt.remessa-12-meses      
           tt-solicitacoes.resp-despesas            = es-solic-mkt.resp-despesas
           tt-solicitacoes.nome-resp-desp           = ""
           tt-solicitacoes.segmento                 = es-solic-mkt.segmento              
           tt-solicitacoes.super-resp               = es-solic-mkt.super-resp            
           tt-solicitacoes.usu-aprov-mkt            = es-solic-mkt.usu-aprov-mkt
           tt-solicitacoes.nome-aprov-mkt           = ""
           tt-solicitacoes.val-historico-1          = es-solic-mkt.val-historico[1]      
           tt-solicitacoes.val-historico-2          = es-solic-mkt.val-historico[2]      
           tt-solicitacoes.val-historico-3          = es-solic-mkt.val-historico[3]      
           tt-solicitacoes.vlr-adiantamento         = es-solic-mkt.vlr-adiantamento      
           tt-solicitacoes.vlr-agua                 = es-solic-mkt.vlr-agua              
           tt-solicitacoes.vlr-coffee               = es-solic-mkt.vlr-coffee            
           tt-solicitacoes.vlr-cop                  = es-solic-mkt.vlr-cop               
           tt-solicitacoes.vlr-desloc               = es-solic-mkt.vlr-desloc            
           tt-solicitacoes.vlr-desp-reme            = es-solic-mkt.vlr-desp-reme         
           tt-solicitacoes.vlr-equip                = es-solic-mkt.vlr-equip             
           tt-solicitacoes.vlr-espaco               = es-solic-mkt.vlr-espaco            
           tt-solicitacoes.vlr-estag                = es-solic-mkt.vlr-estag             
           tt-solicitacoes.vlr-garcom               = es-solic-mkt.vlr-garcom            
           tt-solicitacoes.vlr-hospedagem           = es-solic-mkt.vlr-hospedagem        
           tt-solicitacoes.vlr-impress              = es-solic-mkt.vlr-impress           
           tt-solicitacoes.vlr-internet             = es-solic-mkt.vlr-internet          
           tt-solicitacoes.vlr-limpeza              = es-solic-mkt.vlr-limpeza           
           tt-solicitacoes.vlr-liq-rps              = es-solic-mkt.vlr-liq-rps           
           tt-solicitacoes.vlr-orcam-1              = es-solic-mkt.vlr-orcam-1           
           tt-solicitacoes.vlr-orcam-2              = es-solic-mkt.vlr-orcam-2           
           tt-solicitacoes.vlr-orcam-3              = es-solic-mkt.vlr-orcam-3           
           tt-solicitacoes.vlr-promo                = es-solic-mkt.vlr-promo             
           tt-solicitacoes.vlr-recep                = es-solic-mkt.vlr-recep             
           tt-solicitacoes.vlr-refeicao             = es-solic-mkt.vlr-refeicao          
           tt-solicitacoes.vlr-refri                = es-solic-mkt.vlr-refri             
           tt-solicitacoes.vlr-rem-1                = es-solic-mkt.vlr-rem[1]            
           tt-solicitacoes.vlr-rem-2                = es-solic-mkt.vlr-rem[2]            
           tt-solicitacoes.vlr-rem-3                = es-solic-mkt.vlr-rem[3]            
           tt-solicitacoes.vlr-rem-4                = es-solic-mkt.vlr-rem[4]            
           tt-solicitacoes.vlr-salga                = es-solic-mkt.vlr-salga             
           tt-solicitacoes.vlr-seg                  = es-solic-mkt.vlr-seg               
           tt-solicitacoes.vlr-serv                 = es-solic-mkt.vlr-serv              
           tt-solicitacoes.vlr-stand                = es-solic-mkt.vlr-stand             
           tt-solicitacoes.vlr-tel                  = es-solic-mkt.vlr-tel               
           tt-solicitacoes.vol-historico-1          = es-solic-mkt.vol-historico[1]      
           tt-solicitacoes.vol-historico-2          = es-solic-mkt.vol-historico[2]      
           tt-solicitacoes.vol-historico-3          = es-solic-mkt.vol-historico[3]
           tt-solicitacoes.vlr-desp-rem             = es-solic-mkt.vlr-desp-reme.

        FIND FIRST emitente WHERE emitente.cod-emitente = tt-solicitacoes.cod-emitente NO-LOCK NO-ERROR.
        IF AVAIL emitente AND
           emitente.cod-emitente <> 0 THEN
           ASSIGN tt-solicitacoes.descr-emitente = emitente.nome-emit.

        FIND FIRST emitente WHERE emitente.cod-emitente = tt-solicitacoes.cod-emitente-remessa NO-LOCK NO-ERROR.
        IF AVAIL emitente AND
           emitente.cod-emitente <> 0 THEN
           ASSIGN tt-solicitacoes.descr-emit-rem = emitente.nome-emit.

        FIND FIRST es-ev-tipo-verba WHERE es-ev-tipo-verba.tipo-verba = tt-solicitacoes.cod-segmento NO-LOCK NO-ERROR.
        IF AVAIL es-ev-tipo-verba THEN
            ASSIGN tt-solicitacoes.descr-segmento = es-ev-tipo-verba.descricao.

        FIND FIRST usuar_mestre WHERE cod_usuar = tt-solicitacoes.cod-usu-reprova  NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN
            ASSIGN tt-solicitacoes.nome-usu-reprova = usuar_mestre.nom_usuario.

        FIND FIRST usuar_mestre WHERE cod_usuar = tt-solicitacoes.cod-usuario NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN
            ASSIGN tt-solicitacoes.nome-usuario = usuar_mestre.nom_usuario.

        FIND FIRST usuar_mestre WHERE cod_usuar = tt-solicitacoes.usu-aprov-mkt NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN
            ASSIGN tt-solicitacoes.nome-aprov-mkt = usuar_mestre.nom_usuario.

        FIND FIRST ITEM WHERE ITEM.it-codigo = tt-solicitacoes.it-codigo-rem-1 NO-LOCK NO-ERROR.
        IF AVAIL ITEM AND
           ITEM.it-codigo <> "" THEN
            ASSIGN tt-solicitacoes.descr-rem-1 = ITEM.descricao-1.

        FIND FIRST ITEM WHERE ITEM.it-codigo = tt-solicitacoes.it-codigo-rem-2 NO-LOCK NO-ERROR.
        IF AVAIL ITEM AND
           ITEM.it-codigo <> "" THEN
            ASSIGN tt-solicitacoes.descr-rem-2 = ITEM.descricao-1.

        FIND FIRST ITEM WHERE ITEM.it-codigo = tt-solicitacoes.it-codigo-rem-3 NO-LOCK NO-ERROR.
        IF AVAIL ITEM AND
           ITEM.it-codigo <> "" THEN
            ASSIGN tt-solicitacoes.descr-rem-3 = ITEM.descricao-1.

        FIND FIRST ITEM WHERE ITEM.it-codigo = tt-solicitacoes.it-codigo-rem-4 NO-LOCK NO-ERROR.
        IF AVAIL ITEM AND
           ITEM.it-codigo <> "" THEN
            ASSIGN tt-solicitacoes.descr-rem-4 = ITEM.descricao-1.

        FIND FIRST usuar_mestre WHERE cod_usuar = tt-solicitacoes.resp-despesas NO-LOCK NO-ERROR.
        IF AVAIL usuar_mestre THEN
            ASSIGN tt-solicitacoes.nome-resp-desp = usuar_mestre.nom_usuario.

        CASE es-solic-mkt.nivel-hierarquia:
            WHEN 0 THEN
                ASSIGN tt-solicitacoes.desc-hierarquia = "Pendente Supervisor".
            WHEN 1 THEN
                ASSIGN tt-solicitacoes.desc-hierarquia = "Em aprovacao pelo Gerente de Vendas".
            WHEN 2 THEN
                ASSIGN tt-solicitacoes.desc-hierarquia = "Em aprovacao pelo Departamento de Marketing".
            WHEN 3 THEN
                ASSIGN tt-solicitacoes.desc-hierarquia = "Em aprovacao pelo Gerente de Marketing".
            WHEN 4 THEN
                ASSIGN tt-solicitacoes.desc-hierarquia = "Aprovado pelo Gerente de Marketing".
            WHEN 5 THEN
                ASSIGN tt-solicitacoes.desc-hierarquia = "Reprovado".
            WHEN 6 THEN
                ASSIGN tt-solicitacoes.desc-hierarquia = "Aprovado final".
        END CASE.        
                
END.

FOR EACH tt-solicitacoes NO-LOCK:
    PUT tt-solicitacoes.ano-historico-1         ";"       
        tt-solicitacoes.ano-historico-2         ";"
        tt-solicitacoes.ano-historico-3         ";"
        tt-solicitacoes.anos-anter              ";"
        tt-solicitacoes.cod-emitente            ";"
        tt-solicitacoes.descr-emitente          ";"
        tt-solicitacoes.cod-emitente-remessa    ";"
        tt-solicitacoes.descr-emit-rem          ";"
        tt-solicitacoes.cod-evento              ";"
        tt-solicitacoes.cod-segmento            ";"
        tt-solicitacoes.descr-segmento          ";"
        tt-solicitacoes.cod-usu-reprova         ";"
        tt-solicitacoes.nome-usu-reprova        ";"
        tt-solicitacoes.cod-usuario             ";"
        tt-solicitacoes.nome-usuario            ";"
        tt-solicitacoes.desc-despesas           ";"
        tt-solicitacoes.desc-serv               ";"
        tt-solicitacoes.descr-evento            ";"
        tt-solicitacoes.descr-motivo-retorno    ";"
        tt-solicitacoes.dest-material           ";"
        tt-solicitacoes.dest-remessa            ";"
        tt-solicitacoes.dt-aprovacao            ";"
        tt-solicitacoes.dt-criacao              ";"
        tt-solicitacoes.envio-mater-endereco    ";"
        tt-solicitacoes.envio-mater-nome        ";"
        tt-solicitacoes.fim-evento              ";"
        tt-solicitacoes.ini-evento              ";"
        tt-solicitacoes.dias-restantes          ";"
        tt-solicitacoes.it-codigo-bri-1         ";"
        tt-solicitacoes.it-codigo-bri-2         ";"
        tt-solicitacoes.it-codigo-bri-3         ";"
        tt-solicitacoes.it-codigo-bri-4         ";"
        tt-solicitacoes.it-codigo-bri-5         ";"
        tt-solicitacoes.it-codigo-bri-6         ";"
        tt-solicitacoes.it-codigo-bri-7         ";"
        tt-solicitacoes.it-codigo-bri-8         ";"
        tt-solicitacoes.it-codigo-bri-9         ";"
        tt-solicitacoes.it-codigo-bri-10        ";"
        tt-solicitacoes.it-codigo-bri-11        ";"
        tt-solicitacoes.it-codigo-rem-1         ";"
        tt-solicitacoes.descr-rem-1             ";"
        tt-solicitacoes.it-codigo-rem-2         ";"
        tt-solicitacoes.descr-rem-2             ";"
        tt-solicitacoes.it-codigo-rem-3         ";"
        tt-solicitacoes.descr-rem-3             ";"
        tt-solicitacoes.it-codigo-rem-4         ";"
        tt-solicitacoes.descr-rem-4             ";"
        tt-solicitacoes.local-evento            ";"
        tt-solicitacoes.log-cliente             ";"
        tt-solicitacoes.log-palestrante         ";"
        tt-solicitacoes.nivel-hierarquia        ";"
        tt-solicitacoes.desc-hierarquia         ";"
        tt-solicitacoes.nome-ab-reg             ";"
        tt-solicitacoes.nome-cliente-entidade   ";"
        tt-solicitacoes.nome-mic-reg            ";"
        tt-solicitacoes.nome-palestrante        ";"
        tt-solicitacoes.nome-regiao             ";"
        tt-solicitacoes.nr-ordem                ";"
        tt-solicitacoes.nr-seq                  ";"
        tt-solicitacoes.qtd-bri-1               ";"
        tt-solicitacoes.qtd-bri-2               ";"
        tt-solicitacoes.qtd-bri-3               ";"
        tt-solicitacoes.qtd-bri-4               ";"
        tt-solicitacoes.qtd-bri-5               ";"
        tt-solicitacoes.qtd-bri-6               ";"
        tt-solicitacoes.qtd-bri-7               ";"
        tt-solicitacoes.qtd-bri-8               ";"
        tt-solicitacoes.qtd-bri-9               ";"
        tt-solicitacoes.qtd-bri-10              ";"
        tt-solicitacoes.qtd-bri-11              ";"
        tt-solicitacoes.qtd-particip            ";"
        tt-solicitacoes.qtd-rem-1               ";"
        tt-solicitacoes.qtd-rem-2               ";"
        tt-solicitacoes.qtd-rem-3               ";"
        tt-solicitacoes.qtd-rem-4               ";"
        tt-solicitacoes.remessa-12-meses        ";"
        tt-solicitacoes.resp-despesas           ";"
        tt-solicitacoes.nome-resp-desp          ";"
        tt-solicitacoes.super-resp              ";"
        tt-solicitacoes.usu-aprov-mkt           ";"
        tt-solicitacoes.nome-aprov-mkt          ";"
        tt-solicitacoes.val-historico-1         ";"
        tt-solicitacoes.val-historico-2         ";"
        tt-solicitacoes.val-historico-3         ";"
        tt-solicitacoes.vlr-adiantamento        ";"
        tt-solicitacoes.vlr-agua                ";"
        tt-solicitacoes.vlr-coffee              ";"
        tt-solicitacoes.vlr-cop                 ";"
        tt-solicitacoes.vlr-desloc              ";"
        tt-solicitacoes.vlr-desp-reme           ";"
        tt-solicitacoes.vlr-equip               ";"
        tt-solicitacoes.vlr-espaco              ";"
        tt-solicitacoes.vlr-estag               ";"
        tt-solicitacoes.vlr-garcom              ";"
        tt-solicitacoes.vlr-hospedagem          ";"
        tt-solicitacoes.vlr-impress             ";"
        tt-solicitacoes.vlr-internet            ";"
        tt-solicitacoes.vlr-limpeza             ";"
        tt-solicitacoes.vlr-liq-rps             ";"
        tt-solicitacoes.vlr-orcam-1             ";"
        tt-solicitacoes.vlr-orcam-2             ";"
        tt-solicitacoes.vlr-orcam-3             ";"
        tt-solicitacoes.vlr-promo               ";"
        tt-solicitacoes.vlr-recep               ";"
        tt-solicitacoes.vlr-refeicao            ";"
        tt-solicitacoes.vlr-refri               ";"
        tt-solicitacoes.vlr-rem-1               ";"
        tt-solicitacoes.vlr-rem-2               ";"
        tt-solicitacoes.vlr-rem-3               ";"
        tt-solicitacoes.vlr-rem-4               ";"
        tt-solicitacoes.vlr-salga               ";"
        tt-solicitacoes.vlr-seg                 ";"
        tt-solicitacoes.vlr-serv                ";"
        tt-solicitacoes.vlr-stand               ";"
        tt-solicitacoes.vlr-tel                 ";"
        tt-solicitacoes.vol-historico-1         ";"
        tt-solicitacoes.vol-historico-2         ";"
        tt-solicitacoes.vol-historico-3         ";"
        tt-solicitacoes.vlr-desp-rem            SKIP.
                                                
END.                                            
OUTPUT CLOSE.                                   
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
                                                
