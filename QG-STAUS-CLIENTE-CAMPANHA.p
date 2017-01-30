define buffer b-emitente        for emitente.
define buffer b2-emitente       for emitente.
define buffer bf-nota-fiscal    for nota-fiscal.
define buffer bf2-nota-fiscal   for nota-fiscal.

define variable dt-data-fim     as date format 99/99/9999.
define variable dt-inicial      as date format 99/99/9999.
define variable data-ult-ped    as date format 99/99/9999.

def var ano-i   as inte.
def var dat-i   as inte.
def var dat-s   as char.
def var data-entrada as date format 99/99/9999.
def var data-saida   as date format 99/99/9999.

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

define variable i       as inte.
define variable i-ram   as inte.
define variable i-cliente as inte label "Cliente".

update i-cliente dt-data-fim.

find first emitente   where emitente.cod-emitente = i-cliente no-lock no-error.
find first b-emitente where b-emitente.nome-abrev = emitente.nome-matriz no-lock no-error.
if not avail b-emitente then
    find first b-emitente where b-emitente.nome-matriz = emitente.nome-matriz no-lock no-error.

i-ram = random(0, 100000).

for each b2-emitente where b2-emitente.nome-matriz = b-emitente.nome-matriz no-lock.
    
    for each nota-fiscal where nota-fiscal.cod-emitente =   b2-emitente.cod-emitente and
                               nota-fiscal.dt-canc      =   ?                        and
                               nota-fiscal.dt-emis      <=  dt-data-fim
                               break by nota-fiscal.dt-emis.

        find first bf-nota-matriz where (month(bf-nota-matriz.tt-dt-emis) = 02 or
                                         month(bf-nota-matriz.tt-dt-emis) = 03) and
                                         year(bf-nota-matriz.tt-dt-emis) = 2010
                                         no-lock no-error.
            
        if avail bf-nota-matriz and
           (month(nota-fiscal.dt-emis) = 02 or
            month(nota-fiscal.dt-emis) = 03) and
            year(nota-fiscal.dt-emis) = 2010 then next.
        
        create tt-nota-matriz.
        assign tt-nota-matriz.tt-nr-nota    = nota-fiscal.nr-nota-fis
               tt-nota-matriz.tt-dt-emis    = nota-fiscal.dt-emis
               tt-nota-matriz.tt-serie      = nota-fiscal.serie
               tt-nota-matriz.tt-emit       = b-emitente.cod-emitente
               tt-nota-matriz.tt-emit-m     = b2-emitente.cod-emitente
               tt-nota-matriz.i-random      = i-ram
               tt-nota-matriz.tt-hora       = nota-fiscal.hr-confirma.

    end.  
end.    

for each tt-nota-matriz no-lock break by tt-nota-matriz.i-random
                                      by tt-nota-matriz.tt-dt-emis.

    i = i + 1.

    if first-of(tt-nota-matriz.i-random) then
        assign dt-inicial = tt-nota-matriz.tt-dt-emis.

    if not last-of(tt-nota-matriz.i-random) then data-ult-ped = tt-nota-matriz.tt-dt-emis.

    if last-of(tt-nota-matriz.i-random) then do:

        run calcula-6-meses(input tt-nota-matriz.tt-dt-emis,output data-saida).

        find first bf-nota-matriz where bf-nota-matriz.i-random     =   tt-nota-matriz.i-random     and
                                        bf-nota-matriz.tt-dt-emis   >=  data-saida                  and 
                                        bf-nota-matriz.tt-dt-emis   <   tt-nota-matriz.tt-dt-emis 
                                        no-lock no-error.   

        if avail bf-nota-matriz then assign tt-nota-matriz.c-status = "RECOMPRA"
                                            c-status                = "RECOMPRA".
        
        if not avail bf-nota-matriz then do:

            run calcula-6-meses(input tt-nota-matriz.tt-dt-emis,output data-saida).

            FIND last bf-nota-matriz WHERE bf-nota-matriz.i-random   = tt-nota-matriz.i-random
                                       and bf-nota-matriz.tt-dt-emis < data-saida
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
       assign tt-nota-matriz.c-status = "RECUPERADO CICS"
              c-status                = "RECUPERADO CICS"
              data-ult-ped            = ?.

end.

procedure calcula-6-meses:

    define input  parameter dat    as date format 99/99/9999.
    define output parameter dat-sa as date format 99/99/9999.

    dat-s = substr(string(dat),4,2).

    dat-i = int(dat-s).
    
    if dat-i >= 7 then dat-i = dat-i - 6.
    else
        if dat-i <= 6 then
            assign dat-i = dat-i + 12
                   dat-i = dat-i - 6.
    
    dat-s = string(dat,"99/99/9999").
    
    substr(dat-s,4,2) = string(dat-i,"99").
    
    if (substr(dat-s,4,2) = "04" or 
       substr(dat-s,4,2) = "06" or
       substr(dat-s,4,2) = "09" or
       substr(dat-s,4,2) = "11") and
       substr(dat-s,1,2) = "31" then substr(dat-s,1,2) = "30".
    
    IF substr(dat-s,4,2) = "02" then do:
        /* Se ano for bisexto */
        IF  inte(substr(dat-s,7,4)) MOD 4 = 0 AND
            inte(substr(dat-s,7,4)) MOD 100 <> 0 then do:
    
            if substr(dat-s,1,2) = "31" or
               substr(dat-s,1,2) = "30" then substr(dat-s,1,2) = "29".
            
        end.
        else
            if substr(dat-s,1,2) = "31" or
               substr(dat-s,1,2) = "30" or
               substr(dat-s,1,2) = "29" then substr(dat-s,1,2) = "28".
                    
    end.
    
    if inte(substr(string(dat),4,2)) <= 6 then do:
        assign ano-i = inte(substr(dat-s,7,4))
               ano-i = ano-i - 1
               substr(dat-s,7,4) = string(ano-i).        
    end.

    dat-sa = date(dat-s).

end.
