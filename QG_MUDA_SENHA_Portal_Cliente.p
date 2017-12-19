DEFINE VARIABLE iCodEmitente AS INTEGER     NO-UNDO.
DEFINE VARIABLE cSenha AS CHARACTER   NO-UNDO.
cSenha = "".

UPDATE iCodEmitente LABEL "Cod. Cliente".

FIND FIRST emitente NO-LOCK WHERE emitente.cod-emit = iCodEmitente NO-ERROR.
IF AVAIL emitente THEN DO:
    
    FIND FIRST ws-emitente WHERE ws-emitente.cgc = emitente.cgc NO-ERROR.

    RUN Descriptografa (INPUT ws-emitente.senha, OUTPUT cSenha).

    UPDATE cSenha FORMAT "x(30)".

    RUN CriptoGrafa(INPUT cSenha,
                    OUTPUT cSenha).
    
    ASSIGN ws-emitente.senha = cSenha.

    MESSAGE cSenha
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

PROCEDURE CriptoGrafa: 

    DEF INPUT   PARAM  senha   AS CHAR NO-UNDO.
    DEF OUTPUT  PARAM  p-senha AS CHAR NO-UNDO INIT "".
    DEF VAR z AS CHAR.
    DEF VAR vi-idx AS INTE NO-UNDO.

    ASSIGN senha = LC(senha).

    DO vi-idx = 1 TO LENGTH(senha):
        
        IF (ASC(SUBSTR(senha,vi-idx,1),"iso8859-1")) >= 97 AND
            (ASC(SUBSTR(senha,vi-idx,1),"iso8859-1")) <= 122 THEN DO:
            IF (ASC(substr(senha,vi-idx,1),"iso8859-1")) = 122 THEN DO:                
                z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") + 38 )).
                
            END.
            else
                if (asc(substr(senha,vi-idx,1),"iso8859-1")) >= 105 and
                    (asc(substr(senha,vi-idx,1),"iso8859-1")) <= 106 then DO:
                    z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") + 22)).
                    
                END.                    
                ELSE
                    if (asc(substr(senha,vi-idx,1),"iso8859-1")) = 109 then DO:
                        z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") + 48)).
                        
                    END.                        
                    ELSE DO:
                        z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") - 96)).
                        
                    END.
            p-senha = IF p-senha = "" THEN TRIM(z)
                      ELSE p-senha + TRIM(z).
        END.

        if (asc(substr(senha,vi-idx,1),"iso8859-1")) >= 224 and
            (asc(substr(senha,vi-idx,1),"iso8859-1")) <= 252 then do:  

            z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") - 128)).
            p-senha = if p-senha = "" then trim(z)
                        else p-senha + trim(z).

            

        end.          
        
        if (asc(substr(senha,vi-idx,1),"iso8859-1")) >= 48 and
            (asc(substr(senha,vi-idx,1),"iso8859-1")) <= 57 then do:

            if (asc(substr(senha,vi-idx,1),"iso8859-1")) >= 54 and
                (asc(substr(senha,vi-idx,1),"iso8859-1")) <= 57 then DO:
                z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") + 87)).
                
            END.
                
            else
                if (asc(substr(senha,vi-idx,1),"iso8859-1")) = 53 THEN DO:

                    z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") + 76)).    

                    
                END.                    
                ELSE DO:
                    
                    z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") - 21)).
                END.
                    

            p-senha = if p-senha = ""
               then trim(z)
               else p-senha + trim(z).
   end.
 end.  
END PROCEDURE.

PROCEDURE Descriptografa: 
  
    DEFINE INPUT   PARAM  p-senha AS CHAR NO-UNDO.
    DEFINE OUTPUT  PARAM  p-dsenha AS CHAR NO-UNDO INIT "".

    DEF VAR z AS CHAR.
    DEF VAR vi-idx AS INTE NO-UNDO.
 
    ASSIGN p-senha = LC(p-senha).

    DO vi-idx = 1 TO LENGTH(p-senha):
   
        if (asc(SUBSTR(p-senha,vi-idx,1),"iso8859-1")) = 160 then
            z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") - 38 )).
        else
            if (asc(substr(p-senha,vi-idx,1),"iso8859-1")) >= 1 and
                (asc(substr(p-senha,vi-idx,1),"iso8859-1")) <= 25 then 
                z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") + 96)).
            else
                if (asc(substr(p-senha,vi-idx,1),"iso8859-1")) >= 127 and
                    (asc(substr(p-senha,vi-idx,1),"iso8859-1")) <= 128 then 
                    z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") - 22)).
                else
                    if (asc(substr(p-senha,vi-idx,1),"iso8859-1")) = 157 then 
                        z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") - 48)).
                    else
                        if (asc(substr(p-senha,vi-idx,1),"iso8859-1")) >= 27 and
                            (asc(substr(p-senha,vi-idx,1),"iso8859-1")) <= 32 then 
                            z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") + 21)).
                        else
                            if (asc(substr(p-senha,vi-idx,1),"iso8859-1")) = 129 then
                                z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") - 76)).    
                            else
                                if (asc(substr(p-senha,vi-idx,1),"iso8859-1")) >= 96 and
                                    (asc(substr(p-senha,vi-idx,1),"iso8859-1")) <= 124 then   
                                    z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") + 128)).
                                else
                                    if (asc(substr(p-senha,vi-idx,1),"iso8859-1")) >= 141 and
                                        (asc(substr(p-senha,vi-idx,1),"iso8859-1")) <= 144 then 
                                        z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") - 87)).

        p-dsenha = IF p-dsenha = ""
                    THEN TRIM(z)
                    ELSE p-dsenha + TRIM(z).
    END.

END PROCEDURE.
