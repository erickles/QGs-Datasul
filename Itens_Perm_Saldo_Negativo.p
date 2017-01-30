DEFINE VARIABLE c-perm-neg AS CHARACTER COLUMN-LABEL "Saldo Neg"  NO-UNDO.
OUTPUT TO "c:\datasul\Item_Perm_Saldo_Negativo.txt".

FOR EACH item-uni-estab
    WHERE item-uni-estab.perm-saldo-neg = 3
    OR    item-uni-estab.perm-saldo-neg = 2 NO-LOCK:

    IF item-uni-estab.perm-saldo-neg = 1 THEN ASSIGN c-perm-neg = "NAO".
     ELSE IF item-uni-estab.perm-saldo-neg = 2 THEN ASSIGN c-perm-neg = "SIM CONFIRMADO".
         ELSE IF item-uni-estab.perm-saldo-neg = 3 THEN ASSIGN c-perm-neg = "SIM".

    FIND FIRST ITEM
        WHERE item.it-codigo = item-uni-estab.it-codigo NO-LOCK NO-ERROR.

    DISP item-uni-estab.cod-estabel
         item-uni-estab.it-codigo
         ITEM.desc-item
         item-uni-estab.perm-saldo-neg
         c-perm-neg
         WITH WIDTH 150.

    ASSIGN c-perm-neg = "".
END.
OUTPUT CLOSE.
  
/* FOR EACH ITEM                               */
/*     WHERE item.perm-saldo-neg = 2           */
/*     OR    ITEM.perm-saldo-neg = 3 NO-LOCK:  */
/*                                             */
/*     DISP ITEM.it-codigo                     */
/*          ITEM.desc-item                     */
/*          ITEM.perm-saldo-neg.               */
/*                                             */
/* END.                                        */
