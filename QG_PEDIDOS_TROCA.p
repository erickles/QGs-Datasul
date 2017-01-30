OUTPUT TO "c:\pedidos_troca.csv".
    
FOR EACH ws-p-venda WHERE nr-pedcli = "1552-3124" OR
                            nr-pedcli = "1552-3126" OR
                            nr-pedcli = "1552-3127" OR
                            nr-pedcli = "1552-3128" OR
                            nr-pedcli = "1670-3017" OR
                            nr-pedcli = "1670-3019" OR
                            nr-pedcli = "1670-3020" OR
                            nr-pedcli = "1670-3022" OR
                            nr-pedcli = "1670-3025" OR
                            nr-pedcli = "1670-3026" OR
                            nr-pedcli = "1992w0128" OR
                            nr-pedcli = "1992w0129" OR
                            nr-pedcli = "1992w0134" OR
                            nr-pedcli = "2001w0125" OR
                            nr-pedcli = "2016-2965" OR
                            nr-pedcli = "2016-2968" OR
                            nr-pedcli = "2016w0070" OR
                            nr-pedcli = "2016w0071" OR
                            nr-pedcli = "2016w0074" OR
                            nr-pedcli = "2016w0075" OR
                            nr-pedcli = "2016w0076" OR
                            nr-pedcli = "2016w0077" OR
                            nr-pedcli = "2016w0078" OR
                            nr-pedcli = "2018-2220" OR
                            nr-pedcli = "220-1373" OR
                            nr-pedcli = "220-1374" OR
                            nr-pedcli = "220-1383" OR
                            nr-pedcli = "220-1384" OR
                            nr-pedcli = "220w0076" OR
                            nr-pedcli = "220w0077" OR
                            nr-pedcli = "247w0068" OR
                            nr-pedcli = "26-4223" OR
                            nr-pedcli = "26w0373" OR
                            nr-pedcli = "26w0374" OR
                            nr-pedcli = "26w0375" OR
                            nr-pedcli = "3000-2520" OR
                            nr-pedcli = "3320-2382" OR
                            nr-pedcli = "340w0337" OR
                            nr-pedcli = "340w0338" OR
                            nr-pedcli = "340w0339" OR
                            nr-pedcli = "340w0340" OR
                            nr-pedcli = "340w0341" OR
                            nr-pedcli = "340w0342" OR
                            nr-pedcli = "340w0343" OR
                            nr-pedcli = "340w0344" OR
                            nr-pedcli = "3876-1961" OR
                            nr-pedcli = "3876-1962" OR
                            nr-pedcli = "3876-1963" OR
                            nr-pedcli = "3876-1964" OR
                            nr-pedcli = "3930-2526" OR
                            nr-pedcli = "3930-2527" OR
                            nr-pedcli = "3930-2529" OR
                            nr-pedcli = "4333w0029" OR
                            nr-pedcli = "4456w0014" OR
                            nr-pedcli = "4456w0015" OR
                            nr-pedcli = "915-3162" OR
                            nr-pedcli = "915w0722" NO-LOCK:

    PUT nr-pedcli ";" ind-sit-ped ";"cod-tipo-oper SKIP.

END.

OUTPUT CLOSE.
