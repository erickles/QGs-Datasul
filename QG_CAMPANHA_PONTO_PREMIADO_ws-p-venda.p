{include/i-freeac.i}
define variable kg-total as decimal no-undo.
define variable familia  as char    no-undo.
define variable c-status as char    no-undo.

define buffer b-emitente        for emitente.
define buffer b2-emitente       for emitente.
define buffer bf-nota-fiscal    for nota-fiscal.
define buffer bf2-nota-fiscal   for nota-fiscal.
define buffer bf3-nota-fiscal   for nota-fiscal.

DEFINE VARIABLE c-var                   AS CHARACTER FORMAT "x(40)" NO-UNDO. 


define variable dt-data-fim             as date format 99/99/9999.
define variable dt-inicial              as date format 99/99/9999.
define variable i                       as inte.
define variable i-ram                   as inte.



define temp-table tt-campanha
    field cod-emit      as inte
    field razao-emit    as char
    field repre-pro     as char
    field endereco      as char
    field bairro        as char
    field cidade        as char
    field estado        as char
    field cep           as char
    field situacao      as char
    field fam-comerc    as char
    field nr-pedcli     as char
    field dt-impl-ped   as date
    field dt-fat-ped    as date
    field qt-pedido     as deci
    field desc-item     as char
    field gerencia      as char
    field supervisao    as char
    field nome-rep      as char
    field atuacao       as char.

def temp-table tt-nota-matriz
    field tt-nr-nota like nota-fiscal.nr-nota-fis
    field tt-dt-emis like nota-fiscal.dt-emis
    field tt-serie   like nota-fiscal.serie
    field tt-hora    like nota-fiscal.hr-confirma
    field tt-emit    like nota-fiscal.cod-emitente
    field tt-emit-m  like nota-fiscal.cod-emitente
    field i-random   as integer
    field c-status   as char.

define buffer bf-nota-matriz    for tt-nota-matriz.
define buffer bf2-nota-matriz   for tt-nota-matriz.
define buffer bf-item           for item.
define var l-sai as logical.


for each ws-p-venda where ws-p-venda.dt-impl        >=  02/01/2010              and
                          ws-p-venda.dt-impl        <=  03/31/2010              and
                          ws-p-venda.dt-cancel      =  ?                        and
                          ws-p-venda.ind-sit-ped    =   17                      
                          no-lock:

    find first es-repres-comis where es-repres-comis.dt-inicio < 02/01/2010          and
                                     (trim(es-repres-comis.u-char-2) = "PROMOTOR"    and
                                     es-repres-comis.u-int-1        = 1        )     or
                                     (es-repres-comis.log-1                          and
                                     es-repres-comis.u-char-2      = "NUTRI€ÇO")     and
                                     es-repres-comis.cod-rep     = ws-p-venda.cod-rep
                                     no-lock no-error.

    if not avail es-repres-comis then next.
        
    find first ws-p-item of ws-p-venda no-lock no-error.
    if avail ws-p-item then
        find first bf-item where bf-item.it-codigo = ws-p-item.it-codigo and
                                 bf-item.ge-codigo <> 44
                                 no-lock no-error.

        if avail bf-item then next.

    assign kg-total = 0
           c-status = "".

    for each ws-p-item of ws-p-venda no-lock:
        find first item where item.it-codigo = ws-p-item.it-codigo no-lock no-error.
        if item.fm-codigo = "EQUINOS"   or
           item.fm-codigo = "CAPRINOS"  or
           item.fm-codigo = "OVINOS"    then
            familia = "ECO".
        else do:
            familia = "NUTRICAO".
            leave.
             end.
    end.

    for each ws-p-item of ws-p-venda:
        kg-total = kg-total + ws-p-item.qt-pedida.
    end.

    if familia = "NUTRICAO" and
       kg-total < 1250      then next.

    if familia = "ECO" and
       kg-total < 500  then next.

    find first emitente where emitente.cod-emitente = inte(ws-p-venda.nome-abrev) no-lock no-error.

    run status-cliente.
            
    for each ws-p-item of ws-p-venda no-lock:

        find first item where item.it-codigo = ws-p-item.it-codigo no-lock no-error.
        find first emitente where inte(ws-p-venda.nome-abrev)   = emitente.cod-emitente no-lock no-error.
        find first repres   where repres.cod-rep                = es-repres-comis.cod-rep no-lock no-error.
        FIND FIRST regiao   WHERE regiao.nome-ab-reg            = repres.nome-ab-reg NO-LOCK NO-ERROR.
        find last tt-nota-matriz no-lock no-error.

        if c-status = "RECOMPRA" THEN NEXT.

        disp ws-p-venda.nome-abrev
             emitente.nome-emit
             repres.nome
             emitente.endereco
             emitente.bairro
             emitente.cidade
             emitente.estado
             emitente.cep
             familia
             ws-p-venda.nr-pedcli
             ws-p-venda.dt-impl
             ws-p-item.qt-atendida
             item.descricao-1
             repres.nome
             trim(es-repres-comis.u-char-2) label "Linha"
             item.fm-codigo
             fn-free-accent(regiao.nome-regiao) format "x(40)" label "Gerencia"
             fn-free-accent(repres.nome-ab-reg) format "x(20)" label "Supervisao"
             c-status
             ws-p-venda.ind-sit-ped
             with 1 col.

    end.

    for each tt-nota-matriz:
        delete tt-nota-matriz.
    end.
