DEFINE VARIABLE c-cod-estabel   AS CHAR NO-UNDO.
DEFINE VARIABLE c-serie         AS CHAR NO-UNDO.
DEFINE VARIABLE da-data-emis    AS DATE NO-UNDO.
DEFINE VARIABLE c-cam-xml       AS CHAR NO-UNDO FORMAT 'x(80)'.
DEFINE VARIABLE c-cam-danfe     AS CHAR NO-UNDO FORMAT 'x(80)'.
DEFINE VARIABLE c-cam-boleto    AS CHAR NO-UNDO FORMAT 'x(80)' EXTENT 12.
    
FOR EACH es-envia-email NO-LOCK
        WHERE es-envia-email.situacao      = 1
          AND es-envia-email.codigo-acesso = 'PORTAL'
          AND es-envia-email.dt-incl       = 01/23/2015:

    FIND FIRST nota-fiscal NO-LOCK
            WHERE nota-fiscal.cod-estabel = ENTRY(1,es-envia-email.chave-acesso,"|")
              AND nota-fiscal.serie       = ENTRY(2,es-envia-email.chave-acesso,"|")
              AND nota-fiscal.nr-nota-fis = ENTRY(3,es-envia-email.chave-acesso,"|")
            NO-ERROR.

    IF  AVAIL nota-fiscal THEN DO:
        
        FIND FIRST sit-nf-eletro NO-LOCK WHERE sit-nf-eletro.cod-estabel   = nota-fiscal.cod-estabel
                                        AND sit-nf-eletro.cod-nota-fisc = nota-fiscal.nr-nota-fis
                                        AND sit-nf-eletro.cod-serie     = nota-fiscal.serie 
                                        NO-ERROR.
        
        IF  NOT AVAIL sit-nf-eletro THEN DO:
            MESSAGE "SIT-NF-ELETRO nao Encontrado"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            NEXT.
        END.
        
        IF sit-nf-eletro.idi-sit-nf-eletro <> 3 THEN DO:
            MESSAGE "DANFE n∆o Autorizada!"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
            NEXT.
        END.
            
        FIND FIRST es-xml-nf WHERE es-xml-nf.cod-estabel = nota-fiscal.cod-estabel
                               AND es-xml-nf.serie       = nota-fiscal.serie
                               AND es-xml-nf.nr-nota-fis = nota-fiscal.nr-nota-fis
                               NO-ERROR.
            
        IF  NOT AVAIL es-xml-nf THEN DO:
            MESSAGE "Gerando XML"
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
        END.

        RUN esp\esapi300.p  (INPUT nota-fiscal.cgc,
                             INPUT nota-fiscal.nr-nota-fis,
                             OUTPUT c-cod-estabel,
                             OUTPUT c-serie      ,
                             OUTPUT da-data-emis ,
                             OUTPUT c-cam-xml    ,
                             OUTPUT c-cam-danfe  ,
                             OUTPUT c-cam-boleto).

        MESSAGE c-cam-xml   SKIP
                c-cam-danfe
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

    END.

END.
