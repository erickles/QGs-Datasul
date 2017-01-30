DEFINE VARIABLE cont AS INTEGER     NO-UNDO.
DEFINE VARIABLE data AS DATE        NO-UNDO FORMAT "99/99/9999".

UPDATE data.                                                                              

FOR EACH es-script-pos-entrega NO-LOCK WHERE es-script-pos-entrega.data-pos-entrega = data:

    cont = cont + 1.
    
END.

DISP cont.
