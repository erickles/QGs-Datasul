OUTPUT TO C:\substitui15-03-10.txt.


DEF VAR c-natureza AS CHAR FORMAT "X(20)" NO-UNDO.


FOR EACH nota-fiscal  NO-LOCK WHERE dt-emis-nota >= 01/01/2010 and
                                    dt-emis-nota <= 03/24/2010 AND
                                    estado <> "EX":

      FIND FIRST nota-trans WHERE nota-trans.cod-estabel = nota-fiscal.cod-estabel AND
                                  nota-trans.serie       = nota-fiscal.serie       AND
                                  nota-trans.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.

      FIND FIRST transporte WHERE transporte.nome-abrev = nota-fiscal.nome-trans NO-LOCK NO-ERROR.

       CASE transporte.natureza:
            WHEN 1 THEN ASSIGN c-natureza = "Pessoa Fisica".
            WHEN 2 THEN ASSIGN c-natureza = "Pessoa Juridica".
            WHEN 3 THEN ASSIGN c-natureza = "Estrangeiro".
            OTHERWISE   ASSIGN c-natureza = "Trading".
       END CASE.

       FIND FIRST es-nota-fiscal WHERE es-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel AND
                                       es-nota-fiscal.serie       = nota-fiscal.serie       AND
                                       es-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis 
                                       NO-LOCK NO-ERROR.

/*                 IF nota-trans.vl-servico <> 0 then DO: */

                DISP nota-fiscal.cod-estabel ";"
                     nota-fiscal.nr-nota-fis ";"
                     nota-fiscal.serie       ";"
                     nota-fiscal.nat-operacao ";"
    
                     nota-fiscal.dt-emis-nota ";"  
                     nota-fiscal.cidade-cif   ";"
                     c-natureza               ";"
                     transporte.estado        ";" 
                     IF AVAIL es-nota-fiscal THEN es-nota-fiscal.cod-estabel-st ELSE "" ";" 
                     IF AVAIL es-nota-fiscal THEN es-nota-fiscal.serie-st       ELSE "" ";"
                     IF AVAIL es-nota-fiscal THEN es-nota-fiscal.nr-nota-fis-st  ELSE "" ";" WITH WIDTH 300.
      

/*     FIND FIRST b-natur-oper WHERE b-natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.                              */
/*     IF AVAIL b-natur-oper AND SUBSTRING(b-natur-oper.char-1,45,1) = "6" AND nota-fiscal.cidade-cif <> "" THEN DO:  /* interestadual*/ */
/*            IF transporte.natureza = 1 OR transporte.estado <> "SP" THEN DO:                                                           */


END.
