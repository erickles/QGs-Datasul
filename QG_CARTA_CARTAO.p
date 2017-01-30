DEFINE VARIABLE AppWord         AS COM-HANDLE NO-UNDO.

CREATE "Word.Application" AppWord.
AppWord:Documents:Open("U:\EMS2.06B\esp\doc\CARTA_CARTAO.doc",False,False,False,"","",False).

AppWord:Selection:Find:Text = "#DESTINATARIO".
AppWord:Selection:Find:Replacement:Text = STRING("TESTE").
AppWord:Selection:Find:Forward = True.
AppWord:Selection:Collapse.
AppWord:Selection:Find:Execute(,,,,,,,,,,1,,,,).

AppWord:Selection:Find:Text = "#TRANSPORTADOR".
AppWord:Selection:Find:Replacement:Text = STRING("TESTE 2").
AppWord:Selection:Find:Forward = True.
AppWord:Selection:Collapse.
AppWord:Selection:Find:Execute(,,,,,,,,,,1,,,,).

AppWord:Selection:Find:Text = "#CARTAO".
AppWord:Selection:Find:Replacement:Text = "TESTE 3".
AppWord:Selection:Find:Forward = True.
AppWord:Selection:Collapse.
AppWord:Selection:Find:Execute(,,,,,,,,,,1,,,,).

AppWord:Selection:Find:Forward = TRUE.
AppWord:Selection:Collapse.
AppWord:Selection:Find:Execute(,,,,,,,,,,1,,,,).

AppWord:visible = true.

/* Appword:Quit(). */
RELEASE OBJECT appWord.
