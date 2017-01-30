
DEFINE VARIABLE cAjustado AS CHARACTER   NO-UNDO.

OUTPUT TO "C:\Temp\telefones_55.csv".

PUT "COD CLIENTE"   ";"
    "CELULAR"       ";"
    "AJUSTADO"      ";"
    "UF"            ";"
    "IGUAIS?"       SKIP.

FOR EACH emitente /*WHERE (emitente.telefone[1] BEGINS "(55)" OR emitente.telefone[1] BEGINS "55")
                    AND (emitente.estado = "RS")*/
                    NO-LOCK:
    
        ASSIGN cAjustado = emitente.telefone[1]
               cAjustado = REPLACE(cAjustado," ","")
               cAjustado = REPLACE(cAjustado,"a","")
               cAjustado = REPLACE(cAjustado,"b","")
               cAjustado = REPLACE(cAjustado,"c","")
               cAjustado = REPLACE(cAjustado,"d","")
               cAjustado = REPLACE(cAjustado,"e","")
               cAjustado = REPLACE(cAjustado,"f","")
               cAjustado = REPLACE(cAjustado,"g","")
               cAjustado = REPLACE(cAjustado,"h","")
               cAjustado = REPLACE(cAjustado,"i","")
               cAjustado = REPLACE(cAjustado,"j","")
               cAjustado = REPLACE(cAjustado,"k","")
               cAjustado = REPLACE(cAjustado,"l","")
               cAjustado = REPLACE(cAjustado,"m","")
               cAjustado = REPLACE(cAjustado,"n","")
               cAjustado = REPLACE(cAjustado,"o","")
               cAjustado = REPLACE(cAjustado,"p","")
               cAjustado = REPLACE(cAjustado,"q","")
               cAjustado = REPLACE(cAjustado,"r","")
               cAjustado = REPLACE(cAjustado,"s","")
               cAjustado = REPLACE(cAjustado,"t","")
               cAjustado = REPLACE(cAjustado,"u","")
               cAjustado = REPLACE(cAjustado,"v","")
               cAjustado = REPLACE(cAjustado,"w","")
               cAjustado = REPLACE(cAjustado,"X","")
               cAjustado = REPLACE(cAjustado,"Y","")
               cAjustado = REPLACE(cAjustado,"z","")
               cAjustado = REPLACE(cAjustado,"\","")
               cAjustado = REPLACE(cAjustado,"/","")
               cAjustado = REPLACE(cAjustado,"-","")
               cAjustado = REPLACE(cAjustado,".","")
               cAjustado = REPLACE(cAjustado,"_","")
               cAjustado = REPLACE(cAjustado,"(","")
               cAjustado = REPLACE(cAjustado,")","")
               cAjustado = REPLACE(cAjustado,"*","")
               cAjustado = REPLACE(cAjustado,"#","")
               cAjustado = REPLACE(cAjustado,";","")
               cAjustado = REPLACE(cAjustado,",","")
               cAjustado = REPLACE(cAjustado,CHR(10),"")
               cAjustado = REPLACE(cAjustado,CHR(13),"")
               cAjustado = REPLACE(cAjustado,CHR(9),"").

    /* Caso ja estejam com o nono digito */
    IF LENGTH(cAjustado) = 11 THEN DO:

        IF SUBSTRING(cAjustado,3,1) = "9" THEN DO:
    
            ASSIGN cAjustado = "(" + SUBSTRING(cAjustado,1,2) + ")" + SUBSTRING(cAjustado,3,5) + "-" + SUBSTRING(cAjustado,8,4).

        END.
        ELSE DO:

            ASSIGN cAjustado = SUBSTRING(cAjustado,1,10).
            ASSIGN cAjustado = "(" + SUBSTRING(cAjustado,1,2) + ")" + SUBSTRING(cAjustado,3,4) + "-" + SUBSTRING(cAjustado,7,4).

        END.

    END.
    ELSE
        /* Caso ainda nao estejam com o nono digito */
        IF LENGTH(cAjustado) = 10 THEN DO:
            
            /* Se comecar com 9, provavelmente eh um celular, portanto, incluo o nono digito */
            IF SUBSTRING(cAjustado,3,1) = "9" OR SUBSTRING(cAjustado,3,1) = "8" OR SUBSTRING(cAjustado,3,1) = "7" THEN DO:
        
                ASSIGN cAjustado = "(" + SUBSTRING(cAjustado,1,2) + ")" + "9" + SUBSTRING(cAjustado,3,4) + "-" + SUBSTRING(cAjustado,7,4).
    
            END.
            ELSE DO:
                /* Do contrario, apenas formato. Provavelmente eh um telefone fixo no campo de celular */
                ASSIGN cAjustado = "(" + SUBSTRING(cAjustado,1,2) + ")" + SUBSTRING(cAjustado,3,4) + "-" + SUBSTRING(cAjustado,7,4).
            END.
    
        END.
        ELSE
            /* Caso seja maior que 11, decremento os ultimos caracteres, deixando apenas 10 */
            IF LENGTH(cAjustado) > 11 THEN DO:
        
                ASSIGN cAjustado = SUBSTRING(cAjustado,1,10).
                ASSIGN cAjustado = "(" + SUBSTRING(cAjustado,1,2) + ")" + SUBSTRING(cAjustado,3,4) + "-" + SUBSTRING(cAjustado,7,4).
        
            END.
            ELSE    
                IF LENGTH(cAjustado) < 10 THEN DO:
                    /* Caso seja menor que 10, incremento com zeros */
                    ASSIGN cAjustado = cAjustado + FILL("0",(10 - LENGTH(cAjustado))).
                    ASSIGN cAjustado = "(" + SUBSTRING(cAjustado,1,2) + ")" + SUBSTRING(cAjustado,3,4) + "-" + SUBSTRING(cAjustado,7,4).
            
                END.
    
    cAjustado = REPLACE(cAjustado,CHR(10),"").
    
    PUT UNFORM emitente.cod-emitente                                                                                                ";"
               REPLACE(REPLACE(REPLACE(REPLACE(emitente.telefone[1],CHR(10),""),CHR(13),""),CHR(9),"")," ","")                      ";"
               TRIM(cAjustado)                                                                                                      ";"
               emitente.estado                                                                                                      ";"
               REPLACE(REPLACE(REPLACE(REPLACE(emitente.telefone[1],CHR(10),""),CHR(13),""),CHR(9),"")," ","") = TRIM(cAjustado)    SKIP.

    /*ASSIGN emitente.telefone[1] = cAjustado.*/
    
END.

OUTPUT CLOSE.
