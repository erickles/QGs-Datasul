FOR EACH emitente WHERE emitente.cod-gr-forn = 7
                    AND emitente.cod-emitente = 230960:

/*     FIND FIRST emitente WHERE emitente.nome-abrev = ws-p-venda.nome-abrev. */
/*     UPDATE emitente.telefone[1] emitente.telefone[2].                      */

    
    /* Primeiro, checa se o numero ja esta correto */
    IF SUBSTRING(emitente.telefone[1],1,1) <> "("  OR
       SUBSTRING(emitente.telefone[1],4,1) <> ")"  OR
       SUBSTRING(emitente.telefone[1],9,1) <> "-"  THEN DO:
    
        /* Trata campos de telefone fixo */
        ASSIGN emitente.telefone[1] = REPLACE(emitente.telefone[1]," ","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"a","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"b","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"c","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"d","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"e","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"f","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"g","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"h","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"i","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"j","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"k","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"l","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"m","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"n","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"o","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"p","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"q","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"r","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"s","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"t","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"u","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"v","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"w","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"X","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"Y","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"z","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"\","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"/","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"-","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],".","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"_","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"(","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],")","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"*","")
               emitente.telefone[1] = REPLACE(emitente.telefone[1],"#","").
    
        IF LENGTH(TRIM(emitente.telefone[1])) = 10 THEN
            ASSIGN emitente.telefone[1] = "(" + SUBSTRING(emitente.telefone[1],1,2) + ")" + SUBSTRING(emitente.telefone[1],3,4) + "-" + SUBSTRING(emitente.telefone[1],7,4).
        IF LENGTH(TRIM(emitente.telefone[1])) = 11 THEN
            ASSIGN emitente.telefone[1] = "(" + SUBSTRING(emitente.telefone[1],2,2) + ")" + SUBSTRING(emitente.telefone[1],4,4) + "-" + SUBSTRING(emitente.telefone[1],8,4).
        
    END.

    IF SUBSTRING(emitente.telefone[2],1,1) <> "("  OR
       SUBSTRING(emitente.telefone[2],4,1) <> ")"  OR
       SUBSTRING(emitente.telefone[2],9,1) <> "-"  THEN DO:
        
        ASSIGN emitente.telefone[2] = REPLACE(emitente.telefone[2]," ","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"a","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"b","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"c","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"d","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"e","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"f","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"g","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"h","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"i","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"j","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"k","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"l","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"m","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"n","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"o","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"p","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"q","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"r","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"s","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"t","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"u","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"v","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"w","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"X","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"Y","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"z","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"\","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"/","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"-","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],".","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"_","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"(","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],")","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"*","")
               emitente.telefone[2] = REPLACE(emitente.telefone[2],"#","").

        IF LENGTH(TRIM(emitente.telefone[2])) = 10 THEN
            ASSIGN emitente.telefone[2] = "(" + SUBSTRING(emitente.telefone[1],1,2) + ")" + SUBSTRING(emitente.telefone[2],3,4) + "-" + SUBSTRING(emitente.telefone[2],7,4).
        IF LENGTH(TRIM(emitente.telefone[2])) = 11 THEN
            ASSIGN emitente.telefone[2] = "(" + SUBSTRING(emitente.telefone[1],2,2) + ")" + SUBSTRING(emitente.telefone[2],4,4) + "-" + SUBSTRING(emitente.telefone[2],8,4).

    END.
    
END.