end.       

procedure status-cliente:

    /* L¢gica de status cliente */
    find first b-emitente where b-emitente.nome-abrev = emitente.nome-matriz        no-lock no-error.
    i-ram = random(0, 100000).

    for each b2-emitente where b2-emitente.nome-matriz = b-emitente.nome-matriz no-lock.

        for each bf3-nota-fiscal where bf3-nota-fiscal.cod-emitente =   b2-emitente.cod-emitente and
                                       bf3-nota-fiscal.dt-canc      =   ?                        and
                                       bf3-nota-fiscal.dt-emis      <=  03/31/2010
                                       break by bf3-nota-fiscal.dt-emis.

            create tt-nota-matriz.
            assign tt-nota-matriz.tt-nr-nota    = bf3-nota-fiscal.nr-nota-fis
                   tt-nota-matriz.tt-dt-emis    = bf3-nota-fiscal.dt-emis
                   tt-nota-matriz.tt-serie      = bf3-nota-fiscal.serie
                   tt-nota-matriz.tt-emit       = b-emitente.cod-emitente
                   tt-nota-matriz.tt-emit-m     = b2-emitente.cod-emitente
                   tt-nota-matriz.i-random      = i-ram
                   tt-nota-matriz.tt-hora       = bf3-nota-fiscal.hr-confirma.

        end.  
    end. 

    for each tt-nota-matriz no-lock break by tt-nota-matriz.i-random
                                          by tt-nota-matriz.tt-dt-emis.

        i = i + 1.

        if first-of(tt-nota-matriz.i-random) then
            assign dt-inicial = tt-nota-matriz.tt-dt-emis.

        if last-of(tt-nota-matriz.i-random) then do:
    
            find first bf-nota-matriz where bf-nota-matriz.i-random     =   tt-nota-matriz.i-random             and
                                            bf-nota-matriz.tt-dt-emis   >=  (tt-nota-matriz.tt-dt-emis - 180)   and 
                                            bf-nota-matriz.tt-dt-emis   <   tt-nota-matriz.tt-dt-emis 
                                            no-lock no-error.   

            if avail bf-nota-matriz then assign tt-nota-matriz.c-status = "RECOMPRA"
                                                c-status                = "RECOMPRA".
            
            if not avail bf-nota-matriz then do:
                FIND last bf-nota-matriz WHERE bf-nota-matriz.i-random   = tt-nota-matriz.i-random
                                           and bf-nota-matriz.tt-dt-emis < (tt-nota-matriz.tt-dt-emis - 180)
                                           NO-LOCK NO-ERROR.

                if avail bf-nota-matriz then assign tt-nota-matriz.c-status = "RECUPERADO"
                                                    c-status                = "RECUPERADO".
            end.

            if i = 1 then assign tt-nota-matriz.c-status = "NOVO CLIENTE"
                                 c-status                = "NOVO CLIENTE".
    
            if tt-nota-matriz.c-status = "" or
               tt-nota-matriz.c-status = ? then do:

                for each bf-nota-matriz where bf-nota-matriz.c-status = "" or
                                              bf-nota-matriz.c-status = ?
                                              no-lock break by bf-nota-matriz.i-random
                                                            by bf-nota-matriz.tt-dt-emis.
    
                    i = i + 1.                
    
                    find first bf2-nota-matriz where bf2-nota-matriz.i-random   =   bf-nota-matriz.i-random     and
                                                     bf2-nota-matriz.tt-dt-emis =   bf-nota-matriz.tt-dt-emis   and
                                                     bf2-nota-matriz.tt-hora    <   bf-nota-matriz.tt-hora
                                                     no-lock no-error.
    
                    if avail bf2-nota-matriz then assign bf-nota-matriz.c-status = "RECOMPRA"
                                                         c-status                = "RECOMPRA".
    
                    else assign bf-nota-matriz.c-status = "NOVO CLIENTE"
                                c-status                = "NOVO CLIENTE".
    
                end.
    
            end.

            if tt-nota-matriz.c-status = "RECOMPRA" then do:
                if (month(dt-inicial) = month(tt-nota-matriz.tt-dt-emis) and
                    year(dt-inicial)  = year(tt-nota-matriz.tt-dt-emis)) then
                    assign tt-nota-matriz.c-status = "NOVO CLIENTE"
                           c-status                = "NOVO CLIENTE".
            end.                

        end.

        if tt-nota-matriz.c-status = "NOVO CLIENTE" AND
           (tt-nota-matriz.tt-emit < 70000          OR 
           (tt-nota-matriz.tt-emit >= 90000         AND
           tt-nota-matriz.tt-emit <= 100000))      THEN
           assign tt-nota-matriz.c-status = "RECUPERADO"
                  c-status                = "RECUPERADO".
    
    end.

    /* Fim da l¢gica de status cliente */

end procedure.
