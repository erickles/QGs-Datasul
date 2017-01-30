DEFINE VARIABLE cont AS INTEGER     NO-UNDO.

DEFINE VARIABLE telefone AS CHARACTER FORMAT "X(20)"  NO-UNDO.
DEFINE VARIABLE celular AS CHARACTER FORMAT "X(20)"  NO-UNDO.

DEFINE VARIABLE ddd-tel AS INTEGER FORMAT "99"    NO-UNDO.
DEFINE VARIABLE ddd-cel AS INTEGER FORMAT "99"    NO-UNDO.

DEFINE VARIABLE num-tel AS INTEGER FORMAT "99999999"    NO-UNDO.
DEFINE VARIABLE num-cel AS INTEGER FORMAT "99999999"    NO-UNDO.

{include/i-freeac.i}


FOR EACH es-motorista WHERE es-motorista.telefone = 0:

    IF INDEX(es-motorista.char-1,"}") = 0 THEN DO:
    
        /*cont = cont + 1.*/
        
        /* Primeiro, checa se o numero ja esta correto */
        IF SUBSTRING(es-motorista.char-1,1,1) <> "("  OR SUBSTRING(es-motorista.char-1,4,1) <> ")"  OR SUBSTRING(es-motorista.char-1,9,1) <> "-"  THEN DO:
    
            ASSIGN telefone = fn-free-accent(SUBSTRING(es-motorista.char-1,1,20)).
    
            ASSIGN celular = fn-free-accent(SUBSTRING(es-motorista.char-1,22,20)).
                                        
            /* Trata campos de telefone celular */
            ASSIGN telefone = REPLACE(telefone," ","")
                   telefone = REPLACE(telefone,"a","")
                   telefone = REPLACE(telefone,"b","")
                   telefone = REPLACE(telefone,"c","")
                   telefone = REPLACE(telefone,"d","")
                   telefone = REPLACE(telefone,"e","")
                   telefone = REPLACE(telefone,"f","")
                   telefone = REPLACE(telefone,"g","")
                   telefone = REPLACE(telefone,"h","")
                   telefone = REPLACE(telefone,"i","")
                   telefone = REPLACE(telefone,"j","")
                   telefone = REPLACE(telefone,"k","")
                   telefone = REPLACE(telefone,"l","")
                   telefone = REPLACE(telefone,"m","")
                   telefone = REPLACE(telefone,"n","")
                   telefone = REPLACE(telefone,"o","")
                   telefone = REPLACE(telefone,"p","")
                   telefone = REPLACE(telefone,"q","")
                   telefone = REPLACE(telefone,"r","")
                   telefone = REPLACE(telefone,"s","")
                   telefone = REPLACE(telefone,"t","")
                   telefone = REPLACE(telefone,"u","")
                   telefone = REPLACE(telefone,"v","")
                   telefone = REPLACE(telefone,"w","")
                   telefone = REPLACE(telefone,"X","")
                   telefone = REPLACE(telefone,"Y","")
                   telefone = REPLACE(telefone,"z","")
                   telefone = REPLACE(telefone,"\","")
                   telefone = REPLACE(telefone,"/","")
                   telefone = REPLACE(telefone,"-","")
                   telefone = REPLACE(telefone,".","")
                   telefone = REPLACE(telefone,"_","")
                   telefone = REPLACE(telefone,"(","")
                   telefone = REPLACE(telefone,")","")
                   telefone = REPLACE(telefone,"*","")
                   telefone = REPLACE(telefone,"#","")
                   telefone = REPLACE(telefone,"!","")
                   telefone = REPLACE(telefone,",","")
                   telefone = REPLACE(telefone,"}","")
                   telefone = REPLACE(telefone,"[","")
                   telefone = REPLACE(telefone,"]","")
                   telefone = REPLACE(telefone,"'","")
                   telefone = REPLACE(telefone,"|","").
    
            ASSIGN celular = REPLACE(celular," ","")
                   celular = REPLACE(celular,"a","")
                   celular = REPLACE(celular,"b","")
                   celular = REPLACE(celular,"c","")
                   celular = REPLACE(celular,"d","")
                   celular = REPLACE(celular,"e","")
                   celular = REPLACE(celular,"f","")
                   celular = REPLACE(celular,"g","")
                   celular = REPLACE(celular,"h","")
                   celular = REPLACE(celular,"i","")
                   celular = REPLACE(celular,"j","")
                   celular = REPLACE(celular,"k","")
                   celular = REPLACE(celular,"l","")
                   celular = REPLACE(celular,"m","")
                   celular = REPLACE(celular,"n","")
                   celular = REPLACE(celular,"o","")
                   celular = REPLACE(celular,"p","")
                   celular = REPLACE(celular,"q","")
                   celular = REPLACE(celular,"r","")
                   celular = REPLACE(celular,"s","")
                   celular = REPLACE(celular,"t","")
                   celular = REPLACE(celular,"u","")
                   celular = REPLACE(celular,"v","")
                   celular = REPLACE(celular,"w","")
                   celular = REPLACE(celular,"X","")
                   celular = REPLACE(celular,"Y","")
                   celular = REPLACE(celular,"z","")
                   celular = REPLACE(celular,"\","")
                   celular = REPLACE(celular,"/","")
                   celular = REPLACE(celular,"-","")
                   celular = REPLACE(celular,".","")
                   celular = REPLACE(celular,"_","")
                   celular = REPLACE(celular,"(","")
                   celular = REPLACE(celular,")","")
                   celular = REPLACE(celular,"*","")
                   celular = REPLACE(celular,"#","")
                   celular = REPLACE(celular,"!","")
                   celular = REPLACE(celular,",","")
                   celular = REPLACE(celular,"}","")
                   celular = REPLACE(celular,"[","")
                   celular = REPLACE(celular,"]","")
                   celular = REPLACE(celular,"'","")
                   celular = REPLACE(celular,"|","").

            
            /* Telefone */
            IF SUBSTRING(telefone,1,1) = "0" THEN
                OVERLAY(telefone,1,1) = "".
    
            telefone = TRIM(telefone).
            
            IF LENGTH(TRIM(telefone)) >= 10 THEN
                ASSIGN telefone = "(" + SUBSTRING(telefone,1,2) + ")" + SUBSTRING(telefone,3,4) + "-" + SUBSTRING(telefone,7,4).
            
            IF LENGTH(TRIM(telefone)) = 8 THEN
                ASSIGN telefone = SUBSTRING(telefone,1,4) + "-" + SUBSTRING(telefone,5,4).
            
            
            /* Celular */
            IF SUBSTRING(celular,1,1) = "0" THEN
                OVERLAY(celular,1,1) = "".

            celular = TRIM(celular).
    
            IF LENGTH(TRIM(celular)) >= 10 THEN
                ASSIGN celular = "(" + SUBSTRING(celular,1,2) + ")" + SUBSTRING(celular,3,4) + "-" + SUBSTRING(celular,7,4).
    
            IF LENGTH(TRIM(celular)) = 8 THEN
                ASSIGN celular = SUBSTRING(celular,1,4) + "-" + SUBSTRING(celular,5,4).
            
        END.

        ASSIGN telefone = REPLACE(telefone,"-","")
               telefone = REPLACE(telefone,"(","")
               telefone = REPLACE(telefone,")","")
               telefone = REPLACE(telefone," ","")
    
               celular = REPLACE(celular,"-","")
               celular = REPLACE(celular,"(","")
               celular = REPLACE(celular,")","")
               celular = REPLACE(celular," ","").

        ASSIGN ddd-cel = 0
               num-cel = 0
               ddd-tel = 0
               num-tel = 0.

        IF LENGTH(TRIM(telefone)) = 10 THEN DO:
            ASSIGN ddd-tel  = INTE(SUBSTRING(telefone,1,2))
                   num-tel  = INTE(SUBSTRING(telefone,3,8)).
        END.

        IF LENGTH(TRIM(telefone)) = 8 THEN DO:
            ASSIGN num-tel  = INTE(SUBSTRING(telefone,1,8)).
        END.
    
        IF LENGTH(TRIM(celular)) = 10 THEN DO:
            ASSIGN ddd-cel  = INTE(SUBSTRING(celular,1,2))
                   num-cel  = INTE(SUBSTRING(celular,3,8)).
        END.

        IF LENGTH(TRIM(celular)) = 8 THEN DO:
            ASSIGN num-cel  = INTE(SUBSTRING(celular,1,8)).
        END.
    
        ASSIGN es-motorista.celular         = num-cel
               es-motorista.celular-ddd     = ddd-cel
               es-motorista.telefone        = num-tel
               es-motorista.telefone-ddd    = ddd-tel.
        
    END.
END.

/*DISP cont.*/
