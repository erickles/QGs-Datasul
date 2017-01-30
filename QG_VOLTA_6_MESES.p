def var dat-i   as inte.
def var ano-i   as inte.
def var dat-s   as char.
def var data-saida   as date format 99/99/9999.

def var data-entrada as date format 99/99/9999.

update data-entrada.

run calcula-6-meses(input data-entrada,
                    output data-saida).

disp data-saida.

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
