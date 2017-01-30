DEFINE VARIABLE cChave AS CHARACTER   NO-UNDO.

/* "01;1027200;N" */

ASSIGN cChave = "011027200N"
       cChave = SUBSTRING(cChave,1,2)                   + ";" +
                SUBSTRING(cChave,3,LENGTH(cChave) - 3)  + ";" +
                SUBSTRING(cChave,LENGTH(cChave),1).

MESSAGE cChave
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
