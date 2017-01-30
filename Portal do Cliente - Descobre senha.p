DEFINE VARIABLE iCodEmitente AS INTEGER     NO-UNDO.
DEFINE VARIABLE cSenha AS CHARACTER   NO-UNDO.
cSenha = "".

UPDATE iCodEmitente LABEL "Cod. Cliente".

FIND FIRST emitente NO-LOCK WHERE emitente.cod-emit = iCodEmitente NO-ERROR.
IF AVAIL emitente THEN DO:
    
    FIND FIRST ws-emitente WHERE ws-emitente.cgc = emitente.cgc NO-LOCK NO-ERROR.

    RUN Descriptografa (INPUT ws-emitente.senha, OUTPUT cSenha).

    MESSAGE 'Codigo Cliente: ' emitente.cod-emit    SKIP
            'Usuario.: ' emitente.cgc               SKIP
            'Senha...: ' cSenha                     SKIP
            'Email: ' emitente.e-mail               SKIP
            'Email..portal: ' ws-emitente.e-mail
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

END.

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
