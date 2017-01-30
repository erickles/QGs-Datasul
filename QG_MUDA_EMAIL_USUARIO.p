DEFINE VARIABLE cEmail AS CHARACTER   NO-UNDO.

UPDATE cEmail LABEL "E-mail".

FIND FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = cEmail.
UPDATE usuar_mestre.cod_e_mail_local.
