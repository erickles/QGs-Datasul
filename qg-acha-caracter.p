def var i as int.
def var l as int.

find first es-sac-emit where nr-atend = 2343 no-lock no-error.
if avail es-sac-emit then
    assign l = length(es-sac-emit.pos-reclama).

output to "c:\texto2.txt".
do i = 1 to l:
    put string(string(asc(substr(es-sac-emit.pos-reclama,i,1))) + " - " + string(substr(es-sac-emit.pos-reclama,i,1))).

end.

output close.
