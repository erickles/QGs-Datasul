DEFINE VARIABLE comando AS CHARACTER   NO-UNDO.

DEFINE VARIABLE cUnidanfe   AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cXml        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDestino    AS CHARACTER   NO-UNDO.

ASSIGN cUnidanfe = "C:\Unimake\UniNFe\unidanfe.exe"
       cXml      = "C:\tmp\220020109222.xml"
       cXml      = "W:\webems24\danfe\090020050232.xml"
       cDestino  = "C:\Temp\"
       cDestino  = "W:\webems24\danfe\".

comando = cUnidanfe + ' ' + 'a=' + cXml + ' ' + 'pp="' + cDestino + '" ' + "c=RETRATO" + ' ' + 'v=0' + ' ' + "d=Plus".

/*comando = cUnidanfe + ' ' + 'a=' + cXml + ' ' + 'pp=' + cDestino.*/
/*
MESSAGE comando
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
OS-COMMAND /*SILENT*/ VALUE(comando).
