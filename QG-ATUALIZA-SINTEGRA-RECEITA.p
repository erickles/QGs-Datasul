def var c-data              as char format "x(08)"              no-undo.
def var c-situacao          as char format "x(100)"             no-undo.
def var c-numero            as char init "1,2,3,4,5,6,7,8,9,0"  no-undo.
def var c-ins-estadual      as char                             no-undo.
def var c-razao-social      as char format "x(100)"             no-undo.
DEF VAR c-status            AS CHAR FORMAT "x(1)"               NO-UNDO.

def stream s-arq.
def stream s-cpf.
def stream s-cgc.
def var i-cont              as inte                             no-undo.

FUNCTION cv-texto returns character
(input c-texto as char):
    return codepage-convert(c-texto, session:charset,"IBM850").
end function.

        
for each emitente where cod-emitente = 7191 break by emitente.estado:
        
        if first-of(emitente.estado) then
            output stream s-arq to value("C:\" + trim(emitente.estado) + ".txt").
    
        assign c-data     = "" 
               c-situacao = "". 
    
        assign c-ins-estadual = "".
        do i-cont = 1 to length(emitente.ins-estadual):
            assign c-ins-estadual = c-ins-estadual + if lookup(substr(emitente.ins-estadual,i-cont,1),c-numero) = 0 then "" else substr(emitente.ins-estadual,i-cont,1).
        end.
    
        assign c-razao-social = emitente.nome-emit
               c-status       = "".

        put stream s-arq
            string(emitente.cod-emitente)                   format "x(08)"
            emitente.estado                                 format "x(02)"
            if emitente.natureza = 1 then "F"
                                     else "J"               format "x(01)"
            emitente.cgc                                    format "x(15)"
            c-ins-estadual                                  format "x(15)"
            c-situacao                                      format "x(01)"
            c-data                                          format "x(08)"
            ("00" + string(emitente.cep))                   format "x(10)"
            cv-texto(c-razao-social)                        format "x(100)"
            c-status                                        format "x(01)"
            skip.
    
        if last-of(emitente.estado) then
            output stream s-arq close.
    end.
