{include/i-freeac.i}
define variable kg-total as decimal no-undo.
define variable familia  as char    no-undo.

for each es-repres-comis where es-repres-comis.dt-inicio < 02/01/2010       and
                               (trim(es-repres-comis.u-char-2) = "PROMOTOR" and
                                es-repres-comis.u-int-1        = 1        ) or
                               (es-repres-comis.log-1                       and
                                es-repres-comis.u-char-2      = "NUTRI€ÇO") 
                                no-lock:

    for each nota-fiscal where nota-fiscal.dt-canc      =   ?                       and
                               nota-fiscal.dt-emis      >=  02/01/2010              and
                               nota-fiscal.dt-emis      <=  03/31/2010              and
                               nota-fiscal.cod-rep      =   es-repres-comis.cod-rep no-lock:

        kg-total = 0.

        for each it-nota-fisc of nota-fiscal no-lock:
            find first item of it-nota-fisc no-lock no-error.
            if item.fm-codigo = "EQUINOS"   or
               item.fm-codigo = "CAPRINOS"  or
               item.fm-codigo = "OVINOS"    then
                familia = "ECO".
            else do:
                familia = "NUTRICAO".
                leave.
                 end.
        end.

        for each it-nota-fisc of nota-fiscal:
            kg-total = kg-total + it-nota-fisc.qt-faturada[1].
        end.

        if familia = "NUTRICAO" and 
           kg-total < 1250      then next.

        if familia = "ECO" and 
           kg-total < 500  then next.

        for each it-nota-fisc of nota-fiscal no-lock:
            find first item of it-nota-fisc no-lock no-error.
            if item.ge-codigo <> 44 then next.

            find first emitente of nota-fiscal no-lock no-error.
            find first repres     where repres.cod-rep       = es-repres-comis.cod-rep no-lock no-error.
            find first ws-p-venda where ws-p-venda.nr-pedcli = nota-fiscal.nr-pedcli no-lock no-error.
            FIND FIRST regiao     WHERE regiao.nome-ab-reg   = repres.nome-ab-reg NO-LOCK NO-ERROR.

            
            disp nota-fiscal.cod-emitente
                 nota-fiscal.nr-nota-fis
                 emitente.nome-emit
                 repres.nome
                 emitente.endereco
                 emitente.bairro
                 emitente.cidade
                 emitente.estado
                 emitente.cep
                 familia    
                 nota-fiscal.nr-pedcli                            
                 ws-p-venda.dt-impl
                 nota-fiscal.dt-emis                              
                 it-nota-fisc.qt-faturada[1]                      
                 item.descricao-1
                 repres.nome
                 trim(es-repres-comis.u-char-2) label "Linha"
                 item.fm-codigo
                 fn-free-accent(regiao.nome-regiao) format "x(40)" label "Gerencia"
                 fn-free-accent(repres.nome-ab-reg) format "x(20)" label "Supervisao"
                 with 1 col.

        end.
        
    end.
end.
