def var i as inte.
find first es-acesso-item where es-acesso-item.it-codigo = "40008290" no-lock  NO-error.
output to "c:\40008290.txt".
do i = 1 to num-entries(es-acesso-item.lista-representantes):
    find first repres where repres.cod-rep = INTE(entry(i,es-acesso-item.lista-representantes)) no-lock NO-error.
    put entry(i,es-acesso-item.lista-representantes) + ";" +
        if avail repres then string(repres.nome + ";") else ";" format "x(50)" skip.
end.

output close.
