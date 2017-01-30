DEFINE VARIABLE c-erro-geral    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE pedagio-valor   AS DECIMAL     NO-UNDO.
DEFINE VARIABLE pedagio-km      AS DECIMAL     NO-UNDO.

RUN anp\esan013.p(INPUT  "56992951000149",
                  INPUT  "27269448841",
                  INPUT  "2",
                  INPUT  3528403,
                  INPUT  4204202,
                  INPUT  0,
                  INPUT  "",
                  OUTPUT c-erro-geral,
                  OUTPUT pedagio-valor,
                  OUTPUT pedagio-km).

MESSAGE "Erro: "            c-erro-geral    SKIP
        "Valor Pedagio: "   pedagio-valor   SKIP
        "Valor Km"          pedagio-km 
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/*
c-unidade-documento-numero
c-favorecido-documento-1  
c-veiculo-categoria       
i-origem-cidade-ibge      
i-destino-cidade-ibge     
i-ponto-qtde              
c-pontoN-cidade-ibge

c-erro-geral 
pedagio-valor
pedagio-km
*/
