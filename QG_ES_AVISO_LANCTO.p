DEFINE VARIABLE iNrAviso AS INTEGER     NO-UNDO.

UPDATE iNrAviso LABEL "Aviso".

FIND FIRST es-aviso-lancto WHERE es-aviso-lancto.nr-solicita = iNrAviso.
ASSIGN es-aviso-lancto.situacao = 0
       es-aviso-lancto.usuar-aprov1 = ""
       es-aviso-lancto.usuar-aprov2 = "".
