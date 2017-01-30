DEFINE TEMP-TABLE tt-planilha NO-UNDO
    FIELD cod-emitente      LIKE emitente.cod-emitente
    FIELD nome-emitente     LIKE emitente.nome-emit
    FIELD emp               AS INTEGER
    FIELD cod-estab         LIKE estabel.cod-estab
    FIELD esp               AS CHAR FORMAT "X(3)"
    FIELD docto             AS CHAR FORMAT "X(8)"
    FIELD nr-pedcli         LIKE ws-p-venda.nr-pedcli
    FIELD parcela           AS CHAR FORMAT "X(6)"
    FIELD port              AS CHAR FORMAT "X(10)"
    FIELD dt-emis           AS CHAR FORMAT "X(10)"
    FIELD dt-venc           AS CHAR FORMAT "X(10)"
    FIELD saldo             AS DECI
    FIELD dias              AS INTE
    FIELD cod-rep           AS repres-cod-rep.

EMPTY TEMP-TABLE tt-planilha.

INPUT FROM "C:\COBRANCA_2.csv" CONVERT TARGET "ibm850".

REPEAT ON ERROR UNDO, NEXT:
   CREATE tt-planilha.
   IMPORT DELIMITER ";"
    tt-planilha.cod-emitente
    tt-planilha.nome-emitente
    tt-planilha.emp
    tt-planilha.cod-estab
    tt-planilha.esp
    tt-planilha.docto
    tt-planilha.nr-pedcli
    tt-planilha.parcela
    tt-planilha.port
    tt-planilha.dt-emis
    tt-planilha.dt-venc
    tt-planilha.saldo
    tt-planilha.dias
    tt-planilha.cod-rep.

END.
INPUT CLOSE.

FOR EACH tt-planilha:
    
    DISP tt-planilha.cod-emitente   SKIP      
         tt-planilha.nome-emitente  SKIP
         tt-planilha.emp            SKIP
         tt-planilha.cod-estab      SKIP
         tt-planilha.esp            SKIP
         tt-planilha.docto          SKIP
         tt-planilha.nr-pedcli      SKIP
         tt-planilha.parcela        SKIP
         tt-planilha.port           SKIP
         tt-planilha.dt-emis        SKIP
         tt-planilha.dt-venc        SKIP
         tt-planilha.saldo          SKIP
         tt-planilha.dias           SKIP
         tt-planilha.cod-rep        WITH 1 COL.
END.
