/*colocar int-1 = 4 
  no char-1, colocar o c¢digo do representante que quer ser
  retirar todas as supervisäes do espd007 vinculadas ao usu rio*/

FIND FIRST usuar_mestre 
    WHERE usuar_mestre.cod_usuar = 'ess55813'.

ASSIGN usuar_mestre.char-1 = "".

UPDATE usuar_mestre WITH 1 COL WIDTH 300.
