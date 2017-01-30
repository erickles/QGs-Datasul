{include/i-freeac.i}

DEFINE VARIABLE cAjustado1 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cAjustado2 AS CHARACTER   NO-UNDO.

OUTPUT TO "C:\Temp\CORREC_CLI_3.CSV".

PUT UNFORM "COD CLI"        ";"
           "NOME CLI"       ";"
           "CELULAR"        ";"
           "FIXO"           SKIP.

FOR EACH emitente WHERE 
                    /*AND (emitente.cod-gr-cli <> 3 AND emitente.cod-gr-cli <> 9 AND emitente.cod-gr-cli <> 92)*/
                    (emitente.identific = 1 OR emitente.identific = 3)
                    AND emitente.estado <> "EX"
                    NO-LOCK:

    ASSIGN cAjustado1 = emitente.telefone[1]
           cAjustado1 = REPLACE(cAjustado1," ","")
           cAjustado1 = REPLACE(cAjustado1,"a","")
           cAjustado1 = REPLACE(cAjustado1,"b","")
           cAjustado1 = REPLACE(cAjustado1,"c","")
           cAjustado1 = REPLACE(cAjustado1,"d","")
           cAjustado1 = REPLACE(cAjustado1,"e","")
           cAjustado1 = REPLACE(cAjustado1,"f","")
           cAjustado1 = REPLACE(cAjustado1,"g","")
           cAjustado1 = REPLACE(cAjustado1,"h","")
           cAjustado1 = REPLACE(cAjustado1,"i","")
           cAjustado1 = REPLACE(cAjustado1,"j","")
           cAjustado1 = REPLACE(cAjustado1,"k","")
           cAjustado1 = REPLACE(cAjustado1,"l","")
           cAjustado1 = REPLACE(cAjustado1,"m","")
           cAjustado1 = REPLACE(cAjustado1,"n","")
           cAjustado1 = REPLACE(cAjustado1,"o","")
           cAjustado1 = REPLACE(cAjustado1,"p","")
           cAjustado1 = REPLACE(cAjustado1,"q","")
           cAjustado1 = REPLACE(cAjustado1,"r","")
           cAjustado1 = REPLACE(cAjustado1,"s","")
           cAjustado1 = REPLACE(cAjustado1,"t","")
           cAjustado1 = REPLACE(cAjustado1,"u","")
           cAjustado1 = REPLACE(cAjustado1,"v","")
           cAjustado1 = REPLACE(cAjustado1,"w","")
           cAjustado1 = REPLACE(cAjustado1,"X","")
           cAjustado1 = REPLACE(cAjustado1,"Y","")
           cAjustado1 = REPLACE(cAjustado1,"z","")
           cAjustado1 = REPLACE(cAjustado1,"\","")
           cAjustado1 = REPLACE(cAjustado1,"/","")
           cAjustado1 = REPLACE(cAjustado1,"-","")
           cAjustado1 = REPLACE(cAjustado1,".","")
           cAjustado1 = REPLACE(cAjustado1,"_","")
           cAjustado1 = REPLACE(cAjustado1,"(","")
           cAjustado1 = REPLACE(cAjustado1,")","")
           cAjustado1 = REPLACE(cAjustado1,"*","")
           cAjustado1 = REPLACE(cAjustado1,"#","")
           cAjustado1 = REPLACE(cAjustado1,";","")
           cAjustado1 = REPLACE(cAjustado1,",","")
           cAjustado1 = REPLACE(cAjustado1,CHR(10),"")
           cAjustado1 = REPLACE(cAjustado1,CHR(13),"")
           cAjustado1 = REPLACE(cAjustado1,CHR(9),"").

    ASSIGN cAjustado2 = emitente.telefone[1]
           cAjustado2 = REPLACE(cAjustado2," ","")
           cAjustado2 = REPLACE(cAjustado2,"a","")
           cAjustado2 = REPLACE(cAjustado2,"b","")
           cAjustado2 = REPLACE(cAjustado2,"c","")
           cAjustado2 = REPLACE(cAjustado2,"d","")
           cAjustado2 = REPLACE(cAjustado2,"e","")
           cAjustado2 = REPLACE(cAjustado2,"f","")
           cAjustado2 = REPLACE(cAjustado2,"g","")
           cAjustado2 = REPLACE(cAjustado2,"h","")
           cAjustado2 = REPLACE(cAjustado2,"i","")
           cAjustado2 = REPLACE(cAjustado2,"j","")
           cAjustado2 = REPLACE(cAjustado2,"k","")
           cAjustado2 = REPLACE(cAjustado2,"l","")
           cAjustado2 = REPLACE(cAjustado2,"m","")
           cAjustado2 = REPLACE(cAjustado2,"n","")
           cAjustado2 = REPLACE(cAjustado2,"o","")
           cAjustado2 = REPLACE(cAjustado2,"p","")
           cAjustado2 = REPLACE(cAjustado2,"q","")
           cAjustado2 = REPLACE(cAjustado2,"r","")
           cAjustado2 = REPLACE(cAjustado2,"s","")
           cAjustado2 = REPLACE(cAjustado2,"t","")
           cAjustado2 = REPLACE(cAjustado2,"u","")
           cAjustado2 = REPLACE(cAjustado2,"v","")
           cAjustado2 = REPLACE(cAjustado2,"w","")
           cAjustado2 = REPLACE(cAjustado2,"X","")
           cAjustado2 = REPLACE(cAjustado2,"Y","")
           cAjustado2 = REPLACE(cAjustado2,"z","")
           cAjustado2 = REPLACE(cAjustado2,"\","")
           cAjustado2 = REPLACE(cAjustado2,"/","")
           cAjustado2 = REPLACE(cAjustado2,"-","")
           cAjustado2 = REPLACE(cAjustado2,".","")
           cAjustado2 = REPLACE(cAjustado2,"_","")
           cAjustado2 = REPLACE(cAjustado2,"(","")
           cAjustado2 = REPLACE(cAjustado2,")","")
           cAjustado2 = REPLACE(cAjustado2,"*","")
           cAjustado2 = REPLACE(cAjustado2,"#","")
           cAjustado2 = REPLACE(cAjustado2,";","")
           cAjustado2 = REPLACE(cAjustado2,",","")
           cAjustado2 = REPLACE(cAjustado2,CHR(10),"")
           cAjustado2 = REPLACE(cAjustado2,CHR(13),"")
           cAjustado2 = REPLACE(cAjustado2,CHR(9),"").

    IF LENGTH(cAjustado2) > LENGTH(cAjustado1) THEN
        PUT UNFORM emitente.cod-emitente                                ";"
                   REPLACE(fn-free-accent(emitente.nome-emit),";","")   ";"
                   cAjustado1                                           ";"
                   cAjustado2                                           SKIP.

END.

OUTPUT CLOSE.
