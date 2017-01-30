def var i-cod as int.
def var c-desc as char.
    
for each es-sac-emit where nr-atend <= 4123:    
    if int-2    = 0 and
       char-1 = ""  then
        assign i-cod                    = es-sac-emit.cod-area
               c-desc                   = es-sac-emit.desc-area
               es-sac-emit.cod-area     = int-2 
               es-sac-emit.desc-area    = char-1
               int-2                    = i-cod 
               char-1                   = c-desc.           
end.
