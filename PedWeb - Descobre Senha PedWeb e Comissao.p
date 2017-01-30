/*DEFINIDO UM CàDIGO DE REPRESENTANTE,  GERADO NA TELA A SUA SENHA DO PEDWEB*/
/*COMO USAR?  -->> BASTA RODAR A PROCEDURE.*/

DEFINE VARIABLE p-dsenha                AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p-dsenha-comissao       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-senha                 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cod-repres              AS INTEGER     NO-UNDO LABEL "Codigo Representante".
DEFINE VARIABLE cod-emitente            AS INTEGER     NO-UNDO.

UPDATE cod-emitente LABEL "Codigo emitente".

FIND FIRST emitente WHERE emitente.cod-emitente = cod-emitente NO-LOCK NO-ERROR.

/*UPDATE cod-repres LABEL "Codigo Representante".*/

FIND FIRST ws-repres NO-LOCK WHERE ws-repres.cod-rep = /*cod-repres*/ emitente.cod-rep NO-ERROR.

RUN Descriptografa (INPUT ws-repres.senha, OUTPUT p-dsenha).

RUN Descriptografa (INPUT ws-repres.u-char-1, OUTPUT p-dsenha-comissao).

/*RUN criptografa (INPUT p-dsenha, OUTPUT p-dsenha-comissao).*/

MESSAGE "A senha do representante (acesso PedWeb): " cod-repres " ‚: " p-dsenha             SKIP
        "A senha do representante (comissÆo)     : " cod-repres " ‚: " p-dsenha-comissao    SKIP
        "CNPJ: " STRING(cgc,"99.999.999/9999-99")
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

/*------------------------------------------------------------------------------
   Tipo: Procedure interna
   Nome: includes/cripto.i
  Autor: B&T/Solusoft
 Fun‡Æo: Controlar a criptografia e descriptografia da senha de acesso.
-------------------------------------------------------------------------------*/
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
                MESSAGE "1 " substr(senha,vi-idx,1)
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
            else
                if (asc(substr(senha,vi-idx,1),"iso8859-1")) >= 105 and
                    (asc(substr(senha,vi-idx,1),"iso8859-1")) <= 106 then DO:
                    z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") + 22)).
                    MESSAGE "2 " substr(senha,vi-idx,1)
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.                        
                END.                    
                ELSE
                    if (asc(substr(senha,vi-idx,1),"iso8859-1")) = 109 then DO:
                        z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") + 48)).
                        MESSAGE "3 " substr(senha,vi-idx,1)
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.                            
                    END.                        
                    ELSE DO:
                        z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") - 96)).
                        MESSAGE "4 " substr(senha,vi-idx,1)
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    END.
            p-senha = IF p-senha = "" THEN TRIM(z)
                      ELSE p-senha + TRIM(z).
        END.

        if (asc(substr(senha,vi-idx,1),"iso8859-1")) >= 224 and
            (asc(substr(senha,vi-idx,1),"iso8859-1")) <= 252 then do:  

            z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") - 128)).
            p-senha = if p-senha = "" then trim(z)
                        else p-senha + trim(z).

            MESSAGE "5 " substr(senha,vi-idx,1)
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.

        end.          
        
        if (asc(substr(senha,vi-idx,1),"iso8859-1")) >= 48 and
            (asc(substr(senha,vi-idx,1),"iso8859-1")) <= 57 then do:

            if (asc(substr(senha,vi-idx,1),"iso8859-1")) >= 54 and
                (asc(substr(senha,vi-idx,1),"iso8859-1")) <= 57 then DO:
                z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") + 87)).
                MESSAGE "+87"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            END.
                
            else
                if (asc(substr(senha,vi-idx,1),"iso8859-1")) = 53 THEN DO:

                    z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") + 76)).    

                    MESSAGE z SKIP
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                END.                    
                ELSE DO:
                    MESSAGE "-21" SKIP
                            asc(substr(senha,vi-idx,1),"iso8859-1") - 21
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    z = chr((asc(substr(senha,vi-idx,1),"iso8859-1") - 21)).
                END.
                    

            p-senha = if p-senha = ""
               then trim(z)
               else p-senha + trim(z).
   end.
 end.  
END PROCEDURE.

PROCEDURE Descriptografa: 
  
    def input   param  p-senha as char no-undo.
    def output  param  p-dsenha as char no-undo init "".

    def var z as char.
    def var vi-idx as int no-undo.
 
    assign p-senha = lc(p-senha).

    do vi-idx = 1 to length(p-senha):
    
        IF (ASC(SUBSTR(p-senha,vi-idx,1),"iso8859-1")) = 160 THEN
            z = CHR((ASC(SUBSTR(p-senha,vi-idx,1),"iso8859-1") - 38 )).
        ELSE
            if  (ASC(SUBSTR(p-senha,vi-idx,1),"iso8859-1")) >= 1 AND
                (ASC(SUBSTR(p-senha,vi-idx,1),"iso8859-1")) <= 25 THEN 
                z = CHR((ASC(SUBSTR(p-senha,vi-idx,1),"iso8859-1") + 96)).
            else
                if  (asc(substr(p-senha,vi-idx,1),"iso8859-1")) >= 127 and
                    (asc(substr(p-senha,vi-idx,1),"iso8859-1")) <= 128 then 
                    z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") - 22)).
                else
                    if  (asc(substr(p-senha,vi-idx,1),"iso8859-1")) = 157 then 
                        z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") - 48)).
                    else
                        if  (asc(substr(p-senha,vi-idx,1),"iso8859-1")) >= 27 and
                            (asc(substr(p-senha,vi-idx,1),"iso8859-1")) <= 32 then 
                            z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") + 21)).
                        else
                            if  (asc(substr(p-senha,vi-idx,1),"iso8859-1")) = 129 then
                                z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") - 76)).    
                            else
                                if  (asc(substr(p-senha,vi-idx,1),"iso8859-1")) >= 96 and
                                    (asc(substr(p-senha,vi-idx,1),"iso8859-1")) <= 124 then   
                                    z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") + 128)).
                                else
                                    if  (asc(substr(p-senha,vi-idx,1),"iso8859-1")) >= 141 and
                                        (asc(substr(p-senha,vi-idx,1),"iso8859-1")) <= 144 then 
                                        z = chr((asc(substr(p-senha,vi-idx,1),"iso8859-1") - 87)).
    

        p-dsenha =  IF p-dsenha = ""
                        THEN TRIM(z)
                    ELSE p-dsenha + TRIM(z).
    END.

END PROCEDURE.

/*

Procedure Descriptografa:
  def input  param  p-senha as char no-undo.
  def output param  p-descriptosenha as char no-undo.

  def var vi-idx as int no-undo.                                   

  assign p-descriptosenha = "".
 
  do vi-idx = 1 to num-entries( p-senha ):
     assign p-descriptosenha = p-descriptosenha + chr( (int(entry(vi-idx, p-senha)) - vi-idx),"iso8859-1","iso8859-1").
  end.                                                

end Procedure. 


Procedure CriptoGrafa:
  def input   param  p-descriptosenha as char no-undo.
  def output  param  p-senha as char no-undo init "".

  def var vi-idx as int no-undo.                                   

  do vi-idx = 1 to length( p-descriptosenha ):
     p-senha = if p-senha = ""
               then trim(string(asc(substr(p-descriptosenha,vi-idx,1),"iso8859-1") + vi-idx,">>>>>9"))
               else p-senha + "," + trim(string(asc(substr(p-descriptosenha,vi-idx,1),"iso8859-1") + vi-idx,">>>>>9")).
  end.
end Procedure. 
*/


