/*Diogo Arado
  24/08/2010
  Lê hora de atualiza‡Æo das notas fiscais no Datasul EMS 204*/

define temp-table tt-nota-fiscal-sumarizada
    field data        like ret-nf-eletro.dat-ret
    field periodo     as char /*horario da autorizacao da nota-fiscal*/
    field qtd-notas   as int
    FIELD tipo-oper   AS INT
    field tempo-resposta as int. /*1-Venda;2-Transferencia*/

define temp-table tt-tempo-resposta
    field nr-nota-fis like nota-fiscal.nr-nota-fis
    field tempo-resposta as int
    field periodo     as char /*horario da autorizacao da nota-fiscal*/ 
    field data        like ret-nf-eletro.dat-ret.

define variable c-tipo-operacao as char extent INitial ["Venda","Transferˆncia"].

DEFIne variable i-hora-retorno         as int no-undo.
define variable i-hora-atualizacao     as int no-undo.

define variable c-aux-hora-retorno     as char no-undo.
define variable c-aux-hora-atualizacao as char no-undo.

define stream str-periodo.
define stream str-qtd.

define variable i-qtd-notas-periodo as int EXTENT 16.

function periodo returns CHAR (input param1 as char):

    if substring(param1,1,2) = "00" or substring(param1,1,2) = "01" then param1 = "00:00 …s 01:59". 
    if substring(param1,1,2) = "02" or substring(param1,1,2) = "03" then param1 = "02:00 …s 03:59". 
    if substring(param1,1,2) = "04" or substring(param1,1,2) = "05" then param1 = "04:00 …s 05:59". 
    if substring(param1,1,2) = "06" or substring(param1,1,2) = "07" then param1 = "06:00 …s 07:59". 
    if substring(param1,1,2) = "08" or substring(param1,1,2) = "09" then param1 = "08:00 …s 09:59". 
    if substring(param1,1,2) = "10" or substring(param1,1,2) = "11" then param1 = "10:00 …s 11:59". 
    if substring(param1,1,2) = "12" or substring(param1,1,2) = "13" then param1 = "12:00 …s 13:59". 
    if substring(param1,1,2) = "14" or substring(param1,1,2) = "15" then param1 = "14:00 …s 15:59". 
    if substring(param1,1,2) = "16" or substring(param1,1,2) = "17" then param1 = "16:00 …s 17:59". 
    if substring(param1,1,2) = "18" or substring(param1,1,2) = "19" then param1 = "18:00 …s 19:59". 
    if substring(param1,1,2) = "20" or substring(param1,1,2) = "21" then param1 = "20:00 …s 21:59". 
    if substring(param1,1,2) = "22" or substring(param1,1,2) = "23" then param1 = "22:00 …s 23:59".

    return param1.

end function.

