/* Menu */
DEFINE VARIABLE cTargetType AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lFormatted  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK      AS LOGICAL   NO-UNDO.

DEFINE VARIABLE cTargetType2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cContent     AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE lFormatted2  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lRetOK2      AS LOGICAL   NO-UNDO.

DEFINE TEMP-TABLE tt-menu NO-UNDO
    FIELD idx         AS INTE
    FIELD name          AS CHAR    
    FIELD hasDetails    AS LOGICAL
    FIELD url           AS CHAR
    FIELD menuOption    AS LOGICAL.

DEFINE TEMP-TABLE tt-sub-menu NO-UNDO
    FIELD idx           AS INTE
    FIELD menuIdx       AS INTE
    FIELD name          AS CHAR    
    FIELD hasDetails    AS LOGICAL
    FIELD url           AS CHAR
    FIELD menuOption    AS LOGICAL.

DEFINE TEMP-TABLE tt-option NO-UNDO
    FIELD idx           AS INTE
    FIELD submenuUrl    AS CHAR
    FIELD name          AS CHAR
    FIELD url           AS CHAR.

DEFINE TEMP-TABLE Menu      NO-UNDO LIKE tt-menu.
DEFINE TEMP-TABLE SubMenu   NO-UNDO LIKE tt-sub-menu.
DEFINE TEMP-TABLE Options   NO-UNDO LIKE tt-option.

DEFINE DATASET Menus FOR Menu, SubMenu, Options
DATA-RELATION sMenu FOR Menu, SubMenu RELATION-FIELDS(idx,menuIdx) NESTED
DATA-RELATION sOptions FOR SubMenu, Options RELATION-FIELDS(url,submenuUrl) NESTED.

DEFINE DATA-SOURCE dsMenu       FOR tt-menu.
DEFINE DATA-SOURCE dsSubMenu    FOR tt-sub-menu.
DEFINE DATA-SOURCE dsOptions    FOR tt-option.

BUFFER Menu:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsMenu:HANDLE).
BUFFER SubMenu:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsSubMenu:HANDLE).
BUFFER Options:HANDLE:ATTACH-DATA-SOURCE(DATA-SOURCE dsOptions:HANDLE).

    CREATE tt-menu.
    ASSIGN tt-menu.idx          = 1
           tt-menu.name         = 'Inicio'
           tt-menu.hasDetails   = NO
           tt-menu.url          = '/'
           tt-menu.menuOption   = NO.

    CREATE tt-menu.
    ASSIGN tt-menu.idx          = 2
           tt-menu.name         = 'Perfil'
           tt-menu.hasDetails   = NO
           tt-menu.url          = 'profile'
           tt-menu.menuOption   = NO.

    CREATE tt-menu.
    ASSIGN tt-menu.idx          = 3
           tt-menu.name         = 'Processos'
           tt-menu.hasDetails   = YES
           tt-menu.url          = 'processes'
           tt-menu.menuOption   = NO.

    /* Criando os sub menus da parte de processos */
    CREATE tt-sub-menu.
    ASSIGN tt-sub-menu.idx          = 1
           tt-sub-menu.menuIdx      = tt-menu.idx
           tt-sub-menu.name         = 'Pedido de Venda'
           tt-sub-menu.hasDetails   = YES
           tt-sub-menu.url          = 'order'
           tt-sub-menu.menuOption   = YES.

    /* Criando as opcoes do submenu de pedido de venda */
    CREATE tt-option.
    ASSIGN tt-option.idx          = 1
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Cliente'
           tt-option.url          = 'customer'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 2
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Produtos'
           tt-option.url          = 'products'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 3
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Instrucoes a vendas'
           tt-option.url          = 'salesInstructions'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 4
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Instrucoes a logistica'
           tt-option.url          = 'logisticInstructions'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 5
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Frete'
           tt-option.url          = 'freight'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 6
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Descontos'
           tt-option.url          = 'discounts'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 7
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Condi‡Æo de pagamento'
           tt-option.url          = 'payments'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 8
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Condi‡Æo VV/Consulta'
           tt-option.url          = 'vvCondition'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 9
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Resumo do pedido'
           tt-option.url          = 'summary'.
    /* Criando as opcoes do submenu de pedido de venda */
    
    CREATE tt-sub-menu.
    ASSIGN tt-sub-menu.idx          = 2
           tt-sub-menu.menuIdx      = tt-menu.idx
           tt-sub-menu.name         = 'Ficha de cliente'
           tt-sub-menu.hasDetails   = YES
           tt-sub-menu.url          = 'customerInsertion'
           tt-sub-menu.menuOption   = YES.

    /* Criando as opcoes do submenu de ficha de cliente */
    CREATE tt-option.
    ASSIGN tt-option.idx          = 1
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Principal'
           tt-option.url          = 'basic'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 2
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Enderecos'
           tt-option.url          = 'adresses'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 3
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Comercial'
           tt-option.url          = 'commercial'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 4
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Plantel'
           tt-option.url          = 'breeding'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 5
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Referencia'
           tt-option.url          = 'reference'.

    CREATE tt-option.
    ASSIGN tt-option.idx          = 6
           tt-option.submenuUrl   = tt-sub-menu.url
           tt-option.name         = 'Documenta‡Æo'
           tt-option.url          = 'documents'.

    /* Criando as opcoes do submenu de ficha de cliente */
    
    CREATE tt-sub-menu.
    ASSIGN tt-sub-menu.idx          = 3
           tt-sub-menu.menuIdx      = tt-menu.idx
           tt-sub-menu.name         = 'Manuten‡Æo de consulta'
           tt-sub-menu.hasDetails   = NO
           tt-sub-menu.url          = 'maintenanceConsult'
           tt-sub-menu.menuOption   = NO.

    /* Criando os sub menus da parte de processos */

    CREATE tt-menu.
    ASSIGN tt-menu.idx          = 4
           tt-menu.name         = 'Consultas'
           tt-menu.hasDetails   = YES
           tt-menu.url          = 'reports'
           tt-menu.menuOption   = NO.

    /* Criando os sub menus da parte de consultas */
    CREATE tt-sub-menu.
    ASSIGN tt-sub-menu.idx          = 1
           tt-sub-menu.menuIdx      = tt-menu.idx
           tt-sub-menu.name         = 'Comissäes'
           tt-sub-menu.hasDetails   = NO
           tt-sub-menu.url          = 'comission'
           tt-sub-menu.menuOption   = NO.
    
    CREATE tt-sub-menu.
    ASSIGN tt-sub-menu.idx          = 2
           tt-sub-menu.menuIdx      = tt-menu.idx
           tt-sub-menu.name         = 'Titulos/Boletos'
           tt-sub-menu.hasDetails   = NO
           tt-sub-menu.url          = 'bankslips'
           tt-sub-menu.menuOption   = NO.
    
    CREATE tt-sub-menu.
    ASSIGN tt-sub-menu.idx          = 3
           tt-sub-menu.menuIdx      = tt-menu.idx
           tt-sub-menu.name         = 'Clientes'
           tt-sub-menu.hasDetails   = NO
           tt-sub-menu.url          = 'customers'
           tt-sub-menu.menuOption   = NO.

    /* Criando os sub menus da parte de consultas */

    DATASET Menus:FILL().

    ASSIGN cTargetType = "file"   
           cFile       = "C:\Temp\menu.json"
           lFormatted  = TRUE.

    lRetOK = DATASET Menus:WRITE-JSON(cTargetType, cFile, lFormatted).
