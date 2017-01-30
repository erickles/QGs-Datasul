OUTPUT TO "c:\motoristas.csv".
    
FOR EACH es-motorista WHERE es-motorista.telefone = 0
                        AND SUBSTRING(es-motorista.char-1,1,20) <> ""
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"EM") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"NAO") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"POSSUI") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"ATUALIZAR") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"NOA") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"NADA") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"CONSTA") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"XX") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"MATERIA") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"MP") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"0000") > 0
                        AND NOT INDEX(SUBSTRING(es-motorista.char-1,1,20),"BRANCO") > 0.

    PUT es-motorista.cgc ";"
        SUBSTRING(es-motorista.char-1,1,20) FORMAT "X(20)"
        SKIP.
        /*SUBSTRING(es-motorista.char-1,1,20,"X(20)").*/
END.
OUTPUT CLOSE.
