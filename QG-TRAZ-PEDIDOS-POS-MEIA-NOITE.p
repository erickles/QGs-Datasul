output to c:\temp\pedidos_mobile.txt.

define variable i as integer.

for each ws-p-venda where ws-p-venda.dt-implant = 04/01/2011 
                      and String(ws-p-venda.hr-implant,"HH:MM") < string(time,"HH:MM")
                      and String(ws-p-venda.hr-implant,"HH:MM") >= "12:00"
                      and ws-p-venda.log-5
                      exclusive-lock:

    i = i + 1.

/*     find first ped-venda where ped-venda.nr-pedcli = ws-p-venda.nr-pedcli */
/*         exclusive-lock.                                                   */
/*                                                                           */
/*     assign ped-venda.dt-implant = ws-p-venda.dt-implant                   */
/*            ped-venda.dt-emiss   = ws-p-venda.dt-emiss.                    */
/*                                                                           */
/*     disp ped-venda.dt-implant                                             */
/*          ped-venda.dt-emiss.                                              */
end.

message i view-as alert-box.
output close.
