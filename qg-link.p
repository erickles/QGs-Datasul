DEFINE VARIABLE chBrowserApplication AS COM-HANDLE NO-UNDO.
CREATE "InternetExplorer.Application" chBrowserApplication.
chBrowserApplication:visible = True.
chBrowserApplication:Navigate("/webems24/relatoriosemanal/cad_relatorio_ws.asp").