for each nota-fiscal no-lock
    where nota-fiscal.cod-estabel = "19"
      and nota-fiscal.serie       = "4"
      and nota-fiscal.dt-emis     >= 08/01/2010:

    /*busca natureza de opera‡Æo*/
    FIND natur-oper OF nota-fiscal NO-LOCK NO-ERROR.

    /*nota fiscal de venda*/
    IF nota-fiscal.emite-duplic = yes THEN do:
        find first tt-nota-fiscal-sumarizada where tt-nota-fiscal-sumarizada.tipo-oper = 1
                                    and tt-nota-fiscal-sumarizada.data      = nota-fiscal.dt-emis 
                                    and tt-nota-fiscal-sumarizada.periodo   = periodo(nota-fiscal.hr-atualiza) no-lock no-error.    
        if not avail tt-nota-fiscal-sumarizada then do:
            create tt-nota-fiscal-sumarizada.
            assign tt-nota-fiscal-sumarizada.tipo-oper = 1
                   tt-nota-fiscal-sumarizada.data      = nota-fiscal.dt-emis  
                   tt-nota-fiscal-sumarizada.periodo   = periodo(nota-fiscal.hr-atualiza).
        end.
        assign tt-nota-fiscal-sumarizada.qtd-notas = tt-nota-fiscal-sumarizada.qtd-notas + 1.
    end. /*nota fiscal de transferencia*/
    else IF natur-oper.transf = yes THEN do:
        find first tt-nota-fiscal-sumarizada where tt-nota-fiscal-sumarizada.tipo-oper = 2
                                    and tt-nota-fiscal-sumarizada.data      = nota-fiscal.dt-emis 
                                    and tt-nota-fiscal-sumarizada.periodo   = periodo(nota-fiscal.hr-atualiza) no-lock no-error.    
        if not avail tt-nota-fiscal-sumarizada then do:
            create tt-nota-fiscal-sumarizada.
            assign tt-nota-fiscal-sumarizada.tipo-oper = 2
                   tt-nota-fiscal-sumarizada.data      = nota-fiscal.dt-emis  
                   tt-nota-fiscal-sumarizada.periodo   = periodo(nota-fiscal.hr-atualiza).
        end.
        assign tt-nota-fiscal-sumarizada.qtd-notas = tt-nota-fiscal-sumarizada.qtd-notas + 1.
    end.

    IF nota-fiscal.emite-duplic = yes or natur-oper.transf = yes then do:
        FOR LAST ret-nf-eletro NO-LOCK
            WHERE ret-nf-eletro.cod-estabel = nota-fiscal.cod-estabel
              AND ret-nf-eletro.cod-serie   = nota-fiscal.serie      
              AND ret-nf-eletro.nr-nota-fis = nota-fiscal.nr-nota-fis
              and ret-nf-eletro.dat-ret     = nota-fiscal.dt-emis
              and int(ret-nf-eletro.idi-orig-solicit) = 1
              USE-INDEX rtnfltr-id:
    
             c-aux-hora-retorno = STRING(ret-nf-eletro.hra-ret,"xx:xx:xx").
             i-hora-retorno = ( int(entry(1,c-aux-hora-retorno,":")) * 60) + int(entry(2,c-aux-hora-retorno,":")). 
    
             c-aux-hora-atualizacao = STRING(nota-fiscal.hr-atualiza,"xxxxx").
             i-hora-atualizacao = (int(substring(c-aux-hora-atualizacao,1,2)) * 60) + int(substring(c-aux-hora-atualizacao,4,2)).
    
             find first tt-tempo-resposta where tt-tempo-resposta.nr-nota-fis = nota-fiscal.nr-nota-fis no-lock no-error.
             if not avail tt-tempo-resposta then do:
                 create tt-tempo-resposta.
                 assign tt-tempo-resposta.nr-nota-fis    = nota-fiscal.nr-nota-fis
                        tt-tempo-resposta.tempo-resposta = i-hora-retorno - i-hora-atualizacao
                        tt-tempo-resposta.periodo        = periodo(nota-fiscal.hr-atualiza)
                        tt-tempo-resposta.data           = nota-fiscal.dt-emis.
             end.
             
             /*if i-hora-retorno < i-hora-atualizacao then assign tt-nota-fiscal-sumarizada.tempo-resposta = 0.
             else assign tt-nota-fiscal-sumarizada.tempo-resposta = tt-nota-fiscal-sumarizada.tempo-resposta + (i-hora-retorno - i-hora-atualizacao).*/
             
        END.
    end.    
END.

output stream str-periodo to c:\lista-notas.csv no-convert.
for each tt-nota-fiscal-sumarizada no-lock
    break by tt-nota-fiscal-sumarizada.data
          by tt-nota-fiscal-sumarizada.periodo:

    put stream str-periodo unformatted c-tipo-operacao[tt-nota-fiscal-sumarizada.tipo-oper] ";" tt-nota-fiscal-sumarizada.data ";" tt-nota-fiscal-sumarizada.periodo ";" tt-nota-fiscal-sumarizada.qtd-notas ";" round((tt-nota-fiscal-sumarizada.tempo-resposta / tt-nota-fiscal-sumarizada.qtd-notas),2) skip.
    if last-of(tt-nota-fiscal-sumarizada.data) THEN put "-----------;-----------;-----------;-----------;-----------" skip.
end.
output stream str-periodo close.

