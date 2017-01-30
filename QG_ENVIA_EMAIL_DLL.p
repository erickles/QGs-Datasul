DEFINE VARIABLE EnviaEmail AS COM-HANDLE NO-UNDO.
/* Chamada da Funcao Pesquisa dentro da DLL */
CREATE "EnviaEmail.clsEnviaEmail" EnviaEmail /*chFuncao*/ . /*Instancia da DLL*/
EnviaEmail:EnviaMail("sac@tortuga.com.br",                                  /* From */
                     "erick.souza@tortuga.com.br",                          /* To */
                     "T:\\EMS2.06B\\esp\\doc\\portal_cliente_danfe.html",   /* Body, podendo informar o caminho do arquivo HTML como corpo do e-mail */
                     "DANFE_DSM",                                           /* Subject */
                     "Z:\\producao\\2014\\OUT\\Danfe\\DANFE-05-1-0092090.pdf,Y:\\PRODUCAO\\Processados\\050010092136.xml",  /* Attachments, separados por virgula */
                     "192.168.1.31").

RELEASE OBJECT EnviaEmail.
