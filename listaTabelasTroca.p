/*
- AL-CNR   AL-P      AL-N-P
- CE-CNR   CEARA-P   CE-N-P
- PB-CNR   PB-P      PB-N-P
- PE-CNR   PE-P      PE-N-P
- PI-CNR   PIAUI-P   PI-N-P
- RN-CNR   RGNORT-P  RN-N-P
- SE-CNR   SE-P      SE-N-P
*/

DEFINE VARIABLE pcLista AS CHARACTER   NO-UNDO
    INIT "MIT6MA1P,MIT6MA2P,MIT6TOP,MIT6ALP,MIT6CEP,MIT6PBP,MIT6PEP,MIT6PIP,MIT6RNP,MIT6SEP,MIT6BA1P,MIT6BA2P,MIT6BA3P,MIT6BA4P".
 
DEFINE VARIABLE iLista    AS INTEGER     NO-UNDO.

DO iLista = 1 TO NUM-ENTRIES(pcLista):
    
    FIND FIRST es-busca-preco NO-LOCK 
         WHERE es-busca-preco.nr-tabpre = ENTRY(iLista,pcLista) NO-ERROR.
    IF NOT AVAIL es-busca-preco THEN
        MESSAGE ENTRY(iLista,pcLista) VIEW-AS ALERT-BOX INFO BUTTONS OK.

    FOR EACH es-busca-preco NO-LOCK 
      WHERE es-busca-preco.nr-tabpre = ENTRY(iLista,pcLista):

      DISPLAY es-busca-preco.nr-tabpre
              es-busca-preco.nr-busca
              es-busca-preco.uf
              es-busca-preco.it-codigo
              es-busca-preco.ge-codigo
              es-busca-preco.fm-codigo
              es-busca-preco.fm-cod-com
              es-busca-preco.cod-grupo
              WITH 1 COLUMN 1 DOWN.
           
      PAUSE 0. 
   END.

END.
    
