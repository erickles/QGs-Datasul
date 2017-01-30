DEFINE VARIABLE c-file AS CHARACTER  NO-UNDO. /* nome do arquivo completo diretório + arquivo*/
DEFINE VARIABLE c-linha AS CHARACTER  format "x(172)" NO-UNDO. /* linha que está sendo lida*/
DEFINE STREAM s-entrada.
define variable i as inte.

/*Le os CPFïs*/
c-file = "C:\aves-suinos.txt".

if search(c-file) <> ? then do:
  
    INPUT STREAM s-entrada FROM VALUE(c-file).

    REPEAT:
        IMPORT STREAM s-entrada UNFORMATTED c-linha.
        FIND FIRST es-item WHERE es-item.it-codigo = substr(c-linha,1,8) NO-ERROR.
        IF AVAIL es-item THEN DO:
            ASSIGN es-item.desc-item-web = "".            
        END.
/*         MESSAGE substr(c-linha,1,8) VIEW-AS ALERT-BOX INFO BUTTONS OK. */
    END.
end.
