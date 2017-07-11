DEFINE VARIABLE c-situacao        AS CHARACTER   NO-UNDO EXTENT 6 INIT ["Marcado para Inclusao","Enviado para Inclusao","Incluido no Pefin","Marcado para Exclusao","Enviado para Exclusao","Excluido do Pefin"].
DEFINE VARIABLE iCont AS INTEGER     NO-UNDO.

DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD erro      AS CHAR
    FIELD como      AS CHAR
    FIELD reg       AS CHAR
    FIELD dt-pefin  AS CHAR
    FIELD cod-estab AS CHAR
    FIELD serie     AS CHAR
    FIELD titulo    AS CHAR
    FIELD especie   AS CHAR
    FIELD parcela   AS CHAR
    FIELD dt-emis   AS CHAR
    FIELD dt-venc   AS CHAR
    FIELD saldo     AS CHAR
    FIELD cod-emit  AS CHAR.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\Temp\pefin_1.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.erro        /*A*/
    tt-planilha.como        /*B*/
    tt-planilha.reg         /*C*/
    tt-planilha.dt-pefin    /*D*/
    tt-planilha.cod-estab   /*E*/
    tt-planilha.serie       /*F*/
    tt-planilha.titulo      /*G*/
    tt-planilha.especie     /*H*/
    tt-planilha.parcela
    tt-planilha.dt-emis
    tt-planilha.dt-venc
    tt-planilha.saldo
    tt-planilha.cod-emit.
END.
INPUT CLOSE.

FOR EACH tt-planilha WHERE tt-planilha.cod-emi <> "0":

    IF tt-planilha.como = "Deve ficar incluso efetivo" THEN DO:

        FIND FIRST es-titulo-cr WHERE es-titulo-cr.ep-codigo   = "1"
                                  AND es-titulo-cr.cod-estabel = tt-planilha.cod-estab
                                  AND es-titulo-cr.cod-esp     = tt-planilha.especie
                                  AND es-titulo-cr.serie       = tt-planilha.serie
                                  AND es-titulo-cr.nr-docto    = FILL("0",7 - LENGTH(tt-planilha.titulo)) +  tt-planilha.titulo
                                  AND es-titulo-cr.parcela     = tt-planilha.parcela
                                  NO-ERROR.
        IF AVAIL es-titulo-cr THEN DO:

            iCont = iCont + 1.
            
            ASSIGN es-titulo-cr.situacao-pefin = 3.

            /*
            IF es-titulo-cr.tem-pefin THEN
                MESSAGE "Tem pefin" 
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
            ELSE
                IF es-titulo-cr.situacao-pefin > 0 AND es-titulo-cr.situacao-pefin < 5 THEN
                        MESSAGE "Aparece triangulo"
                                VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ELSE 
                    MESSAGE "Nao aparece triangulo"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        
                IF es-titulo-cr.situacao-pefin > 0 AND es-titulo-cr.situacao-pefin < 7 THEN
                    MESSAGE "Pefin Serasa - " + c-situacao[es-titulo-cr.situacao-pefin]
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
                ELSE 
                    MESSAGE "Pefin Serasa"
                            VIEW-AS ALERT-BOX INFO BUTTONS OK.
            */
        END.

    END.

END.

MESSAGE iCont
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
