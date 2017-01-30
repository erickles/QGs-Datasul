/*Este QG altera CST pis e cofins no faturamento*/

DEFINE VARIABLE Clinha AS CHARACTER   NO-UNDO.
DEFINE VARIABLE nr-nota-fis AS CHARACTER   NO-UNDO.
DEFINE VARIABLE serie AS CHARACTER   NO-UNDO.
/* DEFINE VARIABLE emitente AS CHARACTER   NO-UNDO.  */
DEFINE VARIABLE cod-estabel AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ITEM AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cstpis AS CHARACTER NO-UNDO.
DEFINE VARIABLE cstcofins AS CHARACTER NO-UNDO.
DEFINE VARIABLE seq  AS CHARACTER     NO-UNDO.

DEFINE VARIABLE iCont AS INTEGER INIT 0 NO-UNDO.


/* LEAVE.  */

INPUT FROM "C:\Diversos\carimbar\CARIMBAR NO FATURAMENTO CST 01 PARA  08.csv".

blk:
REPEAT:

    IMPORT DELIMITER ";" cod-estabel
                         serie 
                         nr-nota-fis
                         seq
                         item
                         cstpis 
                         cstcofins.

    FIND FIRST it-nota-fisc 
        WHERE it-nota-fisc.nr-nota-fis = TRIM(REPLACE(nr-nota-fis, "'", ""))
        AND   it-nota-fisc.serie       = serie
        AND   it-nota-fisc.cod-estabel = Trim(REPLACE(cod-estabel, "'", ""))
        AND   it-nota-fisc.it-codigo   = ITEM
        AND   it-nota-fisc.nr-seq-fat = INT(seq)  EXCLUSIVE-LOCK NO-ERROR.

    IF AVAIL it-nota-fisc THEN DO:

        iCont = iCont + 1.

/*          ASSIGN                                             */
/*              OVERLAY(it-nota-fisc.char-1,77,2) = cstpis     */
/*              OVERLAY(it-nota-fisc.char-1,79,2) = cstcofins. */

        DISP it-nota-fisc.nr-nota-fis
             it-nota-fisc.serie
             it-nota-fisc.cod-estabe
             it-nota-fisc.nr-seq-fat
             SUBSTRING(it-nota-fisc.char-1,77,2)  COLUMN-LABEL "cst-pis-antes"
             SUBSTRING(it-nota-fisc.char-1,79,2)  COLUMN-LABEL "cst-cofins-antes"
             cstpis COLUMN-LABEL "cst-pis-depois"
             cstcofins COLUMN-LABEL "cst-cofins-depois"
        WITH WIDTH 300.

    END.

END.

MESSAGE iCont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