output stream str-qtd to c:\lista-notas-tempo.csv no-convert.
for each tt-tempo-resposta no-lock 
    break by tt-tempo-resposta.tempo-resposta:

    if tt-tempo-resposta.tempo-resposta <= 1 then i-qtd-notas-periodo[1] = i-qtd-notas-periodo[1] + 1.
    else if tt-tempo-resposta.tempo-resposta = 2 then i-qtd-notas-periodo[2] = i-qtd-notas-periodo[2] + 1.
    else if tt-tempo-resposta.tempo-resposta = 3 then i-qtd-notas-periodo[3] = i-qtd-notas-periodo[3] + 1.
    else if tt-tempo-resposta.tempo-resposta = 4 then i-qtd-notas-periodo[4] = i-qtd-notas-periodo[4] + 1.
    else if tt-tempo-resposta.tempo-resposta = 5 then i-qtd-notas-periodo[5] = i-qtd-notas-periodo[5] + 1.
    else if tt-tempo-resposta.tempo-resposta = 6 then i-qtd-notas-periodo[6] = i-qtd-notas-periodo[6] + 1.
    else if tt-tempo-resposta.tempo-resposta = 7 then i-qtd-notas-periodo[7] = i-qtd-notas-periodo[7] + 1.
    else if tt-tempo-resposta.tempo-resposta = 8 then i-qtd-notas-periodo[8] = i-qtd-notas-periodo[8] + 1.
    else if tt-tempo-resposta.tempo-resposta = 9 then i-qtd-notas-periodo[9] = i-qtd-notas-periodo[9] + 1.
    else if tt-tempo-resposta.tempo-resposta = 10 then i-qtd-notas-periodo[10] = i-qtd-notas-periodo[10] + 1.
    else if tt-tempo-resposta.tempo-resposta > 10 and tt-tempo-resposta.tempo-resposta <= 20 then i-qtd-notas-periodo[11] = i-qtd-notas-periodo[11] + 1.
    else if tt-tempo-resposta.tempo-resposta > 20 and tt-tempo-resposta.tempo-resposta <= 30 then i-qtd-notas-periodo[12] = i-qtd-notas-periodo[12] + 1.
    else if tt-tempo-resposta.tempo-resposta > 30 and tt-tempo-resposta.tempo-resposta <= 40 then i-qtd-notas-periodo[13] = i-qtd-notas-periodo[15] + 1.
    else if tt-tempo-resposta.tempo-resposta > 40 and tt-tempo-resposta.tempo-resposta <= 50 then i-qtd-notas-periodo[14] = i-qtd-notas-periodo[14] + 1.
    else if tt-tempo-resposta.tempo-resposta > 40 and tt-tempo-resposta.tempo-resposta <= 50 then i-qtd-notas-periodo[15] = i-qtd-notas-periodo[15] + 1.
    else if tt-tempo-resposta.tempo-resposta > 50 and tt-tempo-resposta.tempo-resposta <= 60 then i-qtd-notas-periodo[15] = i-qtd-notas-periodo[15] + 1.
    else i-qtd-notas-periodo[16] = i-qtd-notas-periodo[16] + 1

    /*put stream str-qtd unformatted tt-tempo-resposta.nr-nota-fis ";" tt-tempo-resposta.tempo-resposta ";" tt-tempo-resposta.periodo ";" tt-tempo-resposta.data skip*/.
end.

put stream str-qtd unformatted
    "At‚ 1 min:;" i-qtd-notas-periodo[1] skip
    "At‚ 2 min:;" i-qtd-notas-periodo[2] skip
    "At‚ 3 min:;" i-qtd-notas-periodo[3] skip
    "At‚ 4 min:;" i-qtd-notas-periodo[4] skip
    "At‚ 5 min:;" i-qtd-notas-periodo[5] skip
    "At‚ 6 min:;" i-qtd-notas-periodo[6] skip
    "At‚ 7 min:;" i-qtd-notas-periodo[7] skip
    "At‚ 8 min:;" i-qtd-notas-periodo[8] skip
    "At‚ 9 min:;" i-qtd-notas-periodo[9] skip
    "At‚ 10 min:;" i-qtd-notas-periodo[10] skip
    "Entre 10min e 20min:;" i-qtd-notas-periodo[11] skip
    "Entre 20min e 30min:;" i-qtd-notas-periodo[12] skip
    "Entre 30min e 40min:;" i-qtd-notas-periodo[13] skip
    "Entre 40min e 50min:;" i-qtd-notas-periodo[14] skip
    "Entre 50min e 60min:;" i-qtd-notas-periodo[15] skip
    "Mais de 60min:;" i-qtd-notas-periodo[16].
    


output stream str-qtd close.




